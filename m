Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9444FCF3D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348591AbiDLGDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348578AbiDLGDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:03:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86602E68A;
        Mon, 11 Apr 2022 23:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4554B61876;
        Tue, 12 Apr 2022 06:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A038C385A1;
        Tue, 12 Apr 2022 06:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649743272;
        bh=8oySYUnW/7GlC7l9j44YAFtXZz1Ne1H6iUNwIbnrork=;
        h=From:To:Cc:Subject:Date:From;
        b=LzwRc1BzhqVI9NBkHE/Lda3SWcmwmfvqLzV68LkbkIXzBwfm31GEpvK5nDTOSmzux
         n3AeCa7dChEL5zQKjjr5mdczZ0Owqc7Z8xQEWwnu0sMFO0/oOHusStOHlBkHAP2BgG
         zavBcC+/ifcP3eYuzFYjOdqkfAU4HiE6zJsqRAlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.310
Date:   Tue, 12 Apr 2022 08:01:04 +0200
Message-Id: <1649743264201115@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.310 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.txt |    1 
 Documentation/kernel-parameters.txt    |    9 
 Makefile                               |    2 
 arch/arm/include/asm/kvm_host.h        |    5 
 arch/arm/kvm/psci.c                    |    4 
 arch/arm64/Kconfig                     |   24 +
 arch/arm64/include/asm/arch_timer.h    |   44 +-
 arch/arm64/include/asm/assembler.h     |   34 +
 arch/arm64/include/asm/cpu.h           |    1 
 arch/arm64/include/asm/cpucaps.h       |    4 
 arch/arm64/include/asm/cpufeature.h    |  232 +++++++++++-
 arch/arm64/include/asm/cputype.h       |   63 +++
 arch/arm64/include/asm/fixmap.h        |    6 
 arch/arm64/include/asm/insn.h          |    2 
 arch/arm64/include/asm/kvm_host.h      |    4 
 arch/arm64/include/asm/kvm_mmu.h       |    2 
 arch/arm64/include/asm/mmu.h           |    8 
 arch/arm64/include/asm/processor.h     |    6 
 arch/arm64/include/asm/sections.h      |    6 
 arch/arm64/include/asm/sysreg.h        |    5 
 arch/arm64/include/asm/vectors.h       |   74 ++++
 arch/arm64/kernel/bpi.S                |   55 +++
 arch/arm64/kernel/cpu_errata.c         |  595 ++++++++++++++++++++++++++-------
 arch/arm64/kernel/cpufeature.c         |  167 ++++++---
 arch/arm64/kernel/cpuinfo.c            |    1 
 arch/arm64/kernel/entry.S              |  197 ++++++++--
 arch/arm64/kernel/fpsimd.c             |    1 
 arch/arm64/kernel/insn.c               |   29 +
 arch/arm64/kernel/smp.c                |    6 
 arch/arm64/kernel/traps.c              |    4 
 arch/arm64/kernel/vmlinux.lds.S        |    2 
 arch/arm64/kvm/hyp/hyp-entry.S         |    4 
 arch/arm64/kvm/hyp/switch.c            |    9 
 arch/arm64/mm/fault.c                  |   17 
 arch/arm64/mm/mmu.c                    |   11 
 drivers/clocksource/Kconfig            |    4 
 drivers/clocksource/arm_arch_timer.c   |  192 ++++++++--
 include/linux/arm-smccc.h              |    7 
 38 files changed, 1507 insertions(+), 330 deletions(-)

Anshuman Khandual (1):
      arm64: Add Cortex-X2 CPU part definition

Arnd Bergmann (1):
      arm64: arch_timer: avoid unused function warning

Dave Martin (1):
      arm64: capabilities: Update prototype for enable call back

Ding Tianhong (2):
      clocksource/drivers/arm_arch_timer: Remove fsl-a008585 parameter
      clocksource/drivers/arm_arch_timer: Introduce generic errata handling infrastructure

Greg Kroah-Hartman (1):
      Linux 4.9.310

James Morse (20):
      arm64: Remove useless UAO IPI and describe how this gets enabled
      arm64: entry.S: Add ventry overflow sanity checks
      arm64: entry: Make the trampoline cleanup optional
      arm64: entry: Free up another register on kpti's tramp_exit path
      arm64: entry: Move the trampoline data page before the text page
      arm64: entry: Allow tramp_alias to access symbols after the 4K boundary
      arm64: entry: Don't assume tramp_vectors is the start of the vectors
      arm64: entry: Move trampoline macros out of ifdef'd section
      arm64: entry: Make the kpti trampoline's kpti sequence optional
      arm64: entry: Allow the trampoline text to occupy multiple pages
      arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
      arm64: Move arm64_update_smccc_conduit() out of SSBD ifdef
      arm64: entry: Add vectors that have the bhb mitigation sequences
      arm64: entry: Add macro for reading symbol addresses from the trampoline
      arm64: Add percpu vectors for EL1
      KVM: arm64: Add templates for BHB mitigation sequences
      arm64: Mitigate spectre style branch history side channels
      KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
      arm64: add ID_AA64ISAR2_EL1 sys register
      arm64: Use the clearbhb instruction in mitigations

Marc Zyngier (6):
      arm64: arch_timer: Add infrastructure for multiple erratum detection methods
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

