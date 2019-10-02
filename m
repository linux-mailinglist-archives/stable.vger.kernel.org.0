Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D937C939D
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 23:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfJBVqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 17:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbfJBVqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 17:46:12 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C07CE21A4C;
        Wed,  2 Oct 2019 21:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570052771;
        bh=9cAY2M7RpLTEsWUZcn569zyvp28ZmHjbaxAWFq9lUU0=;
        h=Date:From:To:Subject:From;
        b=x0G1gV7D5i+z3wls7zfyMKFOa+soxbsgFlqtQhL0dZth0SDheA9wfjQOtBFBwPaEm
         bLyqqv9WT9D35dSpBhw7iAX2H/jx88f76LWqqDwnAAGJ1iOm+91KZt11p+F2XQyIn2
         A88YwZviZANccowW8raR3BzCZfPeel5MNRUCH63c=
Date:   Wed, 02 Oct 2019 14:46:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mingo@redhat.com, linux@armlinux.org.uk, keescook@chromium.org,
        gregkh@linuxfoundation.org, contact@xogium.me, will@kernel.org
Subject:  + panic-ensure-preemption-is-disabled-during-panic.patch
 added to -mm tree
Message-ID: <20191002214610.wNOcu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: panic: ensure preemption is disabled during panic()
has been added to the -mm tree.  Its filename is
     panic-ensure-preemption-is-disabled-during-panic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/panic-ensure-preemption-is-disabled-during-panic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/panic-ensure-preemption-is-disabled-during-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Will Deacon <will@kernel.org>
Subject: panic: ensure preemption is disabled during panic()

Calling 'panic()' on a kernel with CONFIG_PREEMPT=y can leave the calling
CPU in an infinite loop, but with interrupts and preemption enabled.  From
this state, userspace can continue to be scheduled, despite the system
being "dead" as far as the kernel is concerned.  This is easily
reproducible on arm64 when booting with "nosmp" on the command line; a
couple of shell scripts print out a periodic "Ping" message whilst another
triggers a crash by writing to /proc/sysrq-trigger:

  | sysrq: Trigger a crash
  | Kernel panic - not syncing: sysrq triggered crash
  | CPU: 0 PID: 1 Comm: init Not tainted 5.2.15 #1
  | Hardware name: linux,dummy-virt (DT)
  | Call trace:
  |  dump_backtrace+0x0/0x148
  |  show_stack+0x14/0x20
  |  dump_stack+0xa0/0xc4
  |  panic+0x140/0x32c
  |  sysrq_handle_reboot+0x0/0x20
  |  __handle_sysrq+0x124/0x190
  |  write_sysrq_trigger+0x64/0x88
  |  proc_reg_write+0x60/0xa8
  |  __vfs_write+0x18/0x40
  |  vfs_write+0xa4/0x1b8
  |  ksys_write+0x64/0xf0
  |  __arm64_sys_write+0x14/0x20
  |  el0_svc_common.constprop.0+0xb0/0x168
  |  el0_svc_handler+0x28/0x78
  |  el0_svc+0x8/0xc
  | Kernel Offset: disabled
  | CPU features: 0x0002,24002004
  | Memory Limit: none
  | ---[ end Kernel panic - not syncing: sysrq triggered crash ]---
  |  Ping 2!
  |  Ping 1!
  |  Ping 1!
  |  Ping 2!

The issue can also be triggered on x86 kernels if CONFIG_SMP=n, otherwise
local interrupts are disabled in 'smp_send_stop()'.

Disable preemption in 'panic()' before re-enabling interrupts.

Link: http://lkml.kernel.org/r/20191002123538.22609-1-will@kernel.org
Link: https://lore.kernel.org/r/BX1W47JXPMR8.58IYW53H6M5N@dragonstone
Signed-off-by: Will Deacon <will@kernel.org>
Reported-by: Xogium <contact@xogium.me>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/panic.c~panic-ensure-preemption-is-disabled-during-panic
+++ a/kernel/panic.c
@@ -180,6 +180,7 @@ void panic(const char *fmt, ...)
 	 * after setting panic_cpu) from invoking panic() again.
 	 */
 	local_irq_disable();
+	preempt_disable_notrace();
 
 	/*
 	 * It's possible to come here directly from a panic-assertion and
_

Patches currently in -mm which might be from will@kernel.org are

panic-ensure-preemption-is-disabled-during-panic.patch

