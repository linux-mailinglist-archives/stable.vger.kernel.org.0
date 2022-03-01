Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3929C4C8700
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 09:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiCAIrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 03:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiCAIrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 03:47:05 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0B889304;
        Tue,  1 Mar 2022 00:46:23 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.70.248])
        by gnuweeb.org (Postfix) with ESMTPSA id 135F67E2A9;
        Tue,  1 Mar 2022 08:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646124383;
        bh=CMMDcbsPaEADI+qn5JKnOaKuzR+twxl3El7gTc2i7TQ=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=Sl1qn6uNMKVysoMOQjUXxjvCufiwurgxU5tlYLN0ctSdsSIyPdm9EiflfUH19z3be
         a3cTJJ/rMZujDK+GPhFWThQCzMqnaI7dIeRnWIARJoClpUKeGIMkFWwyoswIhf+el8
         oINyj7FFdQ9NjdB60uvLyoyhhSY2G2Rp+fxmasmIG1CBIzPek1t6Tt7OdY1gC+gGxo
         kfywx86pZZMqSYF7CGHV1m6sJPbekWE3sg1JHZfJ1RGcvogJFFU0PSEQ0Mm6pb1UV7
         GsHjQNzUZAKd9POjvllX8roUIJ3wO1izXQ1ZvH0ItSiKYqZMLKtrTBXHu0c195n/tS
         oXJkgRmzX877g==
Message-ID: <0f22489a-7b93-1ed8-aa44-3fd731cf34a5@gnuweeb.org>
Date:   Tue, 1 Mar 2022 15:46:15 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org
References: <20220301073223.98236-1-ammarfaizi2@gnuweeb.org>
 <20220301073223.98236-2-ammarfaizi2@gnuweeb.org> <Yh3YyU2VVK/iaLcA@kroah.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v2 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
In-Reply-To: <Yh3YyU2VVK/iaLcA@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 3/1/22 3:26 PM, Greg KH wrote:
> On Tue, Mar 01, 2022 at 02:32:22PM +0700, Ammar Faizi wrote:
>> The asm constraint does not reflect that the asm statement can modify
>> the value of @loops. But the asm statement in delay_loop() does change
>> the @loops.
>>
>> If by any chance the compiler inlines this function, it may clobber
>> random stuff (e.g. local variable, important temporary value in reg,
>> etc.).
>>
>> Fortunately, delay_loop() is only called indirectly (so it can't
>> inline), and then the register it clobbers is %rax (which is by the
>> nature of the calling convention, it's a caller saved register), so it
>> didn't yield any bug.
>>
>> ^ That shouldn't be an excuse for using the wrong constraint anyway.
>>
>> This changes "a" (as an input) to "+a" (as an input and output).
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Fixes: e01b70ef3eb3080fecc35e15f68cd274c0a48163 ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")
> 
> You only need 12 characters here :)

Ah well, that's too verbose. Will fix it in the v4.

>> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>> ---
> 
> Why is this one not tagged for stable?

As far as I can tell, the compiler will never inline that function,
because despite the function is static, it's assigned to a global
variable and it's called indirectly via a function pointer variable,
so it can't be inline. Therefore, it will always be a function call.

Note that %eax is a call clobbered register w.r.t. System V ABI. As
such, *by luck*, this wrong constraint doesn't yield any bug.

The compiler will not assume the %eax value is the same as before the
function call is done. So the compiler isn't aware that constraint
violation. Not sure if it's worth it for backport.

x86 maintainers, any comment on this?

-- 
Ammar Faizi
