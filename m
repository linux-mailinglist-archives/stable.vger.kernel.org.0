Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D83F1F569E
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 16:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgFJOMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 10:12:22 -0400
Received: from foss.arm.com ([217.140.110.172]:59310 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgFJOMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 10:12:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0C4F1F1;
        Wed, 10 Jun 2020 07:12:21 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50B713F6CF;
        Wed, 10 Jun 2020 07:12:20 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
To:     Marc Zyngier <maz@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Cc:     kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20200609084921.1448445-1-maz@kernel.org>
 <20200609084921.1448445-2-maz@kernel.org>
 <7c173265-3f8e-51df-d700-7e3658a0e4d8@arm.com>
 <7451e64c22d8432f998458e0343aee7f@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <5ab013a2-7213-4bf6-b616-ff39bda72ffb@arm.com>
Date:   Wed, 10 Jun 2020 15:12:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <7451e64c22d8432f998458e0343aee7f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc, Robin,

On 09/06/2020 12:48, Marc Zyngier wrote:
> On 2020-06-09 12:41, Robin Murphy wrote:
>> On 2020-06-09 09:49, Marc Zyngier wrote:
>>> AArch32 CP1x registers are overlayed on their AArch64 counterparts
>>> in the vcpu struct. This leads to an interesting problem as they
>>> are stored in their CPU-local format, and thus a CP1x register
>>> doesn't "hit" the lower 32bit portion of the AArch64 register on
>>> a BE host.
>>>
>>> To workaround this unfortunate situation, introduce a bias trick
>>> in the vcpu_cp1x() accessors which picks the correct half of the
>>> 64bit register.

>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 59029e90b557..e80c0e06f235 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -404,8 +404,14 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
>>>    * CP14 and CP15 live in the same array, as they are backed by the
>>>    * same system registers.
>>>    */
>>> -#define vcpu_cp14(v,r)        ((v)->arch.ctxt.copro[(r)])
>>> -#define vcpu_cp15(v,r)        ((v)->arch.ctxt.copro[(r)])
>>> +#ifdef CPU_BIG_ENDIAN
>>
>> Ahem... I think you're missing a "CONFIG_" there ;)
> 
> Duh! As I said, I didn't test the thing at all! ;-)
> 
>> Bonus trickery - for a 0 or 1 value you can simply use IS_ENABLED().
> 
> Beautiful! Definitely a must! :D

With Robin's suggestion of:
---------------%<---------------
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a935457712b..54e9c7eb3596 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -405,11 +405,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
  * CP14 and CP15 live in the same array, as they are backed by the
  * same system registers.
  */
-#ifdef CPU_BIG_ENDIAN
-#define CPx_OFFSET     1
-#else
-#define CPx_OFFSET     0
-#endif
+#define CPx_OFFSET     IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)

 #define vcpu_cp14(v,r)         ((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])
 #define vcpu_cp15(v,r)         ((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])
---------------%<---------------

Tested-by: James Morse <james.morse@arm.com>
Acked-by: James Morse <james.morse@arm.com>


Thanks,

James

-----
Before this patch, an aarch32 guest of a BE host reading sysregs KVM is trap-and-undeffing
gets:
| Bad mode in prefetch abort handler detected
| Internal error: Oops - bad mode: 0 [#1] SMP THUMB2
| Modules linked in:
| CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.7.0+ #260
| Hardware name: Generic DT based system
| PC is at 0x4
| LR is at smp_cpus_done+0x85/0x98
| pc : [<00000004>]    lr : [<808035cb>]    psr: 6000009b
| sp : 9f4a1f08  ip : 00000003  fp : 00000000
| r10: 00000000  r9 : 00000000  r8 : 00000000
| r7 : 80904ea8  r6 : 80904f6c  r5 : 00000002  r4 : 000f4240
| r3 : bc605c12  r2 : bc605c12  r1 : 1f38c000  r0 : 0000c348
| Flags: nZCv  IRQs off  FIQs on  Mode UND_32  ISA ARM  Segment none
| Control: 50c5383d  Table: 8000406a  DAC: bc605c12
| Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
[...]
| [<808035cb>] (smp_cpus_done) from [<00000002>] (0x2)
| Code: bad PC value
| ---[ end trace b37275bf489ca225 ]---


instead of the undef it so richly deserved:
| Internal error: Oops - undefined instruction: 0 [#1] SMP THUMB2
| Modules linked in:
| CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.7.0+ #260
| Hardware name: Generic DT based system
| PC is at smp_cpus_done+0x88/0x98
| LR is at smp_cpus_done+0x85/0x98
| pc : [<808035ce>]    lr : [<808035cb>]    psr: 60000073
| sp : 9f495f50  ip : 00000001  fp : 00000000
| r10: 00000000  r9 : 00000000  r8 : 00000000
| r7 : 80904ea8  r6 : 80904f6c  r5 : 00000001  r4 : 0007a120
| r3 : 7f3828d2  r2 : 7f3828d2  r1 : 1f39f000  r0 : 0000c348
| Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA Thumb  Segment none
| Control: 50c5383d  Table: 8000406a  DAC: 00000051
| Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
[...]
| [<808035ce>] (smp_cpus_done) from [<80800f73>] (kernel_init_freeable+0xdf/0x204)
| [<80800f73>] (kernel_init_freeable) from [<805aa2a7>] (kernel_init+0x7/0xc8)
| [<805aa2a7>] (kernel_init) from [<80100159>] (ret_from_fork+0x11/0x38)
| Code: f7ff f8b9 f24c 3048 (ee11) 1f30
| ---[ end trace 4c78dcd8460e6041 ]---


