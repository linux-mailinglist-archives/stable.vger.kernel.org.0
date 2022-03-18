Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715904DE03B
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbiCRRuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236763AbiCRRuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:50:08 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9DEC15DABC;
        Fri, 18 Mar 2022 10:48:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CB961515;
        Fri, 18 Mar 2022 10:48:49 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADFA23F7B4;
        Fri, 18 Mar 2022 10:48:48 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, james.morse@arm.com,
        catalin.marinas@arm.com
Subject: [stable:PATCH v4.19.235 00/22] arm64: Mitigate spectre style branch history side channels
Date:   Fri, 18 Mar 2022 17:48:20 +0000
Message-Id: <20220318174842.2321061-1-james.morse@arm.com>
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

There is the v4.19 backport with the k=8 typo and SDEI name thing both
fixed.

Again, its the KVM templates patch that doesn't exist upstream, this is
necessary because the infrastructure for older kernels is very
different, and the dependencies for what was a rewrite are huge.


Its v4.14 and erlier that need to bring some timer errata workaround in
with it. I'm still trying to test that.



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
 arch/arm64/Kconfig                  |   9 +
 arch/arm64/include/asm/assembler.h  |  34 +++
 arch/arm64/include/asm/cpu.h        |   1 +
 arch/arm64/include/asm/cpucaps.h    |   3 +-
 arch/arm64/include/asm/cpufeature.h |  39 +++
 arch/arm64/include/asm/cputype.h    |  16 ++
 arch/arm64/include/asm/fixmap.h     |   6 +-
 arch/arm64/include/asm/kvm_host.h   |   5 +
 arch/arm64/include/asm/kvm_mmu.h    |   6 +-
 arch/arm64/include/asm/mmu.h        |   8 +-
 arch/arm64/include/asm/sections.h   |   5 +
 arch/arm64/include/asm/sysreg.h     |   5 +
 arch/arm64/include/asm/vectors.h    |  74 ++++++
 arch/arm64/kernel/cpu_errata.c      | 381 +++++++++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c      |  21 ++
 arch/arm64/kernel/cpuinfo.c         |   1 +
 arch/arm64/kernel/entry.S           | 215 ++++++++++++----
 arch/arm64/kernel/vmlinux.lds.S     |   2 +-
 arch/arm64/kvm/hyp/hyp-entry.S      |  64 +++++
 arch/arm64/kvm/hyp/switch.c         |   8 +-
 arch/arm64/kvm/sys_regs.c           |   2 +-
 arch/arm64/mm/mmu.c                 |  12 +-
 include/linux/arm-smccc.h           |   7 +
 virt/kvm/arm/psci.c                 |  12 +
 25 files changed, 871 insertions(+), 72 deletions(-)
 create mode 100644 arch/arm64/include/asm/vectors.h

-- 
2.30.2

