Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF48BA727F
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfICSUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:20:25 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38774 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbfICSUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:20:24 -0400
Received: by mail-lj1-f194.google.com with SMTP id h3so10200504ljb.5
        for <stable@vger.kernel.org>; Tue, 03 Sep 2019 11:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xeDPsVi2bfuyrB9HeWleFSg6tMOiXB+MS15onZTug3o=;
        b=sklOjv6aMzArD1+i+OXvgYcAde34Ci9vVVWg9ymVo2wh1zuCHzJENSRnkgBdZ+LCvZ
         hvrq79ETZ38UJkAyB8iDNF5pIWbQV/SVDhW3xrtfq45d6bp16t5kcGp9BSgijV7QArCa
         zE8hoPMG6XqTOjMfM+MpbP2nXbRFhE0uCp2jROZk0IKMmLk8HNXG7zXS/jK/bW+i06Bw
         h0Ut3cda5zUIYxDxrZpItFSWcld4obY3KUKO3FGX4x7Ww0t95BgHW3PJYDAyHXvTKpx+
         6T1bivKpXlGa3dioKFEV+MxPFs4ENU/ODsgbBnHLPJLXnBGyVNoKhRT458LEDLL6Mf+d
         CmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xeDPsVi2bfuyrB9HeWleFSg6tMOiXB+MS15onZTug3o=;
        b=cn4wy7Tl2sbAtAk4mzSMxA5vfquD/WlomWTYQmMSPIuz07zG4s90R0FB5jMbgP+qwJ
         7wRRhdYi/eRIWP6yq9wVagRP8nTltSn9JfY6PbToUsAsjje81iwBaxh5Q5Q+4O6qSwAj
         9I+AnRNmSx7YVCLeH5Ae012xlrqlagXIhq+s+ljZPe8WRTv0pQ/wHPAdY6TlIqkewMN7
         t04odQy1g2SxRYnWbxYyKh6NuPOOE4LKaaBEdFrvRzvoTRwhuylFJbESdg7o6GIjlq+C
         HD5/ELb12Fy7kHKvCwkh1VO41vLAfmrGgF3SYxwtithxDgiZRn534BqwghCzqWu8mONv
         UT8w==
X-Gm-Message-State: APjAAAXU2qgcpbWtM/VU+ydnm2zoGVQN1YUd6yh6t89ogk74W0toSME3
        +8dERSzb2Zuy0MOJDfeddhU4f1yaH2s=
X-Google-Smtp-Source: APXvYqw3bQVimEpbaffXNv3XCvGf59hX1/+DXJvHaFMIvuMa52Hs5YFekjaG1J5eyhHritoIQap6Ug==
X-Received: by 2002:a2e:9148:: with SMTP id q8mr14334179ljg.31.1567534821662;
        Tue, 03 Sep 2019 11:20:21 -0700 (PDT)
Received: from [84.217.173.115] (c-8caed954.51034-0-757473696b74.bbcust.telenor.se. [84.217.173.115])
        by smtp.gmail.com with ESMTPSA id m10sm1447984lfo.69.2019.09.03.11.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 11:20:21 -0700 (PDT)
Subject: Re: [BUG] Early OOM and kernel NULL pointer dereference in 4.19.69
To:     Michal Hocko <mhocko@kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc:     linux-mm@kvack.org, stable@vger.kernel.org
References: <31131c2d-a936-8bbf-e58d-a3baaa457340@gmail.com>
 <20190902071617.GC14028@dhcp22.suse.cz>
 <a07da432-1fc1-67de-ae35-93f157bf9a7d@gmail.com>
 <20190903074132.GM14028@dhcp22.suse.cz>
 <84c47d16-ff5a-9af0-efd4-5ef78d302170@virtuozzo.com>
 <20190903122221.GV14028@dhcp22.suse.cz>
