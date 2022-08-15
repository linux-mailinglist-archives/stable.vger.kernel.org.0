Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10982593CE5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241247AbiHOUN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346900AbiHOUMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:12:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F1A86C38;
        Mon, 15 Aug 2022 11:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E40A1B81057;
        Mon, 15 Aug 2022 18:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5C7C433D7;
        Mon, 15 Aug 2022 18:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589911;
        bh=/ETDo4V7GPQUwRsVjK5Nh+gt4dXLrxqWmPgcWmO53ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRh52GAfvQ8BQbWCv6E1jkUy3/QNZdetCC0m+dExgKkcc7VjHkockHz4WN4tPcEGm
         h6JcNaxfJ8pTD2tsS+xoxlkRHqqiJUGkZxFdAU7L73tcfkmzAyBpIPe/bPmBkC1qG8
         07xLaDq+Ry9RkwzZveU1iOwYh2+P5m0mFBh9whRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kitaina <okitain@gmail.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.18 0088/1095] mtd: rawnand: arasan: Fix clock rate in NV-DDR
Date:   Mon, 15 Aug 2022 19:51:27 +0200
Message-Id: <20220815180433.154443347@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Olga Kitaina <okitain@gmail.com>

commit e16eceea863b417fd328588b1be1a79de0bc937f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -1043,7 +1043,13 @@ static int anfc_setup_interface(struct n
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


