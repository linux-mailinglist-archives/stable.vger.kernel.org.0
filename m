Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F74A3C5345
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352227AbhGLHyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349316AbhGLHuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DF2A619A9;
        Mon, 12 Jul 2021 07:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075810;
        bh=MD1JWawNe2ws4m20kH+0XKMRaIcFuDj9Vi/Qa8d8hoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ht8G4o35uh4KUlrFKAm/VtSWF8KteHM8e3JnVvmAzmLlYGsa/b5ROtXPhbsMQJqKL
         mqx2iL5QncOTL8Jv4Fy/rIpd/M4sxCqaBI2r6BFOJcQ66K06BUfer7QbxNzQO+m3he
         ZwkMErgWlladi76Gzlwu8JvYvZyv2EZFC+dQgRGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 337/800] x86/sev: Make sure IRQs are disabled while GHCB is active
Date:   Mon, 12 Jul 2021 08:06:00 +0200
Message-Id: <20210712061002.534442696@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit d187f217335dba2b49fc9002aab2004e04acddee ]

The #VC handler only cares about IRQs being disabled while the GHCB is
active, as it must not be interrupted by something which could cause
another #VC while it holds the GHCB (NMI is the exception for which the
backup GHCB exits).

Make sure nothing interrupts the code path while the GHCB is active
by making sure that callers of __sev_{get,put}_ghcb() have disabled
interrupts upfront.

 [ bp: Massage commit message. ]

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210618115409.22735-2-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/sev.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 651b81cd648e..396d578043d1 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -12,7 +12,6 @@
 #include <linux/sched/debug.h>	/* For show_regs() */
 #include <linux/percpu-defs.h>
 #include <linux/mem_encrypt.h>
-#include <linux/lockdep.h>
 #include <linux/printk.h>
 #include <linux/mm_types.h>
 #include <linux/set_memory.h>
@@ -192,11 +191,19 @@ void noinstr __sev_es_ist_exit(void)
 	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], *(unsigned long *)ist);
 }
 
-static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
+/*
+ * Nothing shall interrupt this code path while holding the per-CPU
+ * GHCB. The backup GHCB is only for NMIs interrupting this path.
+ *
+ * Callers must disable local interrupts around it.
+ */
+static noinstr struct ghcb *__sev_get_ghcb(struct ghcb_state *state)
 {
 	struct sev_es_runtime_data *data;
 	struct ghcb *ghcb;
 
+	WARN_ON(!irqs_disabled());
+
 	data = this_cpu_read(runtime_data);
 	ghcb = &data->ghcb_page;
 
@@ -213,7 +220,9 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 			data->ghcb_active        = false;
 			data->backup_ghcb_active = false;
 
+			instrumentation_begin();
 			panic("Unable to handle #VC exception! GHCB and Backup GHCB are already in use");
+			instrumentation_end();
 		}
 
 		/* Mark backup_ghcb active before writing to it */
@@ -479,11 +488,13 @@ static enum es_result vc_slow_virt_to_phys(struct ghcb *ghcb, struct es_em_ctxt
 /* Include code shared with pre-decompression boot stage */
 #include "sev-shared.c"
 
-static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
+static noinstr void __sev_put_ghcb(struct ghcb_state *state)
 {
 	struct sev_es_runtime_data *data;
 	struct ghcb *ghcb;
 
+	WARN_ON(!irqs_disabled());
+
 	data = this_cpu_read(runtime_data);
 	ghcb = &data->ghcb_page;
 
@@ -507,7 +518,7 @@ void noinstr __sev_es_nmi_complete(void)
 	struct ghcb_state state;
 	struct ghcb *ghcb;
 
-	ghcb = sev_es_get_ghcb(&state);
+	ghcb = __sev_get_ghcb(&state);
 
 	vc_ghcb_invalidate(ghcb);
 	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_NMI_COMPLETE);
@@ -517,7 +528,7 @@ void noinstr __sev_es_nmi_complete(void)
 	sev_es_wr_ghcb_msr(__pa_nodebug(ghcb));
 	VMGEXIT();
 
-	sev_es_put_ghcb(&state);
+	__sev_put_ghcb(&state);
 }
 
 static u64 get_jump_table_addr(void)
@@ -529,7 +540,7 @@ static u64 get_jump_table_addr(void)
 
 	local_irq_save(flags);
 
-	ghcb = sev_es_get_ghcb(&state);
+	ghcb = __sev_get_ghcb(&state);
 
 	vc_ghcb_invalidate(ghcb);
 	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_AP_JUMP_TABLE);
@@ -543,7 +554,7 @@ static u64 get_jump_table_addr(void)
 	    ghcb_sw_exit_info_2_is_valid(ghcb))
 		ret = ghcb->save.sw_exit_info_2;
 
-	sev_es_put_ghcb(&state);
+	__sev_put_ghcb(&state);
 
 	local_irq_restore(flags);
 
@@ -668,7 +679,7 @@ static void sev_es_ap_hlt_loop(void)
 	struct ghcb_state state;
 	struct ghcb *ghcb;
 
-	ghcb = sev_es_get_ghcb(&state);
+	ghcb = __sev_get_ghcb(&state);
 
 	while (true) {
 		vc_ghcb_invalidate(ghcb);
@@ -685,7 +696,7 @@ static void sev_es_ap_hlt_loop(void)
 			break;
 	}
 
-	sev_es_put_ghcb(&state);
+	__sev_put_ghcb(&state);
 }
 
 /*
@@ -1344,7 +1355,6 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 	}
 
 	irq_state = irqentry_nmi_enter(regs);
-	lockdep_assert_irqs_disabled();
 	instrumentation_begin();
 
 	/*
@@ -1353,7 +1363,7 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 	 * keep the IRQs disabled to protect us against concurrent TLB flushes.
 	 */
 
-	ghcb = sev_es_get_ghcb(&state);
+	ghcb = __sev_get_ghcb(&state);
 
 	vc_ghcb_invalidate(ghcb);
 	result = vc_init_em_ctxt(&ctxt, regs, error_code);
@@ -1361,7 +1371,7 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 	if (result == ES_OK)
 		result = vc_handle_exitcode(&ctxt, ghcb, error_code);
 
-	sev_es_put_ghcb(&state);
+	__sev_put_ghcb(&state);
 
 	/* Done - now check the result */
 	switch (result) {
-- 
2.30.2



