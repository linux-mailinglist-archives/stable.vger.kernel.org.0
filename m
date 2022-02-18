Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34724BBACF
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbiBROks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:40:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiBROkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:40:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F05D294FCE
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:40:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0EAC61B71
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CA7C340E9;
        Fri, 18 Feb 2022 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645195230;
        bh=M3eVaoS2E1ygA3iMLNQGBTxdwROeV0e4o9vFr8/injU=;
        h=Subject:To:Cc:From:Date:From;
        b=D6qTG/SoHoDYiva+ChmPNeG2Y5Bc+SxSx86Z0gWStoYxiTMWsGbpVtxe8m0QRWbdp
         xP0aGSier0alLVE/3KANEh1RLKFspipQDymGw2Ks3MxLFBTjxAcY88cQ+TU0eMuyIS
         XOy9M2OxSP441jW0Cf/m4jqitK7sEsyl0gs8EIK4=
Subject: FAILED: patch "[PATCH] net: dsa: lan9303: add VLAN IDs to master device" failed to apply to 4.14-stable tree
To:     mans@mansr.com, f.fainelli@gmail.com, kuba@kernel.org,
        olteanv@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:40:27 +0100
Message-ID: <164519522715541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 430065e2671905ac675f97b7af240cc255964e93 Mon Sep 17 00:00:00 2001
From: Mans Rullgard <mans@mansr.com>
Date: Wed, 16 Feb 2022 20:48:18 +0000
Subject: [PATCH] net: dsa: lan9303: add VLAN IDs to master device

If the master device does VLAN filtering, the IDs used by the switch
must be added for any frames to be received.  Do this in the
port_enable() function, and remove them in port_disable().

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Mans Rullgard <mans@mansr.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20220216204818.28746-1-mans@mansr.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index c0c91440340a..0029d279616f 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -82,6 +82,7 @@ config NET_DSA_REALTEK_SMI
 
 config NET_DSA_SMSC_LAN9303
 	tristate
+	depends on VLAN_8021Q || VLAN_8021Q=n
 	select NET_DSA_TAG_LAN9303
 	select REGMAP
 	help
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 873a5588171b..3969d89fa4db 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -10,6 +10,7 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/etherdevice.h>
 
 #include "lan9303.h"
@@ -1083,21 +1084,27 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 static int lan9303_port_enable(struct dsa_switch *ds, int port,
 			       struct phy_device *phy)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct lan9303 *chip = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
+	if (!dsa_port_is_user(dp))
 		return 0;
 
+	vlan_vid_add(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+
 	return lan9303_enable_processing_port(chip, port);
 }
 
 static void lan9303_port_disable(struct dsa_switch *ds, int port)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct lan9303 *chip = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
+	if (!dsa_port_is_user(dp))
 		return;
 
+	vlan_vid_del(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+
 	lan9303_disable_processing_port(chip, port);
 	lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
 }

