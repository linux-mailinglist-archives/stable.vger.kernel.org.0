Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D12A0C4F
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 23:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfH1VWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 17:22:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:20215 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfH1VWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 17:22:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 14:22:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="332299072"
Received: from astruck-mobl3.ger.corp.intel.com (HELO [10.252.35.162]) ([10.252.35.162])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2019 14:22:28 -0700
Subject: Re: [PATCH] drm/i915: fix broadwell EU computation
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Cc:     intel-gfx@lists.freedesktop.org, dmitry.v.rogozhkin@intel.com,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
References: <20190828210209.10541-1-rodrigo.vivi@intel.com>
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Organization: Intel Corporation (UK) Ltd. - Co. Reg. #1134945 - Pipers Way,
 Swindon SN3 1RJ
Message-ID: <d7faaa1c-362f-ce9e-bbc9-adb5a7400b1f@intel.com>
Date:   Thu, 29 Aug 2019 00:22:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828210209.10541-1-rodrigo.vivi@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/08/2019 00:02, Rodrigo Vivi wrote:
> From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>
> commit 6a67a20366f894c172734f28c5646bdbe48a46e3 upstream.
>
> subslice_mask is an array indexed by slice, not subslice.
>
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Fixes: 8cc7669355136f ("drm/i915: store all subslice masks")
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=108712
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20181112123931.2815-1-lionel.g.landwerlin@intel.com
> (cherry picked from commit 63ac3328f0d1d37f286e397b14d9596ed09d7ca5)
> Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: <stable@vger.kernel.org> # 4.17


Rodrigo pointed out I forgot the Cc: tag which is why this didn't make 
it to stable.

The same bug showed up on a CentOS kernel : 
https://github.com/intel/compute-runtime/issues/200

My bad... :(


Thanks for resending!


-Lionel


> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> ---
>   drivers/gpu/drm/i915/intel_device_info.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_device_info.c b/drivers/gpu/drm/i915/intel_device_info.c
> index 0ef0c6448d53..01fa98299bae 100644
> --- a/drivers/gpu/drm/i915/intel_device_info.c
> +++ b/drivers/gpu/drm/i915/intel_device_info.c
> @@ -474,7 +474,7 @@ static void broadwell_sseu_info_init(struct drm_i915_private *dev_priv)
>   			u8 eu_disabled_mask;
>   			u32 n_disabled;
>   
> -			if (!(sseu->subslice_mask[ss] & BIT(ss)))
> +			if (!(sseu->subslice_mask[s] & BIT(ss)))
>   				/* skip disabled subslice */
>   				continue;
>   


