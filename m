Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBB33D8EE7
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 15:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbhG1NXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhG1NXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 09:23:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B17C061764
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 06:23:11 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i10so2677171pla.3
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 06:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tf3UHSD5uejn5HgAy+owJQfFVB+55P8SzuHzA/+KXzo=;
        b=SmjWFPeoE4TqgW9PSXNDCenY6J5tFOwAUb46FFrhQCj1RYdY/TxHhnWPt1YkWh4B1O
         ERbL5NvsJ+e9fpal3XzWNlANSHAIrmZilPOSUGrH6jriCKHJKdrd5e4/gWjG1BhAZklJ
         6K/oN6d6dSZaDga4s5mx2mcW2xSrYtqy3vAmqKD3Hitl2G+1nqTf9jwSM6GZiicAkeaQ
         +0PFDPc5Rwg3lLRw1MouJ8opgdbCUZREfsxxtjNG4dNOrromrOVroN/jUv/35cchA6+c
         XzTNKJnO3zyWF8BgFvpvJFe0YTWo+YV3chJzooGUQxY1Z2tKSqEhpb+jPtLk1ZCz4tDH
         fHsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tf3UHSD5uejn5HgAy+owJQfFVB+55P8SzuHzA/+KXzo=;
        b=O2Ajdq/ieVixht0YrbA5rLRp4LlPp8f3edDwsK2dL8hmiTvxCc990XKpce2MBkwmG/
         W6t520mzXFOyGEEDXAvcX2oehRXdOpeMneC/7IHcRHGGIGiNQNpTRGdSxTZhb1bHHGYx
         MBIL79XUFhNKbF0Vsz0UnBIhbRyQ0Ae43tBpESkx7qun8AWh4mbZ6eYs1qWaWClp3kwN
         7bWAnpD1Bg2G0E6ZWGzAxWLuHIygxTuC/NYvzrPPbZO28AYQbJgU0xMSZiPb8CWi0/4M
         3vbuRTntHwM48Dtnr1MLK6tsKRKTnCBb+79+NeSsCn9Qzq8lyZvrcPIAlT6t1WAA9z5R
         jtnA==
X-Gm-Message-State: AOAM530ERwm0IEKUaLNwYgrfxmuSyv1zhq+owiRBSOpnMNyqxeyGOfw9
        fsRtCiIlvTbOhtpWQoiEKODe9aCci2vleVFl
X-Google-Smtp-Source: ABdhPJylzwz1I7TEx7aucqQzE+TWY6/zgnTrxKBlGSiX32Y/OvGqQBOexqknt5LFyEo/PXD/kfzBkQ==
X-Received: by 2002:a63:2bcf:: with SMTP id r198mr18809180pgr.373.1627478590552;
        Wed, 28 Jul 2021 06:23:10 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id h20sm7751854pfn.173.2021.07.28.06.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 06:23:10 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: don't block level reissue off completion
 path
To:     Fabian Ebner <f.ebner@proxmox.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210727165811.284510-1-axboe@kernel.dk>
 <20210727165811.284510-3-axboe@kernel.dk>
 <70b7b7b2-c6d5-8088-ee76-c1ffc53ac2a3@proxmox.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <df686cb8-3d6e-f3ee-b767-b297434748e7@kernel.dk>
Date:   Wed, 28 Jul 2021 07:23:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <70b7b7b2-c6d5-8088-ee76-c1ffc53ac2a3@proxmox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/28/21 3:26 AM, Fabian Ebner wrote:
> Am 27.07.21 um 18:58 schrieb Jens Axboe:
>> Some setups, like SCSI, can throw spurious -EAGAIN off the softirq
>> completion path. Normally we expect this to happen inline as part
>> of submission, but apparently SCSI has a weird corner case where it
>> can happen as part of normal completions.
>>
>> This should be solved by having the -EAGAIN bubble back up the stack
>> as part of submission, but previous attempts at this failed and we're
>> not just quite there yet. Instead we currently use REQ_F_REISSUE to
>> handle this case.
>>
>> For now, catch it in io_rw_should_reissue() and prevent a reissue
>> from a bogus path.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Fabian Ebner <f.ebner@proxmox.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   fs/io_uring.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 6ba101cd4661..83f67d33bf67 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2447,6 +2447,12 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
>>   	 */
>>   	if (percpu_ref_is_dying(&ctx->refs))
>>   		return false;
>> +	/*
>> +	 * Play it safe and assume not safe to re-import and reissue if we're
>> +	 * not in the original thread group (or in task context).
>> +	 */
>> +	if (!same_thread_group(req->task, current) || !in_task())
>> +		return false;
>>   	return true;
>>   }
>>   #else
>>
> 
> Hi,
> 
> thank you for the fix! This does indeed prevent the panic (with 5.11.22) 
> and hang (with 5.13.3) with my problematic workload.

Perfect, thanks for re-testing! Can I add your Tested-by to the patch?

-- 
Jens Axboe

