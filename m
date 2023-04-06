Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16ED66D94D1
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjDFLNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbjDFLNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:13:47 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B3B7A9D;
        Thu,  6 Apr 2023 04:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680779626; x=1712315626;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=QAJ9P8dq596wmjAEnWlX5SgBAiqCduCtOC32HFEl8lo=;
  b=eVxfdeJ2FtMPsx0+st69I0Tvef+GLn8mEWewN80VIPWgoYDWyVUF9xDR
   HeVbGDwzTgSHKdLIxM27DZisywyAfqxqqFPzsXm2UXW8YzaDtnhl0JVPr
   LcXAePprDQuLxlidgjd/Xdmf3GoxYz6qdT4015pHajOnvHFHfYJ9ZjHRy
   KfxTPLT35CAFKp7kwZQS8voYy/aO6PJRq4bhBBnVeRqYlDlj9AKNqg+ki
   LJ6iatyJlfutyRPokVwyBzFPUhzSMDX/cGLp1mUzfWua7ewHBfIPPOwCA
   y+EKgmklpL+gsO4liHL3zWnhRgw2fTn3kV4HqilyeIcljagPPsOruzNOx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="341441867"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="341441867"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 04:12:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="637244714"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="637244714"
Received: from ehakkine-mobl.ger.corp.intel.com ([10.251.210.67])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 04:12:18 -0700
Date:   Thu, 6 Apr 2023 14:12:12 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     =?ISO-8859-15?Q?Jan_Kundr=E1t?= <jan.kundrat@cesnet.cz>
cc:     linux-serial <linux-serial@vger.kernel.org>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Cosmin Tanislav <demonsingur@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] serial: max310x: fix IO data corruption in batched
 operations
In-Reply-To: <79db8e82aadb0e174bc82b9996423c3503c8fb37.1680732084.git.jan.kundrat@cesnet.cz>
Message-ID: <bcc7e54c-e570-a9a2-678c-886b7b35c2aa@linux.intel.com>
References: <79db8e82aadb0e174bc82b9996423c3503c8fb37.1680732084.git.jan.kundrat@cesnet.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1090918820-1680779540=:2189"
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1090918820-1680779540=:2189
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 5 Apr 2023, Jan Kundrát wrote:

> After upgrading from 5.16 to 6.1, our board with a MAX14830 started
> producing lots of garbage data over UART. Bisection pointed out commit
> 285e76fc049c as the culprit. That patch tried to replace hand-written
> code which I added in 2b4bac48c1084 ("serial: max310x: Use batched reads
> when reasonably safe") with the generic regmap infrastructure for
> batched operations.
> 
> Unfortunately, the `regmap_raw_read` and `regmap_raw_write` which were
> used are actually functions which perform IO over *multiple* registers.
> That's not what is needed for accessing these Tx/Rx FIFOs; the
> appropriate functions are the `_noinc_` versions, not the `_raw_` ones.
> 
> Fix this regression by using `regmap_noinc_read()` and
> `regmap_noinc_write()` along with the necessary `regmap_config` setup;
> with this patch in place, our board communicates happily again. Since
> our board uses SPI for talking to this chip, the I2C part is completely
> untested.
> 
> Fixes: 285e76fc049c serial: max310x: use regmap methods for SPI batch operations
> Signed-off-by: Jan Kundrát <jan.kundrat@cesnet.cz>
> Cc: stable@vger.kernel.org
> ---
>  drivers/tty/serial/max310x.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
> index c82391c928cb..47520d4a381f 100644
> --- a/drivers/tty/serial/max310x.c
> +++ b/drivers/tty/serial/max310x.c
> @@ -529,6 +529,11 @@ static bool max310x_reg_precious(struct device *dev, unsigned int reg)
>  	return false;
>  }
>  
> +static bool max310x_reg_noinc(struct device *dev, unsigned int reg)
> +{
> +	return reg == MAX310X_RHR_REG;

I'd either add a comment or just do || reg == MAX310X_THR_REG (which 
probably gets optimized away by the compiler) to make it look less magic 
for the Tx side.

-- 
 i.

> +}
> +
>  static int max310x_set_baud(struct uart_port *port, int baud)
>  {
>  	unsigned int mode = 0, div = 0, frac = 0, c = 0, F = 0;
> @@ -658,14 +663,14 @@ static void max310x_batch_write(struct uart_port *port, u8 *txbuf, unsigned int
>  {
>  	struct max310x_one *one = to_max310x_port(port);
>  
> -	regmap_raw_write(one->regmap, MAX310X_THR_REG, txbuf, len);
> +	regmap_noinc_write(one->regmap, MAX310X_THR_REG, txbuf, len);
>  }
>  
>  static void max310x_batch_read(struct uart_port *port, u8 *rxbuf, unsigned int len)
>  {
>  	struct max310x_one *one = to_max310x_port(port);
>  
> -	regmap_raw_read(one->regmap, MAX310X_RHR_REG, rxbuf, len);
> +	regmap_noinc_read(one->regmap, MAX310X_RHR_REG, rxbuf, len);
>  }
>  
>  static void max310x_handle_rx(struct uart_port *port, unsigned int rxlen)
> @@ -1480,6 +1485,10 @@ static struct regmap_config regcfg = {
>  	.writeable_reg = max310x_reg_writeable,
>  	.volatile_reg = max310x_reg_volatile,
>  	.precious_reg = max310x_reg_precious,
> +	.writeable_noinc_reg = max310x_reg_noinc,
> +	.readable_noinc_reg = max310x_reg_noinc,
> +	.max_raw_read = MAX310X_FIFO_SIZE,
> +	.max_raw_write = MAX310X_FIFO_SIZE,
>  };
>  
>  #ifdef CONFIG_SPI_MASTER
> @@ -1565,6 +1574,10 @@ static struct regmap_config regcfg_i2c = {
>  	.volatile_reg = max310x_reg_volatile,
>  	.precious_reg = max310x_reg_precious,
>  	.max_register = MAX310X_I2C_REVID_EXTREG,
> +	.writeable_noinc_reg = max310x_reg_noinc,
> +	.readable_noinc_reg = max310x_reg_noinc,
> +	.max_raw_read = MAX310X_FIFO_SIZE,
> +	.max_raw_write = MAX310X_FIFO_SIZE,
>  };
>  
>  static const struct max310x_if_cfg max310x_i2c_if_cfg = {
> 

--8323329-1090918820-1680779540=:2189--
