Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBFE2C6320
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 11:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgK0Kbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 05:31:42 -0500
Received: from mga17.intel.com ([192.55.52.151]:18044 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727518AbgK0Kbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 05:31:42 -0500
IronPort-SDR: fMLtjSQhJBN0/CftoxNXKQl00rCnsh17ob7qbLPciJdPQjLRvP0iIFm+lszGMr2oYG4j7FSLYb
 OpTfhK6yfdqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9817"; a="152209974"
X-IronPort-AV: E=Sophos;i="5.78,374,1599548400"; 
   d="scan'208";a="152209974"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2020 02:31:42 -0800
IronPort-SDR: p59ETYrz8oPP9dtuICozKwCzu+IXt0ou1DgoAWUFQPkJ7PwAO9JFvh5IZfZo+7uX/zJ8D6e0Ld
 k6jvXeUsX4Sg==
X-IronPort-AV: E=Sophos;i="5.78,374,1599548400"; 
   d="scan'208";a="537600217"
Received: from einatsch-mobl.ger.corp.intel.com (HELO [10.214.245.41]) ([10.214.245.41])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2020 02:31:40 -0800
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Declare gen9 has 64 mocs
 entries!
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20201127102540.13117-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <fe3cc95e-342d-4e3b-2821-853421e8e32c@linux.intel.com>
Date:   Fri, 27 Nov 2020 10:31:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201127102540.13117-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/11/2020 10:25, Chris Wilson wrote:
> We checked the table size against a hardcoded number of entries, and
> that number was excluding the special mocs registers at the end.
> 
> Fixes: 977933b5da7c ("drm/i915/gt: Program mocs:63 for cache eviction on gen9")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v4.3+
> ---
>   drivers/gpu/drm/i915/gt/intel_mocs.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
> index b8d0c32ae9dd..ab6870242e18 100644
> --- a/drivers/gpu/drm/i915/gt/intel_mocs.c
> +++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
> @@ -59,8 +59,7 @@ struct drm_i915_mocs_table {
>   #define _L3_CACHEABILITY(value)	((value) << 4)
>   
>   /* Helper defines */
> -#define GEN9_NUM_MOCS_ENTRIES	62  /* 62 out of 64 - 63 & 64 are reserved. */
> -#define GEN11_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
> +#define GEN9_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
>   
>   /* (e)LLC caching options */
>   /*
> @@ -361,15 +360,15 @@ static unsigned int get_mocs_settings(const struct drm_i915_private *i915,
>   	if (IS_DG1(i915)) {
>   		table->size = ARRAY_SIZE(dg1_mocs_table);
>   		table->table = dg1_mocs_table;
> -		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
> +		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
>   	} else if (INTEL_GEN(i915) >= 12) {
>   		table->size  = ARRAY_SIZE(tgl_mocs_table);
>   		table->table = tgl_mocs_table;
> -		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
> +		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
>   	} else if (IS_GEN(i915, 11)) {
>   		table->size  = ARRAY_SIZE(icl_mocs_table);
>   		table->table = icl_mocs_table;
> -		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
> +		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
>   	} else if (IS_GEN9_BC(i915) || IS_CANNONLAKE(i915)) {
>   		table->size  = ARRAY_SIZE(skl_mocs_table);
>   		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
