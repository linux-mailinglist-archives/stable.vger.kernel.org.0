Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3295499601
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354747AbiAXU6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:58:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48216 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442444AbiAXUyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:54:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 812D5612E9;
        Mon, 24 Jan 2022 20:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6E4C36AE9;
        Mon, 24 Jan 2022 20:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057674;
        bh=6p4xdbbsxT246YjsLChIgTjGYl8VYvjihW6+X1ld13w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZ8JnfUUVlT8GGL/eeg+HomrOm9RPz/3jgKy/5XDLgFtyb/PKw1ZHOdmZnnLQPBi/
         FLNC8CBbV8cj+5FOU6zw6Gu8jHbX6QXq4tKl9oJxQrOxkbuKh1t28WIfHidX1Ei/D0
         TjjM4D0wVHpBgHUgxEBI2g05d47zXFsXKb6ScwNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Christian Eggers <ceggers@arri.de>, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.16 0015/1039] mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings
Date:   Mon, 24 Jan 2022 19:30:04 +0100
Message-Id: <20220124184125.652572361@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -713,14 +713,32 @@ static void gpmi_nfc_compute_timings(str
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
@@ -739,6 +757,8 @@ static void gpmi_nfc_apply_timings(struc
 
 	/* Wait for the DLL to settle. */
 	udelay(dll_wait_time_us);
+
+	return 0;
 }
 
 static int gpmi_setup_interface(struct nand_chip *chip, int chipnr,
@@ -2278,7 +2298,9 @@ static int gpmi_nfc_exec_op(struct nand_
 	 */
 	if (this->hw.must_apply_timings) {
 		this->hw.must_apply_timings = false;
-		gpmi_nfc_apply_timings(this);
+		ret = gpmi_nfc_apply_timings(this);
+		if (ret)
+			return ret;
 	}
 
 	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);


