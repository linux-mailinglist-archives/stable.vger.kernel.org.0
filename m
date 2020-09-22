Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB08274153
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 13:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgIVLsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 07:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgIVLrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 07:47:16 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD2BC061755;
        Tue, 22 Sep 2020 04:47:16 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f82so16913272ilh.8;
        Tue, 22 Sep 2020 04:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ZznVRxbDUmI1MVFhhzO32PT/Ot4Fflk3jY6Lb5eXQw=;
        b=JFIxmImcctlYkp7BavAvPhTYhgZMZveYF1DxxMpZfTjLx1NdGN2l85yQ1lQNIJRd+q
         jRxrY/wwZ9axKxPGIrig54MFwdE3E7XfnOAbEejg3exGszjswdnUd3cmNKSpZoPf1HoI
         jSsuyajsXfPJNxd1edjPg0vQgoWFJZFVmCE2Ddy5R64I85pfOZ/CNBG7LBa1FoLL0q1p
         3ySrbMBp4CZD/oGpVh8o0B+Kssrzer6s609n8/opbB9S6v4o84yrqvme9enRj1Gg+68o
         4A0rPT+gyyw/OfXNQ4DPChLDr+Auwxsk0AKnJ5a7CEpEEYafdc2cWpnH5nLXbKSqAxhf
         wlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ZznVRxbDUmI1MVFhhzO32PT/Ot4Fflk3jY6Lb5eXQw=;
        b=sJyXD2kWHOeuX+lMrbAH12obFs1Bp903Jd5cbDYN5HqZNhRhyGhiBDmjsUEs0/5l5m
         MGIOdIxAH+WxASgxi9CvcY/lpX37DxWb39puIcAxVWCcKAx+8Z80R7cSBypsmFcEPqFp
         sZgrNV0CP+Sj+mnTj+JXOiSWF2DdNoKlNASUbqWoZKsOkawu/YS54y3wZVD+cumusiJB
         D5jnHezvgmSJILbehJEzv+j84/7KVAeIl5rgZNaFDmwfYtQjQE8zuOZ4axcNRvC22XcE
         1JAvKuS0gxbjh+2joWuLNedFo5+jtyYRkxC9+i2qxNa5i9WRA+FW0mDjJ5Q8jADURp2v
         eBgw==
X-Gm-Message-State: AOAM531sCGK79Egzu2IhnDAhf4vnlicvEyM4Y3knAuetXkXlQGwNFMju
        jn8AE4gttEcckxPSU1WHe1OqGceWOaMuiZkBfEiLFDAIaq/rQw==
X-Google-Smtp-Source: ABdhPJw4I8/+CRAsoMH1DWvhvkqW0BE/0GGErYO1ROiQehW/d3UJh8e95INcPpCBkJvII6TGtTku5A9WAKtvT4rbhKU=
X-Received: by 2002:a92:c10c:: with SMTP id p12mr3679348ile.274.1600775235373;
 Tue, 22 Sep 2020 04:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200922114317.2935897-1-gch981213@gmail.com>
In-Reply-To: <20200922114317.2935897-1-gch981213@gmail.com>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Tue, 22 Sep 2020 19:47:04 +0800
Message-ID: <CAJsYDVJugyZQage-aWUqUoHEq6dhNdMw4J+0PmzGKrO=s9hoBw@mail.gmail.com>
Subject: Re: [PATCH] spi: spi-mtk-nor: fix timeout calculation overflow
To:     linux-spi@vger.kernel.org
Cc:     =?UTF-8?B?QmF5aSBDaGVuZyAo56iL5YWr5oSPKQ==?= 
        <bayi.cheng@mediatek.com>, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 7:43 PM Chuanhong Guo <gch981213@gmail.com> wrote:
>
> CLK_TO_US macro is used to calculate potential transfer time for various
> timeout handling. However it overflows on transfer bigger than 512 bytes
> because it first did (len * 8 * 1000000).
> This controller typically operates at 45MHz. This patch did 2 things:
> 1. calculate clock / 1000000 first
> 2. add a 4M transfer size cap so that the final timeout in DMA reading
>    doesn't overflow
>
> Fixes: 881d1ee9fe81f ("spi: add support for mediatek spi-nor controller")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
> ---
>  drivers/spi/spi-mtk-nor.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
> index 6e6ca2b8e6c82..619313db42c0e 100644
> --- a/drivers/spi/spi-mtk-nor.c
> +++ b/drivers/spi/spi-mtk-nor.c
> @@ -89,7 +89,7 @@
>  // Buffered page program can do one 128-byte transfer
>  #define MTK_NOR_PP_SIZE                        128
>
> -#define CLK_TO_US(sp, clkcnt)          ((clkcnt) * 1000000 / sp->spi_freq)
> +#define CLK_TO_US(sp, clkcnt)          DIV_ROUND_UP(clkcnt, sp->spi_freq / 1000000)
>
>  struct mtk_nor {
>         struct spi_controller *ctlr;
> @@ -177,6 +177,10 @@ static int mtk_nor_adjust_op_size(struct spi_mem *mem, struct spi_mem_op *op)
>         if ((op->addr.nbytes == 3) || (op->addr.nbytes == 4)) {
>                 if ((op->data.dir == SPI_MEM_DATA_IN) &&
>                     mtk_nor_match_read(op)) {
> +                       // limit size to prevent timeout calculation overflow
> +                       if (op->data.nbytes > 0x2000000)
> +                               op->data.nbytes = 0x2000000;
> +

Sorry, wrong patch. This cap should be 4M not 32M. I'll send a v2 immediately.

-- 
Regards,
Chuanhong Guo
