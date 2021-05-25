Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A471390692
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 18:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhEYQZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 12:25:22 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:40861 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhEYQZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 12:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1621959833; x=1653495833;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=gNkgT7v0n5SRnIwXSrhTCQhmJu1ThQ+fRnMHpu+sBOs=;
  b=UAvuqP6mEGjXTl76TxxKDzhRPlgjzH3P98MN13FUmXisupaPaWTz16vf
   5a+zFic4brhl/LOQyi9kNQDkVxdPXf9Te4auxUVYWucmtnfIgikQjiJHm
   OF7DF/Qw+zLNQdzuaGupUbQNgfjSZ+x5atM3YL0JUjyWOisNeCWwIyhxf
   k=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 25 May 2021 09:23:52 -0700
X-QCInternal: smtphost
Received: from nalasexr03e.na.qualcomm.com ([10.49.195.114])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 25 May 2021 09:23:51 -0700
Received: from [10.226.59.216] (10.80.80.8) by nalasexr03e.na.qualcomm.com
 (10.49.195.114) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 25 May
 2021 09:23:50 -0700
Subject: Re: [PATCH 5.10 002/299] bus: mhi: core: Clear configuration from
 channel context during reset
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>
CC:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102004.900838842@linuxfoundation.org> <20210510205650.GA17966@amd>
 <20210511061623.GA8651@thinkpad>
 <64a8ebbdc9fc7de48b25b9e2bc896d47@codeaurora.org>
 <20210524041947.GB8823@work>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
Message-ID: <011231f6-f6be-8bf4-f4f0-5e52764101e6@quicinc.com>
Date:   Tue, 25 May 2021 10:23:49 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210524041947.GB8823@work>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanexm03g.na.qualcomm.com (10.85.0.49) To
 nalasexr03e.na.qualcomm.com (10.49.195.114)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/2021 10:19 PM, Manivannan Sadhasivam wrote:
