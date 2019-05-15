Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C98A1F27A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbfEOLLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbfEOLLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B73FE216F4;
        Wed, 15 May 2019 11:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918670;
        bh=I6d+9dKOeglrTD2kyHydzbVP6se/isQi7Sw1aONqFQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5cY4FcCy57vQGSM/s1uhibOL10zRl/azxMxejWWtLum+hY9VED4X+iqnyx1V+EHZ
         LMYYVCq0uPJISIZhiRqecf6t9x6Az+2HU+TERNkCvMQYS+mLuGSebLnBK0A/f5wWei
         GHfArRCAPe5KWmHckPrlIGAWQHmczQM4oNbXuE9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Dave Stewart <david.c.stewart@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 221/266] x86/speculation: Prepare arch_smt_update() for PRCTL mode
Date:   Wed, 15 May 2019 12:55:28 +0200
Message-Id: <20190515090730.469845973@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 6893a959d7fdebbab5f5aa112c277d5a44435ba1 upstream.

The upcoming fine grained per task STIBP control needs to be updated on CPU
hotplug as well.

Split out the code which controls the strict mode so the prctl control code
can be added later. Mark the SMP function call argument __unused while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Casey Schaufler <casey.schaufler@intel.com>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Waiman Long <longman9394@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Stewart <david.c.stewart@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20181125185005.759457117@linutronix.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   46 ++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -525,40 +525,44 @@ specv2_set_mode:
 	arch_smt_update();
 }
 
-static bool stibp_needed(void)
+static void update_stibp_msr(void * __unused)
 {
-	/* Enhanced IBRS makes using STIBP unnecessary. */
-	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
-		return false;
-
-	/* Check for strict user mitigation mode */
-	return spectre_v2_user == SPECTRE_V2_USER_STRICT;
+	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 }
 
-static void update_stibp_msr(void *info)
+/* Update x86_spec_ctrl_base in case SMT state changed. */
+static void update_stibp_strict(void)
 {
-	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+	u64 mask = x86_spec_ctrl_base & ~SPEC_CTRL_STIBP;
+
+	if (sched_smt_active())
+		mask |= SPEC_CTRL_STIBP;
+
+	if (mask == x86_spec_ctrl_base)
+		return;
+
+	pr_info("Update user space SMT mitigation: STIBP %s\n",
+		mask & SPEC_CTRL_STIBP ? "always-on" : "off");
+	x86_spec_ctrl_base = mask;
+	on_each_cpu(update_stibp_msr, NULL, 1);
 }
 
 void arch_smt_update(void)
 {
-	u64 mask;
-
-	if (!stibp_needed())
+	/* Enhanced IBRS implies STIBP. No update required. */
+	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return;
 
 	mutex_lock(&spec_ctrl_mutex);
 
-	mask = x86_spec_ctrl_base & ~SPEC_CTRL_STIBP;
-	if (sched_smt_active())
-		mask |= SPEC_CTRL_STIBP;
-
-	if (mask != x86_spec_ctrl_base) {
-		pr_info("Spectre v2 cross-process SMT mitigation: %s STIBP\n",
-			mask & SPEC_CTRL_STIBP ? "Enabling" : "Disabling");
-		x86_spec_ctrl_base = mask;
-		on_each_cpu(update_stibp_msr, NULL, 1);
+	switch (spectre_v2_user) {
+	case SPECTRE_V2_USER_NONE:
+		break;
+	case SPECTRE_V2_USER_STRICT:
+		update_stibp_strict();
+		break;
 	}
+
 	mutex_unlock(&spec_ctrl_mutex);
 }
 


