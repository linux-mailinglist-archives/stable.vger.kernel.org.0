Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D9832C813
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346120AbhCDAdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344957AbhCCOSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 09:18:36 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299F2C06178C;
        Wed,  3 Mar 2021 06:17:28 -0800 (PST)
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 58CC6412;
        Wed,  3 Mar 2021 15:17:23 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        hpa@zytor.com, Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 2/5] x86/sev-es: Check if regs->sp is trusted before adjusting #VC IST stack
Date:   Wed,  3 Mar 2021 15:17:13 +0100
Message-Id: <20210303141716.29223-3-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210303141716.29223-1-joro@8bytes.org>
References: <20210303141716.29223-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The code in the NMI handler to adjust the #VC handler IST stack is
needed in case an NMI hits when the #VC handler is still using its IST
stack.
But the check for this condition also needs to look if the regs->sp
value is trusted, meaning it was not set by user-space. Extend the
check to not use regs->sp when the NMI interrupted user-space code or
the SYSCALL gap.

Reported-by: Andy Lutomirski <luto@kernel.org>
Fixes: 315562c9af3d5 ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 1e78f4bd7bf2..28b0144daddd 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -121,8 +121,18 @@ static void __init setup_vc_stacks(int cpu)
 	cea_set_pte((void *)vaddr, pa, PAGE_KERNEL);
 }
 
-static __always_inline bool on_vc_stack(unsigned long sp)
+static __always_inline bool on_vc_stack(struct pt_regs *regs)
 {
+	unsigned long sp = regs->sp;
+
+	/* User-mode RSP is not trusted */
+	if (user_mode(regs))
+		return false;
+
+	/* SYSCALL gap still has user-mode RSP */
+	if (ip_within_syscall_gap(regs))
+		return false;
+
 	return ((sp >= __this_cpu_ist_bottom_va(VC)) && (sp < __this_cpu_ist_top_va(VC)));
 }
 
@@ -144,7 +154,7 @@ void noinstr __sev_es_ist_enter(struct pt_regs *regs)
 	old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
 
 	/* Make room on the IST stack */
-	if (on_vc_stack(regs->sp))
+	if (on_vc_stack(regs))
 		new_ist = ALIGN_DOWN(regs->sp, 8) - sizeof(old_ist);
 	else
 		new_ist = old_ist - sizeof(old_ist);
-- 
2.30.1

