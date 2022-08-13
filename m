Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85837591A8E
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiHMNWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiHMNWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:22:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1318337F96
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4BB9B80108
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEBAC433D6;
        Sat, 13 Aug 2022 13:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660396919;
        bh=/Xo1MhPxajNkRJH/vrNtDXFxIK1U4qrXnJPuTXgNl04=;
        h=Subject:To:Cc:From:Date:From;
        b=Q2Jw6rFGAaqQWr4P7VykGAut6jDRwjPAD0N5wykFlAiLVW0EFmvt9Yzy9e3lY6/bj
         bh5mXKjtjloKJE1IwX/w0EMNDs+xyBz5euGEBsmpJCrcPtShzI/o0FPgmnoCtK65rM
         dSrqqc1/Gm/A66Lh7VaQ/2/2Ke/jM5x3yfmvFQYU=
Subject: FAILED: patch "[PATCH] mtd: rawnand: arasan: Fix clock rate in NV-DDR" failed to apply to 5.10-stable tree
To:     okitain@gmail.com, amit.kumar-mahapatra@xilinx.com,
        miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 15:21:56 +0200
Message-ID: <166039691640103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e16eceea863b417fd328588b1be1a79de0bc937f Mon Sep 17 00:00:00 2001
From: Olga Kitaina <okitain@gmail.com>
Date: Tue, 28 Jun 2022 21:18:24 +0530
Subject: [PATCH] mtd: rawnand: arasan: Fix clock rate in NV-DDR

According to the Arasan NAND controller spec, the flash clock rate for SDR
must be <= 100 MHz, while for NV-DDR it must be the same as the rate of the
CLK line for the mode. The driver previously always set 100 MHz for NV-DDR,
which would result in incorrect behavior for NV-DDR modes 0-4.

The appropriate clock rate can be calculated from the NV-DDR timing
parameters as 1/tCK, or for rates measured in picoseconds,
10^12 / nand_nvddr_timings->tCK_min.

Fixes: 197b88fecc50 ("mtd: rawnand: arasan: Add new Arasan NAND controller")
CC: stable@vger.kernel.org # 5.8+
Signed-off-by: Olga Kitaina <okitain@gmail.com>
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220628154824.12222-3-amit.kumar-mahapatra@xilinx.com

diff --git a/drivers/mtd/nand/raw/arasan-nand-controller.c b/drivers/mtd/nand/raw/arasan-nand-controller.c
index c5264fa223c4..296fb16c8dc3 100644
--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -1043,7 +1043,13 @@ static int anfc_setup_interface(struct nand_chip *chip, int target,
 				 DQS_BUFF_SEL_OUT(dqs_mode);
 	}
 
-	anand->clk = ANFC_XLNX_SDR_DFLT_CORE_CLK;
+	if (nand_interface_is_sdr(conf)) {
+		anand->clk = ANFC_XLNX_SDR_DFLT_CORE_CLK;
+	} else {
+		/* ONFI timings are defined in picoseconds */
+		anand->clk = div_u64((u64)NSEC_PER_SEC * 1000,
+				     conf->timings.nvddr.tCK_min);
+	}
 
 	/*
 	 * Due to a hardware bug in the ZynqMP SoC, SDR timing modes 0-1 work

