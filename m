Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C6C67A1BC
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 19:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbjAXSwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 13:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjAXSwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 13:52:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFB2305FD;
        Tue, 24 Jan 2023 10:52:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03F70B81628;
        Tue, 24 Jan 2023 18:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A9EC433EF;
        Tue, 24 Jan 2023 18:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674586320;
        bh=NFhHC6KesBEE+iNcr4d7w80+UBTr2sNXL+XAImTeeLc=;
        h=From:To:Cc:Subject:Date:From;
        b=Z30KhHNvpQVHR1WlqK08wqOiidBscnWm7YlQJTxVssc3yea2yHMyh0iKEbNjqwnch
         xVbuSYRQodXEkX8fX44fwoO//UxBdvQwvr7yqQBYbzIAf/JiA2xUC18NCUSCIR9zmI
         bGEGnkeXIWp4og0RTvUVNRkDIcTy9rwCmVGIPP7xeHcAz+mg3gDeUoW6y+kFuOvNku
         cYPlOAfhL0G7DurXP7kNZm6ec08+eCbylgS212vPvJetVQ+vpIfAPTqCEAkliTKIJv
         Be10AwGTwfOXpc3TGOsGUYxWIxuD3hDSo2N1xp8hdnOO+fGMnecWh7g9kL3gPJXVlJ
         KrNXZRLlQpflg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.15 00/20] Backport oops_limit to 5.15
Date:   Tue, 24 Jan 2023 10:50:50 -0800
Message-Id: <20230124185110.143857-1-ebiggers@kernel.org>
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
to 5.15, as recommended at
https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html

This required backporting various prerequisite patches.

I've tested that oops_limit and warn_limit work correctly on x86_64.

Eric W. Biederman (2):
  exit: Add and use make_task_dead.
  objtool: Add a missing comma to avoid string concatenation

Jann Horn (1):
  exit: Put an upper limit on how often we can oops

Kees Cook (8):
  panic: Separate sysctl logic from CONFIG_SMP
  exit: Expose "oops_count" to sysfs
  exit: Allow oops_limit to be disabled
  panic: Consolidate open-coded panic_on_warn checks
  panic: Introduce warn_limit
  panic: Expose "warn_count" to sysfs
  docs: Fix path paste-o for /sys/kernel/warn_count
  exit: Use READ_ONCE() for all oops/warn limit reads

Nathan Chancellor (3):
  hexagon: Fix function name in die()
  h8300: Fix build errors from do_exit() to make_task_dead() transition
  csky: Fix function name in csky_alignment() and die()

Randy Dunlap (1):
  ia64: make IA64_MCA_RECOVERY bool instead of tristate

Tiezhu Yang (3):
  panic: unset panic_on_warn inside panic()
  ubsan: no need to unset panic_on_warn in ubsan_epilogue()
  kasan: no need to unset panic_on_warn in end_report()

Xiaoming Ni (1):
  sysctl: add a new register_sysctl_init() interface

tangmeng (1):
  kernel/panic: move panic sysctls to its own file

 .../ABI/testing/sysfs-kernel-oops_count       |  6 ++
 .../ABI/testing/sysfs-kernel-warn_count       |  6 ++
 Documentation/admin-guide/sysctl/kernel.rst   | 19 ++++
 arch/alpha/kernel/traps.c                     |  6 +-
 arch/alpha/mm/fault.c                         |  2 +-
 arch/arm/kernel/traps.c                       |  2 +-
 arch/arm/mm/fault.c                           |  2 +-
 arch/arm64/kernel/traps.c                     |  2 +-
 arch/arm64/mm/fault.c                         |  2 +-
 arch/csky/abiv1/alignment.c                   |  2 +-
 arch/csky/kernel/traps.c                      |  2 +-
 arch/csky/mm/fault.c                          |  2 +-
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
 arch/nds32/kernel/fpu.c                       |  2 +-
 arch/nds32/kernel/traps.c                     |  8 +-
 arch/nios2/kernel/traps.c                     |  4 +-
 arch/openrisc/kernel/traps.c                  |  2 +-
 arch/parisc/kernel/traps.c                    |  2 +-
 arch/powerpc/kernel/traps.c                   |  8 +-
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
 fs/proc/proc_sysctl.c                         | 33 +++++++
 include/linux/panic.h                         |  7 +-
 include/linux/sched/task.h                    |  1 +
 include/linux/sysctl.h                        |  3 +
 kernel/exit.c                                 | 72 +++++++++++++++
 kernel/kcsan/report.c                         |  3 +-
 kernel/panic.c                                | 90 ++++++++++++++++---
 kernel/sched/core.c                           |  3 +-
 kernel/sysctl.c                               | 11 ---
 lib/ubsan.c                                   | 11 +--
 mm/kasan/report.c                             | 12 +--
 mm/kfence/report.c                            |  3 +-
 tools/objtool/check.c                         |  3 +-
 53 files changed, 281 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-oops_count
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-warn_count


base-commit: aabd5ba7e9b03e9a211a4842ab4a93d46f684d2c
-- 
2.39.1

