Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165674F6924
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiDFSGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240057AbiDFSGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:06:41 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCB83184622;
        Wed,  6 Apr 2022 09:42:35 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1D0D23A;
        Wed,  6 Apr 2022 09:42:35 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F39B43F73B;
        Wed,  6 Apr 2022 09:42:34 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 00/43] arm64: Mitigate spectre style branch history side channels
Date:   Wed,  6 Apr 2022 17:41:34 +0100
Message-Id: <20220406164217.1888053-1-james.morse@arm.com>
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

Compared to the v4.14 backport, this backport for v4.9 includes extra
infrastructure for the arch timer driver, which is needed for the A76 timer
workaround, which is needed to cleanly pick up the A76 MIDR definition.
I didn't backport the Hisilicon 161010101 workaround as I'm unable to test it.

I also backported the capabilities midr-range support, which the bhb
mitigation makes use of. Ard had already backported this to v4.14.
I ended up backporting Ard's version from v4.14 as it conflicted less,
and he had added A35 to the spectre-safe list.

.. and then the Spectre-BHB bits, where as before the KVM stuff is
different to mainline as the infrastructure for doing this stuff is very
different.


Thanks,

James

Anshuman Khandual (1):
  arm64: Add Cortex-X2 CPU part definition

Arnd Bergmann (1):
  arm64: arch_timer: avoid unused function warning

Dave Martin (1):
  arm64: capabilities: Update prototype for enable call back

Ding Tianhong (2):
  clocksource/drivers/arm_arch_timer: Remove fsl-a008585 parameter
  clocksource/drivers/arm_arch_timer: Introduce generic errata handling
    infrastructure

James Morse (20):
  arm64: Remove useless UAO IPI and describe how this gets enabled
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
  arm64: Move arm64_update_smccc_conduit() out of SSBD ifdef
  arm64: entry: Add vectors that have the bhb mitigation sequences
  arm64: entry: Add macro for reading symbol addresses from the
    trampoline
  arm64: Add percpu vectors for EL1
  KVM: arm64: Add templates for BHB mitigation sequences
  arm64: Mitigate spectre style branch history side channels
  KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and
    migrated
  arm64: add ID_AA64ISAR2_EL1 sys register
  arm64: Use the clearbhb instruction in mitigations

Marc Zyngier (6):
  arm64: arch_timer: Add infrastructure for multiple erratum detection
    methods
  arm64: arch_timer: Add erratum handler for CPU-specific capability
  arm64: arch_timer: Add workaround for ARM erratum 1188873
  arm64: Add silicon-errata.txt entry for ARM erratum 1188873
  arm64: Make ARM64_ERRATUM_1188873 depend on COMPAT
  arm64: Add part number for Neoverse N1

Rob Herring (1):
  arm64: Add part number for Arm Cortex-A77

Robert Richter (1):
  arm64: errata: Provide macro for major and minor cpu revisions

Suzuki K Poulose (10):
  arm64: Add MIDR encoding for Arm Cortex-A55 and Cortex-A35
  arm64: capabilities: Move errata work around check on boot CPU
  arm64: capabilities: Move errata processing code
  arm64: capabilities: Prepare for fine grained capabilities
  arm64: capabilities: Add flags to handle the conflicts on late CPU
  arm64: capabilities: Clean up midr range helpers
  arm64: Add helpers for checking CPU MIDR against a range
  arm64: capabilities: Add support for checks based on a list of MIDRs
  arm64: Add Neoverse-N2, Cortex-A710 CPU part definition
  arm64: Add helper to decode register from instruction

 Documentation/arm64/silicon-errata.txt |   1 +
 Documentation/kernel-parameters.txt    |   9 -
 arch/arm/include/asm/kvm_host.h        |   5 +
 arch/arm/kvm/psci.c                    |   4 +
 arch/arm64/Kconfig                     |  24 +
 arch/arm64/include/asm/arch_timer.h    |  44 +-
 arch/arm64/include/asm/assembler.h     |  34 ++
 arch/arm64/include/asm/cpu.h           |   1 +
 arch/arm64/include/asm/cpucaps.h       |   4 +-
 arch/arm64/include/asm/cpufeature.h    | 232 +++++++++-
 arch/arm64/include/asm/cputype.h       |  63 +++
 arch/arm64/include/asm/fixmap.h        |   6 +-
 arch/arm64/include/asm/insn.h          |   2 +
 arch/arm64/include/asm/kvm_host.h      |   4 +
 arch/arm64/include/asm/kvm_mmu.h       |   2 +-
 arch/arm64/include/asm/mmu.h           |   8 +-
 arch/arm64/include/asm/processor.h     |   6 +-
 arch/arm64/include/asm/sections.h      |   6 +
 arch/arm64/include/asm/sysreg.h        |   5 +
 arch/arm64/include/asm/vectors.h       |  74 +++
 arch/arm64/kernel/bpi.S                |  55 +++
 arch/arm64/kernel/cpu_errata.c         | 595 ++++++++++++++++++++-----
 arch/arm64/kernel/cpufeature.c         | 167 +++++--
 arch/arm64/kernel/cpuinfo.c            |   1 +
 arch/arm64/kernel/entry.S              | 197 ++++++--
 arch/arm64/kernel/fpsimd.c             |   1 +
 arch/arm64/kernel/insn.c               |  29 ++
 arch/arm64/kernel/smp.c                |   6 -
 arch/arm64/kernel/traps.c              |   4 +-
 arch/arm64/kernel/vmlinux.lds.S        |   2 +-
 arch/arm64/kvm/hyp/hyp-entry.S         |   4 +
 arch/arm64/kvm/hyp/switch.c            |   9 +-
 arch/arm64/mm/fault.c                  |  17 +-
 arch/arm64/mm/mmu.c                    |  11 +-
 drivers/clocksource/Kconfig            |   4 +
 drivers/clocksource/arm_arch_timer.c   | 202 +++++++--
 include/linux/arm-smccc.h              |   7 +
 37 files changed, 1509 insertions(+), 336 deletions(-)
 create mode 100644 arch/arm64/include/asm/vectors.h

-- 
2.30.2

