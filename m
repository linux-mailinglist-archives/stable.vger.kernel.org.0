Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F1F4525E
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbfFNDLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:11:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35788 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:11:55 -0400
Received: by mail-pf1-f196.google.com with SMTP id d126so502123pfd.2
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Zrvea35cbkKvmw3GyO8mr45YaSmzw+Vm5XNb6C1uoE=;
        b=IINufsBCwabC4xZ3Z7Ihw1NBxf6PRAByBJpQbktuQPIyE/vXWzkFTAqc+v3zdXazh6
         j59OZcOY3M0I5psnWKJfa0xg9HVk2PD0Hz6xUjvtpe9GX3D69rP8Qn5zng7J5mToEicP
         1ndjesa6p3amTdGZo8/u4drldThhVJ1zoqcLT6K7+ZudeQazL13KWelevKKGbYrDUjyb
         37KlIRGoapUge1ttfwfG6UccFvcS4Bwp2OHvaIQAz4BwkvBTS9xVm9RBJ+9VyAfn5noW
         XchJq03f5QsJU9kZHZCuIBH486GWwYuc9D9aa6HkSko9PMYRh7b0sMoi11VcPSAxvvzw
         962A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Zrvea35cbkKvmw3GyO8mr45YaSmzw+Vm5XNb6C1uoE=;
        b=fjo9qmuQwq6elmQ3Suj03Snuyw0v2w33JU2WGwmRSKcErFFQIylgdmI5tpfViv76fv
         zjq3SmC8gIO0BdrOMJ5hUCSrED0bVgLwHaTONN0pGEXBZDJIzhwalOLOS2UmpaMobxT6
         te+gns8Fri4esaIhidPnghOxgMLLy1innoC5Ih3wKauzEYnYKAr7QHC+C5UwdWsBJIHq
         Ta0rXlWsdwlo5LzLfnDhN72O0M0W/hDrAuqccbAmKPYK3fkXQtdPq99whjlnvWn19uqg
         UXBRqWSLd3uu78ul7DIjEH+DTGXdksh9z1XdVpjAwKM5WPVQQSpZh/o1UI9pQaaF6515
         7VbA==
X-Gm-Message-State: APjAAAUrZlrMoMXkC9FkI3yHCVl9X+27WhQ6xfuipjzpzuZytPe/n7rP
        AA3f0zKrOBruNvVyXcdYEn89fA==
X-Google-Smtp-Source: APXvYqzwXebON2Qs5+W0zhKWg9zKJCZ0HYJ93OMl4DNPh7Vh1EY8nWZAwrcivqUOiKzvTNuLFdPIGA==
X-Received: by 2002:a63:306:: with SMTP id 6mr20591909pgd.263.1560481913746;
        Thu, 13 Jun 2019 20:11:53 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id a3sm1351944pje.3.2019.06.13.20.11.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:11:52 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 00/45] V4.4 backport of arm64 Spectre patches
Date:   Fri, 14 Jun 2019 08:37:43 +0530
Message-Id: <cover.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Here is an attempt to backport arm64 spectre patches to v4.4 stable
tree.

I have started this backport with Mark Rutland's backport of Spectre to
4.9 [1] and tried applying the upstream version of them over 4.4 and
resolved conflicts by checking how they have been resolved in 4.9.

I had to pick few extra upstream patches to avoid unnecessary conflicts
(upstream commit ids mentioned):

  a842789837c0 arm64: remove duplicate macro __KERNEL__ check
  64f8ebaf115b mm/kasan: add API to check memory regions
  bffe1baff5d5 arm64: kasan: instrument user memory access API
  92406f0cc9e3 arm64: cpufeature: Add scope for capability check
  9eb8a2cdf65c arm64: cputype info for Broadcom Vulcan
  0d90718871fe arm64: cputype: Add MIDR values for Cavium ThunderX2 CPUs
  98dd64f34f47 ARM: 8478/2: arm/arm64: add arm-smccc


