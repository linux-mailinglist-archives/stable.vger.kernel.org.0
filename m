Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F41A664996
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbjAJSXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239212AbjAJSWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38ED5E09A
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:19:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FF846182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552A2C433EF;
        Tue, 10 Jan 2023 18:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374789;
        bh=ZY4/f/YyFx47o2IEsclZofW3dUb4bvE17OAZxYAB8NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8EtXaULQ7MKH3yaAUwI+TZ85jJ3GV86KKE0tkfbfEuG2JQsstiq6tNNawfse9kQi
         My6nRn4pU2o/uWj8sHoiwN5gB/NKd5JEv890l6UjzE0U90BXmJLCbPKuEX5Nvx19RS
         hOVnxXdnuUCDE7NrHCx5mxzPkxfTt3VUHw9pusaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/159] caif: fix memory leak in cfctrl_linkup_request()
Date:   Tue, 10 Jan 2023 19:04:13 +0100
Message-Id: <20230110180021.622018919@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index cc405d8c7c30..8480684f2762 100644
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



