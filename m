Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083433ED368
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 13:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhHPLxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 07:53:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:38870 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233530AbhHPLxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 07:53:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="215874526"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="215874526"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 04:53:07 -0700
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="679071090"
Received: from swatish2-mobl1.gar.corp.intel.com (HELO [10.215.193.217]) ([10.215.193.217])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 04:53:03 -0700
Subject: Re: [v3][PATCH] drm/i915/display: Drop redundant debug print
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Ville Syrj_l_ <ville.syrjala@linux.intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Jos_ Roberto de Souza <jose.souza@intel.com>,
        Sean Paul <seanpaul@chromium.org>, stable@vger.kernel.org
References: <20210812131107.5531-1-swati2.sharma@intel.com>
 <20210812160118.GH2600583@ideak-desk.fi.intel.com>
From:   "Sharma, Swati2" <swati2.sharma@intel.com>
Organization: Intel
Message-ID: <4d4c94a4-2344-068d-5096-262b0ad70602@intel.com>
Date:   Mon, 16 Aug 2021 17:23:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210812160118.GH2600583@ideak-desk.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12-Aug-21 9:31 PM, Imre Deak wrote:
> On Thu, Aug 12, 2021 at 06:41:07PM +0530, Swati Sharma wrote:
>> drm_dp_dpcd_read/write already has debug error message.
>> Drop redundant error messages which gives false
>> status even if correct value is read in drm_dp_dpcd_read().
>>
>> v2: -Added fixes tag (Ankit)
>> v3: -Fixed build error (CI)
>>
>> Fixes: 9488a030ac91 ("drm/i915: Add support for enabling link status and recovery")
>> Cc: Swati Sharma <swati2.sharma@intel.com>
>> Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
>> Cc: Uma Shankar <uma.shankar@intel.com> (v2)
>> Cc: Jani Nikula <jani.nikula@intel.com>
>> Cc: "Ville Syrj_l_" <ville.syrjala@linux.intel.com>
>> Cc: Imre Deak <imre.deak@intel.com>
>> Cc: Manasi Navare <manasi.d.navare@intel.com>
>> Cc: Uma Shankar <uma.shankar@intel.com>
>> Cc: "Jos_ Roberto de Souza" <jose.souza@intel.com>
>> Cc: Sean Paul <seanpaul@chromium.org>
>> Cc: <stable@vger.kernel.org> # v5.12+
>>
>> Link: https://patchwork.freedesktop.org/patch/msgid/20201218103723.30844-12-ankit.k.nautiyal@intel.com
>>
>> Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
>> ---
>>   drivers/gpu/drm/i915/display/intel_dp.c | 9 ++-------
>>   1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
>> index c386ef8eb200..2526c9c8c690 100644
>> --- a/drivers/gpu/drm/i915/display/intel_dp.c
>> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
>> @@ -3864,23 +3864,18 @@ static void intel_dp_check_device_service_irq(struct intel_dp *intel_dp)
>>   
>>   static void intel_dp_check_link_service_irq(struct intel_dp *intel_dp)
>>   {
>> -	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
>>   	u8 val;
>>   
>>   	if (intel_dp->dpcd[DP_DPCD_REV] < 0x11)
>>   		return;
>>   
>>   	if (drm_dp_dpcd_readb(&intel_dp->aux,
>> -			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val) {
>> -		drm_dbg_kms(&i915->drm, "Error in reading link service irq vector\n");
> 
> The only problem seems to be that for !val the debug print is incorrect,
> so maybe just have a separate check for that after this one for the read()
> and return w/o the debug message?
> 
> Is it really a stable material, since the change wouldn't have any
> effect for regular users?
> 

W/o this change in case of valid short pulse this error message will 
come even if
it doesn't have anything to do with link service irq. For ex: in case of 
hdcp we keep getting unnecessary error message because the value read is 
0 which will always be the case unless its really a link failure between 
PCON and HDMI2.1 sink.

Also, code is written in accordance with other IRQ func() above like 
intel_dp_check_device_service_irq().

>> +			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val)
>>   		return;
>> -	}
>>   
>>   	if (drm_dp_dpcd_writeb(&intel_dp->aux,
>> -			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1) {
>> -		drm_dbg_kms(&i915->drm, "Error in writing link service irq vector\n");
>> +			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1)
>>   		return;
>> -	}
>>   
>>   	if (val & HDMI_LINK_STATUS_CHANGED)
>>   		intel_dp_handle_hdmi_link_status_change(intel_dp);
>> -- 
>> 2.25.1
>>

-- 
~Swati Sharma
