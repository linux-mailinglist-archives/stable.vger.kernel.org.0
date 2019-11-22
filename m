Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4872D106E2E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731230AbfKVLGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731906AbfKVLGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0A922084D;
        Fri, 22 Nov 2019 11:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420809;
        bh=uttykRXu6fmPslYpYmyO++JnZH4pK/+REWs7vK+7hN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3NeOOJTuUmmYtcHUudMBYmZ1lz86aKpZ4mSwEr13L7gxbtoxd7o2LQRAlMcDAmrc
         4BwESIBSvq/gLEmhkaNIyYqvjlX2hPoJ+fl50eBMVS2dGoMV2ZyGJ6LCooSeqOheWI
         Hjw4QDYoGMa9UGhH7rIjmcA1yYJVd79i4pi2oY3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.3 5/6] arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault
Date:   Fri, 22 Nov 2019 11:30:07 +0100
Message-Id: <20191122100327.349833298@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100320.878809004@linuxfoundation.org>
References: <20191122100320.878809004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>

commit 94bb804e1e6f0a9a77acf20d7c70ea141c6c821e upstream.

A number of our uaccess routines ('__arch_clear_user()' and
'__arch_copy_{in,from,to}_user()') fail to re-enable PAN if they
encounter an unhandled fault whilst accessing userspace.

For CPUs implementing both hardware PAN and UAO, this bug has no effect
when both extensions are in use by the kernel.

For CPUs implementing hardware PAN but not UAO, this means that a kernel
using hardware PAN may execute portions of code with PAN inadvertently
disabled, opening us up to potential security vulnerabilities that rely
on userspace access from within the kernel which would usually be
prevented by this mechanism. In other words, parts of the kernel run the
same way as they would on a CPU without PAN implemented/emulated at all.

For CPUs not implementing hardware PAN and instead relying on software
emulation via 'CONFIG_ARM64_SW_TTBR0_PAN=y', the impact is unfortunately
much worse. Calling 'schedule()' with software PAN disabled means that
the next task will execute in the kernel using the page-table and ASID
of the previous process even after 'switch_mm()', since the actual
hardware switch is deferred until return to userspace. At this point, or
if there is a intermediate call to 'uaccess_enable()', the page-table
and ASID of the new process are installed. Sadly, due to the changes
introduced by KPTI, this is not an atomic operation and there is a very
small window (two instructions) where the CPU is configured with the
page-table of the old task and the ASID of the new task; a speculative
access in this state is disastrous because it would corrupt the TLB
entries for the new task with mappings from the previous address space.

As Pavel explains:

  | I was able to reproduce memory corruption problem on Broadcom's SoC
  | ARMv8-A like this:
  |
  | Enable software perf-events with PERF_SAMPLE_CALLCHAIN so userland's
  | stack is accessed and copied.
  |
  | The test program performed the following on every CPU and forking
  | many processes:
  |
  |	unsigned long *map = mmap(NULL, PAGE_SIZE, PROT_READ|PROT_WRITE,
  |				  MAP_SHARED | MAP_ANONYMOUS, -1, 0);
  |	map[0] = getpid();
  |	sched_yield();
  |	if (map[0] != getpid()) {
  |		fprintf(stderr, "Corruption detected!");
  |	}
  |	munmap(map, PAGE_SIZE);
  |
  | From time to time I was getting map[0] to contain pid for a
  | different process.

Ensure that PAN is re-enabled when returning after an unhandled user
fault from our uaccess routines.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Cc: <stable@vger.kernel.org>
Fixes: 338d4f49d6f7 ("arm64: kernel: Add support for Privileged Access Never")
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
[will: rewrote commit message]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/lib/clear_user.S     |    1 +
 arch/arm64/lib/copy_from_user.S |    1 +
 arch/arm64/lib/copy_in_user.S   |    1 +
 arch/arm64/lib/copy_to_user.S   |    1 +
 4 files changed, 4 insertions(+)

--- a/arch/arm64/lib/clear_user.S
+++ b/arch/arm64/lib/clear_user.S
@@ -48,5 +48,6 @@ EXPORT_SYMBOL(__arch_clear_user)
 	.section .fixup,"ax"
 	.align	2
 9:	mov	x0, x2			// return the original size
+	uaccess_disable_not_uao x2, x3
 	ret
 	.previous
--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -66,5 +66,6 @@ EXPORT_SYMBOL(__arch_copy_from_user)
 	.section .fixup,"ax"
 	.align	2
 9998:	sub	x0, end, dst			// bytes not copied
+	uaccess_disable_not_uao x3, x4
 	ret
 	.previous
--- a/arch/arm64/lib/copy_in_user.S
+++ b/arch/arm64/lib/copy_in_user.S
@@ -68,5 +68,6 @@ EXPORT_SYMBOL(__arch_copy_in_user)
 	.section .fixup,"ax"
 	.align	2
 9998:	sub	x0, end, dst			// bytes not copied
+	uaccess_disable_not_uao x3, x4
 	ret
 	.previous
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -65,5 +65,6 @@ EXPORT_SYMBOL(__arch_copy_to_user)
 	.section .fixup,"ax"
 	.align	2
 9998:	sub	x0, end, dst			// bytes not copied
+	uaccess_disable_not_uao x3, x4
 	ret
 	.previous


