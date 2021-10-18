Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442B54327D1
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 21:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhJRTnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 15:43:09 -0400
Received: from terminus.zytor.com ([198.137.202.136]:48029 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhJRTnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 15:43:09 -0400
X-Greylist: delayed 1789 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2021 15:43:09 EDT
Received: from [IPv6:::1] ([IPv6:2601:646:8600:40c1:2940:488f:135b:c3a7])
        (authenticated bits=0)
        by mail.zytor.com (8.16.1/8.15.2) with ESMTPSA id 19IJAQX71085486
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 18 Oct 2021 12:10:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 19IJAQX71085486
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2021093001; t=1634584228;
        bh=C9HJ0feu4OKIsL+GreNb8UtYdL24BDfJhK8PPZxOU1M=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=g44E5h26MhJnkhrkepWEslUJBDrUA8TblLsBBYZEm1NGqUTlraYx9WU4gV7Z26CpU
         19r+tqsP6PspK2y+gDXA9Z7vfl55eHHq48rk/+SDFCCjfOBwsaHxJacAdeVcrIz4EI
         0xjyoGnkRCABHjUpA+qJkaD1e7fym8tZ3AOF8q/HJjRG+8kVpNiQ/qeSxwhXqp+Sk2
         aDp3DJzAVKpdPra83VaNuVsBsOWEP+UyQIbuIYwA7SHFyPUqoOSkjJu2yAxtPgXLhV
         bq8hkwZbUXTI1d+3kEfo7aQd/Z3nuh0J/44s+qV6XsPsA2KzM7mtRFPJa79JRQJJW+
         wGBXFuHL8KEJw==
Date:   Mon, 18 Oct 2021 12:10:20 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Borislav Petkov <bp@alien8.de>,
        Jane Malalane <jane.malalane@citrix.com>
CC:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
User-Agent: K-9 Mail for Android
In-Reply-To: <YW25x7AYiM1f1HQA@zn.tnic>
References: <20211013142230.10129-1-jane.malalane@citrix.com> <YW25x7AYiM1f1HQA@zn.tnic>
Message-ID: <35CA4584-4CFD-4E47-9825-6438D9ED4ECC@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AFAIK no Intel CPU has ever had that behavior, and always cleared the segme=
nts; I don't Intel has any plans of supporting such a CPUID bit (although I=
'd certainly be willing to take such a request back to the CPU teams on req=
uest=2E)

That being said, this sounds like an ideal use for the hypervisor CPU feat=
ure flag=2E Maybe we should consider a migration hypervisor flag too to exp=
licitly tell the kernel not to rely on hardware probing that breaks migrati=
on in general=2E

Now, with a CPUID but being introduced, the right thing would be to use th=
e CPUID bit as a feature instead of using a bug flag, and add whitelisting =
in the vendor-specific code as applicable=2E



