Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0661C1013E2
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfKSF2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:28:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728862AbfKSF2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:28:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50974208C3;
        Tue, 19 Nov 2019 05:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141292;
        bh=FJvlhdFxsqprxnNVbN95u0jbEh0Nno/W3yfaEzFlnI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xys1sKPjTT2KJuTB6ET3wyuOq3dGQ0sfHGuZE3iW0axrmfRbUGW5Jb5AurnEx+Q02
         2JdIhyPf4AaIkpXNZMYZjn3/w0VZuJNJQGxte7SGPGbDnvIqKiR7e/AjXekFC5ljbv
         coESZiqUsr09d7E3GLcrYzYl3hSJtn7HhupUFAa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/422] mtd: rawnand: marvell: use regmap_update_bits() for syscon access
Date:   Tue, 19 Nov 2019 06:15:09 +0100
Message-Id: <20191119051406.383200157@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>

[ Upstream commit 88aa3bbfc020d14b13d67af3f5c08aa992d82cd8 ]

The marvell_nfc_init() function fiddles with some bits of a system
controller on Armada 7K/8K. However, it does a read/modify/write
sequence on GENCONF_CLK_GATING_CTRL and GENCONF_ND_CLK_CTRL, which
isn't safe from a concurrency point of view, as the regmap lock isn't
taken accross the read/modify/write sequence. To solve this issue, use
regmap_update_bits().

While at it, since the "reg" variable is no longer needed for the
read/modify/write sequences, get rid of it for the regmap_write() to
GENCONF_SOC_DEVICE_MUX, and directly pass the value to be written as
argument.

Fixes: 02f26ecf8c772 ("mtd: nand: add reworked Marvell NAND controller driver")
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/marvell_nand.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index 9c90695a885fe..7a84a8f05b46d 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2710,24 +2710,23 @@ static int marvell_nfc_init(struct marvell_nfc *nfc)
 		struct regmap *sysctrl_base =
 			syscon_regmap_lookup_by_phandle(np,
 							"marvell,system-controller");
-		u32 reg;
 
 		if (IS_ERR(sysctrl_base))
 			return PTR_ERR(sysctrl_base);
 
-		reg = GENCONF_SOC_DEVICE_MUX_NFC_EN |
-		      GENCONF_SOC_DEVICE_MUX_ECC_CLK_RST |
-		      GENCONF_SOC_DEVICE_MUX_ECC_CORE_RST |
-		      GENCONF_SOC_DEVICE_MUX_NFC_INT_EN;
-		regmap_write(sysctrl_base, GENCONF_SOC_DEVICE_MUX, reg);
+		regmap_write(sysctrl_base, GENCONF_SOC_DEVICE_MUX,
+			     GENCONF_SOC_DEVICE_MUX_NFC_EN |
+			     GENCONF_SOC_DEVICE_MUX_ECC_CLK_RST |
+			     GENCONF_SOC_DEVICE_MUX_ECC_CORE_RST |
+			     GENCONF_SOC_DEVICE_MUX_NFC_INT_EN);
 
-		regmap_read(sysctrl_base, GENCONF_CLK_GATING_CTRL, &reg);
-		reg |= GENCONF_CLK_GATING_CTRL_ND_GATE;
-		regmap_write(sysctrl_base, GENCONF_CLK_GATING_CTRL, reg);
+		regmap_update_bits(sysctrl_base, GENCONF_CLK_GATING_CTRL,
+				   GENCONF_CLK_GATING_CTRL_ND_GATE,
+				   GENCONF_CLK_GATING_CTRL_ND_GATE);
 
-		regmap_read(sysctrl_base, GENCONF_ND_CLK_CTRL, &reg);
-		reg |= GENCONF_ND_CLK_CTRL_EN;
-		regmap_write(sysctrl_base, GENCONF_ND_CLK_CTRL, reg);
+		regmap_update_bits(sysctrl_base, GENCONF_ND_CLK_CTRL,
+				   GENCONF_ND_CLK_CTRL_EN,
+				   GENCONF_ND_CLK_CTRL_EN);
 	}
 
 	/* Configure the DMA if appropriate */
-- 
2.20.1



