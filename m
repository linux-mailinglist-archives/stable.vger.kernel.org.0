Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB05041BF6A
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 08:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244314AbhI2G7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 02:59:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:49197 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhI2G7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 02:59:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="205025381"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="205025381"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 23:58:08 -0700
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="554513777"
Received: from jmaugusx-mobl1.gar.corp.intel.com (HELO [10.249.254.159]) ([10.249.254.159])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 23:58:07 -0700
Message-ID: <9fbd95f4-1b73-aa63-6bd5-a46d021606f8@linux.intel.com>
Date:   Wed, 29 Sep 2021 08:58:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 08/21] drm/i915: Fix runtime pm handling in
 i915_gem_shrink
Content-Language: en-US
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        intel-gfx-trybot@lists.freedesktop.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
References: <20210928061016.2789949-1-maarten.lankhorst@linux.intel.com>
 <20210928061016.2789949-8-maarten.lankhorst@linux.intel.com>
From:   =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>
In-Reply-To: <20210928061016.2789949-8-maarten.lankhorst@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/28/21 08:10, Maarten Lankhorst wrote:
> We forgot to call intel_runtime_pm_put on error, fix it!
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Fixes: cf41a8f1dc1e ("drm/i915: Finally remove obj->mm.lock.")
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: <stable@vger.kernel.org> # v5.13+
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_shrinker.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> index e382b7f2353b..5ab136ffdeb2 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> @@ -118,7 +118,7 @@ i915_gem_shrink(struct i915_gem_ww_ctx *ww,
>   	intel_wakeref_t wakeref = 0;
>   	unsigned long count = 0;
>   	unsigned long scanned = 0;
> -	int err;
> +	int err = 0;
>   
>   	/* CHV + VTD workaround use stop_machine(); need to trylock vm->mutex */
>   	bool trylock_vm = !ww && intel_vm_no_concurrent_access_wa(i915);
> @@ -242,12 +242,15 @@ i915_gem_shrink(struct i915_gem_ww_ctx *ww,
>   		list_splice_tail(&still_in_list, phase->list);
>   		spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
>   		if (err)
> -			return err;
> +			break;
>   	}
>   
>   	if (shrink & I915_SHRINK_BOUND)
>   		intel_runtime_pm_put(&i915->runtime_pm, wakeref);
>   
> +	if (err)
> +		return err;
> +
>   	if (nr_scanned)
>   		*nr_scanned += scanned;
>   	return count;


Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>


