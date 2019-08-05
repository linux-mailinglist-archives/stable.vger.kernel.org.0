Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373B181B2D
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbfHENMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730305AbfHENKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:10:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F2A52067D;
        Mon,  5 Aug 2019 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010618;
        bh=BgD3mM4HkmQ/gs+W/RqVaygAB9Nz3ZXAEzte4C+fkoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1P0v75UwMXGNwttu87v2492ie2NpegFtYxnpqVu2+J6LkfTVm7goEBcn8aB/mEhkq
         o2NnJDYh5r4k8DbqU102NiysNfWgUd3QhuRbeK/PKMEx1N535UxFGRkSdCVlHM/LUT
         GMNLGaBvRRs8Utcq2BMolHWa0j+HCbVXORDxsw+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/74] x86/paravirt: Fix callee-saved function ELF sizes
Date:   Mon,  5 Aug 2019 15:02:52 +0200
Message-Id: <20190805124939.004970037@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index e375d4266b53e..a04677038872c 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -768,6 +768,7 @@ static __always_inline bool pv_vcpu_is_preempted(long cpu)
 	    PV_RESTORE_ALL_CALLER_REGS					\
 	    FRAME_END							\
 	    "ret;"							\
+	    ".size " PV_THUNK_NAME(func) ", .-" PV_THUNK_NAME(func) ";"	\
 	    ".popsection")
 
 /* Get a reference to a callee-save function */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7f89d609095ac..cee45d46e67dc 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -830,6 +830,7 @@ asm(
 "cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
 "setne	%al;"
 "ret;"
+".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
 ".popsection");
 
 #endif
-- 
2.20.1



