Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD654BBEC3
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 18:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiBRRxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 12:53:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiBRRxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 12:53:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68904434B5
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 09:52:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21675B826B2
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 17:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6EBC340E9;
        Fri, 18 Feb 2022 17:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645206760;
        bh=vOhrJOSwHUamIVcFXlNH1Pbt7CG+8NDl+OWfAcyWqyA=;
        h=Subject:To:Cc:From:Date:From;
        b=X3DnV+rysGlsQWnyjBtar6VDlIgZ/ibxhbvrRGPex1q9T9RsZNrahXEA2dadRvl1I
         DxjeSkqCOFWjg5yI2LGUVhCLlWowAvW0IC4l+Sde8ssGbdd9y/tC5//z29cKC/2cF6
         VCsbCccopDtcmFUXgy/d3IBbIY/5APwYEuM0gXkQ=
Subject: FAILED: patch "[PATCH] net: dsa: lan9303: add VLAN IDs to master device" failed to apply to 4.19-stable tree
To:     mans@mansr.com, f.fainelli@gmail.com, kuba@kernel.org,
        olteanv@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 18:52:30 +0100
Message-ID: <1645206750141183@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
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

