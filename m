Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5EFCDA06
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 02:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfJGA6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 20:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbfJGA6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 20:58:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E81092084B;
        Mon,  7 Oct 2019 00:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570409883;
        bh=TEqNG+E7NZGxfmnh/oZUseN7WwLS++PntwmOo98E2C8=;
        h=Date:From:To:Subject:From;
        b=lmJ2IrJT0NJcZR8bC/js4q2yd3a8VUyScf02fUuUg1DT5i3wDhp3tAM8eslX7+LOP
         QDdf9f+Q5O3HSVLSg0Z+r4s330m7OFHzi4SPvKNZd+5TDBaSFF2WRo74Mp4jfufRdd
         DE1Mg4fh32SnjDrWt7Nsg2ejY8QsnehL2LkeN3Xc=
Date:   Sun, 06 Oct 2019 17:58:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, contact@xogium.me, feng.tang@intel.com,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        will@kernel.org
Subject:  [patch 05/18] panic: ensure preemption is disabled during
 panic()
Message-ID: <20191007005800.6pFZYN-RH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Feng Tang <feng.tang@intel.com>
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
