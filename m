Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EA42D9B8B
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 16:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732365AbgLNPzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 10:55:46 -0500
Received: from out28-122.mail.aliyun.com ([115.124.28.122]:58442 "EHLO
        out28-122.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729091AbgLNPzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 10:55:46 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07439697|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0789955-0.000352892-0.920652;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047202;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.J733Ogu_1607961298;
Received: from 192.168.10.152(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.J733Ogu_1607961298)
          by smtp.aliyun-inc.com(10.147.40.2);
          Mon, 14 Dec 2020 23:54:59 +0800
Subject: Re: [PATCH] MIPS: Ingenic: Disable HPTLB for D0 XBurst CPUs too
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Zhou Yanjie <zhouyanjie@zoho.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20201212000354.291665-1-paul@crapouillou.net>
 <b5c0677a-fb8c-f5e8-b0f5-5bcaab00d921@wanyeetech.com>
 <PFNALQ.MDZT5ZA4HQDS3@crapouillou.net>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <353d36d6-0aae-6dfa-dbf3-60552cf46d12@wanyeetech.com>
Date:   Mon, 14 Dec 2020 23:54:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <PFNALQ.MDZT5ZA4HQDS3@crapouillou.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On 2020/12/14 上午3:57, Paul Cercueil wrote:
> Hi Zhou,
>
> Le lun. 14 déc. 2020 à 3:12, Zhou Yanjie <zhouyanjie@wanyeetech.com> a 
> écrit :
>> Hi Paul,
>>
>> On 2020/12/12 上午8:03, Paul Cercueil wrote:
>>> The JZ4760 has the HPTLB as well, but has a XBurst CPU with a D0 CPUID.
>>>
>>> Disable the HPTLB for all XBurst CPUs with a D0 CPUID. In the case 
>>> where
>>> there is no HPTLB (e.g. for older SoCs), this won't have any side
>>> effect.
>>>
>>> Fixes: b02efeb05699 ("MIPS: Ingenic: Disable abandoned HPTLB 
>>> function.")
>>> Cc: <stable@vger.kernel.org> # 5.4
>>> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>> ---
>>>   arch/mips/kernel/cpu-probe.c | 15 ++++++++-------
>>>   1 file changed, 8 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/mips/kernel/cpu-probe.c 
>>> b/arch/mips/kernel/cpu-probe.c
>>> index e6853697a056..31cb9199197c 100644
>>> --- a/arch/mips/kernel/cpu-probe.c
>>> +++ b/arch/mips/kernel/cpu-probe.c
>>> @@ -1830,16 +1830,17 @@ static inline void cpu_probe_ingenic(struct 
>>> cpuinfo_mips *c, unsigned int cpu)
>>>            */
>>>           case PRID_COMP_INGENIC_D0:
>>>               c->isa_level &= ~MIPS_CPU_ISA_M32R2;
>>> -            break;
>>> +            fallthrough;
>>>             /*
>>>            * The config0 register in the XBurst CPUs with a 
>>> processor ID of
>>> -         * PRID_COMP_INGENIC_D1 has an abandoned huge page tlb 
>>> mode, this
>>> -         * mode is not compatible with the MIPS standard, it will 
>>> cause
>>> -         * tlbmiss and into an infinite loop (line 21 in the 
>>> tlb-funcs.S)
>>> -         * when starting the init process. After chip reset, the 
>>> default
>>> -         * is HPTLB mode, Write 0xa9000000 to cp0 register 5 sel 4 to
>>
>>
>> I just noticed that I mistakenly wrote a capital 'W' in the original 
>> version.
>>
>> with that fixed:
>>
>> Reviewed-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
>
> Sure, thanks.
>
> If both D0 and D1 CPUs need the fix then I probably should move it 
> outside the switch, that would make the code a bit cleaner. I'll V2.
>

This is a good idea, but it should be noted that it still needs to be 
placed in XBURST_REV1, because XBURST_REV2 processors (such as X1830) 
also use the ID of D0, but they do not have the problem of HPTLB.


>> BTW: Are you planning to add support for JZ4760 recently? I am 
>> currently writing the CGU driver for JZ4775 and X2000. If you plan to 
>> add support for JZ4760, I can also write the CGU driver for JZ4760 by 
>> the way.
>
> Yes, we're working on it, all the core drivers are working (CGU, 
> pinctrl, timers, display, USB), it boots to userspace and allows to 
> telnet. The actual diff is very small, most of the changes were the 
> addition of the ingenic,jz4760-* compatible strings.
>

Good to hear that.

Thanks and best regards!


> Cheers,
> -Paul
>
>>> -         * switch back to VTLB mode to prevent getting stuck.
>>> +         * PRID_COMP_INGENIC_D0 or PRID_COMP_INGENIC_D1 has an 
>>> abandoned
>>> +         * huge page tlb mode, this mode is not compatible with the 
>>> MIPS
>>> +         * standard, it will cause tlbmiss and into an infinite loop
>>> +         * (line 21 in the tlb-funcs.S) when starting the init 
>>> process.
>>> +         * After chip reset, the default is HPTLB mode, Write 
>>> 0xa9000000
>>> +         * to cp0 register 5 sel 4 to switch back to VTLB mode to 
>>> prevent
>>> +         * getting stuck.
>>>            */
>>>           case PRID_COMP_INGENIC_D1:
>>>               write_c0_page_ctrl(XBURST_PAGECTRL_HPTLB_DIS);
>
