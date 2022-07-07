Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A835556AD76
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 23:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbiGGV2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 17:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236282AbiGGV2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 17:28:25 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BFA2E6BE;
        Thu,  7 Jul 2022 14:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657229303; x=1688765303;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7/TlorJDQoNGY2gktJY2UhvNcAgpTuh1cVKPBgUm+/0=;
  b=CfhCZ9LqCuvVIpi6GjX1PeYMalrX6YIcLI9Es7tObjgKl0/6971KvKuL
   3+Dq8+W/OZLa1U+x+yyjKjhcI3MxpTpOnUbvLqBo4XxqOTLyZAn3QE3Jb
   qr/TFIjpex8S8CKI66qJg22TeHEjCZfF7/S2IXBFWhrXA/c+/F8krGMhN
   QuSCmqj6My8a3tH49vBPV0kJkX0kVEh2TgdRYxps0twfTz06gZtCRE/ep
   IY8rlMLJqjU526v3AhZImFhVD4Q0/955BjrVm06ASM3YLScOk2zDyf5PV
   NkMoTqjPk9g+PBgy3upjzEgjPXYkqtS+iasQhN1sWzje32W/AFQK3H56n
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="281674719"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="281674719"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 14:28:23 -0700
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="651297397"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.16.170]) ([10.213.16.170])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 14:28:20 -0700
Message-ID: <70a63b2e-23f5-9bf8-f782-5941f5cd01fc@intel.com>
Date:   Thu, 7 Jul 2022 23:28:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [Intel-gfx] [PATCH v3 2/2] drm/i915/gt: Serialize TLB invalidates
 with GT resets
Content-Language: en-US
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Andi Shyti <andi.shyti@intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org,
        Chris Wilson <chris.p.wilson@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
References: <cover.1656921701.git.mchehab@kernel.org>
 <3ecc1f94290a66b2e682f956b5232b4903c32a2c.1656921701.git.mchehab@kernel.org>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <3ecc1f94290a66b2e682f956b5232b4903c32a2c.1656921701.git.mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.07.2022 10:09, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Avoid trying to invalidate the TLB in the middle of performing an
> engine reset, as this may result in the reset timing out. Currently,
> the TLB invalidate is only serialised by its own mutex, forgoing the
> uncore lock, but we can take the uncore->lock as well to serialise
> the mmio access, thereby serialising with the GDRST.
> 
> Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
> i915 selftest/hangcheck.
> 
> Cc: stable@vger.kernel.org # Up to 4.4
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej

> ---
> 
> To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
> See [PATCH v3 0/2] at: https://lore.kernel.org/all/cover.1656921701.git.mchehab@kernel.org/
> 
>   drivers/gpu/drm/i915/gt/intel_gt.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
> index 8da3314bb6bf..68c2b0d8f187 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gt.c
> @@ -952,6 +952,20 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>   	mutex_lock(&gt->tlb_invalidate_lock);
>   	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
>   
> +	spin_lock_irq(&uncore->lock); /* serialise invalidate with GT reset */
> +
> +	for_each_engine(engine, gt, id) {
> +		struct reg_and_bit rb;
> +
> +		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
> +		if (!i915_mmio_reg_offset(rb.reg))
> +			continue;
> +
> +		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
> +	}
> +
> +	spin_unlock_irq(&uncore->lock);
> +
>   	for_each_engine(engine, gt, id) {
>   		/*
>   		 * HW architecture suggest typical invalidation time at 40us,
> @@ -966,7 +980,6 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>   		if (!i915_mmio_reg_offset(rb.reg))
>   			continue;
>   
> -		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
>   		if (__intel_wait_for_register_fw(uncore,
>   						 rb.reg, rb.bit, 0,
>   						 timeout_us, timeout_ms,

