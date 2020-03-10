Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E6F17FA4E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgCJNEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbgCJNEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:04:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0223A246AA;
        Tue, 10 Mar 2020 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845461;
        bh=KJoKLhjYPFyRWD4d0UPL8yDXl4UR0+scisZD6bxeLpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMFxedS33TPownaWMRCMO2chcfyPx2ogwHvH8BI1ctTUTNpCMNVM9seaULOrB8dS4
         dZsFQ9uaFRa5q5qrOMU9aCADTgE8Q9R0SEa94P2YKPTlRJrDIum/arUcxDWUKhrPYb
         NiyEnLSk5qoYLuo52mWoDfNEdsKK1wUCWs5yqVRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 189/189] net: stmmac: fix notifier registration
Date:   Tue, 10 Mar 2020 13:40:26 +0100
Message-Id: <20200310123658.506018546@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@nokia.com>

commit 474a31e13a4e9749fb3ee55794d69d0f17ee0998 upstream.

We cannot register the same netdev notifier multiple times when probing
stmmac devices. Register the notifier only once in module init, and also
make debugfs creation/deletion safe against simultaneous notifier call.

Fixes: 481a7d154cbb ("stmmac: debugfs entry name is not be changed when udev rename device name.")
Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4289,6 +4289,8 @@ static void stmmac_init_fs(struct net_de
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
+	rtnl_lock();
+
 	/* Create per netdev entries */
 	priv->dbgfs_dir = debugfs_create_dir(dev->name, stmmac_fs_dir);
 
@@ -4300,14 +4302,13 @@ static void stmmac_init_fs(struct net_de
 	debugfs_create_file("dma_cap", 0444, priv->dbgfs_dir, dev,
 			    &stmmac_dma_cap_fops);
 
-	register_netdevice_notifier(&stmmac_notifier);
+	rtnl_unlock();
 }
 
 static void stmmac_exit_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	unregister_netdevice_notifier(&stmmac_notifier);
 	debugfs_remove_recursive(priv->dbgfs_dir);
 }
 #endif /* CONFIG_DEBUG_FS */
@@ -4825,14 +4826,14 @@ int stmmac_dvr_remove(struct device *dev
 
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
-#ifdef CONFIG_DEBUG_FS
-	stmmac_exit_fs(ndev);
-#endif
 	stmmac_stop_all_dma(priv);
 
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
+#ifdef CONFIG_DEBUG_FS
+	stmmac_exit_fs(ndev);
+#endif
 	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
@@ -5052,6 +5053,7 @@ static int __init stmmac_init(void)
 	/* Create debugfs main directory if it doesn't exist yet */
 	if (!stmmac_fs_dir)
 		stmmac_fs_dir = debugfs_create_dir(STMMAC_RESOURCE_NAME, NULL);
+	register_netdevice_notifier(&stmmac_notifier);
 #endif
 
 	return 0;
@@ -5060,6 +5062,7 @@ static int __init stmmac_init(void)
 static void __exit stmmac_exit(void)
 {
 #ifdef CONFIG_DEBUG_FS
+	unregister_netdevice_notifier(&stmmac_notifier);
 	debugfs_remove_recursive(stmmac_fs_dir);
 #endif
 }


