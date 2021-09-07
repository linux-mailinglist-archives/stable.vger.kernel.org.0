Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A9640297C
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 15:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344791AbhIGNOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 09:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344683AbhIGNOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 09:14:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 621F8610C8;
        Tue,  7 Sep 2021 13:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631020382;
        bh=5Yw6F9cg9LJ+J9KJD7E7rgXaIIcH628ZantV+FYvVm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TjqHW62X6UAK+xCKDpopv13fFm2K0RVlHk+wYcblqApGNBUa/4NW2zug3n/ck3k7Q
         YFsiirUGDgsNQs4mDsPXN0qugQuPviwIi2dQv9JXfcuwFVSBmNLTSvH2PwOTV1Upq6
         /VmAwQVTlXWaR/tJM5fj+QvoQjlhPTWoBHw2hq4Q=
Date:   Tue, 7 Sep 2021 15:13:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 1/2 for 4.19.y] ARM: imx: add missing
 clk_disable_unprepare()
Message-ID: <YTdlXLeIQQb8prbw@kroah.com>
References: <20210906232721.2950033-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906232721.2950033-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 07, 2021 at 08:27:21AM +0900, Nobuhiro Iwamatsu wrote:
> From: Yang Yingliang <yangyingliang@huawei.com>
> 
> commit f07ec85365807b3939f32d0094a6dd5ce065d1b9 upstream.
> 
> clock source is prepared and enabled by clk_prepare_enable()
> in probe function, but no disable or unprepare in remove and
> error path.
> 
> Fixes: 9454a0caff6a ("ARM: imx: add mmdc ipg clock operation for mmdc")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  arch/arm/mach-imx/mmdc.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
> index ae0a61c61a6e12..ba830be0b53102 100644
> --- a/arch/arm/mach-imx/mmdc.c
> +++ b/arch/arm/mach-imx/mmdc.c
> @@ -109,6 +109,7 @@ struct mmdc_pmu {
>  	struct perf_event *mmdc_events[MMDC_NUM_COUNTERS];
>  	struct hlist_node node;
>  	struct fsl_mmdc_devtype_data *devtype_data;
> +	struct clk *mmdc_ipg_clk;
>  };
>  
>  /*
> @@ -474,11 +475,13 @@ static int imx_mmdc_remove(struct platform_device *pdev)
>  	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
>  	perf_pmu_unregister(&pmu_mmdc->pmu);
>  	iounmap(pmu_mmdc->mmdc_base);
> +	clk_disable_unprepare(pmu_mmdc->mmdc_ipg_clk);
>  	kfree(pmu_mmdc);
>  	return 0;
>  }
>  
> -static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_base)
> +static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_base,
> +			      struct clk *mmdc_ipg_clk)
>  {
>  	struct mmdc_pmu *pmu_mmdc;
>  	char *name;
> @@ -506,6 +509,7 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
>  	}
>  
>  	mmdc_num = mmdc_pmu_init(pmu_mmdc, mmdc_base, &pdev->dev);
> +	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
>  	if (mmdc_num == 0)
>  		name = "mmdc";
>  	else
> @@ -579,9 +583,11 @@ static int imx_mmdc_probe(struct platform_device *pdev)
>  	val &= ~(1 << BP_MMDC_MAPSR_PSD);
>  	writel_relaxed(val, reg);
>  
> -	err = imx_mmdc_perf_init(pdev, mmdc_base);
> -	if (err)
> +	err = imx_mmdc_perf_init(pdev, mmdc_base, mmdc_ipg_clk);
> +	if (err) {
>  		iounmap(mmdc_base);
> +		clk_disable_unprepare(mmdc_ipg_clk);
> +	}
>  
>  	return err;
>  }
> -- 
> 2.33.0
> 
> 

Both now queued up, thanks.

greg k-h
