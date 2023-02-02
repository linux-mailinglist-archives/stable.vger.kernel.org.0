Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366C3687515
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjBBF2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBBF2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:28:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAC886B3;
        Wed,  1 Feb 2023 21:28:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C776B60ABE;
        Thu,  2 Feb 2023 05:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5D8C433EF;
        Thu,  2 Feb 2023 05:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675315680;
        bh=NhqgdfaLi4iMMTFGDQKY/H8WKJ0eXjK92fSiRVm2+qM=;
        h=From:To:Cc:Subject:Date:From;
        b=r+4oJTpJCIYwur0074FiTYZTKUfcWG8k5EEUvYXL43RZdhLnftbKsrlGTAb8oLUGR
         /1GqLnZ8Xq+Ju676LY+SSuyBTkwCOJRMG5S8oGPDUBOyb4EQbBOtPdgZtbmRPOagEz
         KwQXDVEbrshNDlq5pBRwNH7kAWs/Gfs2DfRRa2xi61SsgY9h05sphkmQ2gy2RTC44/
         dBUX5aiyx8Q0RKS8T8+PoxVrYRN+x9XB2bMOdVO0aokQrCX0T89FthLdk4akUqsZp7
         FH/tSiTmGVAfpmiKWZo/Q4K+69uC4+Gom14jD9ZvavSpj5Jm8M1vpRbjghTz7SsWbX
         nfXH3jCKsvELQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4.19 00/16] Backport oops_limit to 4.19
Date:   Wed,  1 Feb 2023 21:25:48 -0800
Message-Id: <20230202052604.179184-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports the patchset
"exit: Put an upper limit on how often we can oops"
(https://lore.kernel.org/linux-mm/20221117233838.give.484-kees@kernel.org/T/#u)
to 4.19, as recommended at
https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html
This follows the backports to 5.10 and 5.15 which already released, and
the backport to 5.4 that I just sent out too.

This required backporting various prerequisite patches.

I've tested that oops_limit and warn_limit work correctly on x86_64.

David Gow (1):
  mm: kasan: do not panic if both panic_on_warn and kasan_multishot set

Eric W. Biederman (2):
  exit: Add and use make_task_dead.
  objtool: Add a missing comma to avoid string concatenation

Jann Horn (1):
  exit: Put an upper limit on how often we can oops

Kees Cook (7):
  exit: Expose "oops_count" to sysfs
  exit: Allow oops_limit to be disabled
  panic: Consolidate open-coded panic_on_warn checks
  panic: Introduce warn_limit
  panic: Expose "warn_count" to sysfs
  docs: Fix path paste-o for /sys/kernel/warn_count
  exit: Use READ_ONCE() for all oops/warn limit reads

Nathan Chancellor (2):
  hexagon: Fix function name in die()
  h8300: Fix build errors from do_exit() to make_task_dead() transition

Randy Dunlap (1):
  ia64: make IA64_MCA_RECOVERY bool instead of tristate

Tiezhu Yang (1):
  panic: unset panic_on_warn inside panic()

Xiaoming Ni (1):
  sysctl: add a new register_sysctl_init() interface

 .../ABI/testing/sysfs-kernel-oops_count       |  6 ++
 .../ABI/testing/sysfs-kernel-warn_count       |  6 ++
 Documentation/sysctl/kernel.txt               | 20 +++++
 arch/alpha/kernel/traps.c                     |  6 +-
 arch/alpha/mm/fault.c                         |  2 +-
 arch/arm/kernel/traps.c                       |  2 +-
 arch/arm/mm/fault.c                           |  2 +-
 arch/arm64/kernel/traps.c                     |  2 +-
 arch/arm64/mm/fault.c                         |  2 +-
 arch/h8300/kernel/traps.c                     |  3 +-
 arch/h8300/mm/fault.c                         |  2 +-
 arch/hexagon/kernel/traps.c                   |  2 +-
 arch/ia64/Kconfig                             |  2 +-
 arch/ia64/kernel/mca_drv.c                    |  2 +-
 arch/ia64/kernel/traps.c                      |  2 +-
 arch/ia64/mm/fault.c                          |  2 +-
 arch/m68k/kernel/traps.c                      |  2 +-
 arch/m68k/mm/fault.c                          |  2 +-
 arch/microblaze/kernel/exceptions.c           |  4 +-
 arch/mips/kernel/traps.c                      |  2 +-
 arch/nds32/kernel/traps.c                     |  8 +-
 arch/nios2/kernel/traps.c                     |  4 +-
 arch/openrisc/kernel/traps.c                  |  2 +-
 arch/parisc/kernel/traps.c                    |  2 +-
 arch/powerpc/kernel/traps.c                   |  2 +-
 arch/riscv/kernel/traps.c                     |  2 +-
 arch/riscv/mm/fault.c                         |  2 +-
 arch/s390/kernel/dumpstack.c                  |  2 +-
 arch/s390/kernel/nmi.c                        |  2 +-
 arch/sh/kernel/traps.c                        |  2 +-
 arch/sparc/kernel/traps_32.c                  |  4 +-
 arch/sparc/kernel/traps_64.c                  |  4 +-
 arch/x86/entry/entry_32.S                     |  6 +-
 arch/x86/entry/entry_64.S                     |  6 +-
 arch/x86/kernel/dumpstack.c                   |  4 +-
 arch/xtensa/kernel/traps.c                    |  2 +-
 fs/proc/proc_sysctl.c                         | 33 ++++++++
 include/linux/kernel.h                        |  1 +
 include/linux/sched/task.h                    |  1 +
 include/linux/sysctl.h                        |  3 +
 kernel/exit.c                                 | 72 ++++++++++++++++++
 kernel/panic.c                                | 75 ++++++++++++++++---
 kernel/sched/core.c                           |  3 +-
 mm/kasan/report.c                             |  4 +-
 tools/objtool/check.c                         |  3 +-
 45 files changed, 258 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-oops_count
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-warn_count


base-commit: b17faf2c4e88ac0deb894f068bda67ace57e9c0a
-- 
2.39.1

