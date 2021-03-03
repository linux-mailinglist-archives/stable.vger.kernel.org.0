Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF2B32C810
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242128AbhCDAds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:33:48 -0500
Received: from 8bytes.org ([81.169.241.247]:57438 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243058AbhCCOSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 09:18:25 -0500
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 7763747C;
        Wed,  3 Mar 2021 15:17:24 +0100 (CET)
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
Subject: [PATCH 4/5] x86/sev-es: Correctly track IRQ states in runtime #VC handler
Date:   Wed,  3 Mar 2021 15:17:15 +0100
Message-Id: <20210303141716.29223-5-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210303141716.29223-1-joro@8bytes.org>
References: <20210303141716.29223-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Call irqentry_nmi_enter()/irqentry_nmi_exit() in the #VC handler to
correctly track the IRQ state during its execution.

Reported-by: Andy Lutomirski <luto@kernel.org>
Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index e1eeb3ef58c5..3d8ec5bf6f79 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -1270,13 +1270,12 @@ static __always_inline bool on_vc_fallback_stack(struct pt_regs *regs)
 DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 {
 	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
+	irqentry_state_t irq_state;
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
 	enum es_result result;
 	struct ghcb *ghcb;
 
-	lockdep_assert_irqs_disabled();
-
 	/*
 	 * Handle #DB before calling into !noinstr code to avoid recursive #DB.
 	 */
@@ -1285,6 +1284,8 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 		return;
 	}
 
+	irq_state = irqentry_nmi_enter(regs);
+	lockdep_assert_irqs_disabled();
 	instrumentation_begin();
 
 	/*
@@ -1347,6 +1348,7 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 
 out:
 	instrumentation_end();
+	irqentry_nmi_exit(regs, irq_state);
 
 	return;
 
-- 
2.30.1

