Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614C93F25DC
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 06:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhHTEZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 00:25:59 -0400
Received: from ozlabs.org ([203.11.71.1]:46319 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhHTEZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 00:25:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GrT7x1KM1z9sW5;
        Fri, 20 Aug 2021 14:25:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1629433517;
        bh=TY6nLrmjoHyAzLgmjUDiH3O3rM9kTfEtWkmi+ZvE6rY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=qudDX4J8UWi+6+7ay40xF74TpJv5cn1tKDShtykYbqO0aN8uz7Dk+LBw4Gl6G5AXk
         /6jCrrW4nVyt2fmGYJy/vu8bu1j1y3yTDdDvMgHc0SDQRiTlnLzeJJ0UBwRIrqIvSU
         d/EFP6j2FHPpLCx1w5KGwNtKJ7PhGlIJuBMr/u2TdiPESqu76d2WNgpczVCBFFiH/X
         qidFxO9hZBiSMGIPElyGlVAsc1mtkzp2STrpSIXCawTHn6q4ne1W3x8xXP/sY8FYR1
         QBM71FxIuPndLFePXsK3aY761+IdT+UOAW3HRLllVgfahmq5wBwPeAQkmPe7b66adV
         mJy8XZkR/kZUQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Daniel Axtens <dja@axtens.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        kernel-janitors@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] powerpc: rectify selection to
 ARCH_ENABLE_SPLIT_PMD_PTLOCK
In-Reply-To: <87pmu99e4j.fsf@dja-thinkpad.axtens.net>
References: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
 <20210819113954.17515-3-lukas.bulwahn@gmail.com>
 <87pmu99e4j.fsf@dja-thinkpad.axtens.net>
Date:   Fri, 20 Aug 2021 14:25:12 +1000
Message-ID: <87a6lceo9j.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Daniel Axtens <dja@axtens.net> writes:
> Lukas Bulwahn <lukas.bulwahn@gmail.com> writes:
>
>> Commit 66f24fa766e3 ("mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK")
>> selects the non-existing config ARCH_ENABLE_PMD_SPLIT_PTLOCK in
>> ./arch/powerpc/platforms/Kconfig.cputype, but clearly it intends to select
>> ARCH_ENABLE_SPLIT_PMD_PTLOCK here (notice the word swapping!), as this
>> commit does select that for all other architectures.
>>
>> Rectify selection to ARCH_ENABLE_SPLIT_PMD_PTLOCK instead.
>>
>
> Yikes, yes, 66f24fa766e3 does seem to have got that wrong. It looks like
> that went into 5.13.
>
> I think we want to specifically target this for stable so that we don't
> lose the perfomance and scalability benefits of split pmd ptlocks:
>
> Cc: stable@vger.kernel.org # v5.13+
>
> (I don't think you need to do another revision for this, I think mpe
> could add it when merging.)

Yeah. I rewrote the change log a bit to make it clear this is a bug fix,
not a harmless cleanup.

cheers


  powerpc: Re-enable ARCH_ENABLE_SPLIT_PMD_PTLOCK
  
  Commit 66f24fa766e3 ("mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK")
  broke PMD split page table lock for powerpc.
  
  It selects the non-existent config ARCH_ENABLE_PMD_SPLIT_PTLOCK in
  arch/powerpc/platforms/Kconfig.cputype, but clearly intended to
  select ARCH_ENABLE_SPLIT_PMD_PTLOCK (notice the word swapping!), as
  that commit did for all other architectures.
  
  Fix it by selecting the correct symbol ARCH_ENABLE_SPLIT_PMD_PTLOCK.
  
  Fixes: 66f24fa766e3 ("mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK")
  Cc: stable@vger.kernel.org # v5.13+
  Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
  Reviewed-by: Daniel Axtens <dja@axtens.net>
  [mpe: Reword change log to make it clear this is a bug fix]
  Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
  Link: https://lore.kernel.org/r/20210819113954.17515-3-lukas.bulwahn@gmail.com
