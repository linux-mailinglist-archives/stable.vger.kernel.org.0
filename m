Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F14FE033
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 14:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiDLMdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 08:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353042AbiDLMcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 08:32:36 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672264C411;
        Tue, 12 Apr 2022 04:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1649764166; x=1681300166;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iJzP2kpL8zGPLz32hzxkQayaP42vKyZ45PBnqipnpCE=;
  b=cpaiD5j6rFnHL+rR8hA0OtJZiGkSS6R++JOf6/jpLKo1X6XzpudT5xsd
   2cIp6qfGae80et0Rj/h7zy0SLlZGzogzw03344oP4qFdwKZUIf8Cgx4jX
   XXipoZYL0W3Fv25DJio5IehE/qyxSa7FjIcssuHDpjBgFM6hBXepJRSrz
   n8eCiwEsFzCIwdkg1WxAlGH6IHMZl36ZMYFR4E1NAzrLGMFi2Yzc0qLdk
   FO7UyC4iISENfd4PWYPZqLKPOkaxem5ul0IccnKAp0WBH2r+OPMAMtc+w
   rqYJb5Fweq3f2tmoGKN51WVCdnSTBWKYbDzoI7tvURPSR06Wj/BKfPGjD
   w==;
X-IronPort-AV: E=Sophos;i="5.90,253,1643670000"; 
   d="scan'208";a="23248996"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 12 Apr 2022 13:49:22 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 12 Apr 2022 13:49:22 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 12 Apr 2022 13:49:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1649764162; x=1681300162;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iJzP2kpL8zGPLz32hzxkQayaP42vKyZ45PBnqipnpCE=;
  b=Khv6Lt6xLJ4pQNnNJ8M8WFOm8zgBUnjY0eige6Ml3HfNzp/+YN/VdRQj
   mIB3O0w8GnUVt9fBndMZuGFLK31mjBBQM2o2e7igYkYCTDK9wpZa6RS7R
   aJ64TbyoHfqbw0+uSQdx2gBkOPq6hF4DA2obbqcbBfCoZSxHOGsVldMLs
   DgpkMBsch0WqYNQs9xZxzLXO16IlhyibE2tqRM1kvwXTmc5U3a3Mzvr6z
   jz0GU9yMD9QSWIsbVT4bX4WxpsulPWli9KBe7q12UdtF4dD6og6likAsV
   /5mVgTCrn6Uvd9wEQWWYyeuzKsBGhdEjNvmu3O/JzgHF3Pc7pcovkSPy/
   w==;
X-IronPort-AV: E=Sophos;i="5.90,253,1643670000"; 
   d="scan'208";a="23248995"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 12 Apr 2022 13:49:22 +0200
Received: from schifferm-ubuntu (SCHIFFERM-M2.tq-net.de [10.121.49.14])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 94B8C280070;
        Tue, 12 Apr 2022 13:49:21 +0200 (CEST)
Message-ID: <d618fc184f162b1da8d75729b5939bed52308040.camel@ew.tq-group.com>
Subject: Re: [PATCH AUTOSEL 5.17 34/49] spi: cadence-quadspi: fix protocol
 setup for non-1-1-X operations
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        Pratyush Yadav <p.yadav@ti.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Tue, 12 Apr 2022 13:49:19 +0200
In-Reply-To: <20220412004411.349427-34-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
         <20220412004411.349427-34-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mark,

