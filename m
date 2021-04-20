Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043103660F5
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 22:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhDTUeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 16:34:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:25865 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233984AbhDTUeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 16:34:05 -0400
IronPort-SDR: /bEFHUmnZ0g3OanJYWQr03oO+Z9Rd6t2QBSUIlYdf+rqLOyTdweMJq/JPVFud5CfXM5g0i1iny
 wSOi7SU90GcQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="192398632"
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="192398632"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 13:33:32 -0700
IronPort-SDR: iROinzx5GA/O1yaeUWUmQc7JzydRnJRQAgi2rTtTm06vdjY6mjSZw6FAw+iTUhgKY+L5d1ZFmV
 ruOXr974TnSQ==
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="384202468"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.84.204]) ([10.212.84.204])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 13:33:32 -0700
Subject: Re: [PATCH 5.11 007/122] dmaengine: idxd: Fix clobbering of SWERR
 overflow bit on writeback
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20210419130530.166331793@linuxfoundation.org>
 <20210419130530.423797059@linuxfoundation.org>
 <20210420201305.GA9942@duo.ucw.cz>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <1abf0d63-2ddd-be5e-c643-d154c30daf33@intel.com>
Date:   Tue, 20 Apr 2021 13:33:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420201305.GA9942@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/20/2021 1:13 PM, Pavel Machek wrote:
> Hi!
>
>> Current code blindly writes over the SWERR and the OVERFLOW bits. Write
>> back the bits actually read instead so the driver avoids clobbering the
>> OVERFLOW bit that comes after the register is read.
> I believe this is incorrect. Changelog explains that we need to
> preserve bits in the register...

The code is correct, but I guess maybe badly explained by me. The 
IDXD_SWERR_ACK mask is IDXD_SWERR_VALID | IDXD_SWERR_OVERFLOW. When we 
do write 1 to clear, we want to AND the register value that was read 
with the mask so that we don't blindly clear the overflow bit under the 
scenario where we read the register and then another error comes in and 
set the overflow bit while we are in the interrupt handler.


>
>> diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
>> index a60ca11a5784..f1463fc58112 100644
>> --- a/drivers/dma/idxd/irq.c
>> +++ b/drivers/dma/idxd/irq.c
>> @@ -124,7 +124,9 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
>>   		for (i = 0; i < 4; i++)
>>   			idxd->sw_err.bits[i] = ioread64(idxd->reg_base +
>>   					IDXD_SWERR_OFFSET + i * sizeof(u64));
>> -		iowrite64(IDXD_SWERR_ACK, idxd->reg_base + IDXD_SWERR_OFFSET);
>> +
>> +		iowrite64(idxd->sw_err.bits[0] & IDXD_SWERR_ACK,
>> +			  idxd->reg_base + IDXD_SWERR_OFFSET);
> ...but that is not what the code does.
>
> I suspect it should be
>
>> +		iowrite64(idxd->sw_err.bits[0] | IDXD_SWERR_ACK,
>> +			  idxd->reg_base + IDXD_SWERR_OFFSET);
> Best regards,
> 								Pavel
>
