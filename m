Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14921B92CF
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 20:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgDZSeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 14:34:00 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51877 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgDZSeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Apr 2020 14:34:00 -0400
Received: by mail-pj1-f68.google.com with SMTP id mq3so6416053pjb.1;
        Sun, 26 Apr 2020 11:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qXzckTHEzLqfjoEm4W9i8PdnLcL+nCVxfBPlrAmSpss=;
        b=rM0/zQkKYgAmBc9xZJdbveWBXmeDPhvT1m6xGHcoXVNjr9q6ker4zf3vHAmN+xpbyK
         c0INPJWei63ZMT7wHsbUN44cfuVyQ2hPpuu54OH8qE2sdFv/NthiN9Ry5SdIYRxc3i1i
         n4eP8hqyhDwV1WsFqgid8RVa22ke0gUehkyGLLSq6pBFvWreCSVoR4YIwPb+/L12Sbhc
         lFrxxKnRHiVT0uQ0pDgwE0L8XIDVtCqcYe345lTTJt0eklDj29CIISCBYDiMCRAkDjqW
         RFRI18mcSuljDU3Asm75poexQ+V88lIIOPAAczRvkDXx1wycD/qk8wtup3P614ODdkBK
         7+7Q==
X-Gm-Message-State: AGi0PuaM3C76dvJn2d8hnZBqNZpkIl3mJe79gVZFsIXH7SjIRsFR164F
        x+na0UPcJJ0hoPjF+WuQugue1jI6ACg=
X-Google-Smtp-Source: APiQypIXp0UkWpZqGK0QlcZ5upJJhQ7wmtOcL8MPgX9Ev22J1fLNQSBPnPW4EjdGJAC4GHXQIhHIKw==
X-Received: by 2002:a17:90a:3767:: with SMTP id u94mr19971131pjb.23.1587926039349;
        Sun, 26 Apr 2020 11:33:59 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:612a:373a:aa97:7fa7? ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id g1sm9302760pjt.25.2020.04.26.11.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 11:33:58 -0700 (PDT)
Subject: Re: [PATCH] PM: hibernate: Freeze kernel threads in software_resume()
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>, decui@microsoft.com
Cc:     linux-pm@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz,
        mikelley@microsoft.com, longli@microsoft.com,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        wei.liu@kernel.org, sthemmin@microsoft.com, haiyangz@microsoft.com,
        kys@microsoft.com, stable@vger.kernel.org
References: <20200424034016.42046-1-decui@microsoft.com>
 <2420808.aENraY2TMt@kreacher>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <08f28683-4978-3e3c-e85a-303f6e46ef55@acm.org>
Date:   Sun, 26 Apr 2020 11:33:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2420808.aENraY2TMt@kreacher>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-04-26 09:24, Rafael J. Wysocki wrote:
> On Friday, April 24, 2020 5:40:16 AM CEST Dexuan Cui wrote:
>> Currently the kernel threads are not frozen in software_resume(), so
>> between dpm_suspend_start(PMSG_QUIESCE) and resume_target_kernel(),
>> system_freezable_power_efficient_wq can still try to submit SCSI
>> commands and this can cause a panic since the low level SCSI driver
>> (e.g. hv_storvsc) has quiesced the SCSI adapter and can not accept
>> any SCSI commands: https://lkml.org/lkml/2020/4/10/47
>>
>> At first I posted a fix (https://lkml.org/lkml/2020/4/21/1318) trying
>> to resolve the issue from hv_storvsc, but with the help of
>> Bart Van Assche, I realized it's better to fix software_resume(),
>> since this looks like a generic issue, not only pertaining to SCSI.
>>
>> Cc: Bart Van Assche <bvanassche@acm.org>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>> ---
>>  kernel/power/hibernate.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
>> index 86aba8706b16..30bd28d1d418 100644
>> --- a/kernel/power/hibernate.c
>> +++ b/kernel/power/hibernate.c
>> @@ -898,6 +898,13 @@ static int software_resume(void)
>>  	error = freeze_processes();
>>  	if (error)
>>  		goto Close_Finish;
>> +
>> +	error = freeze_kernel_threads();
>> +	if (error) {
>> +		thaw_processes();
>> +		goto Close_Finish;
>> +	}
>> +
>>  	error = load_image_and_restore();
>>  	thaw_processes();
>>   Finish:
> 
> Applied as a fix for 5.7-rc4, thanks!

Hi Rafael,

What is not clear to me is how kernel threads are thawed after
load_image_and_restore() has finished? Should a comment perhaps be added
above the freeze_kernel_threads() call that explains how
thaw_kernel_threads() is invoked after load_image_and_restore() has
finished?

Thanks,

Bart.
