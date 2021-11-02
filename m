Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0CF443782
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 21:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhKBU51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 16:57:27 -0400
Received: from mailout10.rmx.de ([94.199.88.75]:51886 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230061AbhKBU5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 16:57:24 -0400
X-Greylist: delayed 1986 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Nov 2021 16:57:24 EDT
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4HkLsJ0bxbz33G7;
        Tue,  2 Nov 2021 21:21:40 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4HkLrz3xN8z2TTHk;
        Tue,  2 Nov 2021 21:21:23 +0100 (CET)
Received: from N95HX1G2.arri.de (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 2 Nov
 2021 21:21:22 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Michael Trimarchi <michael@amarulasolutions.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Riedmueller <S.Riedmueller@phytec.de>,
        Han Xu <han.xu@nxp.com>, Greg Ungerer <gerg@kernel.org>
CC:     Sascha Hauer <s.hauer@pengutronix.de>,
        Christian Hemp <C.Hemp@phytec.de>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        "Stefan Riedmueller" <s.riedmueller@phytec.de>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/2] gpmi-nand: Add ERR007117 protection for nfc_apply_timings
Date:   Tue, 2 Nov 2021 21:20:22 +0100
Message-ID: <20211102202022.15551-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211102202022.15551-1-ceggers@arri.de>
References: <20211102202022.15551-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20211102-212123-kxqJGwhBvLjf-0@out02.hq
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

gpmi_io clock needs to be gated off when changing the parent/dividers of
enfc_clk_root (i.MX6Q/i.MX6UL) respectively qspi2_clk_root (i.MX6SX).
Otherwise this rate change can lead to an unresponsive GPMI core which
results in DMA timeouts and failed driver probe:

[    4.072318] gpmi-nand 112000.gpmi-nand: DMA timeout, last DMA
...
[    4.370355] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -110
...
[    4.375988] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -22
[    4.381524] gpmi-nand 112000.gpmi-nand: Error in ECC-based read: -22
[    4.387988] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -22
[    4.393535] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -22
...

Other than stated in i.MX 6 erratum ERR007117, it should be sufficient
to gate only gpmi_io because all other bch/nand clocks are derived from
different clock roots.

The i.MX6 reference manuals state that changing clock muxers can cause
glitches but are silent about changing dividers. But tests showed that
these glitches can definitely happen on i.MX6ULL. For i.MX7D/8MM in turn,
the manual guarantees that no glitches can happen when changing
dividers.

Co-developed-by: Stefan Riedmueller <s.riedmueller@phytec.de>
Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
Changelog:
-----------
RFC --> v1
- added comment about clock divider behavior on the different i.MX series
- perform clock gating also on i.MX6SX
- only gate gpmi_io clock. Other GPMI/BCH clocks are not affected when
  ENFC_CLK_ROOT divides are changes
- add error checking for clk_set_rate()
- Cc: stable@vger.kernel.org

 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 28 +++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index a1f7000f033e..6e9f7d80ef8b 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -713,14 +713,32 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 			      (use_half_period ? BM_GPMI_CTRL1_HALF_PERIOD : 0);
 }
 
-static void gpmi_nfc_apply_timings(struct gpmi_nand_data *this)
+static int gpmi_nfc_apply_timings(struct gpmi_nand_data *this)
 {
 	struct gpmi_nfc_hardware_timing *hw = &this->hw;
 	struct resources *r = &this->resources;
 	void __iomem *gpmi_regs = r->gpmi_regs;
 	unsigned int dll_wait_time_us;
+	int ret;
+
+	/* Clock dividers do NOT guarantee a clean clock signal on its output
+	 * during the change of the divide factor on i.MX6Q/UL/SX. On i.MX7/8,
+	 * all clock dividers provide these guarantee.
+	 */
+	if (GPMI_IS_MX6Q(this) || GPMI_IS_MX6SX(this))
+		clk_disable_unprepare(r->clock[0]);
+
+	ret = clk_set_rate(r->clock[0], hw->clk_rate);
+	if (ret) {
+		dev_err(this->dev, "cannot set clock rate to %lu Hz: %d\n", hw->clk_rate, ret);
+		return ret;
+	}
 
-	clk_set_rate(r->clock[0], hw->clk_rate);
+	if (GPMI_IS_MX6Q(this) || GPMI_IS_MX6SX(this)) {
+		ret = clk_prepare_enable(r->clock[0]);
+		if (ret)
+			return ret;
+	}
 
 	writel(hw->timing0, gpmi_regs + HW_GPMI_TIMING0);
 	writel(hw->timing1, gpmi_regs + HW_GPMI_TIMING1);
@@ -739,6 +757,8 @@ static void gpmi_nfc_apply_timings(struct gpmi_nand_data *this)
 
 	/* Wait for the DLL to settle. */
 	udelay(dll_wait_time_us);
+
+	return 0;
 }
 
 static int gpmi_setup_interface(struct nand_chip *chip, int chipnr,
@@ -2271,7 +2291,9 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 	 */
 	if (this->hw.must_apply_timings) {
 		this->hw.must_apply_timings = false;
-		gpmi_nfc_apply_timings(this);
+		ret = gpmi_nfc_apply_timings(this);
+		if (ret)
+			return ret;
 	}
 
 	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

