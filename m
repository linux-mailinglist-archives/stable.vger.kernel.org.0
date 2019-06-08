Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D65039D5E
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfFHLkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727538AbfFHLkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E053214AF;
        Sat,  8 Jun 2019 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994022;
        bh=T9EQLESZEqnofQb5sqhGtTE8EjOGTkxMRhN4PNcztCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTlZ4Swj1Ulxs+8BD3gEl+DHBrtWaUj+fjhcgkTZlXapycWmKiAJhIYB/e6MOxD/j
         qmvAczqKvmytJvH643nf88S5uSupjhjc6oVKQl2zhJJtodU0FcbMrlPUV2jyZlMbIY
         cIDJixiRGARxpVjIx2rFjwe1FVwcLIahE2F+mVp0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank van der Linden <fllinden@amazon.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, bp@alien8.de,
        jiaxun.yang@flygoat.com, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 20/70] x86/CPU/AMD: Don't force the CPB cap when running under a hypervisor
Date:   Sat,  8 Jun 2019 07:38:59 -0400
Message-Id: <20190608113950.8033-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank van der Linden <fllinden@amazon.com>

[ Upstream commit 2ac44ab608705948564791ce1d15d43ba81a1e38 ]

For F17h AMD CPUs, the CPB capability ('Core Performance Boost') is forcibly set,
because some versions of that chip incorrectly report that they do not have it.

However, a hypervisor may filter out the CPB capability, for good
reasons. For example, KVM currently does not emulate setting the CPB
bit in MSR_K7_HWCR, and unchecked MSR access errors will be thrown
when trying to set it as a guest:

	unchecked MSR access error: WRMSR to 0xc0010015 (tried to write 0x0000000001000011) at rIP: 0xffffffff890638f4 (native_write_msr+0x4/0x20)

	Call Trace:
	boost_set_msr+0x50/0x80 [acpi_cpufreq]
	cpuhp_invoke_callback+0x86/0x560
	sort_range+0x20/0x20
	cpuhp_thread_fun+0xb0/0x110
	smpboot_thread_fn+0xef/0x160
	kthread+0x113/0x130
	kthread_create_worker_on_cpu+0x70/0x70
	ret_from_fork+0x35/0x40

To avoid this issue, don't forcibly set the CPB capability for a CPU
when running under a hypervisor.

Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@alien8.de
Cc: jiaxun.yang@flygoat.com
Fixes: 0237199186e7 ("x86/CPU/AMD: Set the CPB bit unconditionally on F17h")
Link: http://lkml.kernel.org/r/20190522221745.GA15789@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
[ Minor edits to the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 01004bfb1a1b..524709dcf749 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -820,8 +820,11 @@ static void init_amd_zn(struct cpuinfo_x86 *c)
 {
 	set_cpu_cap(c, X86_FEATURE_ZEN);
 
-	/* Fix erratum 1076: CPB feature bit not being set in CPUID. */
-	if (!cpu_has(c, X86_FEATURE_CPB))
+	/*
+	 * Fix erratum 1076: CPB feature bit not being set in CPUID.
+	 * Always set it, except when running under a hypervisor.
+	 */
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !cpu_has(c, X86_FEATURE_CPB))
 		set_cpu_cap(c, X86_FEATURE_CPB);
 }
 
-- 
2.20.1

