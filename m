Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3E156054A
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 18:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiF2QEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 12:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbiF2QD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 12:03:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCB36396;
        Wed, 29 Jun 2022 09:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656518590; x=1688054590;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T667AQkQO6W+y7qPEHoEOG/k45uvfM5ZLAMqoGg6hEU=;
  b=Hlp7DK2eOSCSt+H2sq/si3SwEndGMcA1dBnOTPsvxwg0NAvqpeMVP9kj
   +fMbF2i2OD4gJ5R+pL5UgI0bil0XcZBsRgc/nSKMoK3Qx42K91VqwwY6R
   rOA2ObMZO4VbothN/QIhmOYdtaiiauN2tIJk2gT+uLTSbVJhiYyQCBmXA
   7sgB25bSsHAPw0y4DyERtMWl22UzKgbTY2f6uZC5FNfUOqyf6Lakd91v7
   0ciU7wWIAhidiCTXGmkWqrK2DB+KTz+di/iCoRvP33MMiufr89Zvn4MGz
   CmXMDUPzMF+xr0iNM7oDGzz2ORcMrCo+5rZdpbI+WtxLZw6s4ZvRAF8Ip
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="262473883"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="262473883"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 09:03:07 -0700
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="837176977"
Received: from dmurr12x-mobl.ger.corp.intel.com (HELO [10.213.211.77]) ([10.213.211.77])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 09:03:01 -0700
Message-ID: <7e6a9a27-7286-7f21-7fec-b9832b93b10c@linux.intel.com>
Date:   Wed, 29 Jun 2022 17:02:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5/6] drm/i915/gt: Serialize GRDOM access between multiple
 engine resets
Content-Language: en-US
To:     Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>
Cc:     Andi Shyti <andi.shyti@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>
References: <cover.1655306128.git.mchehab@kernel.org>
 <5ee647f243a774927ec328bfca8212abc4957909.1655306128.git.mchehab@kernel.org>
 <YrRLyg1IJoZpVGfg@intel.intel>
 <160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.intel.com>
 <20220627110056.6dfa4f9b@maurocar-mobl2>
 <d79492ad-b99a-f9a9-f64a-52b94db68a3b@linux.intel.com>
 <20220629172955.64ffb5c3@maurocar-mobl2>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220629172955.64ffb5c3@maurocar-mobl2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/06/2022 16:30, Mauro Carvalho Chehab wrote:
> On Tue, 28 Jun 2022 16:49:23 +0100
> Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
> 
>> .. which for me means a different patch 1, followed by patch 6 (moved
>> to be patch 2) would be ideal stable material.
>>
>> Then we have the current patch 2 which is open/unknown (to me at least).
>>
>> And the rest seem like optimisations which shouldn't be tagged as fixes.
>>
>> Apart from patch 5 which should be cc: stable, but no fixes as agreed.
>>
>> Could you please double check if what I am suggesting here is feasible
>> to implement and if it is just send those minimal patches out alone?
> 
> Tested and porting just those 3 patches are enough to fix the Broadwell
> bug.
> 
> So, I submitted a v2 of this series with just those. They all need to
> be backported to stable.

I would really like to give even a smaller fix a try. Something like, although not even compile tested:

commit 4d5e94aef164772f4d85b3b4c1a46eac9a2bd680
Author: Chris Wilson <chris.p.wilson@intel.com>
Date:   Wed Jun 29 16:25:24 2022 +0100

     drm/i915/gt: Serialize TLB invalidates with GT resets
     
     Avoid trying to invalidate the TLB in the middle of performing an
     engine reset, as this may result in the reset timing out. Currently,
     the TLB invalidate is only serialised by its own mutex, forgoing the
     uncore lock, but we can take the uncore->lock as well to serialise
     the mmio access, thereby serialising with the GDRST.
     
     Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
     i915 selftest/hangcheck.
     
     Cc: stable@vger.kernel.org
     Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
     Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
     Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
     Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
     Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
     Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
     Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
     Reviewed-by: Andi Shyti <andi.shyti@intel.com>
     Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
     Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 8da3314bb6bf..aaadd0b02043 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -952,7 +952,23 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
         mutex_lock(&gt->tlb_invalidate_lock);
         intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
  
+       spin_lock_irq(&uncore->lock); /* serialise invalidate with GT reset */
+
+       for_each_engine(engine, gt, id) {
+               struct reg_and_bit rb;
+
+               rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
+               if (!i915_mmio_reg_offset(rb.reg))
+                       continue;
+
+               intel_uncore_write_fw(uncore, rb.reg, rb.bit);
+       }
+
+       spin_unlock_irq(&uncore->lock);
+
         for_each_engine(engine, gt, id) {
+               struct reg_and_bit rb;
+
                 /*
                  * HW architecture suggest typical invalidation time at 40us,
                  * with pessimistic cases up to 100us and a recommendation to
@@ -960,13 +976,11 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
                  */
                 const unsigned int timeout_us = 100;
                 const unsigned int timeout_ms = 4;
-               struct reg_and_bit rb;
  
                 rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
                 if (!i915_mmio_reg_offset(rb.reg))
                         continue;
  
-               intel_uncore_write_fw(uncore, rb.reg, rb.bit);
                 if (__intel_wait_for_register_fw(uncore,
                                                  rb.reg, rb.bit, 0,
                                                  timeout_us, timeout_ms,

If this works it would be least painful to backport. The other improvements can then be devoid of the fixes tag.

> I still think that other TLB patches are needed/desired upstream, but
> I'll submit them on a separate series. Let's fix the regression first ;-)

Yep, that's exactly right.

Regards,

Tvrtko
