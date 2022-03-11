Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DB54D5EEB
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 10:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiCKJ6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 04:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347534AbiCKJ6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 04:58:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A4A5F56;
        Fri, 11 Mar 2022 01:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B94FB82A4F;
        Fri, 11 Mar 2022 09:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9F1C340F3;
        Fri, 11 Mar 2022 09:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646992644;
        bh=rgx5tDDTBJtXYQUnQWsdbxYca95Qq71GgCQN2dH6SLI=;
        h=From:To:Cc:Subject:Date:From;
        b=CJwke/GatDt7MA9To8mG+Kxw/cjMD40S3s5iARGiDhxkA5JzcWfzJD/gvh4a491Y6
         f6o4U9vDrdbTSxQ/tWwV2+u67I24TB0deU/DEZzY1unPpFFSWcnhIoeu+b9M9PvWGy
         8Es+r1k2Gwv/tW53uj1DibwRc1bV+bfUe9vbv9zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.306
Date:   Fri, 11 Mar 2022 10:57:19 +0100
Message-Id: <1646992640229107@kroah.com>
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

I'm announcing the release of the 4.9.306 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/hw-vuln/index.rst          |    1 
 Documentation/hw-vuln/spectre.rst        |  785 +++++++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt      |    8 
 Makefile                                 |    2 
 arch/arm/include/asm/assembler.h         |   10 
 arch/arm/include/asm/spectre.h           |   32 +
 arch/arm/kernel/Makefile                 |    2 
 arch/arm/kernel/entry-armv.S             |   79 ++-
 arch/arm/kernel/entry-common.S           |   24 
 arch/arm/kernel/spectre.c                |   71 ++
 arch/arm/kernel/traps.c                  |   65 ++
 arch/arm/kernel/vmlinux-xip.lds.S        |   45 +
 arch/arm/kernel/vmlinux.lds.S            |   45 +
 arch/arm/mm/Kconfig                      |   11 
 arch/arm/mm/proc-v7-bugs.c               |  199 ++++++-
 arch/x86/Kconfig                         |    4 
 arch/x86/Makefile                        |   11 
 arch/x86/include/asm/cpufeatures.h       |    2 
 arch/x86/include/asm/nospec-branch.h     |   41 +
 arch/x86/kernel/cpu/bugs.c               |  225 ++++++--
 drivers/block/xen-blkfront.c             |   67 +-
 drivers/firmware/psci.c                  |   15 
 drivers/net/xen-netfront.c               |   54 +-
 drivers/scsi/xen-scsifront.c             |    3 
 drivers/xen/gntalloc.c                   |   25 
 drivers/xen/grant-table.c                |   59 +-
 drivers/xen/xenbus/xenbus_client.c       |   24 
 include/linux/arm-smccc.h                |   74 ++
 include/linux/bpf.h                      |   11 
 include/linux/compiler-gcc.h             |    2 
 include/linux/module.h                   |    2 
 include/xen/grant_table.h                |   19 
 kernel/sysctl.c                          |    8 
 scripts/mod/modpost.c                    |    2 
 tools/arch/x86/include/asm/cpufeatures.h |    2 
 35 files changed, 1762 insertions(+), 267 deletions(-)

Borislav Petkov (1):
      x86/speculation: Merge one test in spectre_v2_user_select_mitigation()

Emmanuel Gil Peyrot (1):
      ARM: fix build error when BPF_SYSCALL is disabled

Greg Kroah-Hartman (1):
      Linux 4.9.306

Josh Poimboeuf (4):
      Documentation: Add swapgs description to the Spectre v1 documentation
      x86/speculation: Include unprivileged eBPF status in Spectre v2 mitigation reporting
      x86/speculation: Warn about Spectre v2 LFENCE mitigation
      x86/speculation: Warn about eIBRS + LFENCE + Unprivileged eBPF + SMT

Juergen Gross (9):
      xen/xenbus: don't let xenbus_grant_ring() remove grants in error case
      xen/grant-table: add gnttab_try_end_foreign_access()
      xen/blkfront: don't use gnttab_query_foreign_access() for mapped status
      xen/netfront: don't use gnttab_query_foreign_access() for mapped status
      xen/scsifront: don't use gnttab_query_foreign_access() for mapped status
      xen/gntalloc: don't use gnttab_query_foreign_access()
      xen: remove gnttab_query_foreign_access()
      xen/gnttab: fix gnttab_end_foreign_access() without page specified
      xen/netfront: react properly to failing gnttab_end_foreign_access_ref()

Kim Phillips (2):
      x86/speculation: Use generic retpoline by default on AMD
      x86/speculation: Update link to AMD speculation whitepaper

Lukas Bulwahn (1):
      Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization

Mark Rutland (1):
      arm/arm64: smccc/psci: add arm_smccc_1_1_get_conduit()

Masahiro Yamada (1):
      x86/build: Fix compiler support check for CONFIG_RETPOLINE

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

Steven Price (1):
      arm/arm64: Provide a wrapper for SMCCC 1.1 calls

Tim Chen (1):
      Documentation: Add section about CPU vulnerabilities for Spectre

WANG Chao (1):
      x86, modpost: Replace last remnants of RETPOLINE with CONFIG_RETPOLINE

Zhenzhong Duan (3):
      x86/speculation: Add RETPOLINE_AMD support to the inline asm CALL_NOSPEC variant
      x86/retpoline: Make CONFIG_RETPOLINE depend on compiler support
      x86/retpoline: Remove minimal retpoline support

