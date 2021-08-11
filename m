Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0743E9225
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 15:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhHKNEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 09:04:08 -0400
Received: from mga04.intel.com ([192.55.52.120]:45151 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhHKNEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 09:04:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="213264116"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="213264116"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 06:03:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="516728801"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Aug 2021 06:03:43 -0700
Received: from [10.209.20.238] (kliang2-MOBL.ccr.corp.intel.com [10.209.20.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 656EF58093E;
        Wed, 11 Aug 2021 06:03:42 -0700 (PDT)
Subject: Re: [RESEND PATCH] perf/x86/intel/uncore: Support extra IMC channel
 on Ice Lake server
To:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, eranian@google.com,
        namhyung@kernel.org, ak@linux.intel.com, stable@vger.kernel.org
References: <1626699297-32793-1-git-send-email-kan.liang@linux.intel.com>
 <1626699297-32793-2-git-send-email-kan.liang@linux.intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <85fec916-d0c6-0e8c-55d8-8b16e99c6843@linux.intel.com>
Date:   Wed, 11 Aug 2021 09:03:41 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1626699297-32793-2-git-send-email-kan.liang@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Peter,

Could you please pick up the fix?
Please let me know if you have any comments/concerns.

Thanks,
Kan

On 7/19/2021 8:54 AM, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> There are three channels on a Ice Lake server, but only two channels
> will ever be active. Current perf only enables two channels.
> 
> Support the extra IMC channel, which may be activated on some Ice Lake
> machines. For a non-activated channel, the SW can still access it. The
> write will be ignored by the HW. 0 is always returned for the reading.
> 
> Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
> 
>   arch/x86/events/intel/uncore_snbep.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
> index 9a178a9..72a4181 100644
> --- a/arch/x86/events/intel/uncore_snbep.c
> +++ b/arch/x86/events/intel/uncore_snbep.c
> @@ -452,7 +452,7 @@
>   #define ICX_M3UPI_PCI_PMON_BOX_CTL		0xa0
>   
>   /* ICX IMC */
> -#define ICX_NUMBER_IMC_CHN			2
> +#define ICX_NUMBER_IMC_CHN			3
>   #define ICX_IMC_MEM_STRIDE			0x4
>   
>   /* SPR */
> @@ -5458,7 +5458,7 @@ static struct intel_uncore_ops icx_uncore_mmio_ops = {
>   static struct intel_uncore_type icx_uncore_imc = {
>   	.name		= "imc",
>   	.num_counters   = 4,
> -	.num_boxes	= 8,
> +	.num_boxes	= 12,
>   	.perf_ctr_bits	= 48,
>   	.fixed_ctr_bits	= 48,
>   	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,
> 