> On Fri, May 21, 2021 at 10:50:33AM -0700, Bhaumik Bhatt wrote:
>> On 2021-05-10 11:17 PM, Manivannan Sadhasivam wrote:
>>> Hi Pavel,
>>>
>>> On Mon, May 10, 2021 at 10:56:50PM +0200, Pavel Machek wrote:
>>>> Hi!
>>>>
>>>>> From: Bhaumik Bhatt <bbhatt@codeaurora.org>
>>>>>
>>>>> commit 47705c08465931923e2f2b506986ca0bdf80380d upstream.
>>>>>
>>>>> When clearing up the channel context after client drivers are
>>>>> done using channels, the configuration is currently not being
>>>>> reset entirely. Ensure this is done to appropriately handle
>>>>> issues where clients unaware of the context state end up calling
>>>>> functions which expect a context.
>>>>
>>>>> +++ b/drivers/bus/mhi/core/init.c
>>>>> @@ -544,6 +544,7 @@ void mhi_deinit_chan_ctxt(struct mhi_con
>>>>> +	u32 tmp;
>>>>> @@ -554,7 +555,19 @@ void mhi_deinit_chan_ctxt(struct mhi_con
>>>> ...
>>>>> +	tmp = chan_ctxt->chcfg;
>>>>> +	tmp &= ~CHAN_CTX_CHSTATE_MASK;
>>>>> +	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
>>>>> +	chan_ctxt->chcfg = tmp;
>>>>> +
>>>>> +	/* Update to all cores */
>>>>> +	smp_wmb();
>>>>>   }
>>>>
>>>> This is really interesting code; author was careful to make sure chcfg
>>>> is updated atomically, but C compiler is free to undo that. Plus, this
>>>> will make all kinds of checkers angry.
>>>>
>>>> Does the file need to use READ_ONCE and WRITE_ONCE?
>>>>
>>>
>>> Thanks for looking into this.
>>>
>>> I agree that the order could be mangled between chcfg read & write and
>>> using READ_ONCE & WRITE_ONCE seems to be a good option.
>>>
>>> Bhaumik, can you please submit a patch and tag stable?
>>>
>>> Thanks,
>>> Mani
>>>
>>>> Best regards,
>>>> 								Pavel
>>>> --
>>>> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
>>>> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
>>
>> Hi Pavel/Mani,
>>
>> Hemant and I went over this patch and we noticed this particular function is
>> already being called with the channel mutex lock held. This would take care
>> of
>> the atomicity and we also probably don't need the smp_wmb() barrier as the
>> mutex
>> unlock will implicitly take care of it.
>>
> 
> okay
> 
>> To the point of compiler re-ordering, we would need some help to understand
>> the
>> purpose of READ_ONCE()/WRITE_ONCE() for these dependent statements:
>>
>>> +	tmp = chan_ctxt->chcfg;
>>> +	tmp &= ~CHAN_CTX_CHSTATE_MASK;
>>> +	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
>>> +	chan_ctxt->chcfg = tmp;
>>
>> Since RMW operation means that the chan_ctxt->chcfg is copied to a local
>> variable (tmp) and the _same_ is being written back to chan_ctxt->chcfg, can
>> compiler reorder these dependent statements and cause a different result?
>>
> 
> Well, I agree that there is a minimal guarantee with modern day CPUs on
> not breaking the order of dependent memory accesses (like here tmp
> variable is the one which gets read and written) but we want to make
> sure that this won't break on future CPUs as well. So IMO using
> READ_ONCE and WRITE_ONCE adds extra level of safety.

?

I'm sorry, but this argument is non-sense to me, and so I want to 
understand more.

I've talked to our CPU designers from time to time, but cannot speak for 
other vendors.  A modern CPU can easily reorder accesses all it wants, 
so long as it does not change the end result.  This is typically 
identified via "data dependencies", where the CPU identifies that the 
result of a previous instruction is required to be known before 
processing the current instruction (or any instructions in flight in the 
pipeline, the instructions don't need to be adjacent).  These data 
dependencies can be "read" or "write".

The typical reason barriers are needed is because the CPU cannot detect 
these dependencies when we are talking about different "memory".  For 
example, a write to a register in some hardware block to program some 
mode, and then a write to another register to activate the hardware 
block based on that mode.  In this example, there is no data dependency 
that the CPU can detect, although you and I as the software writer knows 
there is a specific order to these operations.  Thus, a barrier is required.

Your argument is that we need to protect against some hypothetical 
future CPU where these data dependencies are ignored, and so the CPU 
reorders things.  Except that means that the end result is (possibly) 
changed, meaning the contract between software and hardware is no longer 
valid.  It breaks the entire memory model for the C language.

In the above code snippet, you are saying this is valid for some future 
CPU to do:

tmp = chan_ctxt->chcfg;
chan_ctxt->chcfg = tmp; //probably optimized out because this now 
obviously has no effect
tmp &= ~CHAN_CTX_CHSTATE_MASK;
tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);

That is clearly wrong (I seriously hope you agree), and while I've seen 
hardware designers do some boneheaded things to the point where I don't 
trust them a lot of the time, I have a hard time believing they would 
think that is acceptable.

That fundamentally breaks all of software to the point where the only 
recourse is to have a literal barrier between every line of code.  That 
doubles the line count of Linux and kills all performance.  Its plainly 
not tenable.

So, seriously, please explain your view in great detail because it feels 
like we are talking past each-other and not coming to common ground.  As 
I understand it, adding an explicit barrier in a patch cannot be done 
"just because" and requires a good documented reason (in a comment next 
to the barrier) for why the barrier is required.  It seems like the same 
level of scrutiny should be applied for READ_ONCE/WRITE_ONCE, but your 
reason for adding them, "using READ_ONCE and WRITE_ONCE adds extra level 
of safety", reads like the reason to use them is "just because" to me.
