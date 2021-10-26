Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49A943B09F
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 12:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhJZK6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 06:58:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:8096 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234007AbhJZK6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 06:58:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="229823312"
X-IronPort-AV: E=Sophos;i="5.87,182,1631602800"; 
   d="scan'208";a="229823312"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 03:56:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,182,1631602800"; 
   d="scan'208";a="724084101"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga005.fm.intel.com with ESMTP; 26 Oct 2021 03:56:15 -0700
Subject: Re: [PATCH] mmc: cqhci: clear HALT state after CQE enable
To:     Wenbin Mei <wenbin.mei@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, srv_heupstream@mediatek.com,
        stable@vger.kernel.org
References: <20211026070812.9359-1-wenbin.mei@mediatek.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <8d096ff5-4266-815f-d050-1f3f0cddeba8@intel.com>
Date:   Tue, 26 Oct 2021 13:56:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211026070812.9359-1-wenbin.mei@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/10/2021 10:08, Wenbin Mei wrote:
> While mmc0 enter suspend state, we need halt CQE to send legacy cmd(flush
> cache) and disable cqe, for resume back, we enable CQE and not clear HALT
> state.
> In this case MediaTek mmc host controller will keep the value for HALT
> state after CQE disable/enable flow, so the next CQE transfer after resume
> will be timeout due to CQE is in HALT state, the log as below:
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: timeout for tag 2
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: ============ CQHCI REGISTER DUMP ===========
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: Caps:      0x100020b6 | Version:  0x00000510
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: Config:    0x00001103 | Control:  0x00000001
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: Int stat:  0x00000000 | Int enab: 0x00000006
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: Int sig:   0x00000006 | Int Coal: 0x00000000
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: TDL base:  0xfd05f000 | TDL up32: 0x00000000
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: Doorbell:  0x8000203c | TCN:      0x00000000
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: Dev queue: 0x00000000 | Dev Pend: 0x00000000
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: Task clr:  0x00000000 | SSC1:     0x00001000
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: SSC2:      0x00000001 | DCMD rsp: 0x00000000
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: RED mask:  0xfdf9a080 | TERRI:    0x00000000
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: Resp idx:  0x00000000 | Resp arg: 0x00000000
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: CRNQP:     0x00000000 | CRNQDUN:  0x00000000
> <4>.(4)[318:kworker/4:1H]mmc0: cqhci: CRNQIS:    0x00000000 | CRNQIE:   0x00000000
> 
> This change check HALT state after CQE enable, if CQE is in HALT state, we
> will clear it.
> 
> Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
> Cc: stable@vger.kernel.org

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/cqhci-core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mmc/host/cqhci-core.c b/drivers/mmc/host/cqhci-core.c
> index ca8329d55f43..b0d30c35c390 100644
> --- a/drivers/mmc/host/cqhci-core.c
> +++ b/drivers/mmc/host/cqhci-core.c
> @@ -282,6 +282,9 @@ static void __cqhci_enable(struct cqhci_host *cq_host)
>  
>  	cqhci_writel(cq_host, cqcfg, CQHCI_CFG);
>  
> +	if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT)
> +		cqhci_writel(cq_host, 0, CQHCI_CTL);
> +
>  	mmc->cqe_on = true;
>  
>  	if (cq_host->ops->enable)
> 

