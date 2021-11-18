Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBDA455500
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 07:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbhKRHB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 02:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238258AbhKRHBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 02:01:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3014E61B51;
        Thu, 18 Nov 2021 06:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637218706;
        bh=6yZ3GLk5SX1oLN5yUTcbreoLrMeBhb12Ay6jy//yloY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b9/IJjLIVdSrNRY/PF3QcsbnF0y0jx1Su97tT0PLC1jvrhm8gGWg1l45t3baqbs/J
         2fW8NRQ8NQ6Ktx1MOgiz70b5oZrm09dp976XX/DfJLjJ5lF3Gl7v5WfGP//0etlXqr
         LZMRapdgE9krFdnmGimWCiVcqAdLzuZdvDfZu1D0=
Date:   Thu, 18 Nov 2021 07:58:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     zhengjun.xing@linux.intel.com
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        alexander.shishkin@intel.com, ak@linux.intel.com,
        kan.liang@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX
Message-ID: <YZX5jisoDQ2ydvV0@kroah.com>
References: <20211118144811.329111-1-zhengjun.xing@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118144811.329111-1-zhengjun.xing@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 10:48:11PM +0800, zhengjun.xing@linux.intel.com wrote:
> From: Zhengjun Xing <zhengjun.xing@linux.intel.com>
> 
> The user recently report a perf issue in the ICX platform, when test by
> perf event “uncore_imc_x/cas_count_write”,the write bandwidth is always
> very small (only 0.38MB/s), it is caused by the wrong "umask" for the
> "cas_count_write" event. When double-checking, find "cas_count_read"
> also is wrong.
> 
> The public document for ICX uncore:
> 
> https://www.intel.com/content/www/us/en/develop/download/3rd-gen-intel-xeon-processor-scalable-uncore-pm.html
> 
> On page 142, Table 2-143, defines Unit Masks for CAS_COUNT:
> RD b00001111
> WR b00110000
> 
> So Corrected both "cas_count_read" and "cas_count_write" for ICX.
> 
> Old settings:
>  hswep_uncore_imc_events
> 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03")
>  	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c")
> 
> New settings:
>  snr_uncore_imc_events
> 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x0f")
> 	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x30"),
> 
> Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
> ---
>  arch/x86/events/intel/uncore_snbep.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
> index 5ddc0f30db6f..a6fd8eb410a9 100644
> --- a/arch/x86/events/intel/uncore_snbep.c
> +++ b/arch/x86/events/intel/uncore_snbep.c
> @@ -5468,7 +5468,7 @@ static struct intel_uncore_type icx_uncore_imc = {
>  	.fixed_ctr_bits	= 48,
>  	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,
>  	.fixed_ctl	= SNR_IMC_MMIO_PMON_FIXED_CTL,
> -	.event_descs	= hswep_uncore_imc_events,
> +	.event_descs	= snr_uncore_imc_events,
>  	.perf_ctr	= SNR_IMC_MMIO_PMON_CTR0,
>  	.event_ctl	= SNR_IMC_MMIO_PMON_CTL0,
>  	.event_mask	= SNBEP_PMON_RAW_EVENT_MASK,
> -- 
> 2.25.1
> 
<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