what's your plan regarding this patch and the other patch I sent [1]? I
think there has been some confusion regarding which solution we want to
backport to stable kernels (well, at least I'm confused...)

I'm fine with this patch getting backported, but in that case [1]
doesn't make sense anymore (in fact I expected this patch to be dropped
for now when I submitted [1], due to Pratyush Yadav's concerns).

Regards,
Matthias


[1] https://patchwork.kernel.org/project/spi-devel-general/patch/20220406132832.199777-1-matthias.schiffer@ew.tq-group.com/



On Mon, 2022-04-11 at 20:43 -0400, Sasha Levin wrote:
> From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> 
> [ Upstream commit 97e4827d775faa9a32b5e1a97959c69dd77d17a3 ]
> 
> cqspi_set_protocol() only set the data width, but ignored the command
> and address width (except for 8-8-8 DTR ops), leading to corruption
> of
> all transfers using 1-X-X or X-X-X ops. Fix by setting the other two
> widths as well.
> 
> While we're at it, simplify the code a bit by replacing the
> CQSPI_INST_TYPE_* constants with ilog2().
> 
> Tested on a TI AM64x with a Macronix MX25U51245G QSPI flash with 1-4-
> 4
> read and write operations.
> 
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Link: 
> https://lore.kernel.org/r/20220331110819.133392-1-matthias.schiffer@ew.tq-group.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/spi/spi-cadence-quadspi.c | 46 ++++++++---------------------
> --
>  1 file changed, 12 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-
> cadence-quadspi.c
> index b808c94641fa..75f356041138 100644
> --- a/drivers/spi/spi-cadence-quadspi.c
> +++ b/drivers/spi/spi-cadence-quadspi.c
> @@ -19,6 +19,7 @@
>  #include <linux/iopoll.h>
>  #include <linux/jiffies.h>
>  #include <linux/kernel.h>
> +#include <linux/log2.h>
>  #include <linux/module.h>
>  #include <linux/of_device.h>
>  #include <linux/of.h>
> @@ -102,12 +103,6 @@ struct cqspi_driver_platdata {
>  #define CQSPI_TIMEOUT_MS			500
>  #define CQSPI_READ_TIMEOUT_MS			10
>  
> -/* Instruction type */
> -#define CQSPI_INST_TYPE_SINGLE			0
> -#define CQSPI_INST_TYPE_DUAL			1
> -#define CQSPI_INST_TYPE_QUAD			2
> -#define CQSPI_INST_TYPE_OCTAL			3
> -
>  #define CQSPI_DUMMY_CLKS_PER_BYTE		8
>  #define CQSPI_DUMMY_BYTES_MAX			4
>  #define CQSPI_DUMMY_CLKS_MAX			31
> @@ -376,10 +371,6 @@ static unsigned int cqspi_calc_dummy(const
> struct spi_mem_op *op, bool dtr)
>  static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
>  			      const struct spi_mem_op *op)
>  {
> -	f_pdata->inst_width = CQSPI_INST_TYPE_SINGLE;
> -	f_pdata->addr_width = CQSPI_INST_TYPE_SINGLE;
> -	f_pdata->data_width = CQSPI_INST_TYPE_SINGLE;
> -
>  	/*
>  	 * For an op to be DTR, cmd phase along with every other non-
> empty
>  	 * phase should have dtr field set to 1. If an op phase has
> zero
> @@ -389,32 +380,23 @@ static int cqspi_set_protocol(struct
> cqspi_flash_pdata *f_pdata,
>  		       (!op->addr.nbytes || op->addr.dtr) &&
>  		       (!op->data.nbytes || op->data.dtr);
>  
> -	switch (op->data.buswidth) {
> -	case 0:
> -		break;
> -	case 1:
> -		f_pdata->data_width = CQSPI_INST_TYPE_SINGLE;
> -		break;
> -	case 2:
> -		f_pdata->data_width = CQSPI_INST_TYPE_DUAL;
> -		break;
> -	case 4:
> -		f_pdata->data_width = CQSPI_INST_TYPE_QUAD;
> -		break;
> -	case 8:
> -		f_pdata->data_width = CQSPI_INST_TYPE_OCTAL;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> +	f_pdata->inst_width = 0;
> +	if (op->cmd.buswidth)
> +		f_pdata->inst_width = ilog2(op->cmd.buswidth);
> +
> +	f_pdata->addr_width = 0;
> +	if (op->addr.buswidth)
> +		f_pdata->addr_width = ilog2(op->addr.buswidth);
> +
> +	f_pdata->data_width = 0;
> +	if (op->data.buswidth)
> +		f_pdata->data_width = ilog2(op->data.buswidth);
>  
>  	/* Right now we only support 8-8-8 DTR mode. */
>  	if (f_pdata->dtr) {
>  		switch (op->cmd.buswidth) {
>  		case 0:
> -			break;
>  		case 8:
> -			f_pdata->inst_width = CQSPI_INST_TYPE_OCTAL;
>  			break;
>  		default:
>  			return -EINVAL;
> @@ -422,9 +404,7 @@ static int cqspi_set_protocol(struct
> cqspi_flash_pdata *f_pdata,
>  
>  		switch (op->addr.buswidth) {
>  		case 0:
> -			break;
>  		case 8:
> -			f_pdata->addr_width = CQSPI_INST_TYPE_OCTAL;
>  			break;
>  		default:
>  			return -EINVAL;
> @@ -432,9 +412,7 @@ static int cqspi_set_protocol(struct
> cqspi_flash_pdata *f_pdata,
>  
>  		switch (op->data.buswidth) {
>  		case 0:
> -			break;
>  		case 8:
> -			f_pdata->data_width = CQSPI_INST_TYPE_OCTAL;
>  			break;
>  		default:
>  			return -EINVAL;

