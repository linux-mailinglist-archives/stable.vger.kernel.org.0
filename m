Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4383338D
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 17:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfFCPau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 11:30:50 -0400
Received: from foss.arm.com ([217.140.101.70]:53096 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfFCPau (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 11:30:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A80CD80D;
        Mon,  3 Jun 2019 08:30:49 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C4453F246;
        Mon,  3 Jun 2019 08:30:47 -0700 (PDT)
Subject: Re: [PATCH] arm: fix using smp_processor_id() in preemptible context
To:     gaoyongliang <gaoyongliang@huawei.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "punitagrawal@gmail.com" <punitagrawal@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Chenjie (K)" <chenjie6@huawei.com>,
        Nixiaoming <nixiaoming@huawei.com>,
        Zengweilin <zengweilin@huawei.com>,
        Shiwenlu <shiwenlu@huawei.com>
References: <d003bd4642aa44e1a51b83cd0bf1f04e@huawei.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
Organization: ARM Ltd
Message-ID: <a66ef5b9-19d0-2c02-8d1b-7e9c90067a76@arm.com>
Date:   Mon, 3 Jun 2019 16:30:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <d003bd4642aa44e1a51b83cd0bf1f04e@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/06/2019 15:44, gaoyongliang wrote:
> Hi Marc,
> 
> On 2019/6/3 18:17, Marc Zyngier wrote:
>> On 27/05/2019 10:39, Yongliang Gao wrote:
>>> harden_branch_predictor() call smp_processor_id() in preemptible
>>> context, this would cause a bug messages.
>>>
>>> The bug messages is as follows:
>>> BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor0/17992
>>> caller is harden_branch_predictor arch/arm/include/asm/system_misc.h:27 [inline]
>>> caller is __do_user_fault+0x34/0x114 arch/arm/mm/fault.c:200
>>> CPU: 1 PID: 17992 Comm: syz-executor0 Tainted: G O 4.4.176 #1
>>> Hardware name: Hisilicon A9
>>> [<c0114ae4>] (unwind_backtrace) from [<c010e6fc>] (show_stack+0x18/0x1c)
>>> [<c010e6fc>] (show_stack) from [<c0379514>] (dump_stack+0xc8/0x118)
>>> [<c0379514>] (dump_stack) from [<c039b5a0>] (check_preemption_disabled+0xf4/0x138)
>>> [<c039b5a0>] (check_preemption_disabled) from [<c011abe4>] (__do_user_fault+0x34/0x114)
>>> [<c011abe4>] (__do_user_fault) from [<c053b0d0>] (do_page_fault+0x3b4/0x3d8)
>>> [<c053b0d0>] (do_page_fault) from [<c01013dc>] (do_DataAbort+0x58/0xf8)
>>> [<c01013dc>] (do_DataAbort) from [<c053a880>] (__dabt_usr+0x40/0x60)
>>>
>>> Reported-by: Jingwen Qiu <qiujingwen@huawei.com>
>>> Signed-off-by: Yongliang Gao <gaoyongliang@huawei.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>  arch/arm/include/asm/system_misc.h | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
>>> index 66f6a3a..4a55cfb 100644
>>> --- a/arch/arm/include/asm/system_misc.h
>>> +++ b/arch/arm/include/asm/system_misc.h
>>> @@ -22,9 +22,10 @@
>>>  static inline void harden_branch_predictor(void)
>>>  {
>>>  	harden_branch_predictor_fn_t fn = per_cpu(harden_branch_predictor_fn,
>>> -						  smp_processor_id());
>>> +						  get_cpu());
>>>  	if (fn)
>>>  		fn();
>>> +	put_cpu();
>>>  }
>>>  #else
>>>  #define harden_branch_predictor() do { } while (0)
>>>
>>
>> This doesn't look like the right fix. If we're in a preemptible context,
>> then we could invalidate the branch predictor on the wrong CPU.
> 
> Sorry, my bad, thanks a lot for the good catch.
> 
>>
>> The right fix would be to move the call to a point where we haven't
>> enabled preemption yet.
> 
> I took a look at the code, and find out that the caller of
> harden_branch_predictor(), __do_user_fault(), is called by do_page_fault()
> and do_bad_area(), those two function's context are both running with
> preemption enabled, so I didn't find a good place to move the call,
> could you please give some suggestion for my next step?

Since we land here from do_page_fault, it seems natural to move the
invalidation up there, probably before we re-enable interrupts.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
