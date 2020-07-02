Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE1321234F
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 14:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgGBM1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 08:27:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:19322 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbgGBM1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 08:27:49 -0400
IronPort-SDR: te8+BZUW2vA+ggfNR8KwE0ugCNsvGbMxW7DzhlnIiWJ0lOcnLcBIVy4xGLvNmAx+f/87yWTmyx
 qz9oOaJkrWbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="148428527"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="148428527"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:27:48 -0700
IronPort-SDR: n9B3TEmF8lcbbhsfjDkqIXQuq8GVImYsOh43rXQc7XhMKv6Gu3/fCZDvGglnjXh/wiZElnBznP
 pY0nc+5sNWzA==
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="481984527"
Received: from dandoron-mobl.ger.corp.intel.com (HELO [10.214.212.30]) ([10.214.212.30])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:27:46 -0700
Subject: Re: [Intel-gfx] [PATCH 01/23] drm/i915: Drop vm.ref for duplicate vma
 on construction
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200702083225.20044-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <8a50fa3d-83bd-0a75-cd50-17a593a2e0ca@linux.intel.com>
Date:   Thu, 2 Jul 2020 13:27:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200702083225.20044-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/07/2020 09:32, Chris Wilson wrote:
> As we allow for parallel threads to create vma instances in parallel,
> and we only filter out the duplicates upon reacquiring the spinlock for
> the rbtree, we have to free the loser of the constructors' race. When
> freeing, we should also drop any resource references acquired for the
> redundant vma.
> 
> Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+
> ---
>   drivers/gpu/drm/i915/i915_vma.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
> index 1f63c4a1f055..7fe1f317cd2b 100644
> --- a/drivers/gpu/drm/i915/i915_vma.c
> +++ b/drivers/gpu/drm/i915/i915_vma.c
> @@ -198,6 +198,7 @@ vma_create(struct drm_i915_gem_object *obj,
>   		cmp = i915_vma_compare(pos, vm, view);
>   		if (cmp == 0) {
>   			spin_unlock(&obj->vma.lock);
> +			i915_vm_put(vm);
>   			i915_vma_free(vma);
>   			return pos;
>   		}
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
