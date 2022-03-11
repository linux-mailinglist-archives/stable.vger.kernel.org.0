Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EE34D5EF6
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 10:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346694AbiCKJ7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 04:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347741AbiCKJ7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 04:59:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7CA29815;
        Fri, 11 Mar 2022 01:57:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 297DAB82A51;
        Fri, 11 Mar 2022 09:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF65C340E9;
        Fri, 11 Mar 2022 09:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646992666;
        bh=TlDKXRJP8g+zPbOArl+lDTVPe4L2hwaGQqxQ7NQQgho=;
        h=From:To:Cc:Subject:Date:From;
        b=Lrw7AXAfvAHFetL7ZavLHZ7im1XZieixKl83nUEpiu7roX0qjXq69d4GQxxNjtXDm
         VjH2ZbW1DaFWY9/Tp6uKw1QZ91yeSHnml6J7kAv5pjOdHhTrnV91CT9kO0Z1vAhpqG
         m4+vczqvPUnNbo/GRdNa3gLc42LCotTfUSf5jTvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.234
Date:   Fri, 11 Mar 2022 10:57:28 +0100
Message-Id: <1646992649239226@kroah.com>
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

I'm announcing the release of the 4.19.234 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst   |   48 +++--
 Documentation/admin-guide/kernel-parameters.txt |    8 
 Makefile                                        |    2 
 arch/arm/include/asm/assembler.h                |   10 +
 arch/arm/include/asm/spectre.h                  |   32 +++
 arch/arm/kernel/Makefile                        |    2 
 arch/arm/kernel/entry-armv.S                    |   79 ++++++++
 arch/arm/kernel/entry-common.S                  |   24 ++
 arch/arm/kernel/spectre.c                       |   71 +++++++
 arch/arm/kernel/traps.c                         |   65 ++++++-
 arch/arm/kernel/vmlinux.lds.h                   |   43 +++-
 arch/arm/mm/Kconfig                             |   11 +
 arch/arm/mm/proc-v7-bugs.c                      |  201 +++++++++++++++++++---
 arch/x86/include/asm/cpufeatures.h              |    2 
 arch/x86/include/asm/nospec-branch.h            |   16 +
 arch/x86/kernel/cpu/bugs.c                      |  214 +++++++++++++++++-------
 drivers/block/xen-blkfront.c                    |   63 ++++---
 drivers/firmware/psci.c                         |   15 +
 drivers/net/xen-netfront.c                      |   54 +++---
 drivers/scsi/xen-scsifront.c                    |    3 
 drivers/xen/gntalloc.c                          |   25 --
 drivers/xen/grant-table.c                       |   71 ++++---
 drivers/xen/pvcalls-front.c                     |    8 
 drivers/xen/xenbus/xenbus_client.c              |   24 +-
 include/linux/arm-smccc.h                       |   74 ++++++++
 include/linux/bpf.h                             |   11 +
 include/xen/grant_table.h                       |   19 +-
 init/Kconfig                                    |    3 
 kernel/sysctl.c                                 |    8 
 net/9p/trans_xen.c                              |   14 -
 tools/arch/x86/include/asm/cpufeatures.h        |    2 
 31 files changed, 962 insertions(+), 260 deletions(-)

Borislav Petkov (1):
      x86/speculation: Merge one test in spectre_v2_user_select_mitigation()

Emmanuel Gil Peyrot (1):
      ARM: fix build error when BPF_SYSCALL is disabled

Greg Kroah-Hartman (1):
      Linux 4.19.234

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

Mark Rutland (1):
      arm/arm64: smccc/psci: add arm_smccc_1_1_get_conduit()

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

Sami Tolvanen (1):
      kbuild: add CONFIG_LD_IS_LLD

Steven Price (1):
      arm/arm64: Provide a wrapper for SMCCC 1.1 calls

