Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F324523A1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348229AbhKPB1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:27:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244024AbhKOTIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:08:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C2E633FD;
        Mon, 15 Nov 2021 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000270;
        bh=l0aKp8ca26bq3qWZd9dQxTWCS4ZcATBIyEK80Ijq2g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acEFoM/94NfF0QvV4M9HHDjJPparPOGc1WazFHQLEzB3v5TuBm/X+a+/npPr6oePd
         bb0wYNg0C9OYeEpipGtNyyb/xo2ib2hL9/u9joRuSr6KF07p2mrpTC7ix13Gz29zCP
         0OmK9/UssjmvSi0ofG3oBeaYF5Qq+z4k7t04kwXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 598/849] powerpc/paravirt: correct preempt debug splat in vcpu_is_preempted()
Date:   Mon, 15 Nov 2021 18:01:21 +0100
Message-Id: <20211115165440.483469182@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit fda0eb220021a97c1d656434b9340ebf3fc4704a ]

vcpu_is_preempted() can be used outside of preempt-disabled critical
sections, yielding warnings such as:

BUG: using smp_processor_id() in preemptible [00000000] code: systemd-udevd/185
caller is rwsem_spin_on_owner+0x1cc/0x2d0
CPU: 1 PID: 185 Comm: systemd-udevd Not tainted 5.15.0-rc2+ #33
Call Trace:
[c000000012907ac0] [c000000000aa30a8] dump_stack_lvl+0xac/0x108 (unreliable)
[c000000012907b00] [c000000001371f70] check_preemption_disabled+0x150/0x160
[c000000012907b90] [c0000000001e0e8c] rwsem_spin_on_owner+0x1cc/0x2d0
[c000000012907be0] [c0000000001e1408] rwsem_down_write_slowpath+0x478/0x9a0
[c000000012907ca0] [c000000000576cf4] filename_create+0x94/0x1e0
[c000000012907d10] [c00000000057ac08] do_symlinkat+0x68/0x1a0
[c000000012907d70] [c00000000057ae18] sys_symlink+0x58/0x70
[c000000012907da0] [c00000000002e448] system_call_exception+0x198/0x3c0
[c000000012907e10] [c00000000000c54c] system_call_common+0xec/0x250

The result of vcpu_is_preempted() is always used speculatively, and the
function does not access per-cpu resources in a (Linux) preempt-unsafe way.
Use raw_smp_processor_id() to avoid such warnings, adding explanatory
comments.

Fixes: ca3f969dcb11 ("powerpc/paravirt: Use is_kvm_guest() in vcpu_is_preempted()")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210928214147.312412-3-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/paravirt.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/paravirt.h b/arch/powerpc/include/asm/paravirt.h
index bcb7b5f917be6..b325022ffa2b0 100644
--- a/arch/powerpc/include/asm/paravirt.h
+++ b/arch/powerpc/include/asm/paravirt.h
@@ -97,7 +97,23 @@ static inline bool vcpu_is_preempted(int cpu)
 
 #ifdef CONFIG_PPC_SPLPAR
 	if (!is_kvm_guest()) {
-		int first_cpu = cpu_first_thread_sibling(smp_processor_id());
+		int first_cpu;
+
+		/*
+		 * The result of vcpu_is_preempted() is used in a
+		 * speculative way, and is always subject to invalidation
+		 * by events internal and external to Linux. While we can
+		 * be called in preemptable context (in the Linux sense),
+		 * we're not accessing per-cpu resources in a way that can
+		 * race destructively with Linux scheduler preemption and
+		 * migration, and callers can tolerate the potential for
+		 * error introduced by sampling the CPU index without
+		 * pinning the task to it. So it is permissible to use
+		 * raw_smp_processor_id() here to defeat the preempt debug
+		 * warnings that can arise from using smp_processor_id()
+		 * in arbitrary contexts.
+		 */
+		first_cpu = cpu_first_thread_sibling(raw_smp_processor_id());
 
 		/*
 		 * Preemption can only happen at core granularity. This CPU
-- 
2.33.0



