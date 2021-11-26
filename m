Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A08E45E3FA
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 02:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244323AbhKZB1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 20:27:19 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15869 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239553AbhKZBZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 20:25:19 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J0cQm5rrlz91NJ;
        Fri, 26 Nov 2021 09:21:36 +0800 (CST)
Received: from dggema774-chm.china.huawei.com (10.1.198.216) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 09:22:02 +0800
Received: from [10.67.102.197] (10.67.102.197) by
 dggema774-chm.china.huawei.com (10.1.198.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 26 Nov 2021 09:22:01 +0800
Subject: Re: [PATCH v2 2/2] powerpc:85xx: fix timebase sync issue when
 CONFIG_HOTPLUG_CPU=n
To:     Martin Kennedy <hurricos@gmail.com>
CC:     <Yuantian.Tang@feescale.com>, <benh@kernel.crashing.org>,
        <chenhui.zhao@freescale.com>, <chenjianguo3@huawei.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <liuwenliang@huawei.com>,
        <mpe@ellerman.id.au>, <oss@buserror.net>,
        <paul.gortmaker@windriver.com>, <paulus@samba.org>,
        <stable@vger.kernel.org>, <wangle6@huawei.com>,
        "Christian Lamparter" <chunkeey@gmail.com>
References: <CANA18Uxu5dUYOkDmXpYtLc8iQuAYMv1UujkmEo1bkhm3CqxMAA@mail.gmail.com>
 <3c7523a3-2de2-3a76-2f46-9e4cf38f40b6@huawei.com>
 <CANA18Uyba4kMJQrbCSZVTFep2Exe5izE45whNJgwwUvNSEcNLg@mail.gmail.com>
From:   Xiaoming Ni <nixiaoming@huawei.com>
Message-ID: <5f56f1af-9404-21fa-eda0-05a75d769427@huawei.com>
Date:   Fri, 26 Nov 2021 09:22:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <CANA18Uyba4kMJQrbCSZVTFep2Exe5izE45whNJgwwUvNSEcNLg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.197]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema774-chm.china.huawei.com (10.1.198.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/11/25 22:34, Martin Kennedy wrote:
> Hi there,
> 
> Yes, I can test this patch.
> 
> I have added it to my tree and removed the reversion, and can confirm
> that the second CPU comes up correctly now.
> 
> Martin
> 
Thank you very much for your report and testing, I'll send a patch later

Thanks
Xiaoming Ni

> On Thu, Nov 25, 2021 at 2:23 AM Xiaoming Ni <nixiaoming@huawei.com> wrote:
>>
>> On 2021/11/25 12:20, Martin Kennedy wrote:
>>> Hi there,
>>>
>>> I have bisected OpenWrt master, and then the Linux kernel down to this
>>> change, to confirm that this change causes a kernel panic on my
>>> P1020RDB-based, dual-core Aerohive HiveAP 370, at initialization of
>>> the second CPU:
>>>
>>> :
>>> [    0.000000] Linux version 5.10.80 (labby@lobon)
>>> (powerpc-openwrt-linux-musl-gcc (OpenWrt GCC 11.2.0
>>> r18111+1-ebb6f9287e) 11.2.0, GNU ld (GNU Binutils) 2.37) #0 SMP Thu
>>> Nov 25 02:49:35 2021
>>> [    0.000000] Using P1020 RDB machine description
>>> :
>>> [    0.627233] smp: Bringing up secondary CPUs ...
>>> [    0.681659] kernel tried to execute user page (0) - exploit attempt? (uid: 0)
>>> [    0.766618] BUG: Unable to handle kernel instruction fetch (NULL pointer?)
>>> [    0.848899] Faulting instruction address: 0x00000000
>>> [    0.908273] Oops: Kernel access of bad area, sig: 11 [#1]
>>> [    0.972851] BE PAGE_SIZE=4K SMP NR_CPUS=2 P1020 RDB
>>> [    1.031179] Modules linked in:
>>> [    1.067640] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.80 #0
>>> [    1.139507] NIP:  00000000 LR: c0021d2c CTR: 00000000
>>> [    1.199921] REGS: c1051cf0 TRAP: 0400   Not tainted  (5.10.80)
>>> [    1.269705] MSR:  00021000 <CE,ME>  CR: 84020202  XER: 00000000
>>> [    1.340534]
>>> [    1.340534] GPR00: c0021cb8 c1051da8 c1048000 00000001 00029000
>>> 00000000 00000001 00000000
>>> [    1.340534] GPR08: 00000001 00000000 c08b0000 00000040 22000208
>>> 00000000 c00032c4 00000000
>>> [    1.340534] GPR16: 00000000 00000000 00000000 00000000 00000000
>>> 00000000 00029000 00000001
>>> [    1.340534] GPR24: 1ffff240 20000000 dffff240 c080a1f4 00000001
>>> c08ae0a8 00000001 dffff240
>>> [    1.758220] NIP [00000000] 0x0
>>> [    1.794688] LR [c0021d2c] smp_85xx_kick_cpu+0xe8/0x568
>>> [    1.856126] Call Trace:
>>> [    1.885295] [c1051da8] [c0021cb8] smp_85xx_kick_cpu+0x74/0x568 (unreliable)
>>> [    1.968633] [c1051de8] [c0011460] __cpu_up+0xc0/0x228
>>> [    2.029038] [c1051e18] [c0031bbc] bringup_cpu+0x30/0x224
>>> [    2.092572] [c1051e48] [c0031f3c] cpu_up.constprop.0+0x180/0x33c
>>> [    2.164443] [c1051e88] [c00322e8] bringup_nonboot_cpus+0x88/0xc8
>>> [    2.236326] [c1051eb8] [c07e67bc] smp_init+0x30/0x78
>>> [    2.295698] [c1051ed8] [c07d9e28] kernel_init_freeable+0x118/0x2a8
>>> [    2.369641] [c1051f18] [c00032d8] kernel_init+0x14/0x124
>>> [    2.433176] [c1051f38] [c0010278] ret_from_kernel_thread+0x14/0x1c
>>> [    2.507125] Instruction dump:
>>> [    2.542541] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>>> XXXXXXXX XXXXXXXX
>>> [    2.635242] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>>> XXXXXXXX XXXXXXXX
>>> [    2.727952] ---[ end trace 9b796a4bafb6bc14 ]---
>>> [    2.783149]
>>> [    3.800879] Kernel panic - not syncing: Fatal exception
>>> [    3.862353] Rebooting in 1 seconds..
>>> [    5.905097] System Halted, OK to turn off power
>>>
>>> Without this patch, the kernel no longer panics:
>>>
>>> [    0.627232] smp: Bringing up secondary CPUs ...
>>> [    0.681857] smp: Brought up 1 node, 2 CPUs
>>>
>>> Here is the kernel configuration for this built kernel:
>>> https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/mpc85xx/config-5.10;hb=HEAD
>>>
>>> In case a force-push is needed for the source repository
>>> (https://github.com/Hurricos/openwrt/commit/ad19bdfc77d60ee1c52b41bb4345fdd02284c4cf),
>>> here is the device tree for this board:
>>> https://paste.c-net.org/TrousersSliced
>>>
>>> Martin
>>> .
>>>
>> When CONFIG_FSL_PMC is set to n, cpu_up_prepare is not assigned to
>> mpc85xx_pm_ops. I suspect that this is the cause of the current null
>> pointer access.
>> I do not have the corresponding board test environment. Can you help me
>> to test whether the following patch solves the problem?
>>
>> diff --git a/arch/powerpc/platforms/85xx/smp.c
>> b/arch/powerpc/platforms/85xx/smp.c
>> index 83f4a6389a28..d7081e9af65c 100644
>> --- a/arch/powerpc/platforms/85xx/smp.c
>> +++ b/arch/powerpc/platforms/85xx/smp.c
>> @@ -220,7 +220,7 @@ static int smp_85xx_start_cpu(int cpu)
>>           local_irq_save(flags);
>>           hard_irq_disable();
>>
>> -   if (qoriq_pm_ops)
>> + if (qoriq_pm_ops && qoriq_pm_ops->cpu_up_prepare)
>>                   qoriq_pm_ops->cpu_up_prepare(cpu);
>>
>>           /* if cpu is not spinning, reset it */
>> @@ -292,7 +292,7 @@ static int smp_85xx_kick_cpu(int nr)
>>                   booting_thread_hwid = cpu_thread_in_core(nr);
>>                   primary = cpu_first_thread_sibling(nr);
>>
>> -           if (qoriq_pm_ops)
>> +         if (qoriq_pm_ops && qoriq_pm_ops->cpu_up_prepare)
>>                           qoriq_pm_ops->cpu_up_prepare(nr);
>>
>>                   /*
>>
>>
> .
> 

