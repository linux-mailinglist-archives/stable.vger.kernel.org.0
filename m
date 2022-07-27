Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4B3582E38
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbiG0RKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241601AbiG0RJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:09:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D1850044;
        Wed, 27 Jul 2022 09:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BC7960DDB;
        Wed, 27 Jul 2022 16:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82859C433D6;
        Wed, 27 Jul 2022 16:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940053;
        bh=nO9vN98lzG+8FMhdNslgASCIMtubLetqdATFaeG8C6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pxi2Kg1zAOhs45d6rLvGHU12cwiKum404hulsITdtAqewZtItxPwuG4OjhaRGg5rJ
         WWqRCXal/ZsTOk4HqjreEOqVM4bZ+O0XPVtLjT3uYPBGVpomkC8zAh3QHTH0wMjw0Y
         t0yFxnFM3PrQjU4aIvXAn0WYBIVG/PDZJ4nAwT6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/201] mtd: rawnand: gpmi: validate controller clock rate
Date:   Wed, 27 Jul 2022 18:09:35 +0200
Message-Id: <20220727161029.886728305@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 15e27d197a7ea69b4643791ca2f8467fdd998359 ]

What to do when the real rate of the gpmi clock is not equal to the
required one? The solutions proposed in [1] did not lead to a conclusion
on how to validate the clock rate, so, inspired by the document [2], I
consider the rate correct only if not lower or equal to the rate of the
previous edo mode. In fact, in chapter 4.16.2 (NV-DDR) of the document [2],
it is written that "If the host selects timing mode n, then its clock
period shall be faster than the clock period of timing mode n-1 and
slower than or equal to the clock period of timing mode n.". I thought
that it could therefore also be used in this case, without therefore
having to define the valid rate ranges empirically.

For example, suppose that gpmi_nfc_compute_timings() is called to set
edo mode 5 (100MHz) but the rate returned by clk_round_rate() is 80MHz
(edo mode 4). In this case gpmi_nfc_compute_timings() will return error,
and will be called again to set edo mode 4, which this time will be
successful.

[1] https://lore.kernel.org/r/20210702065350.209646-5-ebiggers@kernel.org
[2] http://www.onfi.org/-/media/client/onfi/specs/onfi_3_0_gold.pdf?la=en

Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220118095434.35081-4-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index b72b387c08ef..62f4988c2a5f 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -644,8 +644,8 @@ static int bch_set_geometry(struct gpmi_nand_data *this)
  *         RDN_DELAY = -----------------------     {3}
  *                           RP
  */
-static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
-				     const struct nand_sdr_timings *sdr)
+static int gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
+				    const struct nand_sdr_timings *sdr)
 {
 	struct gpmi_nfc_hardware_timing *hw = &this->hw;
 	struct resources *r = &this->resources;
@@ -657,23 +657,33 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	int sample_delay_ps, sample_delay_factor;
 	u16 busy_timeout_cycles;
 	u8 wrn_dly_sel;
+	unsigned long clk_rate, min_rate;
 
 	if (sdr->tRC_min >= 30000) {
 		/* ONFI non-EDO modes [0-3] */
 		hw->clk_rate = 22000000;
+		min_rate = 0;
 		wrn_dly_sel = BV_GPMI_CTRL1_WRN_DLY_SEL_4_TO_8NS;
 	} else if (sdr->tRC_min >= 25000) {
 		/* ONFI EDO mode 4 */
 		hw->clk_rate = 80000000;
+		min_rate = 22000000;
 		wrn_dly_sel = BV_GPMI_CTRL1_WRN_DLY_SEL_NO_DELAY;
 	} else {
 		/* ONFI EDO mode 5 */
 		hw->clk_rate = 100000000;
+		min_rate = 80000000;
 		wrn_dly_sel = BV_GPMI_CTRL1_WRN_DLY_SEL_NO_DELAY;
 	}
 
-	hw->clk_rate = clk_round_rate(r->clock[0], hw->clk_rate);
+	clk_rate = clk_round_rate(r->clock[0], hw->clk_rate);
+	if (clk_rate <= min_rate) {
+		dev_err(this->dev, "clock setting: expected %ld, got %ld\n",
+			hw->clk_rate, clk_rate);
+		return -ENOTSUPP;
+	}
 
+	hw->clk_rate = clk_rate;
 	/* SDR core timings are given in picoseconds */
 	period_ps = div_u64((u64)NSEC_PER_SEC * 1000, hw->clk_rate);
 
@@ -714,6 +724,7 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 		hw->ctrl1n |= BF_GPMI_CTRL1_RDN_DELAY(sample_delay_factor) |
 			      BM_GPMI_CTRL1_DLL_ENABLE |
 			      (use_half_period ? BM_GPMI_CTRL1_HALF_PERIOD : 0);
+	return 0;
 }
 
 static int gpmi_nfc_apply_timings(struct gpmi_nand_data *this)
@@ -769,6 +780,7 @@ static int gpmi_setup_interface(struct nand_chip *chip, int chipnr,
 {
 	struct gpmi_nand_data *this = nand_get_controller_data(chip);
 	const struct nand_sdr_timings *sdr;
+	int ret;
 
 	/* Retrieve required NAND timings */
 	sdr = nand_get_sdr_timings(conf);
@@ -784,7 +796,9 @@ static int gpmi_setup_interface(struct nand_chip *chip, int chipnr,
 		return 0;
 
 	/* Do the actual derivation of the controller timings */
-	gpmi_nfc_compute_timings(this, sdr);
+	ret = gpmi_nfc_compute_timings(this, sdr);
+	if (ret)
+		return ret;
 
 	this->hw.must_apply_timings = true;
 
-- 
2.35.1



