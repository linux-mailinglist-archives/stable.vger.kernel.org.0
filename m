Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8485C1EACE5
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgFASlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731281AbgFASMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1041A2073B;
        Mon,  1 Jun 2020 18:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035170;
        bh=dDWJWOpncPPX2szTDuVaKkhggkjwjJqWcD1lFGGyD/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtwnV5Pnaqrb4KEYYdhPj8tvKOryAuu7B+CCTg6Qb+f9GjfV4Dwm2snXiBZxU7L9+
         NyjXpF4mINsl7HhDSYzEwlAwVaB9IuVMXQwHbxBt0fPkyiRhqzpedJFre5ZU2/FguD
         mHS4bbla7iRtt1t5ymC8olQWHd+ImaQ70ExwmAfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 004/177] felix: Fix initialization of ioremap resources
Date:   Mon,  1 Jun 2020 19:52:22 +0200
Message-Id: <20200601174048.912011455@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit b4024c9e5c57902155d3b5e7de482e245f492bff ]

The caller of devm_ioremap_resource(), either accidentally
or by wrong assumption, is writing back derived resource data
to global static resource initialization tables that should
have been constant.  Meaning that after it computes the final
physical start address it saves the address for no reason
in the static tables.  This doesn't affect the first driver
probing after reboot, but it breaks consecutive driver reloads
(i.e. driver unbind & bind) because the initialization tables
no longer have the correct initial values.  So the next probe()
will map the device registers to wrong physical addresses,
causing ARM SError async exceptions.
This patch fixes all of the above.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix.c         |   23 +++++++++++------------
 drivers/net/dsa/ocelot/felix.h         |    6 +++---
 drivers/net/dsa/ocelot/felix_vsc9959.c |   22 ++++++++++------------
 3 files changed, 24 insertions(+), 27 deletions(-)

--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -385,6 +385,7 @@ static int felix_init_structs(struct fel
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
 	resource_size_t switch_base;
+	struct resource res;
 	int port, i, err;
 
 	ocelot->num_phys_ports = num_phys_ports;
@@ -416,17 +417,16 @@ static int felix_init_structs(struct fel
 
 	for (i = 0; i < TARGET_MAX; i++) {
 		struct regmap *target;
-		struct resource *res;
 
 		if (!felix->info->target_io_res[i].name)
 			continue;
 
-		res = &felix->info->target_io_res[i];
-		res->flags = IORESOURCE_MEM;
-		res->start += switch_base;
-		res->end += switch_base;
+		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
+		res.flags = IORESOURCE_MEM;
+		res.start += switch_base;
+		res.end += switch_base;
 
-		target = ocelot_regmap_init(ocelot, res);
+		target = ocelot_regmap_init(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -447,7 +447,6 @@ static int felix_init_structs(struct fel
 	for (port = 0; port < num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port;
 		void __iomem *port_regs;
-		struct resource *res;
 
 		ocelot_port = devm_kzalloc(ocelot->dev,
 					   sizeof(struct ocelot_port),
@@ -459,12 +458,12 @@ static int felix_init_structs(struct fel
 			return -ENOMEM;
 		}
 
-		res = &felix->info->port_io_res[port];
-		res->flags = IORESOURCE_MEM;
-		res->start += switch_base;
-		res->end += switch_base;
+		memcpy(&res, &felix->info->port_io_res[port], sizeof(res));
+		res.flags = IORESOURCE_MEM;
+		res.start += switch_base;
+		res.end += switch_base;
 
-		port_regs = devm_ioremap_resource(ocelot->dev, res);
+		port_regs = devm_ioremap_resource(ocelot->dev, &res);
 		if (IS_ERR(port_regs)) {
 			dev_err(ocelot->dev,
 				"failed to map registers for port %d\n", port);
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -8,9 +8,9 @@
 
 /* Platform-specific information */
 struct felix_info {
-	struct resource			*target_io_res;
-	struct resource			*port_io_res;
-	struct resource			*imdio_res;
+	const struct resource		*target_io_res;
+	const struct resource		*port_io_res;
+	const struct resource		*imdio_res;
 	const struct reg_field		*regfields;
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -328,10 +328,8 @@ static const u32 *vsc9959_regmap[] = {
 	[GCB]	= vsc9959_gcb_regmap,
 };
 
-/* Addresses are relative to the PCI device's base address and
- * will be fixed up at ioremap time.
- */
-static struct resource vsc9959_target_io_res[] = {
+/* Addresses are relative to the PCI device's base address */
+static const struct resource vsc9959_target_io_res[] = {
 	[ANA] = {
 		.start	= 0x0280000,
 		.end	= 0x028ffff,
@@ -374,7 +372,7 @@ static struct resource vsc9959_target_io
 	},
 };
 
-static struct resource vsc9959_port_io_res[] = {
+static const struct resource vsc9959_port_io_res[] = {
 	{
 		.start	= 0x0100000,
 		.end	= 0x010ffff,
@@ -410,7 +408,7 @@ static struct resource vsc9959_port_io_r
 /* Port MAC 0 Internal MDIO bus through which the SerDes acting as an
  * SGMII/QSGMII MAC PCS can be found.
  */
-static struct resource vsc9959_imdio_res = {
+static const struct resource vsc9959_imdio_res = {
 	.start		= 0x8030,
 	.end		= 0x8040,
 	.name		= "imdio",
@@ -984,7 +982,7 @@ static int vsc9959_mdio_bus_alloc(struct
 	struct device *dev = ocelot->dev;
 	resource_size_t imdio_base;
 	void __iomem *imdio_regs;
-	struct resource *res;
+	struct resource res;
 	struct enetc_hw *hw;
 	struct mii_bus *bus;
 	int port;
@@ -1001,12 +999,12 @@ static int vsc9959_mdio_bus_alloc(struct
 	imdio_base = pci_resource_start(felix->pdev,
 					felix->info->imdio_pci_bar);
 
-	res = felix->info->imdio_res;
-	res->flags = IORESOURCE_MEM;
-	res->start += imdio_base;
-	res->end += imdio_base;
+	memcpy(&res, felix->info->imdio_res, sizeof(res));
+	res.flags = IORESOURCE_MEM;
+	res.start += imdio_base;
+	res.end += imdio_base;
 
-	imdio_regs = devm_ioremap_resource(dev, res);
+	imdio_regs = devm_ioremap_resource(dev, &res);
 	if (IS_ERR(imdio_regs)) {
 		dev_err(dev, "failed to map internal MDIO registers\n");
 		return PTR_ERR(imdio_regs);


