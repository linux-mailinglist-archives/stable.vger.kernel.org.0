Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE0476A16
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfGZN4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387813AbfGZNl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AEDA22CBF;
        Fri, 26 Jul 2019 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148517;
        bh=QbcCrcYP0/ZaPPQaKsY9QH7x/pjhlz95ZsQjyztPYys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buoQ0UQtgXPRX5nVwbWTwdgr2nWSWYEFQiZnBloMY//geCM6wlaJ8hpGdGs1YNlG1
         55bVlgzwTuIAzN9SHj38GiCj9AuZBifNNZgus7DRaefSG9aDixW+HAtOZ7GkiPPprD
         d8sXjGTOCU1VacvWNGOKA13WWFH/zL88Se3Pb81Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 79/85] x86/paravirt: Fix callee-saved function ELF sizes
Date:   Fri, 26 Jul 2019 09:39:29 -0400
Message-Id: <20190726133936.11177-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 083db6764821996526970e42d09c1ab2f4155dd4 ]

The __raw_callee_save_*() functions have an ELF symbol size of zero,
which confuses objtool and other tools.

Fixes a bunch of warnings like the following:

  arch/x86/xen/mmu_pv.o: warning: objtool: __raw_callee_save_xen_pte_val() is missing an ELF size annotation
  arch/x86/xen/mmu_pv.o: warning: objtool: __raw_callee_save_xen_pgd_val() is missing an ELF size annotation
  arch/x86/xen/mmu_pv.o: warning: objtool: __raw_callee_save_xen_make_pte() is missing an ELF size annotation
  arch/x86/xen/mmu_pv.o: warning: objtool: __raw_callee_save_xen_make_pgd() is missing an ELF size annotation

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/afa6d49bb07497ca62e4fc3b27a2d0cece545b4e.1563413318.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/paravirt.h | 1 +
 arch/x86/kernel/kvm.c           | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index c25c38a05c1c..d6f5ae2c79ab 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -746,6 +746,7 @@ bool __raw_callee_save___native_vcpu_is_preempted(long cpu);
 	    PV_RESTORE_ALL_CALLER_REGS					\
 	    FRAME_END							\
 	    "ret;"							\
+	    ".size " PV_THUNK_NAME(func) ", .-" PV_THUNK_NAME(func) ";"	\
 	    ".popsection")
 
 /* Get a reference to a callee-save function */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5169b8cc35bb..320b70acb211 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -817,6 +817,7 @@ asm(
 "cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
 "setne	%al;"
 "ret;"
+".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
 ".popsection");
 
 #endif
-- 
2.20.1

