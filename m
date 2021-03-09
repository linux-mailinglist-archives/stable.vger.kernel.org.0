Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DE7332B89
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 17:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhCIQIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 11:08:41 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53932 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbhCIQIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 11:08:14 -0500
Date:   Tue, 09 Mar 2021 16:08:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615306092;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5F7N5kd+eK43s5MXIq7LdDQpORfqOxSFoXbLiPet8ko=;
        b=06zOgsK3x5FYaWIZkDubheqh+7TeKYEBMh4Ac7SU9VJVRXKEiHjJ+zAF/wscrn7pVdyETJ
        P33Yxq3hkqtPEQvmxAA/uhQUWI62npC629mDJDA8tB1dPSIfuBSJofIcWlod5aWciu9ONv
        Q3H0LzxdrRVCenIDl7U/TcKY36fON7109V+5GtWoCwiAcff3OPtO9mubReztsuAAK8YHnz
        wGqGjIdaWHv+RL0HLNgdW4B9lPjJRf8yszG8jGjYrvnvpVEqYfYn9LtXt/lrr/KFDbed/N
        6jqjlrIEMr9a3fdM4jhpJ4QYhqO3NudCJ5Amot3ayCdUxLvBvNOcS0pocRl24Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615306092;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5F7N5kd+eK43s5MXIq7LdDQpORfqOxSFoXbLiPet8ko=;
        b=oPmpdhWS3KKF5JSbhl40gII+AShRGTE1EjnuchBy0Hp4KkC1Lkfb+9rsRYxKuQPYeW7y24
        Ieu0FrGFbRkFAQDQ==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev-es: Check regs->sp is trusted before
 adjusting #VC IST stack
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, 5.10+@tip-bot2.tec.linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210303141716.29223-3-joro@8bytes.org>
References: <20210303141716.29223-3-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <161530609222.398.7645217212660727699.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     545ac14c16b5dbd909d5a90ddf5b5a629a40fa94
Gitweb:        https://git.kernel.org/tip/545ac14c16b5dbd909d5a90ddf5b5a629a40fa94
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Wed, 03 Mar 2021 15:17:13 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 09 Mar 2021 12:26:26 +01:00

x86/sev-es: Check regs->sp is trusted before adjusting #VC IST stack

The code in the NMI handler to adjust the #VC handler IST stack is
needed in case an NMI hits when the #VC handler is still using its IST
stack.

But the check for this condition also needs to look if the regs->sp
value is trusted, meaning it was not set by user-space. Extend the check
to not use regs->sp when the NMI interrupted user-space code or the
SYSCALL gap.

Fixes: 315562c9af3d5 ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Reported-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # 5.10+
Link: https://lkml.kernel.org/r/20210303141716.29223-3-joro@8bytes.org
---
 arch/x86/kernel/sev-es.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 84c1821..301f20f 100644
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
