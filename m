Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0630E57638E
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiGOOWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGOOWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:22:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E06862A62
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:22:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l12so3349025plk.13
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=scD5Y6x8Dpii4wtV8lReK71mpwGJMxDbW8aqYBDgeNI=;
        b=P7YBPp4VxZafQR8wxDfEMTbszffEPaXUZfooPpzw1qP6Z/tBabiKR6Y/IYGtxXdoSm
         HXAtK0pa0mu8Mhm6YKeKNgVDA4QGY/dYMAFS8NKGGFKR7GsVKz42vNKVeYdosnkL067K
         JkTFwVvF8PrMOaHRLkrIq8ZKX4DkWpqpx6c3aoMgOp7wsaZhUPEWw9K1f+jYFLzEEqzd
         fIKa367VbsmEH3RbxlKciafYlSUr5nnhptjV7ZLP17UHGpmF/fXUp7TF/oUgmGgAYsQu
         D77jUOhomMXDQmKY2lWGtZr+bZUhxvU0LOuOIZXnvw1q5y2yp1mzYA3iLdxrcCtnGWao
         Q1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=scD5Y6x8Dpii4wtV8lReK71mpwGJMxDbW8aqYBDgeNI=;
        b=M4qvPROsYpEUX5vptWqaSxE7oJ+b9PdsUraGYKQQxt3pVMI9s4bp+tW5Wu/l0k08MO
         9feKTLPH5b37Xru2T0nAUCGsvuF0lfCx4NEG2KGMU9xGB8P0Yb50e9bPwIFxgF9YC/G1
         CbEKhPx1MLodW/2Hu99GDF78Q4qdWx0joAkfytPpcBzSgCPlAO71ELjmUrNr827ehJ40
         wlS4gTM40tT3q1MdQtfZHN6EjbwaSxxzL7WJn4El4sMnWgkQWJPMqcC1a636dZpR8ePi
         Kahsym6RQ0wFphwOCIDupoOtlyOb8S2fkyeCBp4Mfe7G+/G+rcW4rDJ5Kvp3LBPro5MU
         4JhA==
X-Gm-Message-State: AJIora9Zd6n/Bzj9ikPEmqkIZgPlnKZSbtKdbj3wymPlsBgpTmS9b37D
        BtIOfetQLUMoSayIkxIw1Sc=
X-Google-Smtp-Source: AGRyM1s6txUyAuDdY9j0njA9GU/kwNRpimk3GXWtXzlwoE2/zj/C15RXSuCCW1nGjqoP7FNge9m7LA==
X-Received: by 2002:a17:90b:3b43:b0:1ef:d89b:3454 with SMTP id ot3-20020a17090b3b4300b001efd89b3454mr22310522pjb.87.1657894930959;
        Fri, 15 Jul 2022 07:22:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 200-20020a6304d1000000b004126fc7c986sm3312826pge.13.2022.07.15.07.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 07:22:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Jul 2022 07:22:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-mtd@lists.infradead.org, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@pengutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: gpmi: Fix setting busy timeout setting
Message-ID: <20220715142209.GA1688021@roeck-us.net>
References: <20220614083138.3455683-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614083138.3455683-1-s.hauer@pengutronix.de>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
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

I see this patch was reverted in a set of rush stable releases,
but I still see it in the mainline kernel. Is it going to be reverted
there as well ?

Thanks,
Guenter

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
>  
>  	/*
>  	 * Derive NFC ideal delay from {3}:
