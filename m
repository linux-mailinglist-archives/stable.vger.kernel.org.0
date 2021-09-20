Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D7A412630
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354794AbhITS4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385441AbhITSu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E9663377;
        Mon, 20 Sep 2021 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159287;
        bh=dA7U1tdDIjyX8sZwRkxnnuVALF6K0xFNrP1sb6B2NZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCMUuXP35Ol3zKICXaa8CT5ihlDSJKzDs7dAY0ztbrE8IAkTPKvAOIhts21kEIr+G
         7vynXOFNn/1jzcyggbzd8WUum5BgPOpGIoPfFiZjZyCKT4HNJoj2rE6PJNdjuwz0fF
         CwejJkMxDZ/wXa7xtBVhhylqv2zq8DHyX9LWfgt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 161/168] net: dsa: b53: Fix IMP port setup on BCM5301x
Date:   Mon, 20 Sep 2021 18:44:59 +0200
Message-Id: <20210920163926.957566751@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
 drivers/net/dsa/b53/b53_common.c | 28 +++++++++++++++++++++++++---
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5646eb8afe38..604f54112665 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1144,7 +1144,7 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
 	u8 reg, val, off;
 
 	/* Override the port settings */
-	if (port == dev->cpu_port) {
+	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
 	} else {
@@ -1168,7 +1168,7 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	u8 reg, val, off;
 
 	/* Override the port settings */
-	if (port == dev->cpu_port) {
+	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
 	} else {
@@ -1236,7 +1236,7 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 	b53_force_link(dev, port, phydev->link);
 
 	if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
-		if (port == 8)
+		if (port == dev->imp_port)
 			off = B53_RGMII_CTRL_IMP;
 		else
 			off = B53_RGMII_CTRL_P(port);
@@ -2280,6 +2280,7 @@ struct b53_chip_data {
 	const char *dev_name;
 	u16 vlans;
 	u16 enabled_ports;
+	u8 imp_port;
 	u8 cpu_port;
 	u8 vta_regs[3];
 	u8 arl_bins;
@@ -2304,6 +2305,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 2,
 		.arl_buckets = 1024,
+		.imp_port = 5,
 		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
@@ -2314,6 +2316,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 2,
 		.arl_buckets = 1024,
+		.imp_port = 5,
 		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
@@ -2324,6 +2327,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2337,6 +2341,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2350,6 +2355,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2363,6 +2369,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x7f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2377,6 +2384,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.vta_regs = B53_VTA_REGS,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2389,6 +2397,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0xff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2402,6 +2411,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2415,6 +2425,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0, /* pdata must provide them */
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_63XX,
 		.duplex_reg = B53_DUPLEX_STAT_63XX,
@@ -2428,6 +2439,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2441,6 +2453,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2454,6 +2467,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2467,6 +2481,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2480,6 +2495,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2493,6 +2509,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2506,6 +2523,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x103,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2520,6 +2538,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 256,
+		.imp_port = 8,
 		.cpu_port = 8, /* TODO: ports 4, 5, 8 */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2533,6 +2552,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2546,6 +2566,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 256,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2571,6 +2592,7 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->vta_regs[1] = chip->vta_regs[1];
 			dev->vta_regs[2] = chip->vta_regs[2];
 			dev->jumbo_pm_reg = chip->jumbo_pm_reg;
+			dev->imp_port = chip->imp_port;
 			dev->cpu_port = chip->cpu_port;
 			dev->num_vlans = chip->vlans;
 			dev->num_arl_bins = chip->arl_bins;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 9bf8319342b0..5d068acf7cf8 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -123,6 +123,7 @@ struct b53_device {
 
 	/* used ports mask */
 	u16 enabled_ports;
+	unsigned int imp_port;
 	unsigned int cpu_port;
 
 	/* connect specific data */
-- 
2.30.2



