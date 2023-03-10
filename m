Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4463C6B44EE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbjCJO35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjCJO3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:29:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E87546171
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEF98618A6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2866C433D2;
        Fri, 10 Mar 2023 14:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458463;
        bh=l1UqvGZYtMVp5vaOEznFtIy4S9BUTmOCZ2PXrj77veI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJOJN6AQq1l8K/6g2HxK5Hs1kTPoDgU3ZkgkNhcFbX5A9YujGYEnF+oZxyDEsQrlu
         F6m0J+i7UH5UqLpTVz/h1CDkCRiXOevYxg1MLB3gP8LQElZlAVmuOU7DeC3EuOvprL
         UpeslEs0tFtUUkdykBd6FZgH7bE5fuKkTeDr7iNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/357] wifi: libertas: fix memory leak in lbs_init_adapter()
Date:   Fri, 10 Mar 2023 14:35:24 +0100
Message-Id: <20230310133735.560918406@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 16a03958618fb91bb1bc7077cf3211055162cc2f ]

When kfifo_alloc() failed in lbs_init_adapter(), cmd buffer is not
released. Add free memory to processing error path.

Fixes: 7919b89c8276 ("libertas: convert libertas driver to use an event/cmdresp queue")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221208121448.2845986-1-shaozhengchao@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/wireless/marvell/libertas/main.c
index 2233b59cdf444..a94e50eb34bfb 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -870,6 +870,7 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL);
 	if (ret) {
 		pr_err("Out of memory allocating event FIFO buffer\n");
+		lbs_free_cmd_buffer(priv);
 		goto out;
 	}
 
-- 
2.39.2



