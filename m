Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A868B4D6080
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348169AbiCKLXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbiCKLXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:23:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EE8EFFA8;
        Fri, 11 Mar 2022 03:22:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17A67B82B50;
        Fri, 11 Mar 2022 11:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7011DC340F5;
        Fri, 11 Mar 2022 11:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646997719;
        bh=zG9sD4lExWMbS9kOUv/da3D25pIhkkdnvYNUq/5JKdM=;
        h=From:To:Cc:Subject:Date:From;
        b=Ik3tCOHS9sw4KnoUe4aH/BXUraWsu53Yx3s/tKGcGpYpOaqPeXyj4dqfbP+YZ9vx9
         M0oRStQsHmfMra7dDVpEbKUL0zPhGWcw+6KjPnH6nv7pctc+EJqqtQNtHc1nF4QCTj
         pkUZm9NGkNdeOwTH23cPFBLc5a/JSkihOsPy9IS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.105
Date:   Fri, 11 Mar 2022 12:21:55 +0100
Message-Id: <164699771512242@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.105 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst   |   48 ++-
 Documentation/admin-guide/kernel-parameters.txt |    8 
 Documentation/arm64/cpu-feature-registers.rst   |   29 +
 Documentation/arm64/elf_hwcaps.rst              |   12 
 Makefile                                        |    2 
 arch/arm/include/asm/assembler.h                |   10 
 arch/arm/include/asm/spectre.h                  |   32 ++
 arch/arm/include/asm/vmlinux.lds.h              |   43 ++
 arch/arm/kernel/Makefile                        |    2 
 arch/arm/kernel/entry-armv.S                    |   79 ++++-
 arch/arm/kernel/entry-common.S                  |   24 +
 arch/arm/kernel/spectre.c                       |   71 ++++
 arch/arm/kernel/traps.c                         |   65 +++-
 arch/arm/mm/Kconfig                             |   11 
 arch/arm/mm/proc-v7-bugs.c                      |  208 +++++++++++--
 arch/arm64/Kconfig                              |    9 
 arch/arm64/include/asm/assembler.h              |   33 ++
 arch/arm64/include/asm/cpu.h                    |    1 
 arch/arm64/include/asm/cpucaps.h                |    3 
 arch/arm64/include/asm/cpufeature.h             |   28 +
 arch/arm64/include/asm/cputype.h                |   22 +
 arch/arm64/include/asm/fixmap.h                 |    6 
 arch/arm64/include/asm/hwcap.h                  |    3 
 arch/arm64/include/asm/insn.h                   |    1 
 arch/arm64/include/asm/kvm_asm.h                |    8 
 arch/arm64/include/asm/kvm_mmu.h                |    3 
 arch/arm64/include/asm/mmu.h                    |    6 
 arch/arm64/include/asm/sections.h               |    5 
 arch/arm64/include/asm/spectre.h                |    4 
 arch/arm64/include/asm/sysreg.h                 |   18 +
 arch/arm64/include/asm/vectors.h                |   73 ++++
 arch/arm64/include/uapi/asm/hwcap.h             |    3 
 arch/arm64/include/uapi/asm/kvm.h               |    5 
 arch/arm64/kernel/cpu_errata.c                  |    7 
 arch/arm64/kernel/cpufeature.c                  |   28 +
 arch/arm64/kernel/cpuinfo.c                     |    4 
 arch/arm64/kernel/entry.S                       |  213 ++++++++++----
 arch/arm64/kernel/proton-pack.c                 |  359 +++++++++++++++++++++++-
 arch/arm64/kernel/vmlinux.lds.S                 |    2 
 arch/arm64/kvm/arm.c                            |    3 
 arch/arm64/kvm/hyp/hyp-entry.S                  |    4 
 arch/arm64/kvm/hyp/smccc_wa.S                   |   75 +++++
 arch/arm64/kvm/hyp/vhe/switch.c                 |    9 
 arch/arm64/kvm/hypercalls.c                     |   12 
 arch/arm64/kvm/psci.c                           |   18 +
 arch/arm64/kvm/sys_regs.c                       |    2 
 arch/arm64/mm/mmu.c                             |   12 
 arch/x86/include/asm/cpufeatures.h              |    2 
 arch/x86/include/asm/nospec-branch.h            |   16 -
 arch/x86/kernel/cpu/bugs.c                      |  205 ++++++++++---
 drivers/acpi/ec.c                               |   10 
 drivers/acpi/sleep.c                            |   14 
 drivers/block/xen-blkfront.c                    |   63 ++--
 drivers/net/xen-netfront.c                      |   54 ++-
 drivers/scsi/xen-scsifront.c                    |    3 
 drivers/xen/gntalloc.c                          |   25 -
 drivers/xen/grant-table.c                       |   71 ++--
 drivers/xen/pvcalls-front.c                     |    8 
 drivers/xen/xenbus/xenbus_client.c              |   24 -
 include/linux/arm-smccc.h                       |    5 
 include/linux/bpf.h                             |   12 
 include/xen/grant_table.h                       |   19 +
 kernel/sysctl.c                                 |    7 
 net/9p/trans_xen.c                              |   14 
 tools/arch/x86/include/asm/cpufeatures.h        |    2 
 65 files changed, 1824 insertions(+), 353 deletions(-)

