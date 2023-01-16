Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1DA66CBC6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbjAPRRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbjAPRQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:16:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6134B3FF27
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:57:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10D0CB8109B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ADFC433D2;
        Mon, 16 Jan 2023 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888234;
        bh=vg85DTGXmWW6C93c/1iml8rTOxn9gtzv3sGafFQVNa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9xb3ChRVcEc+UvqJu7xayiO5xlAb3prEZNujK3cjp0anzpUeN6DPzQ83YPowucMG
         0GbYD9X41kbXCFOeIYA2jp/BorhxGpFQf+Y2wOHrqaK/ptmG3TLf3OF+C9rM4iOo4y
         1qmm8wWFCFVJ2AweUZmoBGYEmjuCgUPxh23b0b4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 451/521] caif: fix memory leak in cfctrl_linkup_request()
Date:   Mon, 16 Jan 2023 16:51:53 +0100
Message-Id: <20230116154907.290622706@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index a1e85f032108..330cb2b087bb 100644
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



