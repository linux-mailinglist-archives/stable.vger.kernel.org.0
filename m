Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7F74DA245
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351011AbiCOSZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiCOSZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:25:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D9E3205C6
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:24:22 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AB9A1474;
        Tue, 15 Mar 2022 11:24:22 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DEC93F73D;
        Tue, 15 Mar 2022 11:24:21 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com
Subject: [stable:PATCH v5.4.184 00/22] arm64: Mitigate spectre style branch history side channels
Date:   Tue, 15 Mar 2022 18:23:53 +0000
Message-Id: <20220315182415.3900464-1-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Here is the state of the current v5.4 backport. Now that the 32bit
code has been merged, it doesn't conflict when KVM's shared 32bit/64bit
code needs to use these constants.

I've fixed the two issues that were reported against the v5.10 backport.

I had a go at bringing all the pre-requisites in to add proton-pack.c
to v5.4. Its currently 39 patches:
https://git.gitlab.arm.com/linux-arm/linux-jm.git /bhb/alternative_backport/UNTESTED/v5.4.183
(or for web browsers:
https://gitlab.arm.com/linux-arm/linux-jm/-/commits/bhb/alternative_backport/UNTESTED/v5.4.183/
)

I've not managed to bring b881cdce77b4 "KVM: arm64: Allocate hyp vectors
statically" in, as that depends on the hypervisor's per-cpu support. Its
this patch that means those 'smccc_wa' templates are needed.
I estimate it would be 60 patches in total if we go this way, I don't
think its a good idea:
All this still has to work around 541ad0150ca4 ("arm: Remove 32bit KVM
host support") and 9ed24f4b712b ("KVM: arm64: Move virt/kvm/arm to
arch/arm64") being missing.
I think this approach creates more problems than it solves as the
files have to be in different places because of 32bit. It also creates
a significantly larger testing problem: I'm not looking forward to
working out how to test KVM guest migration over the variant-4 KVM ABI
changes in 29e8910a566a.


This version of the backport still adds the mitigation management code
to cpu_errata.c, because that is where this stuff lived in v5.4.

If you prefer, I can try adding proton-pack.c as a new empty file.
I think this would only confuse matters as the line-numbers would
never match, and there is an interaction with the spectre-v2 mitigations
that live in cpu_errata.c.

There is one patch not present in mainline 'KVM: arm64: Add templtes for
BHB mitigation sequences'.


Thanks,

James


Anshuman Khandual (1):
  arm64: Add Cortex-X2 CPU part definition

James Morse (18):
  arm64: entry.S: Add ventry overflow sanity checks
  arm64: entry: Make the trampoline cleanup optional
  arm64: entry: Free up another register on kpti's tramp_exit path
  arm64: entry: Move the trampoline data page before the text page
  arm64: entry: Allow tramp_alias to access symbols after the 4K
    boundary
  arm64: entry: Don't assume tramp_vectors is the start of the vectors
  arm64: entry: Move trampoline macros out of ifdef'd section
  arm64: entry: Make the kpti trampoline's kpti sequence optional
  arm64: entry: Allow the trampoline text to occupy multiple pages
  arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
  arm64: entry: Add vectors that have the bhb mitigation sequences
  arm64: entry: Add macro for reading symbol addresses from the
    trampoline
  arm64: Add percpu vectors for EL1
  arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of
    Spectre-v2
  KVM: arm64: Add templates for BHB mitigation sequences
  arm64: Mitigate spectre style branch history side channels
  KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and
    migrated
  arm64: Use the clearbhb instruction in mitigations

Joey Gouly (1):
  arm64: add ID_AA64ISAR2_EL1 sys register

Rob Herring (1):
  arm64: Add part number for Arm Cortex-A77

Suzuki K Poulose (1):
  arm64: Add Neoverse-N2, Cortex-A710 CPU part definition

 arch/arm/include/asm/kvm_host.h     |   7 +
 arch/arm/include/uapi/asm/kvm.h     |   6 +
 arch/arm64/Kconfig                  |   9 +
 arch/arm64/include/asm/assembler.h  |  33 +++
 arch/arm64/include/asm/cpu.h        |   1 +
 arch/arm64/include/asm/cpucaps.h    |   3 +-
 arch/arm64/include/asm/cpufeature.h |  40 +++
 arch/arm64/include/asm/cputype.h    |  16 ++
 arch/arm64/include/asm/fixmap.h     |   6 +-
 arch/arm64/include/asm/kvm_host.h   |   5 +
 arch/arm64/include/asm/kvm_mmu.h    |   6 +-
 arch/arm64/include/asm/mmu.h        |   8 +-
 arch/arm64/include/asm/sections.h   |   5 +
 arch/arm64/include/asm/sysreg.h     |  17 ++
 arch/arm64/include/asm/vectors.h    |  73 ++++++
 arch/arm64/include/uapi/asm/kvm.h   |   5 +
 arch/arm64/kernel/cpu_errata.c      | 385 +++++++++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c      |  21 ++
 arch/arm64/kernel/cpuinfo.c         |   1 +
 arch/arm64/kernel/entry.S           | 213 +++++++++++----
 arch/arm64/kernel/vmlinux.lds.S     |   2 +-
 arch/arm64/kvm/hyp/hyp-entry.S      |  64 +++++
 arch/arm64/kvm/hyp/switch.c         |   8 +-
 arch/arm64/kvm/sys_regs.c           |   2 +-
 arch/arm64/mm/mmu.c                 |  12 +-
 include/linux/arm-smccc.h           |   5 +
 virt/kvm/arm/psci.c                 |  34 ++-
 27 files changed, 912 insertions(+), 75 deletions(-)
 create mode 100644 arch/arm64/include/asm/vectors.h

-- 
2.30.2

