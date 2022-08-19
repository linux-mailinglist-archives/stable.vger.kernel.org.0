Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED8959A401
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354467AbiHSQyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354387AbiHSQxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:53:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384E512E137;
        Fri, 19 Aug 2022 09:15:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B259FB8281E;
        Fri, 19 Aug 2022 16:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4D0C433C1;
        Fri, 19 Aug 2022 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925347;
        bh=eou5GJzj1FvAtUZvfuzQ41sL1a5kEyKGxeirdLNXbY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gg0SrLC1TqEGq7WHHUzUve+/G067T6LOMcIYYD9viiGsn3MJDEUta/yw5oRsU5E3C
         AiGhANxceRtENPq6gNMtOT4shkRe1jH8r5a3nASCm9ZnehTKv//0PPNTGkO+PRsmGe
         NM7W+tBw+ELB8yS+62wjCQojnRp1Y6mCXbx0T5AI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 462/545] mtd: rawnand: arasan: Support NV-DDR interface
Date:   Fri, 19 Aug 2022 17:43:52 +0200
Message-Id: <20220819153850.062701266@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 4edde60314587382e42141df2f41ca968dc20737 ]

Add support for the NV-DDR interface.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210505213750.257417-23-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c | 27 ++++++++++++++-----
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/raw/arasan-nand-controller.c b/drivers/mtd/nand/raw/arasan-nand-controller.c
index a3d4ee988394..f926d658192b 100644
--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -885,25 +885,38 @@ static int anfc_setup_interface(struct nand_chip *chip, int target,
 	struct arasan_nfc *nfc = to_anfc(chip->controller);
 	struct device_node *np = nfc->dev->of_node;
 	const struct nand_sdr_timings *sdr;
-
-	sdr = nand_get_sdr_timings(conf);
-	if (IS_ERR(sdr))
-		return PTR_ERR(sdr);
+	const struct nand_nvddr_timings *nvddr;
+
+	if (nand_interface_is_nvddr(conf)) {
+		nvddr = nand_get_nvddr_timings(conf);
+		if (IS_ERR(nvddr))
+			return PTR_ERR(nvddr);
+	} else {
+		sdr = nand_get_sdr_timings(conf);
+		if (IS_ERR(sdr))
+			return PTR_ERR(sdr);
+	}
 
 	if (target < 0)
 		return 0;
 
-	anand->timings = DIFACE_SDR | DIFACE_SDR_MODE(conf->timings.mode);
+	if (nand_interface_is_sdr(conf))
+		anand->timings = DIFACE_SDR |
+				 DIFACE_SDR_MODE(conf->timings.mode);
+	else
+		anand->timings = DIFACE_NVDDR |
+				 DIFACE_DDR_MODE(conf->timings.mode);
+
 	anand->clk = ANFC_XLNX_SDR_DFLT_CORE_CLK;
 
 	/*
 	 * Due to a hardware bug in the ZynqMP SoC, SDR timing modes 0-1 work
 	 * with f > 90MHz (default clock is 100MHz) but signals are unstable
 	 * with higher modes. Hence we decrease a little bit the clock rate to
-	 * 80MHz when using modes 2-5 with this SoC.
+	 * 80MHz when using SDR modes 2-5 with this SoC.
 	 */
 	if (of_device_is_compatible(np, "xlnx,zynqmp-nand-controller") &&
-	    conf->timings.mode >= 2)
+	    nand_interface_is_sdr(conf) && conf->timings.mode >= 2)
 		anand->clk = ANFC_XLNX_SDR_HS_CORE_CLK;
 
 	return 0;
-- 
2.35.1



