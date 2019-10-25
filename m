Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C2CE5011
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 17:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440630AbfJYPZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 11:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731226AbfJYPZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 11:25:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7324721D7F;
        Fri, 25 Oct 2019 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572017135;
        bh=dSx7rE1J+3SZP7KDCK328smpGaLJtvBgkr6tq3Ic3co=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xz+zgHOH05B2vW4JbReW8JOD6Lt23nD/yJ+ZYTD+KjU40NB0+pMemPkD4eLfnvTtD
         7WJhOvrQN1cak2a5Sz48zcY0iDh4F8yKh9OuIDw6sEhP+kEpow6gMycIZjgb9yfjkE
         6rEDbqFfW5WwgWCgWFG5Zjw9eK71kUWWZKif1Sqs=
Date:   Fri, 25 Oct 2019 11:25:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH for-stable-4.14 42/48] arm64: Always enable spectre-v2
 vulnerability detection
Message-ID: <20191025152534.GF31224@sasha-vm>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
 <20191024124833.4158-43-ard.biesheuvel@linaro.org>
 <b41df418-2e09-ac29-92cd-3910f0c05c50@arm.com>
 <CAKv+Gu8zW08_TKgvU4yHh=8E4_cnhx7iLoeOrYfmoy4m7ofwsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKv+Gu8zW08_TKgvU4yHh=8E4_cnhx7iLoeOrYfmoy4m7ofwsA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 04:37:12PM +0200, Ard Biesheuvel wrote:
>On Thu, 24 Oct 2019 at 16:34, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>
>> Hi,
>>
>> On 10/24/19 1:48 PM, Ard Biesheuvel wrote:
>> > From: Jeremy Linton <jeremy.linton@arm.com>
>> >
>> > [ Upstream commit 8c1e3d2bb44cbb998cb28ff9a18f105fee7f1eb3 ]
>> >
>> > Ensure we are always able to detect whether or not the CPU is affected
>> > by Spectre-v2, so that we can later advertise this to userspace.
>> >
>> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>> > Reviewed-by: Andre Przywara <andre.przywara@arm.com>
>> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> > Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
>> > Signed-off-by: Will Deacon <will.deacon@arm.com>
>> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> > ---
>> >  arch/arm64/kernel/cpu_errata.c | 15 ++++++++-------
>> >  1 file changed, 8 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>> > index bf6d8aa9b45a..647c533cfd90 100644
>> > --- a/arch/arm64/kernel/cpu_errata.c
>> > +++ b/arch/arm64/kernel/cpu_errata.c
>> > @@ -76,7 +76,6 @@ cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *__unused)
>> >       config_sctlr_el1(SCTLR_EL1_UCT, 0);
>> >  }
>> >
>> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>> >  #include <asm/mmu_context.h>
>> >  #include <asm/cacheflush.h>
>> >
>> > @@ -217,11 +216,11 @@ static int detect_harden_bp_fw(void)
>> >           ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
>> >               cb = qcom_link_stack_sanitization;
>> >
>> > -     install_bp_hardening_cb(cb, smccc_start, smccc_end);
>> > +     if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR))
>> > +             install_bp_hardening_cb(cb, smccc_start, smccc_end);
>> >
>> >       return 1;
>> >  }
>> > -#endif       /* CONFIG_HARDEN_BRANCH_PREDICTOR */
>> >
>> >  DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
>> >
>> > @@ -457,7 +456,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
>> >       .type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,                 \
>> >       CAP_MIDR_RANGE_LIST(midr_list)
>> >
>> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>> >  /*
>> >   * List of CPUs that do not need any Spectre-v2 mitigation at all.
>> >   */
>> > @@ -489,6 +487,12 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
>> >       if (!need_wa)
>> >               return false;
>> >
>> > +     if (!IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR)) {
>> > +             pr_warn_once("spectrev2 mitigation disabled by kernel configuration\n");
>> > +             __hardenbp_enab = false;
>>
>> This breaks when building, because __hardenbp_enab is declared in the next patch:
>>
>> $ make -j32 defconfig && make -j32
>>
>> [..]
>> arch/arm64/kernel/cpu_errata.c: In function ‘check_branch_predictor’:
>> arch/arm64/kernel/cpu_errata.c:492:3: error: ‘__hardenbp_enab’ undeclared (first
>> use in this function)
>>    __hardenbp_enab = false;
>>    ^~~~~~~~~~~~~~~
>> arch/arm64/kernel/cpu_errata.c:492:3: note: each undeclared identifier is reported
>> only once for each function it appears in
>> make[1]: *** [scripts/Makefile.build:326: arch/arm64/kernel/cpu_errata.o] Error 1
>> make[1]: *** Waiting for unfinished jobs....
>>
>
>Indeed, but as discussed, this matches the state of both mainline and
>v4.19, which carry these patches in the same [wrong] order as well.
>
>Greg should confirm, but as I understand it, it is preferred to be
>bug-compatible with mainline rather than fixing problems when spotting
>them while doing the backport.

Is it just patch ordering? If so I'd rather fix it, there's no reason to
carry this issue into the stable trees.

We reserve "bug compatibility" for functional issues that are not yet
fixed upstream, it doesn't seem to be the case here.

-- 
Thanks,
Sasha
