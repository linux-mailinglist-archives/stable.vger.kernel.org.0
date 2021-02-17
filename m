Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422FC31D90E
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 13:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhBQMDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 07:03:36 -0500
Received: from 8bytes.org ([81.169.241.247]:55998 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232585AbhBQMDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 07:03:01 -0500
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 36CF337C;
        Wed, 17 Feb 2021 13:02:09 +0100 (CET)
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
Subject: [PATCH 2/3] x86/sev-es: Check if regs->sp is trusted before adjusting #VC IST stack
Date:   Wed, 17 Feb 2021 13:01:42 +0100
Message-Id: <20210217120143.6106-3-joro@8bytes.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210217120143.6106-1-joro@8bytes.org>
References: <20210217120143.6106-1-joro@8bytes.org>
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
 arch/x86/kernel/sev-es.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 84c1821819af..0df38b185d53 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -144,7 +144,9 @@ void noinstr __sev_es_ist_enter(struct pt_regs *regs)
 	old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
 
 	/* Make room on the IST stack */
-	if (on_vc_stack(regs->sp))
+	if (on_vc_stack(regs->sp) &&
+	    !user_mode(regs) &&
+	    !from_syscall_gap(regs))
 		new_ist = ALIGN_DOWN(regs->sp, 8) - sizeof(old_ist);
 	else
 		new_ist = old_ist - sizeof(old_ist);
-- 
2.30.0

