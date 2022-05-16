Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEFF52835F
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 13:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiEPLgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 07:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238340AbiEPLfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 07:35:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DB138DB6
        for <stable@vger.kernel.org>; Mon, 16 May 2022 04:35:08 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso10740938wma.0
        for <stable@vger.kernel.org>; Mon, 16 May 2022 04:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p0rgIQMbrFiYsgcjoFDoepTtn20KjWcRTBgi8tJw9xw=;
        b=EP2TdXabYG332lC6IQzUMr2ULmKLrDB4KGdp8I6SWNs04aBaf3I6jszrlcZgGB8yIa
         o7kis32F+jau35chRkGfeHadrRjA6u0RXPmxldOhSa0cHxAKCPBUAC0FxKW87xFy2g8S
         EbPe9HLWE8k7NgQ9ZsrQEenZXDxFkE/00UVL3LFfDVJHCxfWTh+a8uUL8jJr/aK+2kyw
         EZhsW5F3T47H+M5fXNsIO7+W4X8WK+k9IHlSluvAYA2I+Sy9YUoekPvZbfy40IPlFZYo
         tJp+n3nWpqAcXoMYWJqM/Pn+WHRcGzh/A2QQrzaeqdAHrLJEWFmaPObt9TvGCViseifg
         ysCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p0rgIQMbrFiYsgcjoFDoepTtn20KjWcRTBgi8tJw9xw=;
        b=PFtSp/x+w9UwTxCJDMgzoXQaebJIrEvKGR25jethqisfaIJhZX5cK74QAm6ejGLSPs
         eW76O3BvRny41zuc4pD3DiE6xX2MRlmxyOg9BkuXBWwwonMqwSB6Oj7KedsSZ5MaL251
         uq/rHVY5McZXg4Rwef6blh9HPsVbCADc3EokInJXQt4PiOuSktKF4ymxPw4JL4Z1eSec
         LiCevjgjgmkXxAYccTSYovWnWSNs2BYJ63sfZJjTwm3inNow7WRII7y/vPmz91LECB8l
         bl0b4Vb6nZ237K6F2bdljT2N0xWYmLa8HZ8b41ZkML5Y2l7QubzujLb0ZEnPv7q8eoJe
         ugJA==
X-Gm-Message-State: AOAM533oJCVl3S+KATkIzAXDKCamNw1MZ3v7CnKEy26kZ11k4TKz6jkU
        gHJe+CjBPOewbHG3Umq5pm4n+ePWWv0Vwg==
X-Google-Smtp-Source: ABdhPJwvr0l6PJJkDzfVHiRQJgiJsClLA678PoHTLNXsEYIPazSWO4idGkNNFLNsvnExx5k3OJUorw==
X-Received: by 2002:a05:600c:ad2:b0:394:22e1:ebcf with SMTP id c18-20020a05600c0ad200b0039422e1ebcfmr26715670wmr.181.1652700906530;
        Mon, 16 May 2022 04:35:06 -0700 (PDT)
Received: from arch-thunder (a109-49-33-111.cpe.netcabo.pt. [109.49.33.111])
        by smtp.gmail.com with ESMTPSA id j25-20020adfa799000000b0020c5253d8dbsm9334014wrc.39.2022.05.16.04.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:35:06 -0700 (PDT)
Date:   Mon, 16 May 2022 12:35:03 +0100
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH] usb: isp1760: Fix out-of-bounds array access
Message-ID: <20220516113503.5ewp65vqp3yworvh@arch-thunder>
References: <20220516091424.391209-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516091424.391209-1-linus.walleij@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Linus,
Thanks for the patch.

