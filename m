Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6550CE32C7
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfJXMsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:48:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40479 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfJXMsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:48:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so1303734wmm.5
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txEoJ8554brixsArEG7cSK/HZLmr9bOMKSTm/83Drkc=;
        b=u9trsbQEdXb6Zo/XCOi+xZ4AROTQa5h7W2zdDbrTVCV3B/QhRp7hNtMaerWIGhuGFB
         QkUwK5KuWacWWWvHL8JJ+va3MEpmVGPO5eInOSnTPnnxGqptEXb5h5+XZ3W/odklOsix
         6ZOAHSa0XZpiOFiWgEbAaPT/Wpkz+FH6tzH0soSamG3hWN3iJMmY+H5qvAdoBuYJ65jr
         5iXYRQgv8zrciXJRHoWVL5IYmWgZOa4azGExNVWBA8I3X1DfaR9XKy0zMjOdnAkxJVGA
         labSE8v5KaY5hbVPTfuynaJb6m8/bcAzU0l4V5W2OCbDHxlDlee2JFOPv3kEEVYp7wRc
         yDrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txEoJ8554brixsArEG7cSK/HZLmr9bOMKSTm/83Drkc=;
        b=Wrc4glxIQ7Z4S2Vmn/+WgyCC6VohZyYNuznwUxMH131DWuwIPJON7xid5akL8sacmp
         jwQYyY1NdU+y2QytAh/DYjg3UGEpONmCvujCCygKSR8v+RmqhaoK5UdeaLeFDh1Z/ILg
         xMWmcSBvlLSScv6NmANMeGGr8FJL3BKMiaCHtCXgqiQtceGRIrsX1ePgunZi6HOnQtns
         qLWHEspZJ6/ULh0UtevL2e22ohS54JNOHFJHmfD8QpZkTnltmdP+JkI7onBId6xHrW3e
         VLLN3MwvGxn+2J8MlFizpuH56VfnOPeiq57cCIKCahJkWP4Iea4xoMQESRwU25huOQY3
         vMqA==
X-Gm-Message-State: APjAAAUG9LTCQ94XZzrJ6PmGFni8Cqgdk0yaCdC/yL+cIbZXz8ue9v2F
        kdZJmGbpADAGnj8FR9aefYw1nCxW1DVb6DFK
X-Google-Smtp-Source: APXvYqyApIczPxUVzViN8r2MhLwRchxBW8kzEQ1DjAGYYl8Omy4ehRRkEdReYDr24B0uGmQVxb12QA==
X-Received: by 2002:a1c:7c10:: with SMTP id x16mr2571531wmc.117.1571921326878;
        Thu, 24 Oct 2019 05:48:46 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:48:45 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH for-stable-4.14 00/48] arm64 spec mitigation backports
Date:   Thu, 24 Oct 2019 14:47:45 +0200
Message-Id: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport to v4.14 of the arm64 patches that exist in mainline
and v4.19-stable to support CPUs that implement the SSBS capability, which
gives the OS and user space control over whether Speculative Store Bypass 
is permitted in certain contexts. This gives a substantial performance
boost on hardware that implements it.

At the same time, this series backports arm64 support for reporting
of vulnerabilities via syfs. This is covered by the same series since
it produces a much cleaner backport, where none of the 16 original patches
required any changes beyond some manual mangling of the context to make
them apply.

NOTE: in addition to the 16 patches that were also backported to v4.19
earlier, this series contains an additional 32 (!) patches that were
included as prerequisites, even though by themselves they wouldn't qualify
as stable backports. This was a conscious decision, and made the backport
considerably cleaner, and should also make future backports of arm64
specific fixes less painful.

Build tested using a fair number of randconfig builds. Boot tested
under KVM and on ThunderX2. Many thanks to Suzuki and Alexandru for the
internal review and testing.

Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>

Dave Martin (1):
  arm64: capabilities: Update prototype for enable call back

Dongjiu Geng (1):
  arm64: v8.4: Support for new floating point multiplication
    instructions

James Morse (1):
  arm64: sysreg: Move to use definitions for all the SCTLR bits

Jeremy Linton (6):
  arm64: add sysfs vulnerability show for meltdown
  arm64: Always enable ssb vulnerability detection
  arm64: Provide a command line to disable spectre_v2 mitigation
  arm64: Always enable spectre-v2 vulnerability detection
  arm64: add sysfs vulnerability show for spectre-v2
  arm64: add sysfs vulnerability show for speculative store bypass

Josh Poimboeuf (1):
  arm64/speculation: Support 'mitigations=' cmdline option

