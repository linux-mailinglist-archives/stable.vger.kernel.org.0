Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4894A553C
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 03:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiBACaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 21:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiBACaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 21:30:00 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E61DC061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 18:30:00 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o11so15766180pjf.0
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 18:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xmfGKqYtzWsPy/dkw6dTcGzoX4wzAb5Lhsp0fn6Ogp0=;
        b=PutUrgbuAS6jGnHuyoS43e0d26xBa+2999PsalMAgAufn8ugKhtGK32Z69LsZ2/C/Z
         H0bZTr6T/SJAxzAnKMssXSe50wyYpNozMlKUVOzy1FmQLyLc92MZ9Rd8HlchSN5IntOk
         ko4jlLO5xy6e9owkzjDwNRTmlcj7H6PlwfPQ9Qo4BRE09XN5sG3jrYbeDhor8Tr7DOLo
         QoC3cQ1I1SkndCOkNP8+W5VR4HhhwzAyMCjx3u06K2Zlfu6cqSLrM6QLhznAY00Xev4D
         bBAdUszvgSzbVDYt3zU53dlt7pdoy8JToFuTyjy4OxngMyWLBdNGr7QrPQ+lcBCxh7vP
         36vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xmfGKqYtzWsPy/dkw6dTcGzoX4wzAb5Lhsp0fn6Ogp0=;
        b=fRHJUm6Uxqk/mUQYgKEXtd+BIqdF0vSAnGF5R0/3+vcozsRrtBMuCxY4H2YpyRbfN/
         gJraHuMP5Ki3dBEvIaI7QEAgMDAEHddpK7rZmZJtF/Ip/Hmryos0ldRlUErs8VfxOogN
         X9GTV96p7RmMhnGdGrGosTR7oCJObbLetTxJqah5zpXH+k/hns8b/x1IXQAmFy5DcCkC
         4ldUPyNQwnyVja+4kRn8B1SnkUfml4hhW4mn2pzHAUEjfbMrOCFbLF4KYrab31LzPzEF
         NUffptf9FPbjCbkkWBC8+mhMvWuR80iPARa6SaOsyk07jtgumatvPCZNHj8EZbGhjCwp
         PYHw==
X-Gm-Message-State: AOAM531Sde+C4fulHj4+dRWVElPuehLlMH2eleylRz+w6xv7wDVMgmdb
        H2Jo9+hBDjSjrEFZcvEH+TWLAA==
X-Google-Smtp-Source: ABdhPJyXUF38Av70PFGRTiF0fy4mJeKySQJ7hut4SIKM6U3SRHCyBJw2/+Z8cFb297hCvXgU25zXeg==
X-Received: by 2002:a17:90b:4d0e:: with SMTP id mw14mr24963812pjb.133.1643682599630;
        Mon, 31 Jan 2022 18:29:59 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id b13sm19161302pfm.27.2022.01.31.18.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 18:29:59 -0800 (PST)
Message-ID: <3789ab35-6ede-34e8-b2d0-f50f4e0f1f15@linaro.org>
Date:   Mon, 31 Jan 2022 18:29:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RESEND] KVM: x86/mmu: fix UAF in
 paging_update_accessed_dirty_bits
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
References: <20220124172633.103323-1-tadeusz.struk@linaro.org>
 <6fd96538-b767-41e8-0cca-5b9be1dbb1c9@redhat.com>
 <Ye7wCbRpcbU2G4qH@google.com>
 <a806f5e1-9247-679c-4990-0bbf6c8de9d9@linaro.org>
 <YfB7KWFNMvo0FkCO@google.com> <YfiIxK36yD5pQgu3@google.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <YfiIxK36yD5pQgu3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/31/22 17:11, Sean Christopherson wrote:
> On Tue, Jan 25, 2022, Sean Christopherson wrote:
>> On Mon, Jan 24, 2022, Tadeusz Struk wrote:
>>> On 1/24/22 10:29, Sean Christopherson wrote:
>>>> On Mon, Jan 24, 2022, Paolo Bonzini wrote:
>>>>> On 1/24/22 18:26, Tadeusz Struk wrote:
>>>>>> Syzbot reported an use-after-free bug in update_accessed_dirty_bits().
>>>>>> Fix this by checking if the memremap'ed pointer is still valid.
>>>>> access_ok only checks that the pointer is in the userspace range.  Is this
>>>>> correct?  And if so, what are the exact circumstances in which access_ok
>>>>> returns a non-NULL but also non-userspace address?
>>>> I "objected" to this patch in its initial posting[*].  AFAICT adding access_ok()
>>>> is just masking a more egregious bug where interpretation of vm_pgoff as a PFN
>>>> base is flat out wrong except for select backing stores that use VM_PFNMAP.  In
>>>> other words, the vm_pgoff hack works for the /dev/mem use case, but it is wrong
>>>> in general.
>>>>
>>>
>>> The issue here is not related to /dev/mem, but binder allocated memory, which is
>>> yet another special mapping use case. In this case the condition
>>>
>>> if (!vma || !(vma->vm_flags & VM_PFNMAP))
>>>
>>> doesn't cover this special mappings. Adding the access_ok() was my something
>>> that fixed the use-after-free issue for me, and since I didn't have anything
>>> better I thought I will send an RFC to start some discussion.
>>> After some more debugging I came up with the bellow.
>>> Will that be more acceptable?
>>
>> I'm pretty sure anything that keeps the vm_pgoff "logic" is a band-aid.  But I'm 99%
>> sure we can simply do cmpxchg directly on the user address, we just need to get
>> support for that, which has happily been posted[*].  I'll give that a shot tomorrow,
>> I want to convert similar code in the emulator, it'd be very nice to purge all of
>> this crud.
>>
>> [*] https://lore.kernel.org/all/20220120160822.852009966@infradead.org
> 
> Posted a series and belatedly realized my script didn't pick up Debugged-by: to Cc
> you :-/  Let me know if you want me to forward any/all of the series to you.
> 
> https://lore.kernel.org/all/20220201010838.1494405-1-seanjc@google.com

It's fine, I can follow up using the link you sent.
I will try it tomorrow and let you know.

-- 
Thanks,
Tadeusz
