Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B4C332B87
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 17:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhCIQIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 11:08:42 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53926 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhCIQIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 11:08:13 -0500
Date:   Tue, 09 Mar 2021 16:08:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615306092;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ydP5OQo35wAYWz8Gi3ovOO+XhHXKCyB4t30sZUCfcWY=;
        b=nsZ8Th5H5/zsO4YFl832ncOKMjnzzxio0VuJ6lBubI6i/9DUSr0PmT4kG7DD4WcfXOhLoa
        ZBtVqz+9ygOrW37YaKJLMMQFKWAO+fdZymo9QItWZiC6Y0S3uGo97dp9jMZFnH7CdCUWgo
        5MhMQYNtwNOJ3Z4wf+wLnIe9eGeoGUbKouZ3Ji1wijVkdSLy+ZHk1SaJ0I3kLILNOhBDg1
        hDkolbGTIwW0j8f9bBWuP5YUsmJyrSG8jM7uajAvHCuJCY/pAC2uDGc3B9oJ7D9Zn82OAQ
        VlLHVLqxSnGJ6e8r4NAB/bVciaPpJblssdN6lKth9GODMBA4+Yia53Qry1P/RQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615306092;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ydP5OQo35wAYWz8Gi3ovOO+XhHXKCyB4t30sZUCfcWY=;
        b=LAyffzNC8k6oFMCgFgcPG7DdJWE7W+sff6EeaPNVcS60FT81IS7NQsaFJCYxX3yb3AFcYf
        1HcgYsprM2pqZ0CA==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev-es: Correctly track IRQ states in runtime
 #VC handler
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, v5.10+@tip-bot2.tec.linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210303141716.29223-5-joro@8bytes.org>
References: <20210303141716.29223-5-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <161530609185.398.9748998065952345534.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     62441a1fb53263bda349b6e5997c3cc5c120d89e
Gitweb:        https://git.kernel.org/tip/62441a1fb53263bda349b6e5997c3cc5c120d89e
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Wed, 03 Mar 2021 15:17:15 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 09 Mar 2021 12:33:46 +01:00

x86/sev-es: Correctly track IRQ states in runtime #VC handler

Call irqentry_nmi_enter()/irqentry_nmi_exit() in the #VC handler to
correctly track the IRQ state during its execution.

Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Reported-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v5.10+
Link: https://lkml.kernel.org/r/20210303141716.29223-5-joro@8bytes.org
---
 arch/x86/kernel/sev-es.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 301f20f..c3fd8fa 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -1258,13 +1258,12 @@ static __always_inline bool on_vc_fallback_stack(struct pt_regs *regs)
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
@@ -1273,6 +1272,8 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 		return;
 	}
 
+	irq_state = irqentry_nmi_enter(regs);
+	lockdep_assert_irqs_disabled();
 	instrumentation_begin();
 
 	/*
@@ -1335,6 +1336,7 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 
 out:
 	instrumentation_end();
+	irqentry_nmi_exit(regs, irq_state);
 
 	return;
 
