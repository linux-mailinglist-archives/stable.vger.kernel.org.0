Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5F944605C
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 08:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhKEH7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 03:59:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:62912 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhKEH7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 03:59:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10158"; a="231705135"
X-IronPort-AV: E=Sophos;i="5.87,210,1631602800"; 
   d="scan'208";a="231705135"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 00:56:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,210,1631602800"; 
   d="scan'208";a="600543626"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga004.jf.intel.com with ESMTP; 05 Nov 2021 00:56:28 -0700
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: disable CMDQ support
To:     Tim Harvey <tharvey@gateworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        BOUGH CHEN <haibo.chen@nxp.com>, linux-mmc@vger.kernel.org,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        Adam Ford <aford173@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Peng Fan <peng.fan@nxp.com>
Cc:     stable@vger.kernel.org
References: <CAJ+vNU3zKEVz=fHu2hLmEpsQKzinUFW-28Lm=2wSEghjMvQtmw@mail.gmail.com>
 <20211103165415.2016-1-tharvey@gateworks.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <9bd6e5cb-d7ab-8c7f-9771-255c4a7d4f04@intel.com>
Date:   Fri, 5 Nov 2021 09:56:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211103165415.2016-1-tharvey@gateworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/11/2021 18:54, Tim Harvey wrote:
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
> Fixes: cde5e8e9ff146 ("mmc: sdhci-esdhc-imx: Add an new esdhc_soc_data
> for i.MX8MM")
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index e658f0174242..60f19369de84 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -300,7 +300,6 @@ static struct esdhc_soc_data usdhc_imx8qxp_data = {
>  	.flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
>  			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
>  			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
> -			| ESDHC_FLAG_CQHCI
>  			| ESDHC_FLAG_STATE_LOST_IN_LPMODE
>  			| ESDHC_FLAG_CLK_RATE_LOST_IN_PM_RUNTIME,
>  };
> @@ -309,7 +308,6 @@ static struct esdhc_soc_data usdhc_imx8mm_data = {
>  	.flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
>  			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
>  			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
> -			| ESDHC_FLAG_CQHCI
>  			| ESDHC_FLAG_STATE_LOST_IN_LPMODE,
>  };
>  
> 

