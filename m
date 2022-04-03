Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C44F0B7D
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 19:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348690AbiDCRNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 13:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiDCRNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 13:13:37 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8496344D2;
        Sun,  3 Apr 2022 10:11:42 -0700 (PDT)
Received: from [192.168.148.80] (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id AB1367E312;
        Sun,  3 Apr 2022 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649005901;
        bh=1rC6UHt0mHextJbrBjiOVj+mspQiXUc+hY7TYceWF9w=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=SUYqG/yl9vJAQyJZf1pDM93sT7CGNqHRaq/BR0J9H350N4KFqlF4GeIq89LxMjZv7
         4vAxcSqQtFTBDyR5Ja+2TxP7xLYknukDns160e8kQUbOMWvW/rwm/F9Tg1K0j4sQhY
         x3QqFyuD4ZDm7xTSLSZWLCvTQaT5A2SG7yzX5/Ocz9jxapf857FMkgcRKQqwDkUI6j
         oTfbb3iqdpzTQ7T91/nMO+NfQkuLKwgfMjj3MUlAolNnAK63On/JEpgHDCjN9TY+Tn
         wVEntNBZjd521CNnEg1/iq58GSBZMmgl2+m0wUBS+kN6bN7WXPsDudumeFV3zO+Kkf
         DIcOpuZ9o3WRQ==
Message-ID: <3ceb39a4-f592-68b6-b5e7-a33a2b33a402@gnuweeb.org>
Date:   Mon, 4 Apr 2022 00:11:31 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86 Mailing List <x86@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jiri Hladky <hladky.jiri@googlemail.com>
References: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
 <20220329104705.65256-2-ammarfaizi2@gnuweeb.org> <87zgl2ksu3.ffs@tglx>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v6 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
In-Reply-To: <87zgl2ksu3.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/22 11:57 PM, Thomas Gleixner wrote:
> On Tue, Mar 29 2022 at 17:47, Ammar Faizi wrote:
>> The asm constraint does not reflect that the asm statement can modify
>> the value of @loops. But the asm statement in delay_loop() does modify
>> the @loops.
>>
>> Specifiying the wrong constraint may lead to undefined behavior, it may
>> clobber random stuff (e.g. local variable, important temporary value in
>> regs, etc.). This is especially dangerous when the compiler decides to
>> inline the function and since it doesn't know that the value gets
>> modified, it might decide to use it from a register directly without
>> reloading it.
>>
>> Fix this by changing the constraint from "a" (as an input) to "+a" (as
>> an input and output).
> 
> This analysis is plain wrong. The assembly code operates on a register
> and not on memory:



> 	asm volatile(
> 		"	test %0,%0	\n"
> 		"	jz 3f		\n"
> 		"	jmp 1f		\n"
> 
> 		".align 16		\n"
> 		"1:	jmp 2f		\n"
> 
> 		".align 16		\n"
> 		"2:	dec %0		\n"
> 		"	jnz 2b		\n"
> 		"3:	dec %0		\n"
> 
> 		: /* we don't need output */
> ---->		:"a" (loops)
> 
> This tells the compiler to use [RE]AX and initialize it from the
> variable 'loops'. It's never written back because all '%0' in the above
> assembly are substituted with [RE]AX. This also tells the compiler that
> the inline assembly clobbers [RE]AX and that's all it needs to know.

Hi Thomas,

Thanks for taking a look. I doubt about your sentence "This also tells
the compiler that the inline assembly clobbers [RE]AX".

How come it tells the compiler that the inline ASM clobbers [RE]AX?

That's an input constraint. Doesn't that mean it is read-only for the
ASM statement? That means the compiler is allowed to assume [RE]AX doesn't
change inside the ASM statement.

Those `dec`s do really change the [RE]AX. Please review this again.

Thanks!

-- 
Ammar Faizi
