Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6A54124AE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380638AbhITSg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380566AbhITSeb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F168163305;
        Mon, 20 Sep 2021 17:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158907;
        bh=lW9r/iKZHKiF3fS0PwFOsCYPqiO12/0dIcjRjbP8DOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJ5vG+197zu30c8FmH9h3o7Re11+ApYjLxzULgZV15bLi0K7Wg6EnXhGWOXDci5Om
         SINPnArQqjGiD9DdbWfMlwDEdMIejU551hWTOXXCTZP8vrizeHOxfp1ignv8E96H/X
         226mCxt/x2eujhaaAj9ujG95fnLgoLY/TU3aAJm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/122] net: dsa: b53: Fix IMP port setup on BCM5301x
Date:   Mon, 20 Sep 2021 18:44:43 +0200
Message-Id: <20210920163919.450192633@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 63f8428b4077de3664eb0b252393c839b0b293ec ]

Broadcom's b53 switches have one IMP (Inband Management Port) that needs
to be programmed using its own designed register. IMP port may be
different than CPU port - especially on devices with multiple CPU ports.

For that reason it's required to explicitly note IMP port index and
check for it when choosing a register to use.

This commit fixes BCM5301x support. Those switches use CPU port 5 while
their IMP port is 8. Before this patch b53 was trying to program port 5
with B53_PORT_OVERRIDE_CTRL instead of B53_GMII_PORT_OVERRIDE_CTRL(5).

It may be possible to also replace "cpu_port" usages with
dsa_is_cpu_port() but that is out of the scope of thix BCM5301x fix.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 27 ++++++++++++++++++++++++---
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 54558f47b633..d3b37cebcfde 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1083,7 +1083,7 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
 	u8 reg, val, off;
 
 	/* Override the port settings */
-	if (port == dev->cpu_port) {
+	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
 	} else {
@@ -1107,7 +1107,7 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	u8 reg, val, off;
 
 	/* Override the port settings */
-	if (port == dev->cpu_port) {
+	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
 	} else {
@@ -1175,7 +1175,7 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 	b53_force_link(dev, port, phydev->link);
 
 	if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
-		if (port == 8)
+		if (port == dev->imp_port)
 			off = B53_RGMII_CTRL_IMP;
 		else
 			off = B53_RGMII_CTRL_P(port);
@@ -2238,6 +2238,7 @@ struct b53_chip_data {
 	const char *dev_name;
 	u16 vlans;
 	u16 enabled_ports;
+	u8 imp_port;
 	u8 cpu_port;
 	u8 vta_regs[3];
 	u8 arl_bins;
@@ -2262,6 +2263,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 2,
 		.arl_buckets = 1024,
+		.imp_port = 5,
 		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
@@ -2272,6 +2274,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 2,
 		.arl_buckets = 1024,
+		.imp_port = 5,
 		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
@@ -2282,6 +2285,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2295,6 +2299,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2308,6 +2313,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2321,6 +2327,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x7f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2335,6 +2342,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.vta_regs = B53_VTA_REGS,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2347,6 +2355,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0xff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2360,6 +2369,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2373,6 +2383,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0, /* pdata must provide them */
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_63XX,
 		.duplex_reg = B53_DUPLEX_STAT_63XX,
@@ -2386,6 +2397,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2399,6 +2411,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2412,6 +2425,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2425,6 +2439,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2438,6 +2453,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2451,6 +2467,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2464,6 +2481,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x103,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2477,6 +2495,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2490,6 +2509,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 256,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2515,6 +2535,7 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->vta_regs[1] = chip->vta_regs[1];
 			dev->vta_regs[2] = chip->vta_regs[2];
 			dev->jumbo_pm_reg = chip->jumbo_pm_reg;
+			dev->imp_port = chip->imp_port;
 			dev->cpu_port = chip->cpu_port;
 			dev->num_vlans = chip->vlans;
 			dev->num_arl_bins = chip->arl_bins;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 7c67409bb186..bdb2ade7ad62 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -122,6 +122,7 @@ struct b53_device {
 
 	/* used ports mask */
 	u16 enabled_ports;
+	unsigned int imp_port;
 	unsigned int cpu_port;
 
 	/* connect specific data */
-- 
2.30.2



