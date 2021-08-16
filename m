Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04F83ED3B3
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 14:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhHPMKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 08:10:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:2366 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhHPMKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 08:10:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="203047890"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="203047890"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:10:10 -0700
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="519629221"
Received: from ifridman-mobl.ger.corp.intel.com (HELO localhost) ([10.251.210.77])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:10:05 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     "Sharma\, Swati2" <swati2.sharma@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Ville Syrj_l_ <ville.syrjala@linux.intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Jos_ Roberto de Souza <jose.souza@intel.com>,
        Sean Paul <seanpaul@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/display: Drop redundant debug print
In-Reply-To: <04e2728f-a5e3-a8ee-9fdc-9affe753b59e@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20210812125845.27787-1-swati2.sharma@intel.com> <871r6xn5wd.fsf@intel.com> <04e2728f-a5e3-a8ee-9fdc-9affe753b59e@intel.com>
Date:   Mon, 16 Aug 2021 15:10:02 +0300
Message-ID: <87wnolio9x.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 Aug 2021, "Sharma, Swati2" <swati2.sharma@intel.com> wrote:
> On 13-Aug-21 1:16 PM, Jani Nikula wrote:
>> On Thu, 12 Aug 2021, Swati Sharma <swati2.sharma@intel.com> wrote:
>>> drm_dp_dpcd_read/write already has debug error message.
>>> Drop redundant error messages which gives false
>>> status even if correct value is read in drm_dp_dpcd_read().
>> 
>> I guess the only problem is it gets harder to associate the preceding
>> low level error messages with intel_dp_check_link_service_irq(). *shrug*
>> 
>> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
>> 
>> 
> Thanks Jani for the review. Can you please merge?

There was another version with open review?

BR,
Jani.


>
>>>
>>> Fixes: 9488a030ac91 ("drm/i915: Add support for enabling link status and recovery")
>>> Cc: Swati Sharma <swati2.sharma@intel.com>
>>> Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
>>> Cc: Uma Shankar <uma.shankar@intel.com> (v2)
>>> Cc: Jani Nikula <jani.nikula@intel.com>
>>> Cc: "Ville Syrj_l_" <ville.syrjala@linux.intel.com>
>>> Cc: Imre Deak <imre.deak@intel.com>
>>> Cc: Manasi Navare <manasi.d.navare@intel.com>
>>> Cc: Uma Shankar <uma.shankar@intel.com>
>>> Cc: "Jos_ Roberto de Souza" <jose.souza@intel.com>
>>> Cc: Sean Paul <seanpaul@chromium.org>
>>> Cc: <stable@vger.kernel.org> # v5.12+
>>>
>>> Link: https://patchwork.freedesktop.org/patch/msgid/20201218103723.30844-12-ankit.k.nautiyal@intel.com
>>> Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
>>> ---
>>>   drivers/gpu/drm/i915/display/intel_dp.c | 8 ++------
>>>   1 file changed, 2 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
>>> index c386ef8eb200..5c84f51ad41d 100644
>>> --- a/drivers/gpu/drm/i915/display/intel_dp.c
>>> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
>>> @@ -3871,16 +3871,12 @@ static void intel_dp_check_link_service_irq(struct intel_dp *intel_dp)
>>>   		return;
>>>   
>>>   	if (drm_dp_dpcd_readb(&intel_dp->aux,
>>> -			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val) {
>>> -		drm_dbg_kms(&i915->drm, "Error in reading link service irq vector\n");
>>> +			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val)
>>>   		return;
>>> -	}
>>>   
>>>   	if (drm_dp_dpcd_writeb(&intel_dp->aux,
>>> -			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1) {
>>> -		drm_dbg_kms(&i915->drm, "Error in writing link service irq vector\n");
>>> +			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1)
>>>   		return;
>>> -	}
>>>   
>>>   	if (val & HDMI_LINK_STATUS_CHANGED)
>>>   		intel_dp_handle_hdmi_link_status_change(intel_dp);
>> 

-- 
Jani Nikula, Intel Open Source Graphics Center
