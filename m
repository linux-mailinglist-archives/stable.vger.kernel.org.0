Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508394D6113
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbiCKL46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiCKL45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:56:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EDC10708B;
        Fri, 11 Mar 2022 03:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52AED61D13;
        Fri, 11 Mar 2022 11:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564ABC340E9;
        Fri, 11 Mar 2022 11:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646999753;
        bh=k5OXGMl+D8vYAl28+w6codL2CoiyZ4ETbJQkUt9XGCA=;
        h=From:To:Cc:Subject:Date:From;
        b=G6priS1Eq+KZ2Hye7tPG5E7M0Gw6Ffr2ga5fmeO+ZL2CE1/0omEcAC73bA+mpDBLU
         GbffYIpmqx5atxfkyqGnw+bcpRlNQqIYN3aVSUiNAA0oX7zHwojGjU3EyMPzzki34V
         0CjQzB4q6M9a6RTD2eBRNXNYn+bndIIktX0Aok7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.14
Date:   Fri, 11 Mar 2022 12:55:49 +0100
Message-Id: <164699974918063@kroah.com>
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

I'm announcing the release of the 5.16.14 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst   |   50 ++-
 Documentation/admin-guide/kernel-parameters.txt |    8 
 Documentation/arm64/cpu-feature-registers.rst   |   17 +
 Documentation/arm64/elf_hwcaps.rst              |    8 
 Makefile                                        |    2 
 arch/arm/include/asm/assembler.h                |   10 
 arch/arm/include/asm/spectre.h                  |   32 +
 arch/arm/include/asm/vmlinux.lds.h              |   43 ++
 arch/arm/kernel/Makefile                        |    2 
 arch/arm/kernel/entry-armv.S                    |   79 ++++
 arch/arm/kernel/entry-common.S                  |   24 +
 arch/arm/kernel/spectre.c                       |   71 ++++
 arch/arm/kernel/traps.c                         |   65 +++
 arch/arm/mm/Kconfig                             |   11 
 arch/arm/mm/proc-v7-bugs.c                      |  208 ++++++++++--
 arch/arm64/Kconfig                              |    9 
 arch/arm64/include/asm/assembler.h              |   53 +++
 arch/arm64/include/asm/cpu.h                    |    1 
 arch/arm64/include/asm/cpufeature.h             |   29 +
 arch/arm64/include/asm/cputype.h                |    8 
 arch/arm64/include/asm/fixmap.h                 |    6 
 arch/arm64/include/asm/hwcap.h                  |    2 
 arch/arm64/include/asm/insn.h                   |    1 
 arch/arm64/include/asm/kvm_host.h               |    5 
 arch/arm64/include/asm/rwonce.h                 |    4 
 arch/arm64/include/asm/sections.h               |    5 
 arch/arm64/include/asm/spectre.h                |    4 
 arch/arm64/include/asm/sysreg.h                 |   18 +
 arch/arm64/include/asm/vectors.h                |   73 ++++
 arch/arm64/include/uapi/asm/hwcap.h             |    2 
 arch/arm64/include/uapi/asm/kvm.h               |    5 
 arch/arm64/kernel/cpu_errata.c                  |    7 
 arch/arm64/kernel/cpufeature.c                  |   25 +
 arch/arm64/kernel/cpuinfo.c                     |    3 
 arch/arm64/kernel/entry.S                       |  214 +++++++++----
 arch/arm64/kernel/image-vars.h                  |    4 
 arch/arm64/kernel/proton-pack.c                 |  391 +++++++++++++++++++++++-
 arch/arm64/kernel/vmlinux.lds.S                 |    2 
 arch/arm64/kvm/arm.c                            |    5 
 arch/arm64/kvm/hyp/hyp-entry.S                  |    9 
 arch/arm64/kvm/hyp/nvhe/mm.c                    |    4 
 arch/arm64/kvm/hyp/vhe/switch.c                 |    9 
 arch/arm64/kvm/hypercalls.c                     |   12 
 arch/arm64/kvm/psci.c                           |   18 +
 arch/arm64/kvm/sys_regs.c                       |    2 
 arch/arm64/mm/mmu.c                             |   12 
 arch/arm64/tools/cpucaps                        |    1 
 arch/x86/include/asm/cpufeatures.h              |    2 
 arch/x86/include/asm/nospec-branch.h            |   16 
 arch/x86/kernel/alternative.c                   |    8 
 arch/x86/kernel/cpu/bugs.c                      |  204 +++++++++---
 arch/x86/lib/retpoline.S                        |    2 
 arch/x86/net/bpf_jit_comp.c                     |    2 
 drivers/acpi/ec.c                               |   10 
 drivers/acpi/sleep.c                            |   14 
 drivers/block/xen-blkfront.c                    |   63 ++-
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
 68 files changed, 1781 insertions(+), 357 deletions(-)

Emmanuel Gil Peyrot (1):
      ARM: fix build error when BPF_SYSCALL is disabled

Greg Kroah-Hartman (2):
      Revert "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
      Linux 5.16.14

James Morse (20):
      arm64: entry.S: Add ventry overflow sanity checks
      arm64: spectre: Rename spectre_v4_patch_fw_mitigation_conduit
      KVM: arm64: Allow indirect vectors to be used without SPECTRE_V3A
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

Nathan Chancellor (2):
      ARM: Do not use NOCROSSREFS directive with ld.lld
      arm64: Do not include __READ_ONCE() block in assembly files

Peter Zijlstra (2):
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