On Mon, May 16, 2022 at 11:14:24AM +0200, Linus Walleij wrote:
> Running the driver through kasan gives an interesting splat:
> 
>   BUG: KASAN: global-out-of-bounds in isp1760_register+0x180/0x70c
>   Read of size 20 at addr f1db2e64 by task swapper/0/1
>   (...)
>   isp1760_register from isp1760_plat_probe+0x1d8/0x220
>   (...)
> 
> This happens because the loop reading the regmap fields for the
> different ISP1760 variants look like this:
> 
>   for (i = 0; i < HC_FIELD_MAX; i++) { ... }
> 
> Meaning it expects the arrays to be at least HC_FIELD_MAX - 1 long.
> 
> However the arrays isp1760_hc_reg_fields[], isp1763_hc_reg_fields[],
> isp1763_hc_volatile_ranges[] and isp1763_dc_volatile_ranges[] are
> dynamically sized during compilation.
> 
> Fix this by putting an empty assignment to the [HC_FIELD_MAX]
> and [DC_FIELD_MAX] array member at the end of each array.
> This will make the array one member longer than it needs to be,
> but avoids the risk of overwriting whatever is inside
> [HC_FIELD_MAX - 1] and is simple and intuitive to read. Also
> add comments explaining what is going on.
> 
> Fixes: 1da9e1c06873 ("usb: isp1760: move to regmap for register access")
> Cc: stable@vger.kernel.org
> Cc: Rui Miguel Silva <rui.silva@linaro.org>

Very good catch. Thanks for fixing this.

Reviewed-by: Rui Miguel Silva <rui.silva@linaro.org>

Cheers,
   Rui

> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Found while testing to compile the Vexpress kernel into the
> vmalloc area in some experimental patches, curiously it did not
> manifest before, I guess we were lucky with padding
> etc.
> ---
>  drivers/usb/isp1760/isp1760-core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/usb/isp1760/isp1760-core.c b/drivers/usb/isp1760/isp1760-core.c
> index d1d9a7d5da17..af88f4fe00d2 100644
> --- a/drivers/usb/isp1760/isp1760-core.c
> +++ b/drivers/usb/isp1760/isp1760-core.c
> @@ -251,6 +251,8 @@ static const struct reg_field isp1760_hc_reg_fields[] = {
>  	[HW_DM_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 2, 2),
>  	[HW_DP_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 1, 1),
>  	[HW_DP_PULLUP]		= REG_FIELD(ISP176x_HC_OTG_CTRL, 0, 0),
> +	/* Make sure the array is sized properly during compilation */
> +	[HC_FIELD_MAX]		= {},
>  };
>  
>  static const struct reg_field isp1763_hc_reg_fields[] = {
> @@ -321,6 +323,8 @@ static const struct reg_field isp1763_hc_reg_fields[] = {
>  	[HW_DM_PULLDOWN_CLEAR]	= REG_FIELD(ISP1763_HC_OTG_CTRL_CLEAR, 2, 2),
>  	[HW_DP_PULLDOWN_CLEAR]	= REG_FIELD(ISP1763_HC_OTG_CTRL_CLEAR, 1, 1),
>  	[HW_DP_PULLUP_CLEAR]	= REG_FIELD(ISP1763_HC_OTG_CTRL_CLEAR, 0, 0),
> +	/* Make sure the array is sized properly during compilation */
> +	[HC_FIELD_MAX]		= {},
>  };
>  
>  static const struct regmap_range isp1763_hc_volatile_ranges[] = {
> @@ -405,6 +409,8 @@ static const struct reg_field isp1761_dc_reg_fields[] = {
>  	[DC_CHIP_ID_HIGH]	= REG_FIELD(ISP176x_DC_CHIPID, 16, 31),
>  	[DC_CHIP_ID_LOW]	= REG_FIELD(ISP176x_DC_CHIPID, 0, 15),
>  	[DC_SCRATCH]		= REG_FIELD(ISP176x_DC_SCRATCH, 0, 15),
> +	/* Make sure the array is sized properly during compilation */
> +	[DC_FIELD_MAX]		= {},
>  };
>  
>  static const struct regmap_range isp1763_dc_volatile_ranges[] = {
> @@ -458,6 +464,8 @@ static const struct reg_field isp1763_dc_reg_fields[] = {
>  	[DC_CHIP_ID_HIGH]	= REG_FIELD(ISP1763_DC_CHIPID_HIGH, 0, 15),
>  	[DC_CHIP_ID_LOW]	= REG_FIELD(ISP1763_DC_CHIPID_LOW, 0, 15),
>  	[DC_SCRATCH]		= REG_FIELD(ISP1763_DC_SCRATCH, 0, 15),
> +	/* Make sure the array is sized properly during compilation */
> +	[DC_FIELD_MAX]		= {},
>  };
>  
>  static const struct regmap_config isp1763_dc_regmap_conf = {
> -- 
> 2.35.1
> 
