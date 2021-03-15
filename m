Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350E933AF78
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 11:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCOKBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 06:01:41 -0400
Received: from foss.arm.com ([217.140.110.172]:57098 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhCOKBS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 06:01:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BE4D1FB;
        Mon, 15 Mar 2021 03:01:17 -0700 (PDT)
Received: from [10.57.12.51] (unknown [10.57.12.51])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 71C1B3F70D;
        Mon, 15 Mar 2021 03:01:16 -0700 (PDT)
Subject: Re: [PATCH v2] PM / devfreq: Unlock mutex and free devfreq struct in
 error path
To:     Chanwoo Choi <cw00.choi@samsung.com>
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        stable@vger.kernel.org
References: <CGME20210315093239epcas1p4516341a9f5614f59bfeb6af66e146540@epcas1p4.samsung.com>
 <20210315093123.20049-1-lukasz.luba@arm.com>
 <a73d618f-2369-0d80-f8c6-22ddd9a9a716@samsung.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <b688e97d-d616-2c1a-a649-c6dfeb435c44@arm.com>
Date:   Mon, 15 Mar 2021 10:01:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a73d618f-2369-0d80-f8c6-22ddd9a9a716@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/15/21 9:54 AM, Chanwoo Choi wrote:
> On 3/15/21 6:31 PM, Lukasz Luba wrote:
>> The devfreq->lock is held for time of setup. Release the lock in the
>> error path, before jumping to the end of the function.
>>
>> Change the goto destination which frees the allocated memory.
>>
>> Cc: v5.9+ <stable@vger.kernel.org> # v5.9+
>> Fixes: 4dc3bab8687f ("PM / devfreq: Add support delayed timer for polling mode")
>> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
>> ---
>> v2:
>> - added fixes tag and CC stable v5.9+
>> - used capital letter in commit header
>>
>>
>>   drivers/devfreq/devfreq.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>> index b6d3e7db0b09..99b2eeedc238 100644
>> --- a/drivers/devfreq/devfreq.c
>> +++ b/drivers/devfreq/devfreq.c
>> @@ -822,7 +822,8 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>   
>>   	if (devfreq->profile->timer < 0
>>   		|| devfreq->profile->timer >= DEVFREQ_TIMER_NUM) {
>> -		goto err_out;
>> +		mutex_unlock(&devfreq->lock);
>> +		goto err_dev;
>>   	}
>>   
>>   	if (!devfreq->profile->max_state && !devfreq->profile->freq_table) {
>>
> 
> 
> Applied it. Thanks.
> 

Thank you Chanwoo!

Regards,
Lukasz
