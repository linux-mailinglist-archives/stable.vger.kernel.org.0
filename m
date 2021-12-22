Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDDF47D51D
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 17:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbhLVQaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 11:30:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:60913 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236333AbhLVQaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Dec 2021 11:30:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640190623; x=1671726623;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OQkd/+4WnQwVupRHWCmJi8rcxsFXTMWhWZ8ZTu/W230=;
  b=Yf8S+cDQMpZtJ/K/sqaHZQccdJwDYMF60Rn/+fmF5dwYull72kyiTzx2
   oPQ5+PpkiBzR2V1Ntv3Lpi7TbSxDFmr7u7vHk6A7sYkfVGGib79Sywutn
   abIOPqInVIQOLrqbjoPbL+/gCBQFfh8g1YE1z1GSyFwLav6HFqjM44+/b
   afb/m16fjtNp7CMQAFxPWjlYWp7i88ziibNo2xEEW1MwuTC4oJrMPd9It
   9vNNmPygTxSSM2lZdPhdbI5xO38KytHIoPTl0CS62dozJGPQlZ+9JXCXR
   EriCIWyGxgtHVrPETX4Od7Z/JEjNfBnF4OnHxWIbHZewvHXLKwjsjVD7X
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="238191027"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="238191027"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 08:30:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="613889167"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 22 Dec 2021 08:30:23 -0800
Received: from [10.212.131.121] (kliang2-MOBL.ccr.corp.intel.com [10.212.131.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 3C984580A92;
        Wed, 22 Dec 2021 08:30:22 -0800 (PST)
Message-ID: <e4a9aa08-1594-1b7b-a9e6-b1d9221e44d3@linux.intel.com>
Date:   Wed, 22 Dec 2021 11:30:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3] perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for
 ICX
Content-Language: en-US
To:     zhengjun.xing@linux.intel.com, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org
Cc:     adrian.hunter@intel.com, alexander.shishkin@intel.com,
        ak@linux.intel.com, kan.liang@intel.com, stable@vger.kernel.org
References: <20211118160241.329657-1-zhengjun.xing@linux.intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20211118160241.329657-1-zhengjun.xing@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/18/2021 11:02 AM, zhengjun.xing@linux.intel.com wrote:
> From: Zhengjun Xing <zhengjun.xing@linux.intel.com>
> 
> The user recently report a perf issue in the ICX platform, when test by

If you have the user's name, you may want to add a Reported-by tag to 
give them credit. If you don't have, it doesn't matter either.

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

I think we usually want a permanent reference in the change log. The 
document may be updated later. The page number or the table number may 
not be accurate anymore.

I guess you may want to give the exact document name and the version 
number here. So people can still easily locate the information several 
years later.
E.g., "3rd Gen Intel® Xeon® Processor Scalable Family, Codename Ice 
Lake, Uncore Performance Monitoring Reference Manual, Revision 1.00, May 
2021"


> So Corrected both "cas_count_read" and "cas_count_write" for ICX.
> 
> Old settings:
>   hswep_uncore_imc_events
> 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03")
>   	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c")
> 
> New settings:
>   snr_uncore_imc_events
> 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x0f")
> 	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x30"),
> 
> Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

Other than the above comments, the patch looks good to me.

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>


Thanks,
Kan

> Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
> Change log:
> 
>    v3:
>      * Add change log
> 
>    v2:
>      * Add stable tag
> 
>   arch/x86/events/intel/uncore_snbep.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
> index 5ddc0f30db6f..a6fd8eb410a9 100644
> --- a/arch/x86/events/intel/uncore_snbep.c
> +++ b/arch/x86/events/intel/uncore_snbep.c
> @@ -5468,7 +5468,7 @@ static struct intel_uncore_type icx_uncore_imc = {
>   	.fixed_ctr_bits	= 48,
>   	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,
>   	.fixed_ctl	= SNR_IMC_MMIO_PMON_FIXED_CTL,
> -	.event_descs	= hswep_uncore_imc_events,
> +	.event_descs	= snr_uncore_imc_events,
>   	.perf_ctr	= SNR_IMC_MMIO_PMON_CTR0,
>   	.event_ctl	= SNR_IMC_MMIO_PMON_CTL0,
>   	.event_mask	= SNBEP_PMON_RAW_EVENT_MASK,
