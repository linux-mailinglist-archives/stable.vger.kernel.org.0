Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2CD34446A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhCVM7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231210AbhCVM4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:56:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 969CD61A39;
        Mon, 22 Mar 2021 12:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417312;
        bh=k8FE2Gsif1w1ejXL4TjjzV6AUO6S8xjbtI7a4EYTkvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCppyJM27o2FNhDeCMrX5ST0G4KeQeULvrm42YJzGbUwlbjiOC29NFihzbV/t0EtN
         gdNOTiDB3+vEG9kSS8nSRm3+G8rwHyKg7IjLRtbXsZzWBX/HhnccYxzBCKVY8Dnwfn
         /FTozK5HSciRoqT4cLAr+HPZxoP6rxHPHOPZpwf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 07/43] net: dsa: b53: Support setting learning on port
Date:   Mon, 22 Mar 2021 13:28:48 +0100
Message-Id: <20210322121920.292640228@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit f9b3827ee66cfcf297d0acd6ecf33653a5f297ef upstream.

Add support for being able to set the learning attribute on port, and
make sure that the standalone ports start up with learning disabled.

We can remove the code in bcm_sf2 that configured the ports learning
attribute because we want the standalone ports to have learning disabled
by default and port 7 cannot be bridged, so its learning attribute will
not change past its initial configuration.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/dsa/b53/b53_common.c |   20 ++++++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |    1 +
 drivers/net/dsa/bcm_sf2.c        |    5 +++++
 drivers/net/dsa/bcm_sf2_regs.h   |    2 ++
 4 files changed, 28 insertions(+)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -501,6 +501,19 @@ static void b53_imp_vlan_setup(struct ds
 	}
 }
 
+static void b53_port_set_learning(struct b53_device *dev, int port,
+				  bool learning)
+{
+	u16 reg;
+
+	b53_read16(dev, B53_CTRL_PAGE, B53_DIS_LEARNING, &reg);
+	if (learning)
+		reg &= ~BIT(port);
+	else
+		reg |= BIT(port);
+	b53_write16(dev, B53_CTRL_PAGE, B53_DIS_LEARNING, reg);
+}
+
 static int b53_enable_port(struct dsa_switch *ds, int port,
 			   struct phy_device *phy)
 {
@@ -508,6 +521,8 @@ static int b53_enable_port(struct dsa_sw
 	unsigned int cpu_port = dev->cpu_port;
 	u16 pvlan;
 
+	b53_port_set_learning(dev, port, false);
+
 	/* Clear the Rx and Tx disable bits and set to no spanning tree */
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), 0);
 
@@ -551,6 +566,8 @@ static void b53_enable_cpu_port(struct b
 		    PORT_CTRL_RX_MCST_EN |
 		    PORT_CTRL_RX_UCST_EN;
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(cpu_port), port_ctrl);
+
+	b53_port_set_learning(dev, cpu_port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1342,6 +1359,8 @@ int b53_br_join(struct dsa_switch *ds, i
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
+	b53_port_set_learning(dev, port, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_br_join);
@@ -1392,6 +1411,7 @@ void b53_br_leave(struct dsa_switch *ds,
 		vl->untag |= BIT(port) | BIT(dev->cpu_port);
 		b53_set_vlan_entry(dev, pvid, vl);
 	}
+	b53_port_set_learning(dev, port, false);
 }
 EXPORT_SYMBOL(b53_br_leave);
 
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -112,6 +112,7 @@
 #define B53_UC_FLOOD_MASK		0x32
 #define B53_MC_FLOOD_MASK		0x34
 #define B53_IPMC_FLOOD_MASK		0x36
+#define B53_DIS_LEARNING		0x3c
 
 /*
  * Override Ports 0-7 State on devices with xMII interfaces (8 bit)
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -252,6 +252,11 @@ static int bcm_sf2_port_setup(struct dsa
 	reg &= ~P_TXQ_PSM_VDD(port);
 	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
 
+	/* Disable learning */
+	reg = core_readl(priv, CORE_DIS_LEARN);
+	reg |= BIT(port);
+	core_writel(priv, reg, CORE_DIS_LEARN);
+
 	/* Enable Broadcom tags for that port if requested */
 	if (priv->brcm_tag_mask & BIT(port))
 		bcm_sf2_brcm_hdr_setup(priv, port);
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -150,6 +150,8 @@ enum bcm_sf2_reg_offs {
 #define CORE_SWITCH_CTRL		0x00088
 #define  MII_DUMB_FWDG_EN		(1 << 6)
 
+#define CORE_DIS_LEARN			0x000f0
+
 #define CORE_SFT_LRN_CTRL		0x000f8
 #define  SW_LEARN_CNTL(x)		(1 << (x))
 


