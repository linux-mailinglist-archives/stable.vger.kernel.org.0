Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46373BD8F6
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 16:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhGFOxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 10:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232531AbhGFOxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 10:53:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 474B8613B2;
        Tue,  6 Jul 2021 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625583025;
        bh=Bl7xsIWGma1Zx5mem8ueP6zDMR8yL00GCmoXM2niB94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZTLeoguR+oEiI8/+fRt/9NPDFayJ3+gI0ATOpiWcJnWBUbivNSLTZrqTrsDeE9DMO
         7pr29lEWbKQc0PHfRddP/xBWdBHxmrxi53gQuxqFH4IjdaMA9yrBaJXCT67UmUFPcJ
         Q7ZXvho61T3UEUmKJnMUkYi4SVkaYRE1qUHHi/+s=
Date:   Tue, 6 Jul 2021 16:50:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     alexander.antonov@linux.intel.com
Cc:     peterz@infradead.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        stable@vger.kernel.org, alexey.v.bayduraev@linux.intel.com
Subject: Re: [PATCH] perf/x86/intel/uncore: Fix IIO cleanup mapping procedure
 for SNR/ICX
Message-ID: <YORtrROGAEbzY4Dk@kroah.com>
References: <20210706090723.41850-1-alexander.antonov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706090723.41850-1-alexander.antonov@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 06, 2021 at 12:07:23PM +0300, alexander.antonov@linux.intel.com wrote:
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
> ---
>  arch/x86/events/intel/uncore_snbep.c | 40 +++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
> index bb6eb1e5569c..54cdbb96e628 100644
> --- a/arch/x86/events/intel/uncore_snbep.c
> +++ b/arch/x86/events/intel/uncore_snbep.c
> @@ -3836,26 +3836,32 @@ pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
>  	return ret;
>  }
>  
> -static int skx_iio_set_mapping(struct intel_uncore_type *type)
> -{
> -	return pmu_iio_set_mapping(type, &skx_iio_mapping_group);
> -}
> -
> -static void skx_iio_cleanup_mapping(struct intel_uncore_type *type)
> +static void
> +pmu_iio_cleanup_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
>  {
> -	struct attribute **attr = skx_iio_mapping_group.attrs;
> +	struct attribute **attr = ag->attrs;
>  
>  	if (!attr)
>  		return;
>  
>  	for (; *attr; attr++)
>  		kfree((*attr)->name);
> -	kfree(attr_to_ext_attr(*skx_iio_mapping_group.attrs));
> -	kfree(skx_iio_mapping_group.attrs);
> -	skx_iio_mapping_group.attrs = NULL;
> +	kfree(attr_to_ext_attr(*ag->attrs));
> +	kfree(ag->attrs);
> +	ag->attrs = NULL;
>  	kfree(type->topology);
>  }
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
>  static struct intel_uncore_type skx_uncore_iio = {
>  	.name			= "iio",
>  	.num_counters		= 4,
> @@ -4499,6 +4505,11 @@ static int snr_iio_set_mapping(struct intel_uncore_type *type)
>  	return pmu_iio_set_mapping(type, &snr_iio_mapping_group);
>  }
>  
> +static void snr_iio_cleanup_mapping(struct intel_uncore_type *type)
> +{
> +	pmu_iio_cleanup_mapping(type, &snr_iio_mapping_group);
> +}
> +
>  static struct intel_uncore_type snr_uncore_iio = {
>  	.name			= "iio",
>  	.num_counters		= 4,
> @@ -4515,7 +4526,7 @@ static struct intel_uncore_type snr_uncore_iio = {
>  	.attr_update		= snr_iio_attr_update,
>  	.get_topology		= snr_iio_get_topology,
>  	.set_mapping		= snr_iio_set_mapping,
> -	.cleanup_mapping	= skx_iio_cleanup_mapping,
> +	.cleanup_mapping	= snr_iio_cleanup_mapping,
>  };
>  
>  static struct intel_uncore_type snr_uncore_irp = {
> @@ -5090,6 +5101,11 @@ static int icx_iio_set_mapping(struct intel_uncore_type *type)
>  	return pmu_iio_set_mapping(type, &icx_iio_mapping_group);
>  }
>  
> +static void icx_iio_cleanup_mapping(struct intel_uncore_type *type)
> +{
> +	pmu_iio_cleanup_mapping(type, &icx_iio_mapping_group);
> +}
> +
>  static struct intel_uncore_type icx_uncore_iio = {
>  	.name			= "iio",
>  	.num_counters		= 4,
> @@ -5107,7 +5123,7 @@ static struct intel_uncore_type icx_uncore_iio = {
>  	.attr_update		= icx_iio_attr_update,
>  	.get_topology		= icx_iio_get_topology,
>  	.set_mapping		= icx_iio_set_mapping,
> -	.cleanup_mapping	= skx_iio_cleanup_mapping,
> +	.cleanup_mapping	= icx_iio_cleanup_mapping,
>  };
>  
>  static struct intel_uncore_type icx_uncore_irp = {
> 
> base-commit: 3dbdb38e286903ec220aaf1fb29a8d94297da246
> -- 
> 2.21.3
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
