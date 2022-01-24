Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD03549902B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346517AbiAXT6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351785AbiAXTwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:52:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61491C06138F;
        Mon, 24 Jan 2022 11:25:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC8DD61488;
        Mon, 24 Jan 2022 19:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB123C340EA;
        Mon, 24 Jan 2022 19:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052346;
        bh=g7mHWUR/GWhbjh5JLbfZd53yt1tiPR9RD2IitNW5qzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuJdjbRHGUjmYqj6yGR/wDkd++ODSmiRmUs1li60fZBCcmzA/wi7YgteNmmImkrWV
         2Bn9bOIZWssiXQoqccL093ml5Fsb4ndQ/JjR2rZwbVpnjq1o7CB+j53qazAWFrGehy
         xSd2+METCPxJIV0jQOStDvcFMSALIhmUki4mT03E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Christian Eggers <ceggers@arri.de>, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 007/320] mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings
Date:   Mon, 24 Jan 2022 19:39:51 +0100
Message-Id: <20220124183954.021297586@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

commit f53d4c109a666bf1a4883b45d546fba079258717 upstream.

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
Acked-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211102202022.15551-2-ceggers@arri.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -710,14 +710,32 @@ static void gpmi_nfc_compute_timings(str
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
@@ -736,6 +754,8 @@ static void gpmi_nfc_apply_timings(struc
 
 	/* Wait for the DLL to settle. */
 	udelay(dll_wait_time_us);
+
+	return 0;
 }
 
 static int gpmi_setup_data_interface(struct nand_chip *chip, int chipnr,
@@ -2429,7 +2449,9 @@ static int gpmi_nfc_exec_op(struct nand_
 	 */
 	if (this->hw.must_apply_timings) {
 		this->hw.must_apply_timings = false;
-		gpmi_nfc_apply_timings(this);
+		ret = gpmi_nfc_apply_timings(this);
+		if (ret)
+			return ret;
 	}
 
 	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);


