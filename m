Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D54341C2F
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhCSMTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhCSMTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F73E64F6E;
        Fri, 19 Mar 2021 12:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156334;
        bh=Xsv6uBz+2BuWLAQLzEeuYikoPDZ+SQRqq5W5nIPI5Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcTYDBunPllT3+XbkezFiY3S+stXMf33QtdyhEKsEWnLLBHI1vqtP7I5AvenjQZha
         fqPFpjXFHpbkiXp9+vqHMNCXRcmAmb8aU/Y5MXPZduTZpvNifgj3qtH00S9+QSVuhd
         VC++YidiCz3Bj8EdhJl9BOqF+OXVgcRELQX02nV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 8/8] net: dsa: b53: Support setting learning on port
Date:   Fri, 19 Mar 2021 13:18:27 +0100
Message-Id: <20210319121744.371636297@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121744.114946147@linuxfoundation.org>
References: <20210319121744.114946147@linuxfoundation.org>
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
 drivers/net/dsa/b53/b53_common.c |   19 +++++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |    1 +
 drivers/net/dsa/bcm_sf2.c        |    5 -----
 3 files changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -507,12 +507,27 @@ void b53_imp_vlan_setup(struct dsa_switc
 }
 EXPORT_SYMBOL(b53_imp_vlan_setup);
 
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
 int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
 	struct b53_device *dev = ds->priv;
 	unsigned int cpu_port = ds->ports[port].cpu_dp->index;
 	u16 pvlan;
 
+	b53_port_set_learning(dev, port, false);
+
 	/* Clear the Rx and Tx disable bits and set to no spanning tree */
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), 0);
 
@@ -620,6 +635,7 @@ static void b53_enable_cpu_port(struct b
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), port_ctrl);
 
 	b53_brcm_hdr_setup(dev->ds, port);
+	b53_port_set_learning(dev, port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1517,6 +1533,8 @@ int b53_br_join(struct dsa_switch *ds, i
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
+	b53_port_set_learning(dev, port, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_br_join);
@@ -1564,6 +1582,7 @@ void b53_br_leave(struct dsa_switch *ds,
 		vl->untag |= BIT(port) | BIT(cpu_port);
 		b53_set_vlan_entry(dev, pvid, vl);
 	}
+	b53_port_set_learning(dev, port, false);
 }
 EXPORT_SYMBOL(b53_br_leave);
 
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -115,6 +115,7 @@
 #define B53_UC_FLOOD_MASK		0x32
 #define B53_MC_FLOOD_MASK		0x34
 #define B53_IPMC_FLOOD_MASK		0x36
+#define B53_DIS_LEARNING		0x3c
 
 /*
  * Override Ports 0-7 State on devices with xMII interfaces (8 bit)
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -173,11 +173,6 @@ static int bcm_sf2_port_setup(struct dsa
 	reg &= ~P_TXQ_PSM_VDD(port);
 	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
 
-	/* Enable learning */
-	reg = core_readl(priv, CORE_DIS_LEARN);
-	reg &= ~BIT(port);
-	core_writel(priv, reg, CORE_DIS_LEARN);
-
 	/* Enable Broadcom tags for that port if requested */
 	if (priv->brcm_tag_mask & BIT(port))
 		b53_brcm_hdr_setup(ds, port);


