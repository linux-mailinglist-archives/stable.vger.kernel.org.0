Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C95456D3D
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 11:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhKSK3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 05:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhKSK3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 05:29:34 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E214C061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 02:26:32 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b13so7817241plg.2
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 02:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=6w55kTpau74YSZLJIa8X8+WMQwazhW/u3R2GbUt9wtk=;
        b=VvH68lZnDU9FciDyDeffiNWHhL5h/QwYLbMusRknyrnqCr9SHs4HTyPeGHcbm+qp2S
         StOmKlRXQnMcfeOrPfu3fsjVCikGtWUI30ip/aUIycMqvQjY/tzr1CEdvd4VwkCwSsIb
         2ZV8pi2W7Y4kZkCrgMIYxLz94J2iAljOo9kqsr2JSysgz46H8USbGFoDXlGKteCPtm0l
         nfVHIQCqlY9T9tTC9A3GkkG4Y3BwkP+jGhHsSLIwBDXp/8TYjQQYeSGU2d9de+5ELk0J
         2kgpMU0ayWsmuzkbY+UtZn1N4hAbwZbGgFYDOCtdadVHmHN3zDv8/lqBbjA7vqm+DJ6n
         Om6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6w55kTpau74YSZLJIa8X8+WMQwazhW/u3R2GbUt9wtk=;
        b=HSFv5yQNTPpsvww/U9aujM5CJHxHevWHvxuoEwQHrjdsNIWK/7b9NEhFj82Yw/l8NH
         KLZwIperr5k1u4OwL2lBQ4Q6YOKGP0gTsmlDuJY4DV+4gnYXvTsAetrT/bypoKLXZ6DJ
         HsMBnXp+uhp7en9lbqkX6sO2SYVN6bSqGj7PdSU5vfQPnzPOTJDTv+XHtcakvf3bwTFo
         okEkWMcF7D2NVXcz269liSWqzPGT+M0qUCKbvn0ktWiXeYoZZfG1LQe5GJxi4uSrEfYD
         vdupWJlDSt/vhGrf2cOsmYB2+EluYFtV4kDUg5qW37AmCupmmiX6NBdi01shLv7mIjmM
         PC9w==
X-Gm-Message-State: AOAM530HPGF+g+CwF8955+LpcV64ijadLwlWnMdUyirJ7UNy9VverVC+
        OCQ0i+H1GXRjBZlvGZvnUi8XhQ==
X-Google-Smtp-Source: ABdhPJzFQFeewwDICoO/AaPGt9kJGqBG9VuY4xA11XD/c9q4ffCxHcmqbf0rN6lnVUOrDj0HI0peHQ==
X-Received: by 2002:a17:902:904b:b0:143:73ff:eb7d with SMTP id w11-20020a170902904b00b0014373ffeb7dmr73509127plz.85.1637317592235;
        Fri, 19 Nov 2021 02:26:32 -0800 (PST)
Received: from [10.254.160.232] ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id d19sm2555809pfv.199.2021.11.19.02.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 02:26:31 -0800 (PST)
Message-ID: <9307b13e-e87e-1bc1-9e75-b4155d4157ca@bytedance.com>
Date:   Fri, 19 Nov 2021 18:26:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH] x86: Pin task-stack in __get_wchan()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
 <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
 <20211119020427.2y5esq2czquwmvwc@treble>
 <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
 <759cd319-990f-af23-2f1c-aba55d0768b8@bytedance.com>
 <YZd6+SFZVzTeX45f@hirez.programming.kicks-ass.net>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <YZd6+SFZVzTeX45f@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/19/21 6:22 PM, Peter Zijlstra wrote:
> On Fri, Nov 19, 2021 at 06:02:50PM +0800, Qi Zheng wrote:
> 
>> This implementation is very similar to stack_trace_save_tsk(), maybe we
>> can just move stack_trace_save_tsk() out of CONFIG_STACKTRACE and reuse
>> it.
> 
> No, we want to move away from the stack_trace_*() API because it has
> very unclear semantics and various arch implementations differ in
> details.
> 
> There's a patch that untangles arch_stack_walk*() from CONFIG_STACKTRACE
> and we can eventually use that.
> 

Got it.

-- 
Thanks,
Qi