From:   Thomas Lindroth <thomas.lindroth@gmail.com>
Message-ID: <c8c3effe-753c-ce1d-60f4-7d6ff2845074@gmail.com>
Date:   Tue, 3 Sep 2019 20:20:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903122221.GV14028@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/3/19 2:22 PM, Michal Hocko wrote:
> On Tue 03-09-19 15:05:22, Andrey Ryabinin wrote:
>>
>>
>> On 9/3/19 10:41 AM, Michal Hocko wrote:
>>> On Mon 02-09-19 21:34:29, Thomas Lindroth wrote:
>>>> On 9/2/19 9:16 AM, Michal Hocko wrote:
>>>>> On Sun 01-09-19 22:43:05, Thomas Lindroth wrote:
>>>>>> After upgrading to the 4.19 series I've started getting problems with
>>>>>> early OOM.
>>>>>
>>>>> What is the kenrel you have updated from? Would it be possible to try
>>>>> the current Linus' tree?
>>>>
>>>> I did some more testing and it turns out this is not a regression after all.
>>>>
>>>> I followed up on my hunch and monitored memory.kmem.max_usage_in_bytes while
>>>> running cgexec -g memory:12G bash -c 'find / -xdev -type f -print0 | \
>>>>          xargs -0 -n 1 -P 8 stat > /dev/null'
>>>>
>>>> Just as memory.kmem.max_usage_in_bytes = memory.kmem.limit_in_bytes the OOM
>>>> killer kicked in and killed my X server.
>>>>
>>>> Using the find|stat approach it was easy to test the problem in a testing VM.
>>>> I was able to reproduce the problem in all these kernels:
>>>>    4.9.0
>>>>    4.14.0
>>>>    4.14.115
>>>>    4.19.0
>>>>    5.2.11
>>>>
>>>> 5.3-rc6 didn't build in the VM. The build environment is too old probably.
>>>>
>>>> I was curious why I initially couldn't reproduce the problem in 4.14 by
>>>> building chromium. I was again able to successfully build chromium using
>>>> 4.14.115. Turns out memory.kmem.max_usage_in_bytes was 1015689216 after
>>>> building and my limit is set to 1073741824. I guess some unrelated change in
>>>> memory management raised that slightly for 4.19 triggering the problem.
>>>>
>>>> If you want to reproduce for yourself here are the steps:
>>>> 1. build any kernel above 4.9 using something like my .config
>>>> 2. setup a v1 memory cgroup with memory.kmem.limit_in_bytes lower than
>>>>     memory.limit_in_bytes. I used 100M in my testing VM.
>>>> 3. Run "find / -xdev -type f -print0 | xargs -0 -n 1 -P 8 stat > /dev/null"
>>>>     in the cgroup.
>>>> 4. Assuming there is enough inodes on the rootfs the global OOM killer
>>>>     should kick in when memory.kmem.max_usage_in_bytes =
>>>>     memory.kmem.limit_in_bytes and kill something outside the cgroup.
>>>
>>> This is certainly a bug. Is this still an OOM triggered from
>>> pagefault_out_of_memory? Since 4.19 (29ef680ae7c21) the memcg charge
>>> path should invoke the memcg oom killer directly from the charge path.
>>> If that doesn't happen then the failing charge is either GFP_NOFS or a
>>> large allocation.
>>>
>>> The former has been fixed just recently by http://lkml.kernel.org/r/cbe54ed1-b6ba-a056-8899-2dc42526371d@i-love.sakura.ne.jp
>>> and I suspect this is a fix you are looking for. Although it is curious
>>> that you can see a global oom even before because the charge path would
>>> mark an oom situation even for NOFS context and it should trigger the
>>> memcg oom killer on the way out from the page fault path. So essentially
>>> the same call trace except the oom killer should be constrained to the
>>> memcg context.
>>>
>>> Could you try the above patch please?
>>>
>>
>> It won't help. We hitting ->kmem limit here, not the ->memory or ->memsw, so try_charge() is successful and
>> only __memcg_kmem_charge_memcg() fails to charge ->kmem and returns -ENOMEM.
>>
>> Limiting kmem just never worked and it doesn't work now. AFAIK this feature hasn't been finished because
>> there was no clear purpose/use case found. I remember that there was some discussion on lsfmm about this https://lwn.net/Articles/636331/
>> but I don't remember the discussion itself.
> 
> Ohh, right you are. I completely forgot that __memcg_kmem_charge_memcg
> doesn't really trigger the normal charge path but rather charge the
> counter directly.
> 
> So you are right. The v1 kmem accounting is broken and probably
> unfixable. Do not use it.

I don't know why I setup a kmem limit. I think the documentation I followed
when setting up the cgroup said that kmem is counted separately from the
regular memory limit so if you want to limit total memory you have to limit
both. That's what I did.

If kmem accounting is both broken, unfixable and cause kernel crashes when
used why not remove it? Or perhaps disable it per default like
cgroup.memory=nokmem or at least print a warning to dmesg if the user tries
to user it in a way that cause crashes?
