Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F580456CF5
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 11:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhKSKGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 05:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhKSKGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 05:06:01 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFA4C06173E
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 02:02:59 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id q17so7727186plr.11
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 02:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=OXsBApL347OT9MITky6gwOe2SpOPkEu0t/lMDuUut9o=;
        b=Fto+KToKTKcXYoGIFqbniumi8NWDhK4r05GXOQNCbmfCYBn3qBIrbhgCfFSPQFt0TK
         7YwNv2FgzPjyKxquxAmM0goTWtO2UDUCnGck7I7tApWfSkOVzV4zETOarfiKguChbvn1
         SbEnSzb5PQ3h+4jeE2W5R5oyCZJCI1jcxPrNI7eXCec31OCOPclr2FKvSIU/PnTAYSU0
         HsKZdrcJos8p5Dzu/kpxKvYipOu3ZoCqtazecuMDx2JZ7b+qW6iSwVQ6ZC2bgbafsJHg
         qI88bqELzcoPWdtJfX5jB1WRRGxEQnzjcxzhYMYjNXcKpL8T55rtLE95WCNvQPRKXyHW
         +3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OXsBApL347OT9MITky6gwOe2SpOPkEu0t/lMDuUut9o=;
        b=mukG0x2mNPG1vtMYHjvIkoygAnuFqy0NuN3UpvEKvVO5PPQXk36LStrUb5fhcIgOox
         fWyM4IGqVM8ekBdbQXkIo3dsCuiTPJ/sBze5ZVu9VylnRB7gMQW3/dPdw0TAf/c6I1ZV
         V5st2YxiMZ8mr2/3m1NmH71vXoxsz2VotpnYFE1fE5QBv3P5T/LF18q9kJlhzRFxY07U
         bGrAGnL3N6aDl0tOFKZds+VGm6Jcky2rakgj17L51TIPDAWcC8iBp2f76qBoluiMdKDy
         B8+A/h1oqIejW0Y/e1kMGPIXzjtwMXOaOx5d3g0GGCZkDZCICcU1omQT/jA06CVfwnk2
         LuFQ==
X-Gm-Message-State: AOAM531kJrVckGfFy/fH/vN1UeESGxESumpikKe5h/IY/aRuYgdsmhd9
        9iC5aul7twI36NIDwDVuzhFnCw==
X-Google-Smtp-Source: ABdhPJzi8dCLjKdDLfTsmIlQmM/ZsBMUCzIScvlCizvP7Hugl34kJmtBt6SS+soYCowNpm5bZW9+Tg==
X-Received: by 2002:a17:903:124e:b0:143:a388:a5de with SMTP id u14-20020a170903124e00b00143a388a5demr75140214plh.73.1637316179324;
        Fri, 19 Nov 2021 02:02:59 -0800 (PST)
Received: from [10.254.160.232] ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id d2sm2335587pfu.203.2021.11.19.02.02.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 02:02:58 -0800 (PST)
Message-ID: <759cd319-990f-af23-2f1c-aba55d0768b8@bytedance.com>
Date:   Fri, 19 Nov 2021 18:02:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH] x86: Pin task-stack in __get_wchan()
To:     Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Holger Hoffst??tte <holger@applied-asynchrony.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
 <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
 <20211119020427.2y5esq2czquwmvwc@treble>
 <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/19/21 5:29 PM, Peter Zijlstra wrote:
> On Thu, Nov 18, 2021 at 06:04:27PM -0800, Josh Poimboeuf wrote:
>> On Thu, Nov 18, 2021 at 01:11:09PM +0100, Peter Zijlstra wrote:
> 
>>> I now have the below, the only thing missing is that there's a
>>> user_mode() call on a stack based regs. Now on x86_64 we can
>>> __get_kernel_nofault() regs->cs and call it a day, but on i386 we have
>>> to also fetch regs->flags.
>>>
>>> Is this really the way to go?
>>
>> Please no.  Can we just add a check in unwind_start() to ensure the
>> caller did try_get_task_stack()?
> 
> I tried; but at best it's fundamentally racy and in practise its worse
> because init_task doesn't seem to believe in refcounts and kthreads are
> odd for some raisin. Now those are fixable, but given the fundamental
> races, I don't see how it's ever going to be reliable.
> 
> I don't mind the __get_kernel_nofault() usage and think I can do a
> better implementation that will allow us to get rid of the
> pagefault_{dis,en}able() sprinkling, but that's for another day. It's
> just the user_mode(regs) usage that's going to be somewhat ugleh.
> 
> Anyway, below is the minimal fix for the situation at hand. I'm not
> going to be around much today, so if Linus wants to pick that up instead
> of mass revert things that's obviously fine too.
> 
> ---
> Subject: x86: Pin task-stack in __get_wchan()
> 
> When commit 5d1ceb3969b6 ("x86: Fix __get_wchan() for !STACKTRACE")
> moved from stacktrace to native unwind_*() usage, the
> try_get_task_stack() got lost, leading to use-after-free issues for
> dying tasks.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>   arch/x86/kernel/process.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index e9ee8b526319..04143a653a8a 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -964,6 +964,9 @@ unsigned long __get_wchan(struct task_struct *p)
>   	struct unwind_state state;
>   	unsigned long addr = 0;
>   
> +	if (!try_get_task_stack(p))
> +		return 0;
> +
>   	for (unwind_start(&state, p, NULL, NULL); !unwind_done(&state);
>   	     unwind_next_frame(&state)) {
>   		addr = unwind_get_return_address(&state);
> @@ -974,6 +977,8 @@ unsigned long __get_wchan(struct task_struct *p)
>   		break;
>   	}
>   
> +	put_task_stack(p);
> +
>   	return addr;
>   }
>   
> 

This implementation is very similar to stack_trace_save_tsk(), maybe we
can just move stack_trace_save_tsk() out of CONFIG_STACKTRACE and reuse
it.

-- 
Thanks,
Qi
