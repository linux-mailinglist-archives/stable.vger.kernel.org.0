Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1526437B723
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 09:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhELH4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 03:56:19 -0400
Received: from 8bytes.org ([81.169.241.247]:38564 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhELH4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 03:56:17 -0400
Received: from cap.home.8bytes.org (p549ad305.dip0.t-ipconnect.de [84.154.211.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id E9F862A5;
        Wed, 12 May 2021 09:55:07 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH 1/6] x86/sev-es: Don't return NULL from sev_es_get_ghcb()
Date:   Wed, 12 May 2021 09:54:40 +0200
Message-Id: <20210512075445.18935-2-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512075445.18935-1-joro@8bytes.org>
References: <20210512075445.18935-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The sev_es_get_ghcb() is called from several places, but only one of
them checks the return value. The reaction to returning NULL is always
the same: Calling panic() and kill the machine.

Instead of adding checks to all call-places, move the panic() into the
function itself so that it will no longer return NULL.

Fixes: 0786138c78e7 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 9578c82832aa..c49270c7669e 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -203,8 +203,18 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 	if (unlikely(data->ghcb_active)) {
 		/* GHCB is already in use - save its contents */
 
-		if (unlikely(data->backup_ghcb_active))
-			return NULL;
+		if (unlikely(data->backup_ghcb_active)) {
+			/*
+			 * Backup-GHCB is also already in use. There is no way
+			 * to continue here so just kill the machine. To make
+			 * panic() work, mark GHCBs inactive so that messages
+			 * can be printed out.
+			 */
+			data->ghcb_active        = false;
+			data->backup_ghcb_active = false;
+
+			panic("Unable to handle #VC exception! GHCB and Backup GHCB are already in use");
+		}
 
 		/* Mark backup_ghcb active before writing to it */
 		data->backup_ghcb_active = true;
@@ -1284,7 +1294,6 @@ static __always_inline bool on_vc_fallback_stack(struct pt_regs *regs)
  */
 DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 {
-	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
 	irqentry_state_t irq_state;
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -1310,16 +1319,6 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 	 */
 
 	ghcb = sev_es_get_ghcb(&state);
-	if (!ghcb) {
-		/*
-		 * Mark GHCBs inactive so that panic() is able to print the
-		 * message.
-		 */
-		data->ghcb_active        = false;
-		data->backup_ghcb_active = false;
-
-		panic("Unable to handle #VC exception! GHCB and Backup GHCB are already in use");
-	}
 
 	vc_ghcb_invalidate(ghcb);
 	result = vc_init_em_ctxt(&ctxt, regs, error_code);
-- 
2.31.1

