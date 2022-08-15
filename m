Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E851E59435A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347999AbiHOWFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347517AbiHOWDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:03:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E7182D3A;
        Mon, 15 Aug 2022 12:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 965DEB80EA9;
        Mon, 15 Aug 2022 19:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89CDC433D6;
        Mon, 15 Aug 2022 19:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592231;
        bh=PCAo73Hw2NLQ3lErF5pXmj2+7jaMLRIg15cWMfprYbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dm6eXAUMgUuq3O5ru9q2+dVZqxPwUSCSVhsMcjlPKLefYPmQzwJxOtqTAsGmkbmdP
         qanXvlorMGMmQLSixwblL202PZEmkYmhzX2cT7GN0RRKMUMP2DeCa0xIJgoP7AzGH+
         0de3nE18C1cjPD+T/tOF+SSZou4ArTJlmeUQhmmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0753/1095] xtensa: iss: fix handling error cases in iss_net_configure()
Date:   Mon, 15 Aug 2022 20:02:32 +0200
Message-Id: <20220815180500.490663374@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 24f162bd5874..eee389187807 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -512,16 +512,15 @@ static void iss_net_pdev_release(struct device *dev)
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
@@ -550,7 +549,7 @@ static int iss_net_configure(int index, char *init)
 	if (!tuntap_probe(lp, index, init)) {
 		pr_err("%s: invalid arguments. Skipping device!\n",
 		       dev->name);
-		goto errout;
+		goto err_free_netdev;
 	}
 
 	pr_info("Netdevice %d (%pM)\n", index, dev->dev_addr);
@@ -558,7 +557,8 @@ static int iss_net_configure(int index, char *init)
 	/* sysfs register */
 
 	if (!driver_registered) {
-		platform_driver_register(&iss_net_driver);
+		if (platform_driver_register(&iss_net_driver))
+			goto err_free_netdev;
 		driver_registered = 1;
 	}
 
@@ -569,7 +569,8 @@ static int iss_net_configure(int index, char *init)
 	lp->pdev.id = index;
 	lp->pdev.name = DRIVER_NAME;
 	lp->pdev.dev.release = iss_net_pdev_release;
-	platform_device_register(&lp->pdev);
+	if (platform_device_register(&lp->pdev))
+		goto err_free_netdev;
 	SET_NETDEV_DEV(dev, &lp->pdev.dev);
 
 	dev->netdev_ops = &iss_netdev_ops;
@@ -578,23 +579,20 @@ static int iss_net_configure(int index, char *init)
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



