Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7661455E31A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiF0Ld5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiF0LdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:33:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CB1BE05;
        Mon, 27 Jun 2022 04:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 663B8B8111A;
        Mon, 27 Jun 2022 11:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77BBC3411D;
        Mon, 27 Jun 2022 11:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329409;
        bh=rluxQ2+A54yIjuuZuUh66DBwb2gFHEaBDbn3E7gQcac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t67rs93C1/aQz3AqZQXy4eQB/oPDJwh6vB5xMRj88sSgnbM4j+QEI6XeLqRDyI5hK
         taFLWT6k1FsXFfCpX3aBXTze+eRKccCzUhPEaQsH7f+hQ7zCViytNFnr7YcvIB14+C
         2DDu9FAug+5ySfvGaVAX/1o9VFRg5H2k79r6Bv38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 09/60] mtd: rawnand: gpmi: Fix setting busy timeout setting
Date:   Mon, 27 Jun 2022 13:21:20 +0200
Message-Id: <20220627111927.925744356@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 06781a5026350cde699d2d10c9914a25c1524f45 upstream.

The DEVICE_BUSY_TIMEOUT value is described in the Reference Manual as:

| Timeout waiting for NAND Ready/Busy or ATA IRQ. Used in WAIT_FOR_READY
| mode. This value is the number of GPMI_CLK cycles multiplied by 4096.

So instead of multiplying the value in cycles with 4096, we have to
divide it by that value. Use DIV_ROUND_UP to make sure we are on the
safe side, especially when the calculated value in cycles is smaller
than 4096 as typically the case.

This bug likely never triggered because any timeout != 0 usually will
do. In my case the busy timeout in cycles was originally calculated as
2408, which multiplied with 4096 is 0x968000. The lower 16 bits were
taken for the 16 bit wide register field, so the register value was
0x8000. With 2970bf5a32f0 ("mtd: rawnand: gpmi: fix controller timings
setting") however the value in cycles became 2384, which multiplied
with 4096 is 0x950000. The lower 16 bit are 0x0 now resulting in an
intermediate timeout when reading from NAND.

Fixes: b1206122069aa ("mtd: rawnand: gpmi: use core timings instead of an empirical derivation")
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220614083138.3455683-1-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -682,7 +682,7 @@ static void gpmi_nfc_compute_timings(str
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
 		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
-	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
+	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));
 
 	/*
 	 * Derive NFC ideal delay from {3}:


