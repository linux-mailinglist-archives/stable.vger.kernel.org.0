Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E9FF4BB9
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKHMgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfKHMgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:13 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF064222C6;
        Fri,  8 Nov 2019 12:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216572;
        bh=WTA8LsXObtaUSCLcodDurQ9Sa3MiSXROxvhyRria2Yc=;
        h=From:To:Cc:Subject:Date:From;
        b=L/BxXA5H+W3vgzgLt2Rj8HCs1jl/r9bR88vu3TYoISb/4F24VbOpOyK51ibLl+8lt
         e6uooAmFZv39isbI0v2xLX22cn9P9HuqTLkA9MSqCUlooWuYGiJh3sEhJ8P3S6gWtz
         mBuq+dVHVy7wDrZl4ETCG3pXlOyeoIa9Be745zfs=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 00/50] ARM: spectre v1/v2 mitigations
Date:   Fri,  8 Nov 2019 13:35:04 +0100
Message-Id: <20191108123554.29004-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport to v4.4 of the Spectre v1 and v2 mitigations for 32-bit
ARM that have already been backported to v4.9.

Patches #17 and up were cherry-picked from the v4.9 tree, and applied cleanly.
The first 16 patches are prerequisites that were introduced between v4.4 and
v4.9, and some needed minor massaging to apply. Some notable issues:
- the 32-bit KVM host parts were omitted, given the lack of demand and the
  fact that those pieces saw significantly more churn during the v4.4-v4.9
  timeframe due to the fact that the code is shared with arm64
- some other changes are shared between ARM and arm64 (notably, the ARM SMCCCC
  changes), so the backport affects both architectures.

Patches can be found at [0]. They were build and boot tested using a variety
of ARM and arm64 configs and platforms, both locally and on KernelCI.

An RFC of this series was sent out to the linux-arm-kernel mailing list
and cc'ed to the maintainer, and no objections were raised. (The only
difference between the RFC and this submission is that I have dropped
a couple of mostly unrelated patches that were only there to make patch #8
match its context more closely in the file include/linux/arm-smccc.h)

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>

[0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=arm32-v4.4-backport
[1] https://lore.kernel.org/linux-arm-kernel/20191105205846.1394-1-ardb@kernel.org/

Andrey Ryabinin (1):
  ARM: 8051/1: put_user: fix possible data corruption in put_user

Jens Wiklander (4):
  ARM: 8478/2: arm/arm64: add arm-smccc
  ARM: 8479/2: add implementation for arm-smccc
  ARM: 8480/2: arm64: add implementation for arm-smccc
  ARM: 8481/2: drivers: psci: replace psci firmware calls

Julien Thierry (8):
  ARM: 8789/1: signal: copy registers using __copy_to_user()
  ARM: 8791/1: vfp: use __copy_to_user() when saving VFP state
  ARM: 8792/1: oabi-compat: copy oabi events using __copy_to_user()
  ARM: 8793/1: signal: replace __put_user_error with __put_user
  ARM: 8794/1: uaccess: Prevent speculative use of the current
    addr_limit
  ARM: 8795/1: spectre-v1.1: use put_user() for __put_user()
  ARM: 8796/1: spectre-v1,v1.1: provide helpers for address sanitization
  ARM: 8810/1: vfp: Fix wrong assignement to ufp_exc

Marc Zyngier (3):
  arm/arm64: smccc: Add SMCCC-specific return codes
  arm/arm64: smccc-1.1: Make return values unsigned long
  arm/arm64: smccc-1.1: Handle function result as parameters

Mark Rutland (6):
  arm/arm64: KVM: Advertise SMCCC v1.1
  arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
  firmware/psci: Expose PSCI conduit
  firmware/psci: Expose SMCCC version through psci_ops
  arm/arm64: smccc: Make function identifiers an unsigned quantity
  arm/arm64: smccc: Implement SMCCC v1.1 inline primitive

Russell King (27):
  ARM: uaccess: remove put_user() code duplication
  ARM: add more CPU part numbers for Cortex and Brahma B15 CPUs
  ARM: bugs: prepare processor bug infrastructure
  ARM: bugs: hook processor bug checking into SMP and suspend paths
  ARM: bugs: add support for per-processor bug checking
  ARM: spectre: add Kconfig symbol for CPUs vulnerable to Spectre
  ARM: spectre-v2: harden branch predictor on context switches
  ARM: spectre-v2: add Cortex A8 and A15 validation of the IBE bit
  ARM: spectre-v2: harden user aborts in kernel space
  ARM: spectre-v2: add firmware based hardening
  ARM: spectre-v2: warn about incorrect context switching functions
  ARM: spectre-v1: add speculation barrier (csdb) macros
  ARM: spectre-v1: add array_index_mask_nospec() implementation
  ARM: spectre-v1: fix syscall entry
  ARM: signal: copy registers using __copy_from_user()
  ARM: vfp: use __copy_from_user() when restoring VFP state
  ARM: oabi-compat: copy semops using __copy_from_user()
  ARM: use __inttype() in get_user()
  ARM: spectre-v1: use get_user() for __get_user()
  ARM: spectre-v1: mitigate user accesses
  ARM: make lookup_processor_type() non-__init
  ARM: split out processor lookup
  ARM: clean up per-processor check_bugs method call
  ARM: add PROC_VTABLE and PROC_TABLE macros
  ARM: spectre-v2: per-CPU vtables to work around big.Little systems
  ARM: ensure that processor vtables is not lost after boot
  ARM: fix the cockup in the previous patch

Vladimir Murzin (1):
  ARM: Move system register accessors to asm/cp15.h

 arch/arm/Kconfig                   |   3 +-
 arch/arm/include/asm/arch_gicv3.h  |  27 +-
 arch/arm/include/asm/assembler.h   |  23 ++
 arch/arm/include/asm/barrier.h     |  34 +++
 arch/arm/include/asm/bugs.h        |   6 +-
 arch/arm/include/asm/cp15.h        |  18 ++
 arch/arm/include/asm/cputype.h     |   9 +
 arch/arm/include/asm/proc-fns.h    |  65 ++++-
 arch/arm/include/asm/system_misc.h |  15 ++
 arch/arm/include/asm/thread_info.h |   8 +-
 arch/arm/include/asm/uaccess.h     | 177 +++++++-----
 arch/arm/kernel/Makefile           |   4 +-
 arch/arm/kernel/armksyms.c         |   6 +
 arch/arm/kernel/bugs.c             |  18 ++
 arch/arm/kernel/entry-common.S     |  18 +-
 arch/arm/kernel/entry-header.S     |  25 ++
 arch/arm/kernel/head-common.S      |   6 +-
 arch/arm/kernel/psci-call.S        |  31 ---
 arch/arm/kernel/setup.c            |  40 +--
 arch/arm/kernel/signal.c           | 125 +++++----
 arch/arm/kernel/smccc-call.S       |  62 +++++
 arch/arm/kernel/smp.c              |  36 +++
 arch/arm/kernel/suspend.c          |   2 +
 arch/arm/kernel/sys_oabi-compat.c  |  16 +-
 arch/arm/lib/copy_from_user.S      |   5 +
 arch/arm/mm/Kconfig                |  23 ++
 arch/arm/mm/Makefile               |   2 +-
 arch/arm/mm/fault.c                |   3 +
 arch/arm/mm/proc-macros.S          |  13 +-
 arch/arm/mm/proc-v7-2level.S       |   6 -
 arch/arm/mm/proc-v7-bugs.c         | 161 +++++++++++
 arch/arm/mm/proc-v7.S              | 154 ++++++++---
 arch/arm/vfp/vfpmodule.c           |  37 ++-
 arch/arm64/Kconfig                 |   1 +
 arch/arm64/kernel/Makefile         |   4 +-
 arch/arm64/kernel/arm64ksyms.c     |   5 +
 arch/arm64/kernel/asm-offsets.c    |   3 +
 arch/arm64/kernel/psci-call.S      |  28 --
 arch/arm64/kernel/smccc-call.S     |  43 +++
 drivers/firmware/Kconfig           |   3 +
 drivers/firmware/psci.c            |  78 +++++-
 include/linux/arm-smccc.h          | 283 ++++++++++++++++++++
 include/linux/psci.h               |  13 +
 43 files changed, 1313 insertions(+), 326 deletions(-)
 create mode 100644 arch/arm/kernel/bugs.c
 delete mode 100644 arch/arm/kernel/psci-call.S
 create mode 100644 arch/arm/kernel/smccc-call.S
 create mode 100644 arch/arm/mm/proc-v7-bugs.c
 delete mode 100644 arch/arm64/kernel/psci-call.S
 create mode 100644 arch/arm64/kernel/smccc-call.S
 create mode 100644 include/linux/arm-smccc.h

-- 
2.20.1

