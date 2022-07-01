Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBA2562FB7
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiGAJTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 05:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiGAJTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 05:19:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765C4523A6
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 02:19:13 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o7Cnu-0004C7-88; Fri, 01 Jul 2022 11:19:10 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o7Cnt-0002O8-KE; Fri, 01 Jul 2022 11:19:09 +0200
Date:   Fri, 1 Jul 2022 11:19:09 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-mtd@lists.infradead.org
Cc:     Han Xu <han.xu@nxp.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@pengutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH] [REALLY REALLY BROKEN] mtd: rawnand: gpmi: Fix setting
 busy timeout setting
Message-ID: <20220701091909.GE2387@pengutronix.de>
References: <20220614083138.3455683-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614083138.3455683-1-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:46:16 up 92 days, 21:15, 82 users,  load average: 0.07, 0.08,
 0.12
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 10:31:38AM +0200, Sascha Hauer wrote:
> The DEVICE_BUSY_TIMEOUT value is described in the Reference Manual as:
> 
> | Timeout waiting for NAND Ready/Busy or ATA IRQ. Used in WAIT_FOR_READY
> | mode. This value is the number of GPMI_CLK cycles multiplied by 4096.
> 
> So instead of multiplying the value in cycles with 4096, we have to
> divide it by that value. Use DIV_ROUND_UP to make sure we are on the
> safe side, especially when the calculated value in cycles is smaller
> than 4096 as typically the case.
> 
> This bug likely never triggered because any timeout != 0 usually will
> do. In my case the busy timeout in cycles was originally calculated as
> 2408, which multiplied with 4096 is 0x968000. The lower 16 bits were
> taken for the 16 bit wide register field, so the register value was
> 0x8000. With 2970bf5a32f0 ("mtd: rawnand: gpmi: fix controller timings
> setting") however the value in cycles became 2384, which multiplied
> with 4096 is 0x950000. The lower 16 bit are 0x0 now resulting in an
> intermediate timeout when reading from NAND.
> 
> Fixes: b1206122069aa ("mtd: rawnand: gpmi: use core timings instead of an empirical derivation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
> 
> Just a resend with +Cc: stable@vger.kernel.org
> 
>  drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> index 0b68d05846e18..889e403299568 100644
> --- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> +++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> @@ -890,7 +890,7 @@ static int gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
>  	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
>  		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
>  		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
> -	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
> +	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));

This patch is broken. The change itself is fine, but busy_timeout_cycles
is calculated wrong.

busy_timeout_cycles is calculated based on sdr->tR_max which is the page
read time. This timeout is also used for the page program and block
erase operations which have orders of magnitude bigger timeouts. This
means with this patch the controller times out on pages programs and
block erase operations. With the current code this timeout will be
silent as the timeout interrupt is not active.

** THIS PATCH WILL CAUSE DATA LOSS ON YOUR NAND!! **

Fortunately this patch hasn't been included in any mainline release, but
unfortunately it showed up in several stable kernels. Don't use
v5.4.202, v5.10.127, v5.15.51 or v5.18.8 on i.MX[678] or i.MX28 boards
with NAND.

I am sorry for the trouble I have likely caused. I am working on a fix
and will post it later the day.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
