Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AF749E66C
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243058AbiA0PnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:43:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54242 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243057AbiA0PnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:43:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 511DF61632
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A75C340E4;
        Thu, 27 Jan 2022 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643298181;
        bh=W879sVHrmGtJ10SgYRbd9g2fsY0kBUMH4noDKKORtBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lgspVMOpaEgxIO6e/Nqowe4Pu12jVJvHs6kFvIw8M7JjjkQgYzZuvQg23Fwd8XYso
         wYf/TKgtcuJEDI3n1Ymi8iNi6z1m+OndFvyMC01nMHY8lW314Lz8bi1fbaLeL2Een4
         WGjGNPW4zsKPw0Rt/9ZU3g8iK/GC3zADOhuu5/BI=
Date:   Thu, 27 Jan 2022 16:42:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Cc:     stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 5.4.y] mmc: sdhci-esdhc-imx: disable CMDQ support
Message-ID: <YfK9gsIvfJ79MP5o@kroah.com>
References: <20220127103416.53-1-andrey.zhizhikin@leica-geosystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127103416.53-1-andrey.zhizhikin@leica-geosystems.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 11:34:16AM +0100, Andrey Zhizhikin wrote:
> From: Tim Harvey <tharvey@gateworks.com>
> 
> commit adab993c25191b839b415781bdc7173a77315240 upstream.
> 
> On IMX SoC's which support CMDQ the following can occur during high a
> high cpu load:
> 
> mmc2: cqhci: ============ CQHCI REGISTER DUMP ===========
> mmc2: cqhci: Caps:      0x0000310a | Version:  0x00000510
> mmc2: cqhci: Config:    0x00001001 | Control:  0x00000000
> mmc2: cqhci: Int stat:  0x00000000 | Int enab: 0x00000006
> mmc2: cqhci: Int sig:   0x00000006 | Int Coal: 0x00000000
> mmc2: cqhci: TDL base:  0x8003f000 | TDL up32: 0x00000000
> mmc2: cqhci: Doorbell:  0xbf01dfff | TCN:      0x00000000
> mmc2: cqhci: Dev queue: 0x00000000 | Dev Pend: 0x08000000
> mmc2: cqhci: Task clr:  0x00000000 | SSC1:     0x00011000
> mmc2: cqhci: SSC2:      0x00000001 | DCMD rsp: 0x00000800
> mmc2: cqhci: RED mask:  0xfdf9a080 | TERRI:    0x00000000
> mmc2: cqhci: Resp idx:  0x0000000d | Resp arg: 0x00000000
> mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
> mmc2: sdhci: Sys addr:  0x7c722000 | Version:  0x00000002
> mmc2: sdhci: Blk size:  0x00000200 | Blk cnt:  0x00000020
> mmc2: sdhci: Argument:  0x00018000 | Trn mode: 0x00000023
> mmc2: sdhci: Present:   0x01f88008 | Host ctl: 0x00000030
> mmc2: sdhci: Power:     0x00000002 | Blk gap:  0x00000080
> mmc2: sdhci: Wake-up:   0x00000008 | Clock:    0x0000000f
> mmc2: sdhci: Timeout:   0x0000008f | Int stat: 0x00000000
> mmc2: sdhci: Int enab:  0x107f4000 | Sig enab: 0x107f4000
> mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000502
> mmc2: sdhci: Caps:      0x07eb0000 | Caps_1:   0x8000b407
> mmc2: sdhci: Cmd:       0x00000d1a | Max curr: 0x00ffffff
> mmc2: sdhci: Resp[0]:   0x00000000 | Resp[1]:  0xffc003ff
> mmc2: sdhci: Resp[2]:   0x328f5903 | Resp[3]:  0x00d07f01
> mmc2: sdhci: Host ctl2: 0x00000088
> mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr: 0xfe179020
> mmc2: sdhci-esdhc-imx: ========= ESDHC IMX DEBUG STATUS DUMP ====
> mmc2: sdhci-esdhc-imx: cmd debug status:  0x2120
> mmc2: sdhci-esdhc-imx: data debug status:  0x2200
> mmc2: sdhci-esdhc-imx: trans debug status:  0x2300
> mmc2: sdhci-esdhc-imx: dma debug status:  0x2400
> mmc2: sdhci-esdhc-imx: adma debug status:  0x2510
> mmc2: sdhci-esdhc-imx: fifo debug status:  0x2680
> mmc2: sdhci-esdhc-imx: async fifo debug status:  0x2750
> mmc2: sdhci: ============================================
> 
> For now, disable CMDQ support on the imx8qm/imx8qxp/imx8mm until the
> issue is found and resolved.
> 
> Fixes: bb6e358169bf6 ("mmc: sdhci-esdhc-imx: add CMDQ support")
> Fixes: cde5e8e9ff146 ("mmc: sdhci-esdhc-imx: Add an new esdhc_soc_data for i.MX8MM")
> Cc: stable@vger.kernel.org # 5.4.y
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Link: https://lore.kernel.org/r/20211103165415.2016-1-tharvey@gateworks.com
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index 2c01e2ebef7a..d97c19ef7583 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -218,8 +218,7 @@ static struct esdhc_soc_data usdhc_imx7ulp_data = {
>  static struct esdhc_soc_data usdhc_imx8qxp_data = {
>  	.flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
>  			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
> -			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
> -			| ESDHC_FLAG_CQHCI,
> +			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES,
>  };
>  
>  struct pltfm_imx_data {
> 
> base-commit: 4aa2e7393e140f434c469bffe478e11cb9c55ed8
> -- 
> 2.34.1
> 

Now queued up, thanks.

greg k-h
