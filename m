Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8582F5CF7D
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfGBMci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:32:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:38281 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfGBMci (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 08:32:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jul 2019 05:32:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,443,1557212400"; 
   d="scan'208";a="174578831"
Received: from bgrossx-mobl.ger.corp.intel.com (HELO [10.249.141.25]) ([10.249.141.25])
  by orsmga002.jf.intel.com with ESMTP; 02 Jul 2019 05:32:36 -0700
Subject: Re: [Intel-gfx] [PATCH v7 3/3] drm/i915/icl: whitelist
 PS_(DEPTH|INVOCATION)_COUNT
To:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20190628120720.21682-1-lionel.g.landwerlin@intel.com>
 <20190628120720.21682-4-lionel.g.landwerlin@intel.com>
 <87woh039g5.fsf@gaia.fi.intel.com>
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Organization: Intel Corporation (UK) Ltd. - Co. Reg. #1134945 - Pipers Way,
 Swindon SN3 1RJ
Message-ID: <d1292ee6-ab77-5a3c-1a61-af74c2aaee6b@intel.com>
Date:   Tue, 2 Jul 2019 15:32:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87woh039g5.fsf@gaia.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/07/2019 15:30, Mika Kuoppala wrote:
> Lionel Landwerlin <lionel.g.landwerlin@intel.com> writes:
>
>> The same tests failing on CFL+ platforms are also failing on ICL.
>> Documentation doesn't list the
>> WaAllowPMDepthAndInvocationCountAccessFromUMD workaround for ICL but
>> applying it fixes the same tests as CFL.
> Didn't find more documentation either but I have asked
> for the wa author for update.


I've filed an issue on the register definition (maybe a week ago), so 
far no response.

Hopefully you get luckier ;)


-Lionel


>
>> v2: Use only one whitelist entry (Lionel)
>>
>> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>> Tested-by:  Anuj Phogat <anuj.phogat@gmail.com>
>> Cc: stable@vger.kernel.org
> The register offsets are the same so we can't really do
> harm with this so we go with the evidence,
>
> Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
>
>> ---
>>   drivers/gpu/drm/i915/gt/intel_workarounds.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>> index b117583e38bb..a908d829d6bd 100644
>> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
>> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>> @@ -1138,6 +1138,19 @@ static void icl_whitelist_build(struct intel_engine_cs *engine)
>>   
>>   		/* WaEnableStateCacheRedirectToCS:icl */
>>   		whitelist_reg(w, GEN9_SLICE_COMMON_ECO_CHICKEN1);
>> +
>> +		/*
>> +		 * WaAllowPMDepthAndInvocationCountAccessFromUMD:icl
>> +		 *
>> +		 * This covers 4 register which are next to one another :
>> +		 *   - PS_INVOCATION_COUNT
>> +		 *   - PS_INVOCATION_COUNT_UDW
>> +		 *   - PS_DEPTH_COUNT
>> +		 *   - PS_DEPTH_COUNT_UDW
>> +		 */
>> +		whitelist_reg_ext(w, PS_INVOCATION_COUNT,
>> +				  RING_FORCE_TO_NONPRIV_RD |
>> +				  RING_FORCE_TO_NONPRIV_RANGE_4);
>>   		break;
>>   
>>   	case VIDEO_DECODE_CLASS:
>> -- 
>> 2.21.0.392.gf8f6787159e
>>
>> _______________________________________________
>> Intel-gfx mailing list
>> Intel-gfx@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/intel-gfx