On October 18, 2021 11:17:30 AM PDT, Borislav Petkov <bp@alien8=2Ede> wrot=
e:
>On Wed, Oct 13, 2021 at 03:22:30PM +0100, Jane Malalane wrote:
>> @@ -650,6 +651,27 @@ static void early_init_amd(struct cpuinfo_x86 *c)
>>  	if (c->x86_power & BIT(14))
>>  		set_cpu_cap(c, X86_FEATURE_RAPL);
>> =20
>> +	/*
>> +	 * Zen1 and earlier CPUs don't clear segment base/limits when
>> +	 * loading a NULL selector=2E  This has been designated
>> +	 * X86_BUG_NULL_SEG=2E
>> +	 *
>> +	 * Zen3 CPUs advertise Null Selector Clears Base in CPUID=2E
>> +	 * Zen2 CPUs also have this behaviour, but no CPUID bit=2E
>> +	 *
>> +	 * A hypervisor may sythesize the bit, but may also hide it
>> +	 * for migration safety, so we must not probe for model
>> +	 * specific behaviour when virtualised=2E
>> +	 */
>> +	if (c->extended_cpuid_level >=3D 0x80000021 && cpuid_eax(0x80000021) =
& BIT(6))
>> +		nscb =3D true;
>> +
>> +	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !nscb && c->x86 =3D=3D 0x1=
7)
>> +		nscb =3D check_null_seg_clears_base(c);
>> +
>> +	if (!nscb)
>> +		set_cpu_bug(c, X86_BUG_NULL_SEG);
>> +
>>  #ifdef CONFIG_X86_64
>>  	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
>>  #else
>
>Can we do something like this?
>
>It is carved out into a separate function which you can simply call from
>early_init_amd() and early_init_hygon()=2E
>
>I guess you can put that function in arch/x86/kernel/cpu/common=2Ec or so=
=2E
>
>Then, you should put the comments right over the code like I've done
>below so that one can follow what's going on with each particular check=
=2E
>
>I've also flipped the logic a bit and it is simpler this way=2E
>
>Totally untested of course=2E
>
>static void early_probe_null_seg_clearing_base(struct cpuinfo_x86 *c)
>{
>	/*
>	 * A hypervisor may sythesize the bit, but may also hide it
>	 * for migration safety, so do not probe for model-specific
>	 * behaviour when virtualised=2E
>	 */
>	if (cpu_has(c, X86_FEATURE_HYPERVISOR))
>		return;
>
>	/* Zen3 CPUs advertise Null Selector Clears Base in CPUID=2E */
>	if (c->extended_cpuid_level >=3D 0x80000021 && cpuid_eax(0x80000021) & B=
IT(6))
>		return;
>
>	/* Zen2 CPUs also have this behaviour, but no CPUID bit=2E */
>	if (c->x86 =3D=3D 0x17 && check_null_seg_clears_base(c))
>		return;
>
>	/* All the remaining ones are affected */
>	set_cpu_bug(c, X86_BUG_NULL_SEG);
>}
>
>> diff --git a/arch/x86/kernel/cpu/common=2Ec b/arch/x86/kernel/cpu/commo=
n=2Ec
>> index 0f8885949e8c=2E=2E2ca4afb97247 100644
>> --- a/arch/x86/kernel/cpu/common=2Ec
>> +++ b/arch/x86/kernel/cpu/common=2Ec
>> @@ -1395,7 +1395,7 @@ void __init early_cpu_init(void)
>>  	early_identify_cpu(&boot_cpu_data);
>>  }
>> =20
>> -static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
>> +bool check_null_seg_clears_base(struct cpuinfo_x86 *c)
>>  {
>>  #ifdef CONFIG_X86_64
>>  	/*
>> @@ -1418,10 +1418,10 @@ static void detect_null_seg_behavior(struct cpu=
info_x86 *c)
>>  	wrmsrl(MSR_FS_BASE, 1);
>>  	loadsegment(fs, 0);
>>  	rdmsrl(MSR_FS_BASE, tmp);
>> -	if (tmp !=3D 0)
>> -		set_cpu_bug(c, X86_BUG_NULL_SEG);
>>  	wrmsrl(MSR_FS_BASE, old_base);
>> +	return tmp =3D=3D 0;
>>  #endif
>> +	return true;
>>  }
>> =20
>>  static void generic_identify(struct cpuinfo_x86 *c)
>> @@ -1457,8 +1457,6 @@ static void generic_identify(struct cpuinfo_x86 *=
c)
>> =20
>>  	get_model_name(c); /* Default name */
>> =20
>> -	detect_null_seg_behavior(c);
>> -
>>  	/*
>>  	 * ESPFIX is a strange bug=2E  All real CPUs have it=2E  Paravirt
>>  	 * systems that run Linux at CPL > 0 may or may not have the
>
>So this function is called on all x86 CPUs=2E Are you sure others besides
>AMD and Hygon do not have the same issue?
>
>IOW, I wouldn't remove that call here=2E
>
>But then this is the identify() phase in the boot process and you've
>moved it to early_identify() by putting it in the ->c_early_init()
>function pointer on AMD and Hygon=2E
>
>Is there any particular reasoning for this or can that detection remain
>in ->c_identify()?
>
>Because if this null seg behavior detection should happen on all
>CPUs - and I think it should, because, well, it has been that way
>until now - then the vendor specific identification minus what
>detect_null_seg_behavior() does should run first and then after
>->c_identify() is done, you should do something like:
>
>	if (!cpu_has_bug(c, X86_BUG_NULL_SEG)) {
>		if (!check_null_seg_clears_base(c))
>			set_cpu_bug(c, X86_BUG_NULL_SEG);
>	}
>
>so that it still takes place on all CPUs=2E
>
>I=2Ee=2E, you should split the detection=2E
>
>I hope I'm making sense =2E=2E=2E
>
>Ah, btw, that @c parameter to detect_null_seg_behavior() is unused - you
>should remove it in a pre-patch=2E
>
>Thx=2E
>

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
