Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F78122093
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfLQAvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35088 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbfLQAvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003LD-27; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005Uj-UK; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Russell King" <linux@armlinux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Kees Cook" <keescook@chromium.org>,
        "Feng Tang" <feng.tang@intel.com>, "Xogium" <contact@xogium.me>,
        "Petr Mladek" <pmladek@suse.com>, "Will Deacon" <will@kernel.org>
Date:   Tue, 17 Dec 2019 00:46:17 +0000
Message-ID: <lsq.1576543535.860974359@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 043/136] panic: ensure preemption is disabled during
 panic()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit 20bb759a66be52cf4a9ddd17fddaf509e11490cd upstream.

Calling 'panic()' on a kernel with CONFIG_PREEMPT=y can leave the
calling CPU in an infinite loop, but with interrupts and preemption
enabled.  From this state, userspace can continue to be scheduled,
despite the system being "dead" as far as the kernel is concerned.

This is easily reproducible on arm64 when booting with "nosmp" on the
command line; a couple of shell scripts print out a periodic "Ping"
message whilst another triggers a crash by writing to
/proc/sysrq-trigger:

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

The issue can also be triggered on x86 kernels if CONFIG_SMP=n,
otherwise local interrupts are disabled in 'smp_send_stop()'.

Disable preemption in 'panic()' before re-enabling interrupts.

Link: http://lkml.kernel.org/r/20191002123538.22609-1-will@kernel.org
Link: https://lore.kernel.org/r/BX1W47JXPMR8.58IYW53H6M5N@dragonstone
Signed-off-by: Will Deacon <will@kernel.org>
Reported-by: Xogium <contact@xogium.me>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/panic.c | 1 +
 1 file changed, 1 insertion(+)

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -110,6 +110,7 @@ void panic(const char *fmt, ...)
 	 * after the panic_lock is acquired) from invoking panic again.
 	 */
 	local_irq_disable();
+	preempt_disable_notrace();
 
 	/*
 	 * It's possible to come here directly from a panic-assertion and

