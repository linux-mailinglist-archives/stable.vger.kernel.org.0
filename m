Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4047615CB0
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 08:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiKBHHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 03:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiKBHHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 03:07:30 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8D81EEC3;
        Wed,  2 Nov 2022 00:07:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0VTme8ok_1667372840;
Received: from 30.32.78.92(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0VTme8ok_1667372840)
          by smtp.aliyun-inc.com;
          Wed, 02 Nov 2022 15:07:24 +0800
Message-ID: <1aa0ca90-d44c-aa99-1e2d-bd2ae610b088@linux.alibaba.com>
Date:   Wed, 2 Nov 2022 15:07:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH] ACPI: APEI: set memory failure flags as
 MF_ACTION_REQUIRED on action required events
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     lenb@kernel.org, james.morse@arm.com, tony.luck@intel.com,
        bp@alien8.de, dave.hansen@linux.intel.com, jarkko@kernel.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cuibixuan@linux.alibaba.com, baolin.wang@linux.alibaba.com,
        zhuo.song@linux.alibaba.com
References: <20221027042445.60108-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0hdgxsDiXqOmeqBQoZUQJ1RssM=3jpYpWt3qzy0n2eyaA@mail.gmail.com>
From:   Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <CAJZ5v0hdgxsDiXqOmeqBQoZUQJ1RssM=3jpYpWt3qzy0n2eyaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/10/29 AM1:08, Rafael J. Wysocki 写道:
> On Thu, Oct 27, 2022 at 6:25 AM Shuai Xue <xueshuai@linux.alibaba.com> wrote:
>>
>> There are two major types of uncorrected error (UC) :
>>
>> - Action Required: The error is detected and the processor already consumes the
>>   memory. OS requires to take action (for example, offline failure page/kill
>>   failure thread) to recover this uncorrectable error.
>>
>> - Action Optional: The error is detected out of processor execution context.
>>   Some data in the memory are corrupted. But the data have not been consumed.
>>   OS is optional to take action to recover this uncorrectable error.
>>
>> For X86 platforms, we can easily distinguish between these two types
>> based on the MCA Bank. While for arm64 platform, the memory failure
>> flags for all UCs which severity are GHES_SEV_RECOVERABLE are set as 0,
>> a.k.a, Action Optional now.
>>
>> If UC is detected by a background scrubber, it is obviously an Action
>> Optional error.  For other errors, we should conservatively regard them
>> as Action Required.
>>
>> cper_sec_mem_err::error_type identifies the type of error that occurred
>> if CPER_MEM_VALID_ERROR_TYPE is set. So, set memory failure flags as 0
>> for Scrub Uncorrected Error (type 14). Otherwise, set memory failure
>> flags as MF_ACTION_REQUIRED.
>>
>> Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
> 
> I need input from the APEI reviewers on this.
> 
> Thanks!

Hi, Rafael,

Sorry, I missed this email. Thank you for you quick reply. Let's discuss with
reviewers.

Thank you.

Cheers,
Shuai


> 
>> ---
>>  drivers/acpi/apei/ghes.c | 10 ++++++++--
>>  include/linux/cper.h     |  3 +++
>>  2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 80ad530583c9..6c03059cbfc6 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -474,8 +474,14 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
>>         if (sec_sev == GHES_SEV_CORRECTED &&
>>             (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
>>                 flags = MF_SOFT_OFFLINE;
>> -       if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
>> -               flags = 0;
>> +       if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE) {
>> +               if (mem_err->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
>> +                       flags = mem_err->error_type == CPER_MEM_SCRUB_UC ?
>> +                                       0 :
>> +                                       MF_ACTION_REQUIRED;
>> +               else
>> +                       flags = MF_ACTION_REQUIRED;
>> +       }
>>
>>         if (flags != -1)
>>                 return ghes_do_memory_failure(mem_err->physical_addr, flags);
>> diff --git a/include/linux/cper.h b/include/linux/cper.h
>> index eacb7dd7b3af..b77ab7636614 100644
>> --- a/include/linux/cper.h
>> +++ b/include/linux/cper.h
>> @@ -235,6 +235,9 @@ enum {
>>  #define CPER_MEM_VALID_BANK_ADDRESS            0x100000
>>  #define CPER_MEM_VALID_CHIP_ID                 0x200000
>>
>> +#define CPER_MEM_SCRUB_CE                      13
>> +#define CPER_MEM_SCRUB_UC                      14
>> +
>>  #define CPER_MEM_EXT_ROW_MASK                  0x3
>>  #define CPER_MEM_EXT_ROW_SHIFT                 16
>>
>> --
>> 2.20.1.9.gb50a0d7
>>
