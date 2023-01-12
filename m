Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B1C667804
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbjALOvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239985AbjALOvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:51:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FA513E3E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:38:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A74C56203C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE305C433EF;
        Thu, 12 Jan 2023 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534283;
        bh=TeVUh8dUZgnT16RGC+nQBIRxsr3/6yXJ8gB2mW3y3bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYrLdAmi9xWA1adL9Xqfi2ex2krX41PUlC9Tey9ho654fwTx34cl9pO7Vc7PWRbv7
         Klvqk0leKuqgbp8WBuABitAfXchZ605ITdxQPVshRFo6kijpWKuO4cG14fyoqVmzY0
         8vIRyCclY2Y9kqks0J2ZfygaRTUsuBqhcdYsq9DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 756/783] caif: fix memory leak in cfctrl_linkup_request()
Date:   Thu, 12 Jan 2023 14:57:52 +0100
Message-Id: <20230112135559.399893242@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit fe69230f05897b3de758427b574fc98025dfc907 ]

When linktype is unknown or kzalloc failed in cfctrl_linkup_request(),
pkt is not released. Add release process to error path.

Fixes: b482cd2053e3 ("net-caif: add CAIF core protocol stack")
Fixes: 8d545c8f958f ("caif: Disconnect without waiting for response")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20230104065146.1153009-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/caif/cfctrl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index 2809cbd6b7f7..d8cb4b2a076b 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -269,11 +269,15 @@ int cfctrl_linkup_request(struct cflayer *layer,
 	default:
 		pr_warn("Request setup of bad link type = %d\n",
 			param->linktype);
+		cfpkt_destroy(pkt);
 		return -EINVAL;
 	}
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
-	if (!req)
+	if (!req) {
+		cfpkt_destroy(pkt);
 		return -ENOMEM;
+	}
+
 	req->client_layer = user_layer;
 	req->cmd = CFCTRL_CMD_LINK_SETUP;
 	req->param = *param;
-- 
2.35.1



