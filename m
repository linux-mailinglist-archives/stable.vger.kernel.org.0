Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020263BD85D
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 16:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhGFOij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 10:38:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:20304 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232378AbhGFOii (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 10:38:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="196287556"
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="196287556"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 07:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="427601433"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 06 Jul 2021 07:12:57 -0700
Received: from [10.209.95.225] (kliang2-MOBL.ccr.corp.intel.com [10.209.95.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 08E6C5807EA;
        Tue,  6 Jul 2021 07:12:56 -0700 (PDT)
Subject: Re: [PATCH] perf/x86/intel/uncore: Fix IIO cleanup mapping procedure
 for SNR/ICX
To:     alexander.antonov@linux.intel.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     ak@linux.intel.com, stable@vger.kernel.org,
        alexey.v.bayduraev@linux.intel.com
References: <20210706090723.41850-1-alexander.antonov@linux.intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <3d634baf-8abe-480d-61ed-ade1945324ee@linux.intel.com>
Date:   Tue, 6 Jul 2021 10:12:55 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706090723.41850-1-alexander.antonov@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/6/2021 5:07 AM, alexander.antonov@linux.intel.com wrote:
> From: Alexander Antonov <alexander.antonov@linux.intel.com>
> 
> Cleanup mapping procedure for IIO PMU is needed to free memory which was
> allocated for topology data and for attributes in IIO mapping
> attribute_group.
> Current implementation of this procedure for Snowridge and Icelake Server
> platforms doesn't free allocated memory that can be a reason for memory
> leak issue.
> Fix the issue with IIO cleanup mapping procedure for these platforms
> to release allocated memory.
> 
> Fixes: 10337e95e04c ("perf/x86/intel/uncore: Enable I/O stacks to IIO PMON mapping on ICX")
> 
> Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>

The patch looks good to me.

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>


With this fix, there will be several similar codes repeat, e.g., 
XXX_iio_set_mapping() and XXX_iio_cleanup_mapping(), for SKX, ICX, and 
SNR for now.
I guess there will be more for the future platforms. Have you considered 
to add a macro or something to reduce the code repetition?

Thanks,
Kan

> ---
>   arch/x86/events/intel/uncore_snbep.c | 40 +++++++++++++++++++---------
>   1 file changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
> index bb6eb1e5569c..54cdbb96e628 100644
> --- a/arch/x86/events/intel/uncore_snbep.c
> +++ b/arch/x86/events/intel/uncore_snbep.c
> @@ -3836,26 +3836,32 @@ pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
>   	return ret;
>   }
>   
> -static int skx_iio_set_mapping(struct intel_uncore_type *type)
> -{
> -	return pmu_iio_set_mapping(type, &skx_iio_mapping_group);
> -}
> -
> -static void skx_iio_cleanup_mapping(struct intel_uncore_type *type)
> +static void
> +pmu_iio_cleanup_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
>   {
> -	struct attribute **attr = skx_iio_mapping_group.attrs;
> +	struct attribute **attr = ag->attrs;
>   
>   	if (!attr)
>   		return;
>   
>   	for (; *attr; attr++)
>   		kfree((*attr)->name);
> -	kfree(attr_to_ext_attr(*skx_iio_mapping_group.attrs));
> -	kfree(skx_iio_mapping_group.attrs);
> -	skx_iio_mapping_group.attrs = NULL;
> +	kfree(attr_to_ext_attr(*ag->attrs));
> +	kfree(ag->attrs);
> +	ag->attrs = NULL;
>   	kfree(type->topology);
>   }
>   
> +static int skx_iio_set_mapping(struct intel_uncore_type *type)
> +{
> +	return pmu_iio_set_mapping(type, &skx_iio_mapping_group);
> +}
> +
> +static void skx_iio_cleanup_mapping(struct intel_uncore_type *type)
> +{
> +	pmu_iio_cleanup_mapping(type, &skx_iio_mapping_group);
> +}
> +
>   static struct intel_uncore_type skx_uncore_iio = {
>   	.name			= "iio",
>   	.num_counters		= 4,
> @@ -4499,6 +4505,11 @@ static int snr_iio_set_mapping(struct intel_uncore_type *type)
>   	return pmu_iio_set_mapping(type, &snr_iio_mapping_group);
>   }
>   
> +static void snr_iio_cleanup_mapping(struct intel_uncore_type *type)
> +{
> +	pmu_iio_cleanup_mapping(type, &snr_iio_mapping_group);
> +}
> +
>   static struct intel_uncore_type snr_uncore_iio = {
>   	.name			= "iio",
>   	.num_counters		= 4,
> @@ -4515,7 +4526,7 @@ static struct intel_uncore_type snr_uncore_iio = {
>   	.attr_update		= snr_iio_attr_update,
>   	.get_topology		= snr_iio_get_topology,
>   	.set_mapping		= snr_iio_set_mapping,
> -	.cleanup_mapping	= skx_iio_cleanup_mapping,
> +	.cleanup_mapping	= snr_iio_cleanup_mapping,
>   };
>   
>   static struct intel_uncore_type snr_uncore_irp = {
> @@ -5090,6 +5101,11 @@ static int icx_iio_set_mapping(struct intel_uncore_type *type)
>   	return pmu_iio_set_mapping(type, &icx_iio_mapping_group);
>   }
>   
> +static void icx_iio_cleanup_mapping(struct intel_uncore_type *type)
> +{
> +	pmu_iio_cleanup_mapping(type, &icx_iio_mapping_group);
> +}
> +
>   static struct intel_uncore_type icx_uncore_iio = {
>   	.name			= "iio",
>   	.num_counters		= 4,
> @@ -5107,7 +5123,7 @@ static struct intel_uncore_type icx_uncore_iio = {
>   	.attr_update		= icx_iio_attr_update,
>   	.get_topology		= icx_iio_get_topology,
>   	.set_mapping		= icx_iio_set_mapping,
> -	.cleanup_mapping	= skx_iio_cleanup_mapping,
> +	.cleanup_mapping	= icx_iio_cleanup_mapping,
>   };
>   
>   static struct intel_uncore_type icx_uncore_irp = {
> 
> base-commit: 3dbdb38e286903ec220aaf1fb29a8d94297da246
> 