Anshuman Khandual (2):
      arm64: Add Cortex-X2 CPU part definition
      arm64: Add Cortex-A510 CPU part definition

Emmanuel Gil Peyrot (1):
      ARM: fix build error when BPF_SYSCALL is disabled

Greg Kroah-Hartman (2):
      Revert "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
      Linux 5.10.105

Hector Martin (1):
      arm64: cputype: Add CPU implementor & types for the Apple M1 cores

James Morse (20):
      arm64: entry.S: Add ventry overflow sanity checks
      arm64: spectre: Rename spectre_v4_patch_fw_mitigation_conduit
      arm64: entry: Make the trampoline cleanup optional
      arm64: entry: Free up another register on kpti's tramp_exit path
      arm64: entry: Move the trampoline data page before the text page
      arm64: entry: Allow tramp_alias to access symbols after the 4K boundary
      arm64: entry: Don't assume tramp_vectors is the start of the vectors
      arm64: entry: Move trampoline macros out of ifdef'd section
      arm64: entry: Make the kpti trampoline's kpti sequence optional
      arm64: entry: Allow the trampoline text to occupy multiple pages
      arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
      arm64: entry: Add vectors that have the bhb mitigation sequences
      arm64: entry: Add macro for reading symbol addresses from the trampoline
      arm64: Add percpu vectors for EL1
      arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of Spectre-v2
      KVM: arm64: Allow indirect vectors to be used without SPECTRE_V3A
      arm64: Mitigate spectre style branch history side channels
      KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
      arm64: Use the clearbhb instruction in mitigations
      arm64: proton-pack: Include unprivileged eBPF status in Spectre v2 mitigation reporting

Joey Gouly (3):
      arm64: add ID_AA64ISAR2_EL1 sys register
      arm64: cpufeature: add HWCAP for FEAT_AFP
      arm64: cpufeature: add HWCAP for FEAT_RPRES

Josh Poimboeuf (3):
      x86/speculation: Include unprivileged eBPF status in Spectre v2 mitigation reporting
      x86/speculation: Warn about Spectre v2 LFENCE mitigation
      x86/speculation: Warn about eIBRS + LFENCE + Unprivileged eBPF + SMT

Juergen Gross (11):
      xen/xenbus: don't let xenbus_grant_ring() remove grants in error case
      xen/grant-table: add gnttab_try_end_foreign_access()
      xen/blkfront: don't use gnttab_query_foreign_access() for mapped status
      xen/netfront: don't use gnttab_query_foreign_access() for mapped status
      xen/scsifront: don't use gnttab_query_foreign_access() for mapped status
      xen/gntalloc: don't use gnttab_query_foreign_access()
      xen: remove gnttab_query_foreign_access()
      xen/9p: use alloc/free_pages_exact()
      xen/pvcalls: use alloc/free_pages_exact()
      xen/gnttab: fix gnttab_end_foreign_access() without page specified
      xen/netfront: react properly to failing gnttab_end_foreign_access_ref()

Kim Phillips (2):
      x86/speculation: Use generic retpoline by default on AMD
      x86/speculation: Update link to AMD speculation whitepaper

Marc Zyngier (1):
      arm64: Add HWCAP for self-synchronising virtual counter

Nathan Chancellor (1):
      ARM: Do not use NOCROSSREFS directive with ld.lld

Peter Zijlstra (3):
      x86,bugs: Unconditionally allow spectre_v2=retpoline,amd
      x86/speculation: Add eIBRS + Retpoline options
      Documentation/hw-vuln: Update spectre doc

Peter Zijlstra (Intel) (1):
      x86/speculation: Rename RETPOLINE_AMD to RETPOLINE_LFENCE

Russell King (Oracle) (7):
      ARM: report Spectre v2 status through sysfs
      ARM: early traps initialisation
      ARM: use LOADADDR() to get load address of sections
      ARM: Spectre-BHB workaround
      ARM: include unprivileged BPF status in Spectre V2 reporting
      ARM: fix co-processor register typo
      ARM: fix build warning in proc-v7-bugs.c

Suzuki K Poulose (1):
      arm64: Add Neoverse-N2, Cortex-A710 CPU part definition

