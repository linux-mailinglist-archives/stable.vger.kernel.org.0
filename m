Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF7B455579
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 08:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243363AbhKRHZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 02:25:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:31073 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243113AbhKRHZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 02:25:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="233965005"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="233965005"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 23:22:34 -0800
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="454951393"
Received: from xingzhen-mobl.ccr.corp.intel.com (HELO [10.238.4.155]) ([10.238.4.155])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 23:22:31 -0800
Message-ID: <efbdd0de-5e77-1e06-2fc7-f4cea7394e88@linux.intel.com>
Date:   Thu, 18 Nov 2021 15:22:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        alexander.shishkin@intel.com, ak@linux.intel.com,
        kan.liang@intel.com, stable@vger.kernel.org
References: <20211118144811.329111-1-zhengjun.xing@linux.intel.com>
 <YZX5jisoDQ2ydvV0@kroah.com>
From:   Xing Zhengjun <zhengjun.xing@linux.intel.com>
In-Reply-To: <YZX5jisoDQ2ydvV0@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/18/2021 2:58 PM, Greg KH wrote:
> On Thu, Nov 18, 2021 at 10:48:11PM +0800, zhengjun.xing@linux.intel.com wrote:
>> From: Zhengjun Xing <zhengjun.xing@linux.intel.com>
>>
>> The user recently report a perf issue in the ICX platform, when test by
>> perf event “uncore_imc_x/cas_count_write”,the write bandwidth is always
>> very small (only 0.38MB/s), it is caused by the wrong "umask" for the
>> "cas_count_write" event. When double-checking, find "cas_count_read"
>> also is wrong.
>>
>> The public document for ICX uncore:
>>
>> https://www.intel.com/content/www/us/en/develop/download/3rd-gen-intel-xeon-processor-scalable-uncore-pm.html
>>
>> On page 142, Table 2-143, defines Unit Masks for CAS_COUNT:
>> RD b00001111
>> WR b00110000
>>
>> So Corrected both "cas_count_read" and "cas_count_write" for ICX.
>>
>> Old settings:
>>   hswep_uncore_imc_events
>> 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03")
>>   	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c")
>>
>> New settings:
>>   snr_uncore_imc_events
>> 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x0f")
>> 	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x30"),
>>
>> Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
>> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
>> Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
>> ---
>>   arch/x86/events/intel/uncore_snbep.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
>> index 5ddc0f30db6f..a6fd8eb410a9 100644
>> --- a/arch/x86/events/intel/uncore_snbep.c
>> +++ b/arch/x86/events/intel/uncore_snbep.c
>> @@ -5468,7 +5468,7 @@ static struct intel_uncore_type icx_uncore_imc = {
>>   	.fixed_ctr_bits	= 48,
>>   	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,
>>   	.fixed_ctl	= SNR_IMC_MMIO_PMON_FIXED_CTL,
>> -	.event_descs	= hswep_uncore_imc_events,
>> +	.event_descs	= snr_uncore_imc_events,
>>   	.perf_ctr	= SNR_IMC_MMIO_PMON_CTR0,
>>   	.event_ctl	= SNR_IMC_MMIO_PMON_CTL0,
>>   	.event_mask	= SNBEP_PMON_RAW_EVENT_MASK,
>> -- 
>> 2.25.1
>>
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
> 
Sorry, I will add "Cc: stable@vger.kernel.org" in the sign-off area and 
send the new version patch.

-- 
Zhengjun Xing
