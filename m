Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E152341C52
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhCSMUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230419AbhCSMT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 817336146D;
        Fri, 19 Mar 2021 12:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156387;
        bh=gGn674vj9wlOaIzve2iJMfJkDkxEk8z8fFXS1GdD+do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guOmwLniliPa5TVccn5TM7cCUnuJGhsWpXOR7BcPZVvXFva2i6HyAu9ygc/BVDbCB
         4xQPs/LlgH1ls5thnWiAFclr6b0wOs5tNvQVt10F/MdPC8ovrH3G+PUj3rMs4o9M25
         IP3IsbdaOqHRYWviFHAO9QmZ/aHaNdh8qDYnVnSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 18/18] net: dsa: b53: Support setting learning on port
Date:   Fri, 19 Mar 2021 13:18:56 +0100
Message-Id: <20210319121746.074136279@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
References: <20210319121745.449875976@linuxfoundation.org>
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
 drivers/net/dsa/b53/b53_common.c |   18 ++++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |    1 +
 drivers/net/dsa/bcm_sf2.c        |    5 -----
 3 files changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -514,6 +514,19 @@ void b53_imp_vlan_setup(struct dsa_switc
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
@@ -527,6 +540,7 @@ int b53_enable_port(struct dsa_switch *d
 	cpu_port = ds->ports[port].cpu_dp->index;
 
 	b53_br_egress_floods(ds, port, true, true);
+	b53_port_set_learning(dev, port, false);
 
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
@@ -645,6 +659,7 @@ static void b53_enable_cpu_port(struct b
 	b53_brcm_hdr_setup(dev->ds, port);
 
 	b53_br_egress_floods(dev->ds, port, true, true);
+	b53_port_set_learning(dev, port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1704,6 +1719,8 @@ int b53_br_join(struct dsa_switch *ds, i
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
+	b53_port_set_learning(dev, port, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_br_join);
@@ -1751,6 +1768,7 @@ void b53_br_leave(struct dsa_switch *ds,
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
@@ -172,11 +172,6 @@ static int bcm_sf2_port_setup(struct dsa
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