I had to drop few patches as well as they weren't getting applied
properly due to missing files/features (upstream commit id mentioned):

  93f339ef4175 arm64: cpufeature: __this_cpu_has_cap() shouldn't stop early
  3c31fa5a06b4 arm64: Run enable method for errata work arounds on late CPUs
  6840bdd73d07 arm64: KVM: Use per-CPU vector when BP hardening is enabled
  90348689d500 arm64: KVM: Make PSCI_VERSION a fast path


Since v4.4 doesn't contain arch/arm/kvm/hyp/switch.c file, changes for
it are dropped from some of the patches. The commit log of specific
patches are updated with this information.

Also for commit id (from 4.9 stable):
  c24c205d2528 arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support

I have dropped arch/arm64/crypto/sha256-core.S and sha512-core.S files
as they weren't part of the upstream commit. Not sure why it was
included by Mark as the commit log doesn't provide any reasoning for it.

The patches in this series are pushed here [2].

This is only build/boot tested by me as I don't have access to the
required test-suite which can verify spectre mitigations.

@Julien: Can you please help reviewing / testing them ? Thanks.

--
viresh

[1] https://patches.linaro.org/cover/133195/ with top commit in 4.9 stable tree:
    a3b292fe0560 arm64: futex: Mask __user pointers prior to dereference

[2] https://git.kernel.org/pub/scm/linux/kernel/git/vireshk/linux.git stable/v4.4.y/spectre


Andrey Ryabinin (1):
  mm/kasan: add API to check memory regions

Catalin Marinas (1):
  arm64: Factor out TTBR0_EL1 post-update workaround into a specific asm
    macro

Jayachandran C (3):
  arm64: cputype info for Broadcom Vulcan
  arm64: cputype: Add MIDR values for Cavium ThunderX2 CPUs
  arm64: Branch predictor hardening for Cavium ThunderX2

Jens Wiklander (1):
  ARM: 8478/2: arm/arm64: add arm-smccc

Laura Abbott (1):
  mm: Introduce lm_alias

Marc Zyngier (14):
  arm64: Move post_ttbr_update_workaround to C code
  arm64: Move BP hardening to check_and_switch_context
  arm64: cpu_errata: Allow an erratum to be match for all revisions of a
    core
  arm64: KVM: Increment PC after handling an SMC trap
  arm/arm64: KVM: Add PSCI_VERSION helper
  arm/arm64: KVM: Add smccc accessors to PSCI code
  arm/arm64: KVM: Implement PSCI 1.0 support
  arm64: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast handling
  firmware/psci: Expose PSCI conduit
  firmware/psci: Expose SMCCC version through psci_ops
  arm/arm64: smccc: Make function identifiers an unsigned quantity
  arm/arm64: smccc: Implement SMCCC v1.1 inline primitive
  arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support
  arm64: Kill PSCI_GET_VERSION as a variant-2 workaround

Mark Rutland (4):
  arm/arm64: KVM: Consolidate the PSCI include files
  arm/arm64: KVM: Advertise SMCCC v1.1
  arm/arm64: KVM: Turn kvm_psci_version into a static inline
  arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support

Robin Murphy (3):
  arm64: Implement array_index_mask_nospec()
  arm64: Make USER_DS an inclusive limit
  arm64: Use pointer masking to limit uaccess speculation

Suzuki K Poulose (1):
  arm64: cpufeature: Add scope for capability check

