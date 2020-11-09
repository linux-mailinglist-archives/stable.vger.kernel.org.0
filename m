Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273B82ABA44
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387574AbgKINRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387570AbgKINRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48FB920731;
        Mon,  9 Nov 2020 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927836;
        bh=8vZ9IMkypuleCuYxlDjDrbIeHH9kSWQxUCLga1ZFtM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Poi8K0cezZtCF4lgiqSKIEfcb/X/w8J2qONYENWj73hioHPHMMbsYG+J4WXIoAHVv
         g7bT/1f2bUrWAmrQBh3uhhrK2KZNJyIfrqFMVyHWkHUT7RTn5/OoxCcxRbyZMuzoAT
         2MpRFj8Tg+7SX4qf6Gof94z8YOF08t41VfSXhGD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Ungerer <gerg@linux-m68k.org>,
        Fugang Duan <fugand.duan@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Clemens Gruber <clemens.gruber@pqgruber.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 038/133] net: fec: fix MDIO probing for some FEC hardware blocks
Date:   Mon,  9 Nov 2020 13:55:00 +0100
Message-Id: <20201109125032.543394272@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Ungerer <gerg@linux-m68k.org>

[ Upstream commit 1e6114f51f9d4090390fcec2f5d67d8cc8dc4bfc ]

Some (apparently older) versions of the FEC hardware block do not like
the MMFR register being cleared to avoid generation of MII events at
initialization time. The action of clearing this register results in no
future MII events being generated at all on the problem block. This means
the probing of the MDIO bus will find no PHYs.

Create a quirk that can be checked at the FECs MII init time so that
the right thing is done. The quirk is set as appropriate for the FEC
hardware blocks that are known to need this.

Fixes: f166f890c8f0 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Acked-by: Fugang Duan <fugand.duan@nxp.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Clemens Gruber <clemens.gruber@pqgruber.com>
Link: https://lore.kernel.org/r/20201028052232.1315167-1-gerg@linux-m68k.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec.h      |    6 ++++++
 drivers/net/ethernet/freescale/fec_main.c |   29 ++++++++++++++++-------------
 2 files changed, 22 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -456,6 +456,12 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_HAS_FRREG		(1 << 16)
 
+/* Some FEC hardware blocks need the MMFR cleared at setup time to avoid
+ * the generation of an MII event. This must be avoided in the older
+ * FEC blocks where it will stop MII events being generated.
+ */
+#define FEC_QUIRK_CLEAR_SETUP_MII	(1 << 17)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -100,14 +100,14 @@ static const struct fec_devinfo fec_imx2
 static const struct fec_devinfo fec_imx28_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
 		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_FRREG,
+		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static const struct fec_devinfo fec_imx6q_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
-		  FEC_QUIRK_HAS_RACC,
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static const struct fec_devinfo fec_mvf600_info = {
@@ -119,7 +119,8 @@ static const struct fec_devinfo fec_imx6
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
-		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
+		  FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static const struct fec_devinfo fec_imx6ul_info = {
@@ -127,7 +128,7 @@ static const struct fec_devinfo fec_imx6
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
 		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_COALESCE,
+		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static struct platform_device_id fec_devtype[] = {
@@ -2135,15 +2136,17 @@ static int fec_enet_mii_init(struct plat
 	if (suppress_preamble)
 		fep->phy_speed |= BIT(7);
 
-	/* Clear MMFR to avoid to generate MII event by writing MSCR.
-	 * MII event generation condition:
-	 * - writing MSCR:
-	 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
-	 *	  mscr_reg_data_in[7:0] != 0
-	 * - writing MMFR:
-	 *	- mscr[7:0]_not_zero
-	 */
-	writel(0, fep->hwp + FEC_MII_DATA);
+	if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
+		/* Clear MMFR to avoid to generate MII event by writing MSCR.
+		 * MII event generation condition:
+		 * - writing MSCR:
+		 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
+		 *	  mscr_reg_data_in[7:0] != 0
+		 * - writing MMFR:
+		 *	- mscr[7:0]_not_zero
+		 */
+		writel(0, fep->hwp + FEC_MII_DATA);
+	}
 
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 


