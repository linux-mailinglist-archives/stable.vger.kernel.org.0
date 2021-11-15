Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE7F451F34
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355740AbhKPAij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344356AbhKOTYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A7D6366F;
        Mon, 15 Nov 2021 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002585;
        bh=l0aKp8ca26bq3qWZd9dQxTWCS4ZcATBIyEK80Ijq2g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmSRWsvZCTJxuRu8JrFtpyAI/vAdquAImCYNvos88Ri21ivgGKASwI66Nj87Ad07n
         zpJguGazZDruXWN8zSda8Pifxy4DG8cvQvyyZ7FrKHcd+Tz8MEEuO9ypAMqBEly7dw
         jQWeW+1AmOdqlVeVsCP9MO2V01BU2LjD6jvIzgsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 622/917] powerpc/paravirt: correct preempt debug splat in vcpu_is_preempted()
Date:   Mon, 15 Nov 2021 18:01:57 +0100
Message-Id: <20211115165449.885533008@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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



