Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249A54EE080
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 20:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiCaSf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 14:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiCaSf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 14:35:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB25B63BD2;
        Thu, 31 Mar 2022 11:34:07 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47603139F;
        Thu, 31 Mar 2022 11:34:07 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C9493F718;
        Thu, 31 Mar 2022 11:34:06 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     james.morse@arm.com, catalin.marinas@arm.com
Subject: [stable:PATCH v4.14.274 00/27] arm64: Mitigate spectre style branch history side channels
Date:   Thu, 31 Mar 2022 19:33:33 +0100
Message-Id: <20220331183400.73183-1-james.morse@arm.com>
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

Hello!

This is the spectre-bhb backport for v4.14.
This comes with an A76 timer workaround. v4.14 doesn't have a compat
vdso, so doesn't need all the patches for that workaround.
In particular, it doesn't need Marc's series:
https://lore.kernel.org/linux-arm-kernel/20200715125614.3240269-1-maz@kernel.org/

I included the Kconfig change that restricts this to COMPAT, but not commit
0f80cad3124f ("arm64: Restrict ARM64_ERRATUM_1188873 mitigation to AArch32"),
which is an invasive performance optimisation that wasn't marked as
being for stable.


Thanks,

James

Anshuman Khandual (1):
  arm64: Add Cortex-X2 CPU part definition

Arnd Bergmann (1):
  arm64: arch_timer: avoid unused function warning

James Morse (19):
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
  arm64: add ID_AA64ISAR2_EL1 sys register
  arm64: Use the clearbhb instruction in mitigations

Marc Zyngier (4):
  arm64: arch_timer: Add workaround for ARM erratum 1188873
  arm64: Add silicon-errata.txt entry for ARM erratum 1188873
  arm64: Make ARM64_ERRATUM_1188873 depend on COMPAT
  arm64: Add part number for Neoverse N1

Rob Herring (1):
  arm64: Add part number for Arm Cortex-A77

Suzuki K Poulose (1):
  arm64: Add Neoverse-N2, Cortex-A710 CPU part definition

 Documentation/arm64/silicon-errata.txt |   1 +
 arch/arm/include/asm/kvm_host.h        |   6 +
 arch/arm64/Kconfig                     |  24 ++
 arch/arm64/include/asm/assembler.h     |  34 +++
 arch/arm64/include/asm/cpu.h           |   1 +
 arch/arm64/include/asm/cpucaps.h       |   4 +-
 arch/arm64/include/asm/cpufeature.h    |  39 +++
 arch/arm64/include/asm/cputype.h       |  20 ++
 arch/arm64/include/asm/fixmap.h        |   6 +-
 arch/arm64/include/asm/kvm_host.h      |   5 +
 arch/arm64/include/asm/kvm_mmu.h       |   2 +-
 arch/arm64/include/asm/mmu.h           |   8 +-
 arch/arm64/include/asm/sections.h      |   6 +
 arch/arm64/include/asm/sysreg.h        |   5 +
 arch/arm64/include/asm/vectors.h       |  74 +++++
 arch/arm64/kernel/bpi.S                |  55 ++++
 arch/arm64/kernel/cpu_errata.c         | 395 ++++++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c         |  21 ++
 arch/arm64/kernel/cpuinfo.c            |   1 +
 arch/arm64/kernel/entry.S              | 198 ++++++++++---
 arch/arm64/kernel/vmlinux.lds.S        |   2 +-
 arch/arm64/kvm/hyp/hyp-entry.S         |   4 +
 arch/arm64/kvm/hyp/switch.c            |   9 +-
 arch/arm64/mm/mmu.c                    |  11 +-
 drivers/clocksource/arm_arch_timer.c   |  15 +
 include/linux/arm-smccc.h              |   7 +
 virt/kvm/arm/psci.c                    |  12 +
 27 files changed, 908 insertions(+), 57 deletions(-)
 create mode 100644 arch/arm64/include/asm/vectors.h

-- 
2.30.2

