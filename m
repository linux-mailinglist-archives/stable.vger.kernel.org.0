Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0B476771
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfGZN2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:28:41 -0400
Received: from foss.arm.com ([217.140.110.172]:43526 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfGZN2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:28:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 738E3337;
        Fri, 26 Jul 2019 06:28:40 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5354E3F694;
        Fri, 26 Jul 2019 06:28:39 -0700 (PDT)
Subject: Re: [PATCH 1/3] arm64: perf: Mark expected switch fall-through
To:     Will Deacon <will@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20190726112716.19104-1-anders.roxell@linaro.org>
 <20190726121056.GA26088@lakrids.cambridge.arm.com>
 <20190726121354.GB26088@lakrids.cambridge.arm.com>
 <20190726122728.jhn4e6wq7rcowyi4@willie-the-truck>
 <1549fe77-367f-fee1-c09c-e429fca91051@arm.com>
 <20190726130523.ftmc2un7fwwcegrr@willie-the-truck>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <0dc7d97f-88bb-6416-d731-afbf0d3c6133@arm.com>
Date:   Fri, 26 Jul 2019 14:28:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190726130523.ftmc2un7fwwcegrr@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/07/2019 14:05, Will Deacon wrote:
> On Fri, Jul 26, 2019 at 01:38:24PM +0100, Robin Murphy wrote:
>> On 26/07/2019 13:27, Will Deacon wrote:
>>> On Fri, Jul 26, 2019 at 01:13:54PM +0100, Mark Rutland wrote:
>>>> On Fri, Jul 26, 2019 at 01:10:57PM +0100, Mark Rutland wrote:
>>>>> On Fri, Jul 26, 2019 at 01:27:16PM +0200, Anders Roxell wrote:
>>>>>> When fall-through warnings was enabled by default, commit d93512ef0f0e
>>>>>> ("Makefile: Globally enable fall-through warning"), the following
>>>>>> warnings was starting to show up:
>>>>>>
>>>>>> ../arch/arm64/kernel/hw_breakpoint.c: In function ‘hw_breakpoint_arch_parse’:
>>>>>> ../arch/arm64/kernel/hw_breakpoint.c:540:7: warning: this statement may fall
>>>>>>    through [-Wimplicit-fallthrough=]
>>>>>>       if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
>>>>>>          ^
>>>>>> ../arch/arm64/kernel/hw_breakpoint.c:542:3: note: here
>>>>>>      case 2:
>>>>>>      ^~~~
>>>>>> ../arch/arm64/kernel/hw_breakpoint.c:544:7: warning: this statement may fall
>>>>>>    through [-Wimplicit-fallthrough=]
>>>>>>       if (hw->ctrl.len == ARM_BREAKPOINT_LEN_2)
>>>>>>          ^
>>>>>> ../arch/arm64/kernel/hw_breakpoint.c:546:3: note: here
>>>>>>      default:
>>>>>>      ^~~~~~~
>>>>>>
>>>>>> Rework so that the compiler doesn't warn about fall-through. Rework so
>>>>>> the code looks like the arm code. Since the comment in the function
>>>>>> indicates taht this is supposed to behave the same way as arm32 because
>>>>>
>>>>> Typo: s/taht/that/
>>>>>
>>>>>> it handles 32-bit tasks also.
>>>>>>
>>>>>> Cc: stable@vger.kernel.org # v3.16+
>>>>>> Fixes: 6ee33c2712fc ("ARM: hw_breakpoint: correct and simplify alignment fixup code")
>>>>>> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
>>>>>
>>>>> The patch itself looks fine, but I don't think this needs a CC to
>>>>> stable, nor does it require that fixes tag, as there's no functional
>>>>> problem.
>>>>
>>>> Hmm... I now see I spoke too soon, and this is making the 1-byte
>>>> breakpoint work at a 3-byte offset.
>>>
>>> I still don't think it's quite right though, since it forbids a 2-byte
>>> watchpoint on a byte-aligned address.
>>
>> Plus, AFAICS, a 1-byte watchpoint on a 2-byte-aligned address.

[and of course, what I missed was that that's the case the fallthrough 
serves... yuck indeed]

>> Not that I know anything about this code, but it does start to look like it
>> might want rewriting without the offending switch statement anyway. At a
>> glance, it looks like the intended semantic might boil down to:
>>
>> 	if (hw->ctrl.len > offset)
>> 		return -EINVAL;
> 
> Given that it's compat code, I think it's worth staying as close to the
> arch/arm/ implementation as we can.

Right, I also misread the accompanying arch/arm/ patch and got the 
impression that 32-bit also had a problem such that any fix would happen 
in parallel - on closer inspection the current arch/arm/ code does 
actually seem to make sense, even if it is horribly subtle.

> Also, beware that the
> ARM_BREAKPOINT_LEN_* definitions are masks because of the BAS fields in
> the debug architecture.

Fun... Clearly it's a bit too Friday for me to be useful here, so 
apologies for the confusion :)

Robin.
