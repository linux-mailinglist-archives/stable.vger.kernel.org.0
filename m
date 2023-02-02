Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C974687552
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBBFpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjBBFpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:45:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888BE301B2;
        Wed,  1 Feb 2023 21:45:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0209A615E9;
        Thu,  2 Feb 2023 05:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A67C433EF;
        Thu,  2 Feb 2023 05:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675316719;
        bh=B6lSrlLtFAZ1xIL4KTWAiJ+Y2P8ChLSaSxw1tFBI8Lo=;
        h=From:To:Cc:Subject:Date:From;
        b=EYQ3cbsvsm/1Byhw2QM5heq7F1o8uSyITBLY+mW8R3Z6IHbOvwUomFD7BBg0a+/QV
         esJ3kvtEX98LgxzIsMTa3mhbtY7ACzX20JvAH8RIuj39WHVAukIznd088+482v+j4j
         KrbY9rZbyirm0crOkC1ZFxf50j8FeMMremyU8UkwDmAeGQk699w9KIIDbOxlcSMYLi
         ENfESSKtvc5LI2EqlS7MrLM7vtH0tYRpINJH+jK2Cht+6YPh0O5rufro/pTku0mgRg
         VaZD9Cu25AyAg3mMw5bwnDTsvxCOawt7DvDQpgKleW1w6g/Gcuun/7/M7uLw5j1rH/
         TJnJSmXlGsQzw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 00/16] Backport oops_limit to 4.14
Date:   Wed,  1 Feb 2023 21:43:50 -0800
Message-Id: <20230202054406.221721-1-ebiggers@kernel.org>
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

From: Eric Biggers <ebiggers@google.com>

This series backports the patchset
"exit: Put an upper limit on how often we can oops"
(https://lore.kernel.org/linux-mm/20221117233838.give.484-kees@kernel.org/T/#u)
to 4.14, as recommended at
https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html
This follows the backports to 5.10 and 5.15 which already released, and
the backports to 5.4 and 4.19 that I just sent out too.

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
 arch/nios2/kernel/traps.c                     |  4 +-
 arch/openrisc/kernel/traps.c                  |  2 +-
 arch/parisc/kernel/traps.c                    |  2 +-
 arch/powerpc/kernel/traps.c                   |  2 +-
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
 42 files changed, 252 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-oops_count
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-warn_count


base-commit: 3949d16100044eeb6723eca03b1038b469fb9ae8
-- 
2.39.1