Marc Zyngier (4):
  arm64: Get rid of __smccc_workaround_1_hvc_*
  arm64: Advertise mitigation of Spectre-v2, or lack thereof
  arm64: Force SSBS on context switch
  arm64: Use firmware to detect CPUs that are not affected by Spectre-v2

Mark Rutland (5):
  arm64: move SCTLR_EL{1,2} assertions to <asm/sysreg.h>
  arm64: add PSR_AA32_* definitions
  arm64: Introduce sysreg_clear_set()
  arm64: don't zero DIT on signal return
  arm64: fix SSBS sanitization

Mian Yousaf Kaukab (2):
  arm64: Add sysfs vulnerability show for spectre-v1
  arm64: enable generic CPU vulnerabilites support

Shanker Donthineni (1):
  arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP hardening

Suzuki K Poulose (22):
  arm64: Expose support for optional ARMv8-A features
  arm64: Fix the feature type for ID register fields
  arm64: Documentation: cpu-feature-registers: Remove RES0 fields
  arm64: Expose Arm v8.4 features
  arm64: capabilities: Move errata work around check on boot CPU
  arm64: capabilities: Move errata processing code
  arm64: capabilities: Prepare for fine grained capabilities
  arm64: capabilities: Add flags to handle the conflicts on late CPU
  arm64: capabilities: Unify the verification
  arm64: capabilities: Filter the entries based on a given mask
  arm64: capabilities: Prepare for grouping features and errata work
    arounds
  arm64: capabilities: Split the processing of errata work arounds
  arm64: capabilities: Allow features based on local CPU scope
  arm64: capabilities: Group handling of features and errata workarounds
  arm64: capabilities: Introduce weak features based on local CPU
  arm64: capabilities: Restrict KPTI detection to boot-time CPUs
  arm64: capabilities: Add support for features enabled early
  arm64: capabilities: Change scope of VHE to Boot CPU feature
  arm64: capabilities: Clean up midr range helpers
  arm64: Add helpers for checking CPU MIDR against a range
  arm64: Add MIDR encoding for Arm Cortex-A55 and Cortex-A35
  arm64: capabilities: Add support for checks based on a list of MIDRs

Will Deacon (4):
  arm64: cpufeature: Detect SSBS and advertise to userspace
  arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3
  KVM: arm64: Set SCTLR_EL2.DSSBS if SSBD is forcefully disabled and
    !vhe
  arm64: ssbs: Don't treat CPUs with SSBS as unaffected by SSB

 Documentation/admin-guide/kernel-parameters.txt |  16 +-
 Documentation/arm64/cpu-feature-registers.txt   |  26 +-
 arch/arm64/Kconfig                              |   1 +
 arch/arm64/include/asm/cpucaps.h                |   6 +-
 arch/arm64/include/asm/cpufeature.h             | 250 +++++++++-
 arch/arm64/include/asm/cputype.h                |  43 ++
 arch/arm64/include/asm/kvm_asm.h                |   2 -
 arch/arm64/include/asm/kvm_host.h               |  11 +
 arch/arm64/include/asm/processor.h              |  22 +-
 arch/arm64/include/asm/ptrace.h                 |  58 ++-
 arch/arm64/include/asm/sysreg.h                 |  95 +++-
 arch/arm64/include/asm/virt.h                   |   6 -
 arch/arm64/include/uapi/asm/hwcap.h             |  12 +
 arch/arm64/include/uapi/asm/ptrace.h            |   1 +
 arch/arm64/kernel/bpi.S                         |  19 +-
 arch/arm64/kernel/cpu_errata.c                  | 495 +++++++++++--------
 arch/arm64/kernel/cpufeature.c                  | 517 ++++++++++++++------
 arch/arm64/kernel/cpuinfo.c                     |  12 +
 arch/arm64/kernel/fpsimd.c                      |   1 +
 arch/arm64/kernel/head.S                        |  13 +-
 arch/arm64/kernel/process.c                     |  31 ++
 arch/arm64/kernel/ptrace.c                      |  13 +-
 arch/arm64/kernel/smp.c                         |  44 --
 arch/arm64/kernel/ssbd.c                        |  22 +
 arch/arm64/kernel/traps.c                       |   4 +-
 arch/arm64/kvm/hyp/entry.S                      |  12 -
 arch/arm64/kvm/hyp/switch.c                     |  10 -
 arch/arm64/kvm/hyp/sysreg-sr.c                  |  11 +
 arch/arm64/mm/fault.c                           |   3 +-
 arch/arm64/mm/proc.S                            |  24 +-
 30 files changed, 1268 insertions(+), 512 deletions(-)

-- 
2.20.1

