Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE486574F8C
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 15:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239537AbiGNNrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 09:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239382AbiGNNrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 09:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8785852FC9
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 06:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+awr3ZhBs5ChFhOgpPkaLATcx5cLB7nHdpf6QXxPxMY=;
        b=PPBF2Gs3BACqWjwRUIcGHL3jOFStnAQ+CzLuB+Xc8R+twAT7uKE/vCDKgQexZPBF1Z5y+d
        yKMS1+za6R4wuFF0uoWmOlD/iXUaRFpNJ+xuf6KcvdLwJPTOqQAvYXbvCUbD5pjJ/jltXk
        yQDs43ZZjXVYE0CxM/cgmwlBTci8iuA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-jIAOfKdhPHWtI73qMDaJtQ-1; Thu, 14 Jul 2022 09:46:58 -0400
X-MC-Unique: jIAOfKdhPHWtI73qMDaJtQ-1
Received: by mail-ej1-f71.google.com with SMTP id qb28-20020a1709077e9c00b0072af6ccc1aeso778822ejc.6
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 06:46:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+awr3ZhBs5ChFhOgpPkaLATcx5cLB7nHdpf6QXxPxMY=;
        b=b6zMRdmnLxwUcFg9QHAHVIEsOQqup4lrn0fEdbvA0iPubk/PLhKbP68hp947wYKZ7u
         ZLTs5ytYeh1dQLGKEMnKs+gZ6nKzQl6ueWNMGXnpYJIUxwsSM6lACR5SgPo729cSafQP
         ZYeNxX+CcsladdfRV9BOTEirmVnsayz1b8anrhpqSxXWkNDt5ejUwQBc7Z6yBD01xvcL
         PHLf06qtan2CEYLekR/Qk1ODK0CWQePePc90bYJc0WU+AxEMIqnzt6rwIYv/JOD+rqin
         7RSU0Qgxe2RPgC0n7BlMoMNagzP/T7tpBJFJ0m9ghJRJLgrQSpOXqqaLjDiqyaeRizwG
         x2WA==
X-Gm-Message-State: AJIora/d8x3QcawtUTJHIl/DkeYe9hzrFyqB4wG2QcXAl3fSrgyHnYk9
        kSu+++leJcVH3ucatqhCAnOBqfzHXePs3cqYVMWY+Spp3t82T9XD6KzC3DXiTT0Sag7IDBQ8Waq
        Jwmq7FArqgYXfycPb
X-Received: by 2002:a17:907:1c8c:b0:72b:6b8f:4add with SMTP id nb12-20020a1709071c8c00b0072b6b8f4addmr8917274ejc.556.1657806417355;
        Thu, 14 Jul 2022 06:46:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sLM5Xyg7JtYTCIQNuUJMLYhlONllSjxPkuyV7k114ks5G16n5o0fFDxAMDpk1LxZB8rtufpA==
X-Received: by 2002:a17:907:1c8c:b0:72b:6b8f:4add with SMTP id nb12-20020a1709071c8c00b0072b6b8f4addmr8917259ejc.556.1657806417122;
        Thu, 14 Jul 2022 06:46:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id r14-20020aa7cfce000000b0043a4de1d421sm1072680edy.84.2022.07.14.06.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 06:46:56 -0700 (PDT)
Message-ID: <6b4337f4-d1de-7ba3-14e8-3ad0f9b18788@redhat.com>
Date:   Thu, 14 Jul 2022 15:46:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
References: <20220712183238.844813653@linuxfoundation.org>
 <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net>
 <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/14/22 11:01, Borislav Petkov wrote:
> On Wed, Jul 13, 2022 at 11:40:03AM -0700, Linus Torvalds wrote:
>> And I see that Thadeau already figured it out:
>>
>>    https://lore.kernel.org/all/20220713171241.184026-1-cascardo@canonical.com/
>>
>> So presumably we need that patch everywhere.
> Right, I've queued it along with other fallout fixes. Will do some
> testing before I send them to you on Sunday.
> 
> I'm guessing you're thinking of cutting an -rc7 so that people can test
> the whole retbleed mitigation disaster an additional week?

Please leave that one out as Peter suggested a better fix and I have 
that queued for Linus.

(If you don't no big deal, the conflict will be very clear, but it will 
be a bit more work for everyone).

Paolo

