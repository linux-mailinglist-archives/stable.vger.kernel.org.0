Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D0A414462
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 11:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhIVJCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 05:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233792AbhIVJCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 05:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E464861368;
        Wed, 22 Sep 2021 09:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632301276;
        bh=/FE1FpcrzYtcLLXiaDU/x0krUfZQg35qkyKAzCzIZAg=;
        h=Subject:To:Cc:From:Date:From;
        b=UwNtmQW5C81HHFfYjr2jxj6OHVCpX8uH1KIkBlQ8YNLmuqrClSROsVW7fI7t9XkcJ
         hcOkb0icESMqA8qHvWbQCvmizRTMzOEeTc3MmNPiqbbRVzG2qKpnx52FY2begbenFm
         yJyqayBEwpfsvdXnhQMA117Vv9vBf66z5U3caLKI=
Subject: FAILED: patch "[PATCH] net: stmmac: fix MAC not working when system resume back with" failed to apply to 5.10-stable tree
To:     qiangqing.zhang@nxp.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 Sep 2021 11:01:13 +0200
Message-ID: <1632301273232242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90702dcd19c093621b422ba16fcfd870afe2552f Mon Sep 17 00:00:00 2001
From: Joakim Zhang <qiangqing.zhang@nxp.com>
Date: Tue, 7 Sep 2021 18:56:47 +0800
Subject: [PATCH] net: stmmac: fix MAC not working when system resume back with
 WoL active

We can reproduce this issue with below steps:
1) enable WoL on the host
2) host system suspended
3) remote client send out wakeup packets
We can see that host system resume back, but can't work, such as ping failed.

After a bit digging, this issue is introduced by the commit 46f69ded988d
("net: stmmac: Use resolved link config in mac_link_up()"), which use
the finalised link parameters in mac_link_up() rather than the
parameters in mac_config().

There are two scenarios for MAC suspend/resume in STMMAC driver:

1) MAC suspend with WoL inactive, stmmac_suspend() call
phylink_mac_change() to notify phylink machine that a change in MAC
state, then .mac_link_down callback would be invoked. Further, it will
call phylink_stop() to stop the phylink instance. When MAC resume back,
firstly phylink_start() is called to start the phylink instance, then
call phylink_mac_change() which will finally trigger phylink machine to
invoke .mac_config and .mac_link_up callback. All is fine since
configuration in these two callbacks will be initialized, that means MAC
can restore the state.

2) MAC suspend with WoL active, phylink_mac_change() will put link
down, but there is no phylink_stop() to stop the phylink instance, so it
will link up again, that means .mac_config and .mac_link_up would be
invoked before system suspended. After system resume back, it will do
DMA initialization and SW reset which let MAC lost the hardware setting
(i.e MAC_Configuration register(offset 0x0) is reset). Since link is up
before system suspended, so .mac_link_up would not be invoked after
system resume back, lead to there is no chance to initialize the
configuration in .mac_link_up callback, as a result, MAC can't work any
longer.

After discussed with Russell King [1], we confirm that phylink framework
have not take WoL into consideration yet. This patch calls
phylink_suspend()/phylink_resume() functions which is newly introduced
by Russell King to fix this issue.

[1] https://lore.kernel.org/netdev/20210901090228.11308-1-qiangqing.zhang@nxp.com/

Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 97238359e101..ece02b35a6ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7123,8 +7123,6 @@ int stmmac_suspend(struct device *dev)
 	if (!ndev || !netif_running(ndev))
 		return 0;
 
-	phylink_mac_change(priv->phylink, false);
-
 	mutex_lock(&priv->lock);
 
 	netif_device_detach(ndev);
@@ -7150,14 +7148,6 @@ int stmmac_suspend(struct device *dev)
 		stmmac_pmt(priv, priv->hw, priv->wolopts);
 		priv->irq_wake = 1;
 	} else {
-		mutex_unlock(&priv->lock);
-		rtnl_lock();
-		if (device_may_wakeup(priv->device))
-			phylink_speed_down(priv->phylink, false);
-		phylink_stop(priv->phylink);
-		rtnl_unlock();
-		mutex_lock(&priv->lock);
-
 		stmmac_mac_set(priv, priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
@@ -7171,6 +7161,16 @@ int stmmac_suspend(struct device *dev)
 
 	mutex_unlock(&priv->lock);
 
+	rtnl_lock();
+	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
+		phylink_suspend(priv->phylink, true);
+	} else {
+		if (device_may_wakeup(priv->device))
+			phylink_speed_down(priv->phylink, false);
+		phylink_suspend(priv->phylink, false);
+	}
+	rtnl_unlock();
+
 	if (priv->dma_cap.fpesel) {
 		/* Disable FPE */
 		stmmac_fpe_configure(priv, priv->ioaddr,
@@ -7261,13 +7261,15 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
-	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
-		rtnl_lock();
-		phylink_start(priv->phylink);
-		/* We may have called phylink_speed_down before */
-		phylink_speed_up(priv->phylink);
-		rtnl_unlock();
+	rtnl_lock();
+	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
+		phylink_resume(priv->phylink);
+	} else {
+		phylink_resume(priv->phylink);
+		if (device_may_wakeup(priv->device))
+			phylink_speed_up(priv->phylink);
 	}
+	rtnl_unlock();
 
 	rtnl_lock();
 	mutex_lock(&priv->lock);
@@ -7288,8 +7290,6 @@ int stmmac_resume(struct device *dev)
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
 
-	phylink_mac_change(priv->phylink, true);
-
 	netif_device_attach(ndev);
 
 	return 0;

