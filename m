Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8474E4915E6
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345881AbiARCcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245550AbiARC2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:28:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F525C0612FD;
        Mon, 17 Jan 2022 18:25:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A02A61130;
        Tue, 18 Jan 2022 02:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F0FC36AF2;
        Tue, 18 Jan 2022 02:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472752;
        bh=IuUQk7EuyxnlKJabLJmOzkPUFtwzZ9odlbaCsWfgiVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pN6ecbV9Arkk71/nhsLA79XQ8coadOYTq9SmQ0NFtG5aC/ENnwOwZi1VI9s6b+NOz
         J4n6o3bBlLBrmFehogXEiPRry2lcz5SIYOFt4xIVzQTKlu/0pvmrJkDXC5BG5fB9MP
         gmAA+pKzvQ4LV1RZ/yWKVYfyGysTiG1+DGXF14UE68BMXr/BdJJejavx7kMT2YpKkJ
         lCOiF0vikbQlw6viNuFJ5H+j9SXMLRcC+ZT3B8gqPFFGWeddpGV3dJkmK05SzFj9yQ
         yGo7alJCNqxbmT62vGqhBZkH7By1IgNbeuqYcBp2nmavIf2npZ1HW848WR58jujhwT
         qjq4UgY286zow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 123/217] x86/mce: Prevent severity computation from being instrumented
Date:   Mon, 17 Jan 2022 21:18:06 -0500
Message-Id: <20220118021940.1942199-123-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 0a5b288e85bbef5227bb6397e31fcf1d7ba9142a ]

Mark all the MCE severity computation logic noinstr and allow
instrumentation when it "calls out".

Fixes

  vmlinux.o: warning: objtool: do_machine_check()+0xc5d: call to mce_severity() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-7-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/severity.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/severity.c b/arch/x86/kernel/cpu/mce/severity.c
index bb019a594a2c9..171a1495111b1 100644
--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -263,24 +263,36 @@ static bool is_copy_from_user(struct pt_regs *regs)
  * distinguish an exception taken in user from from one
  * taken in the kernel.
  */
-static int error_context(struct mce *m, struct pt_regs *regs)
+static noinstr int error_context(struct mce *m, struct pt_regs *regs)
 {
+	int fixup_type;
+	bool copy_user;
+
 	if ((m->cs & 3) == 3)
 		return IN_USER;
+
 	if (!mc_recoverable(m->mcgstatus))
 		return IN_KERNEL;
 
-	switch (ex_get_fixup_type(m->ip)) {
+	/* Allow instrumentation around external facilities usage. */
+	instrumentation_begin();
+	fixup_type = ex_get_fixup_type(m->ip);
+	copy_user  = is_copy_from_user(regs);
+	instrumentation_end();
+
+	switch (fixup_type) {
 	case EX_TYPE_UACCESS:
 	case EX_TYPE_COPY:
-		if (!regs || !is_copy_from_user(regs))
+		if (!regs || !copy_user)
 			return IN_KERNEL;
 		m->kflags |= MCE_IN_KERNEL_COPYIN;
 		fallthrough;
+
 	case EX_TYPE_FAULT_MCE_SAFE:
 	case EX_TYPE_DEFAULT_MCE_SAFE:
 		m->kflags |= MCE_IN_KERNEL_RECOV;
 		return IN_KERNEL_RECOV;
+
 	default:
 		return IN_KERNEL;
 	}
@@ -317,8 +329,8 @@ static int mce_severity_amd_smca(struct mce *m, enum context err_ctx)
  * See AMD Error Scope Hierarchy table in a newer BKDG. For example
  * 49125_15h_Models_30h-3Fh_BKDG.pdf, section "RAS Features"
  */
-static int mce_severity_amd(struct mce *m, struct pt_regs *regs, int tolerant,
-			    char **msg, bool is_excp)
+static noinstr int mce_severity_amd(struct mce *m, struct pt_regs *regs, int tolerant,
+				    char **msg, bool is_excp)
 {
 	enum context ctx = error_context(m, regs);
 
@@ -370,8 +382,8 @@ static int mce_severity_amd(struct mce *m, struct pt_regs *regs, int tolerant,
 	return MCE_KEEP_SEVERITY;
 }
 
-static int mce_severity_intel(struct mce *m, struct pt_regs *regs,
-			      int tolerant, char **msg, bool is_excp)
+static noinstr int mce_severity_intel(struct mce *m, struct pt_regs *regs,
+				      int tolerant, char **msg, bool is_excp)
 {
 	enum exception excp = (is_excp ? EXCP_CONTEXT : NO_EXCP);
 	enum context ctx = error_context(m, regs);
@@ -407,8 +419,8 @@ static int mce_severity_intel(struct mce *m, struct pt_regs *regs,
 	}
 }
 
-int mce_severity(struct mce *m, struct pt_regs *regs, int tolerant, char **msg,
-		 bool is_excp)
+int noinstr mce_severity(struct mce *m, struct pt_regs *regs, int tolerant, char **msg,
+			 bool is_excp)
 {
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
 	    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
-- 
2.34.1

