Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB407106950
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 10:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKVJvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 04:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbfKVJvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 04:51:23 -0500
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0524720715;
        Fri, 22 Nov 2019 09:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574416282;
        bh=338xDZS6QqVUNG2iUBxb4ObNXug5gpT9Q1vMzLFA60I=;
        h=From:To:Cc:Subject:Date:From;
        b=TkuV01EuhtAM82pt321ZdjvpxSL+eMivTlGUz9YchessFdeY7LH+TfPMriF98wcqs
         5x75LdEhN3IOFGWFeh8eq9zjA2h8NH/6iAsHlwBPpme8A9V/DPXpUNhlrLimtzgyzt
         QbaUPCs2/zmSx726vI7+pbFKxUhPA+GAnVqd9Qxg=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, mark.rutland@arm.com,
        pasha.tatashin@soleen.com, Will Deacon <will@kernel.org>
Subject: [PATCH] [Backport to stable 4.9.y] arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault
Date:   Fri, 22 Nov 2019 09:51:16 +0000
Message-Id: <20191122095116.12244-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
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
[will: backport for 4.9.y stable kernels]
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/lib/clear_user.S     | 2 ++
 arch/arm64/lib/copy_from_user.S | 2 ++
 arch/arm64/lib/copy_in_user.S   | 2 ++
 arch/arm64/lib/copy_to_user.S   | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/arch/arm64/lib/clear_user.S b/arch/arm64/lib/clear_user.S
index efbf610eaf4e..a814f32033b0 100644
--- a/arch/arm64/lib/clear_user.S
+++ b/arch/arm64/lib/clear_user.S
@@ -62,5 +62,7 @@ ENDPROC(__arch_clear_user)
 	.section .fixup,"ax"
 	.align	2
 9:	mov	x0, x2			// return the original size
+ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
+	    CONFIG_ARM64_PAN)
 	ret
 	.previous
diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
index 4fd67ea03bb0..580aca96c53c 100644
--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -80,5 +80,7 @@ ENDPROC(__arch_copy_from_user)
 	.section .fixup,"ax"
 	.align	2
 9998:	sub	x0, end, dst			// bytes not copied
+ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
+	    CONFIG_ARM64_PAN)
 	ret
 	.previous
diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
index 841bf8f7fab7..d9ca6a4f33b3 100644
--- a/arch/arm64/lib/copy_in_user.S
+++ b/arch/arm64/lib/copy_in_user.S
@@ -81,5 +81,7 @@ ENDPROC(__arch_copy_in_user)
 	.section .fixup,"ax"
 	.align	2
 9998:	sub	x0, end, dst			// bytes not copied
+ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
+	    CONFIG_ARM64_PAN)
 	ret
 	.previous
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 7a7efe255034..e8bd40dc00cd 100644
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -79,5 +79,7 @@ ENDPROC(__arch_copy_to_user)
 	.section .fixup,"ax"
 	.align	2
 9998:	sub	x0, end, dst			// bytes not copied
+ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
+	    CONFIG_ARM64_PAN)
 	ret
 	.previous
-- 
2.24.0.432.g9d3f5f5b63-goog

