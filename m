Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CECEDBFEF
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 10:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632832AbfJRIar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 04:30:47 -0400
Received: from [217.140.110.172] ([217.140.110.172]:58292 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727573AbfJRIar (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 04:30:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F9EF32B;
        Fri, 18 Oct 2019 01:30:16 -0700 (PDT)
Received: from [192.168.1.103] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C62413F718;
        Fri, 18 Oct 2019 01:30:13 -0700 (PDT)
Subject: Re: [PATCH] lib/vdso: Use __arch_use_vsyscall() to indicate fallback
To:     Andy Lutomirski <luto@kernel.org>, Huacai Chen <chenhc@lemote.com>,
        Maxime Bizon <mbizon@freebox.fr>
Cc:     Thomas Gleixner <tglx@linutronix.de>, chenhuacai@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <1571367619-13573-1-git-send-email-chenhc@lemote.com>
 <CALCETrWXRgkQOJGRqa_sOLAG2zhjsEX6b86T2VTsNYN9ECRrtA@mail.gmail.com>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <6581a6e8-45c9-a80c-d2a4-33466f5712fd@arm.com>
Date:   Fri, 18 Oct 2019 09:32:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CALCETrWXRgkQOJGRqa_sOLAG2zhjsEX6b86T2VTsNYN9ECRrtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andy and Hucan,

On 10/18/19 4:15 AM, Andy Lutomirski wrote:
> On Thu, Oct 17, 2019 at 7:57 PM Huacai Chen <chenhc@lemote.com> wrote:
>>
>> In do_hres(), we currently use whether the return value of __arch_get_
>> hw_counter() is negtive to indicate fallback, but this is not a good
>> idea. Because:
>>
>> 1, ARM64 returns ULL_MAX but MIPS returns 0 when clock_mode is invalid;
>> 2, For a 64bit counter, a "negtive" value of counter is actually valid.
> 
> s/negtive/negative
> 
> What's the actual bug?  Is it that MIPS is returning 0 but the check
> is < 0?  Sounds like MIPS should get fixed.
> 

I submitted a patch for this yesterday to the MIPS maintainers [1]. The MIPS32
r1 implementation had a bug when VDSO_CLOCK_NONE was set.

The issue has been reported by Maxime Bizon who tested the fix as well.

[1] https://patchwork.kernel.org/patch/11193391/

-- 
Regards,
Vincenzo
