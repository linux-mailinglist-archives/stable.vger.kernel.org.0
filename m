Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DC3D00A0
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 20:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfJHSUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 14:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfJHSUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 14:20:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2AE0217D7;
        Tue,  8 Oct 2019 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570558816;
        bh=01nlXakLi8cBSKtxF4hn/rYRk8wPMODRn200BfMUs0k=;
        h=Date:From:To:Subject:From;
        b=Zsm/RMDrDFXbr94i+c6kuXHy2TZjJP2AJ4CKXWW551XkfCAjm/6bjp0V0XLQkG24Y
         W0JNFhyI79blqYnnhaoyzOsyavgRQRXbKaNJTX/LjZjibXqNSpM0YW3f55mi4Do9/Q
         MdMVR5qdrn2Gj2gaj7BKyjW8BDKRJTNnqMLs6vkw=
Date:   Tue, 08 Oct 2019 11:20:03 -0700
From:   akpm@linux-foundation.org
To:     contact@xogium.me, feng.tang@intel.com, gregkh@linuxfoundation.org,
        keescook@chromium.org, linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com,
        stable@vger.kernel.org, will@kernel.org
Subject:  [merged]
 panic-ensure-preemption-is-disabled-during-panic.patch removed from -mm
 tree
Message-ID: <20191008182003.BZ0YmsDAm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: panic: ensure preemption is disabled during panic()
has been removed from the -mm tree.  Its filename was
     panic-ensure-preemption-is-disabled-during-panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from will@kernel.org are