Will Deacon (13):
  arm64: barrier: Add CSDB macros to control data-value prediction
  arm64: entry: Ensure branch through syscall table is bounded under
    speculation
  arm64: uaccess: Prevent speculative use of the current addr_limit
  arm64: uaccess: Don't bother eliding access_ok checks in __{get,
    put}_user
  arm64: uaccess: Mask __user pointers for __arch_{clear, copy_*}_user
  arm64: cpufeature: Pass capability structure to ->enable callback
  drivers/firmware: Expose psci_get_version through psci_ops structure
  arm64: Add skeleton to harden the branch predictor against aliasing
    attacks
  arm64: entry: Apply BP hardening for high-priority synchronous
    exceptions
  arm64: entry: Apply BP hardening for suspicious interrupts from EL0
  arm64: cputype: Add missing MIDR values for Cortex-A72 and Cortex-A75
  arm64: Implement branch predictor hardening for affected Cortex-A CPUs
  arm64: futex: Mask __user pointers prior to dereference

Yang Shi (1):
  arm64: kasan: instrument user memory access API

Yury Norov (1):
  arm64: move TASK_* definitions to <asm/processor.h>

zijun_hu (1):
  arm64: remove duplicate macro __KERNEL__ check

 MAINTAINERS                         |  14 ++
 arch/arm/include/asm/kvm_host.h     |   6 +
 arch/arm/include/asm/kvm_psci.h     |  27 ---
 arch/arm/kvm/arm.c                  |   2 +-
 arch/arm/kvm/handle_exit.c          |   4 +-
 arch/arm/kvm/psci.c                 | 143 ++++++++++++---
 arch/arm64/Kconfig                  |  17 ++
 arch/arm64/include/asm/assembler.h  |  18 ++
 arch/arm64/include/asm/barrier.h    |  23 +++
 arch/arm64/include/asm/cpufeature.h |  12 +-
 arch/arm64/include/asm/cputype.h    |  12 ++
 arch/arm64/include/asm/futex.h      |   9 +-
 arch/arm64/include/asm/kvm_host.h   |   5 +
 arch/arm64/include/asm/kvm_psci.h   |  27 ---
 arch/arm64/include/asm/memory.h     |  15 --
 arch/arm64/include/asm/mmu.h        |  39 ++++
 arch/arm64/include/asm/processor.h  |  26 ++-
 arch/arm64/include/asm/sysreg.h     |   2 +
 arch/arm64/include/asm/uaccess.h    | 175 ++++++++++++------
 arch/arm64/kernel/Makefile          |   5 +
 arch/arm64/kernel/arm64ksyms.c      |   8 +-
 arch/arm64/kernel/bpi.S             |  75 ++++++++
 arch/arm64/kernel/cpu_errata.c      | 185 ++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c      | 112 ++++++------
 arch/arm64/kernel/entry.S           |  26 ++-
 arch/arm64/kvm/handle_exit.c        |  16 +-
 arch/arm64/kvm/hyp.S                |  20 ++-
 arch/arm64/lib/clear_user.S         |   6 +-
 arch/arm64/lib/copy_from_user.S     |   4 +-
 arch/arm64/lib/copy_in_user.S       |   4 +-
 arch/arm64/lib/copy_to_user.S       |   4 +-
 arch/arm64/mm/context.c             |  12 ++
 arch/arm64/mm/fault.c               |  31 ++++
 arch/arm64/mm/proc.S                |  12 +-
 drivers/firmware/Kconfig            |   3 +
 drivers/firmware/psci.c             |  58 +++++-
 include/kvm/arm_psci.h              |  51 ++++++
 include/linux/arm-smccc.h           | 267 ++++++++++++++++++++++++++++
 include/linux/kasan-checks.h        |  12 ++
 include/linux/mm.h                  |   4 +
 include/linux/psci.h                |  14 ++
 include/uapi/linux/psci.h           |   3 +
 mm/kasan/kasan.c                    |  12 ++
 43 files changed, 1270 insertions(+), 250 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_psci.h
 delete mode 100644 arch/arm64/include/asm/kvm_psci.h
 create mode 100644 arch/arm64/kernel/bpi.S
 create mode 100644 include/kvm/arm_psci.h
 create mode 100644 include/linux/arm-smccc.h
 create mode 100644 include/linux/kasan-checks.h

-- 
2.21.0.rc0.269.g1a574e7a288b

