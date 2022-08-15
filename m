Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB6259507E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiHPEm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbiHPElT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:41:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4AEA5981;
        Mon, 15 Aug 2022 13:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F95A611EC;
        Mon, 15 Aug 2022 20:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3110C433B5;
        Mon, 15 Aug 2022 20:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595571;
        bh=NFO2Nn+G7UW0RYAewZQ0arn1JhLYLVyxLzuRB7BFrQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6saOW5/4SRrH1drn/Q69nJXE3t4Pv8y1Q3DI3+lFQPxMM8h9LhSrPtRt0IbBsBs3
         C+9/0W9W6WFn3P/NpZpVavPZOrwTSVV7KfxVhq7WrkYyeQ/ofwrozFkssKgpO8NLTO
         E1urkfrrg+Tb6PxoT31AKXlBYi7KhGAbqwy3rovs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0807/1157] xtensa: iss: fix handling error cases in iss_net_configure()
Date:   Mon, 15 Aug 2022 20:02:43 +0200
Message-Id: <20220815180511.766771112@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 628ccfc8f5f79dd548319408fcc53949fe97b258 ]

The 'pdev' and 'netdev' need to be released in error cases of
iss_net_configure().

Change the return type of iss_net_configure() to void, because it's
not used.

Fixes: 7282bee78798 ("[PATCH] xtensa: Architecture support for Tensilica Xtensa Part 8")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/platforms/iss/network.c | 32 ++++++++++++++---------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index f0c652c1b438..3805dc2c259c 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -481,16 +481,15 @@ static void iss_net_pdev_release(struct device *dev)
 	free_netdev(lp->dev);
 }
 
-static int iss_net_configure(int index, char *init)
+static void iss_net_configure(int index, char *init)
 {
 	struct net_device *dev;
 	struct iss_net_private *lp;
-	int err;
 
 	dev = alloc_etherdev(sizeof(*lp));
 	if (dev == NULL) {
 		pr_err("eth_configure: failed to allocate device\n");
-		return 1;
+		return;
 	}
 
 	/* Initialize private element. */
@@ -518,7 +517,7 @@ static int iss_net_configure(int index, char *init)
 	if (!tuntap_probe(lp, index, init)) {
 		pr_err("%s: invalid arguments. Skipping device!\n",
 		       dev->name);
-		goto errout;
+		goto err_free_netdev;
 	}
 
 	pr_info("Netdevice %d (%pM)\n", index, dev->dev_addr);
@@ -526,7 +525,8 @@ static int iss_net_configure(int index, char *init)
 	/* sysfs register */
 
 	if (!driver_registered) {
-		platform_driver_register(&iss_net_driver);
+		if (platform_driver_register(&iss_net_driver))
+			goto err_free_netdev;
 		driver_registered = 1;
 	}
 
@@ -537,7 +537,8 @@ static int iss_net_configure(int index, char *init)
 	lp->pdev.id = index;
 	lp->pdev.name = DRIVER_NAME;
 	lp->pdev.dev.release = iss_net_pdev_release;
-	platform_device_register(&lp->pdev);
+	if (platform_device_register(&lp->pdev))
+		goto err_free_netdev;
 	SET_NETDEV_DEV(dev, &lp->pdev.dev);
 
 	dev->netdev_ops = &iss_netdev_ops;
@@ -546,23 +547,20 @@ static int iss_net_configure(int index, char *init)
 	dev->irq = -1;
 
 	rtnl_lock();
-	err = register_netdevice(dev);
-	rtnl_unlock();
-
-	if (err) {
+	if (register_netdevice(dev)) {
+		rtnl_unlock();
 		pr_err("%s: error registering net device!\n", dev->name);
-		/* XXX: should we call ->remove() here? */
-		free_netdev(dev);
-		return 1;
+		platform_device_unregister(&lp->pdev);
+		return;
 	}
+	rtnl_unlock();
 
 	timer_setup(&lp->tl, iss_net_user_timer_expire, 0);
 
-	return 0;
+	return;
 
-errout:
-	/* FIXME: unregister; free, etc.. */
-	return -EIO;
+err_free_netdev:
+	free_netdev(dev);
 }
 
 /* ------------------------------------------------------------------------- */
-- 
2.35.1



