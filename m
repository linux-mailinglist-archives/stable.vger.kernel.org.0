Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7855B429557
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 19:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhJKRPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 13:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhJKRPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 13:15:41 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0824BC061570;
        Mon, 11 Oct 2021 10:13:41 -0700 (PDT)
Received: from zn.tnic (p200300ec2f08bb00e407f16cd758a723.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:bb00:e407:f16c:d758:a723])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5CE331EC03CA;
        Mon, 11 Oct 2021 19:13:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633972419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UCf+OlFdFEs0sMpCGO70LL+YcIAZ0CdGrQ0tUSfjgfw=;
        b=qktKU29O+q+Cm4MJQ6B0HdupzpmRhJPxoEHa3a/KOp8JXcfuZx3cop+7QkbCOXkKqB9VhS
        OZTBLs4MKbMQJ0TqneCOfARPJ0vMpiruhC0p7TSdhqooDUFG9+62DzfAcDdSDrAIoI3WrL
        9LeBbAk4KDjhy/rsj8GQ8D5nusKkq7o=
Date:   Mon, 11 Oct 2021 19:13:40 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
Subject: [PATCH] x86/sev: Carve out HV call's return value verification
Message-ID: <YWRwxImd9Qcls/Yy@zn.tnic>
References: <efc772af831e9e7f517f0439b13b41f56bad8784.1633063321.git.thomas.lendacky@amd.com>
 <YVbYWz+8J7iMTJjc@zn.tnic>
 <00d48af4-1683-350c-c334-08968d455e4c@amd.com>
 <YVcTDM9hshdlUqbN@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YVcTDM9hshdlUqbN@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now as a proper patch with typo fixed and tested:

---
From: Borislav Petkov <bp@suse.de>

Carve out the verification of the HV call return value into a separate
helper and make it more readable.

No functional changes.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/sev-shared.c | 53 ++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index bf1033a62e48..4579c38a11c4 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -94,25 +94,15 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
 	ctxt->regs->ip += ctxt->insn.length;
 }
 
-static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
-					  struct es_em_ctxt *ctxt,
-					  u64 exit_code, u64 exit_info_1,
-					  u64 exit_info_2)
+static enum es_result verify_exception_info(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
-	enum es_result ret;
+	u32 ret;
 
-	/* Fill in protocol and format specifiers */
-	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
-	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
+	ret = ghcb->save.sw_exit_info_1 & GENMASK_ULL(31, 0);
+	if (!ret)
+		return ES_OK;
 
-	ghcb_set_sw_exit_code(ghcb, exit_code);
-	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
-	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
-
-	sev_es_wr_ghcb_msr(__pa(ghcb));
-	VMGEXIT();
-
-	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
+	if (ret == 1) {
 		u64 info = ghcb->save.sw_exit_info_2;
 		unsigned long v;
 
@@ -124,19 +114,34 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 		    ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
 		    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
 			ctxt->fi.vector = v;
+
 			if (info & SVM_EVTINJ_VALID_ERR)
 				ctxt->fi.error_code = info >> 32;
-			ret = ES_EXCEPTION;
-		} else {
-			ret = ES_VMM_ERROR;
+
+			return ES_EXCEPTION;
 		}
-	} else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
-		ret = ES_VMM_ERROR;
-	} else {
-		ret = ES_OK;
 	}
 
-	return ret;
+	return ES_VMM_ERROR;
+}
+
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2)
+{
+	/* Fill in protocol and format specifiers */
+	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
+	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
+
+	ghcb_set_sw_exit_code(ghcb, exit_code);
+	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	return verify_exception_info(ghcb, ctxt);
 }
 
 /*
-- 
2.29.2


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
