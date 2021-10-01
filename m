Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D969341E9F8
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 11:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352915AbhJAJpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 05:45:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33856 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352947AbhJAJpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 05:45:46 -0400
Received: from zn.tnic (p200300ec2f0e8e00572b4e04e961fee2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8e00:572b:4e04:e961:fee2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7E0A91EC05B6;
        Fri,  1 Oct 2021 11:44:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633081440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qaH2SgXehFdkwuB+NIo6dtbyZPg14ekiHuQVpif4oEY=;
        b=WUJyFN8nvj3q1/0z8QCYl3onXXIBSU7a4EcE8pg50Wq8WlgoI2ELV5TtshIUd15J2q/xCE
        ov05ia8r/CJDTX+tfsPXk+U1gU037u1/D+xt3WvtrtNwVy4L0JczZIxN0mwG+/wCo0r7B6
        WzIM8vlfW11m0Skjt1hVp0xRepqzqzc=
Date:   Fri, 1 Oct 2021 11:43:55 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Return an error on a returned non-zero
 SW_EXITINFO1[31:0]
Message-ID: <YVbYWz+8J7iMTJjc@zn.tnic>
References: <efc772af831e9e7f517f0439b13b41f56bad8784.1633063321.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <efc772af831e9e7f517f0439b13b41f56bad8784.1633063321.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 11:42:01PM -0500, Tom Lendacky wrote:
> After returning from a VMGEXIT NAE event, SW_EXITINFO1[31:0] is checked
> for a value of 1, which indicates an error and that SW_EXITINFO2 contains
> exception information. However, future versions of the GHCB specification
> may define new values for SW_EXITINFO1[31:0], so really any non-zero value
> should be treated as an error.
> 
> Fixes: 597cfe48212a ("x86/boot/compressed/64: Setup a GHCB-based VC Exception handler")
> Cc: <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kernel/sev-shared.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 34f20e08dc46..ff1e82ff52d9 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -130,6 +130,8 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>  		} else {
>  			ret = ES_VMM_ERROR;
>  		}
> +	} else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
> +		ret = ES_VMM_ERROR;
>  	} else {
>  		ret = ES_OK;
>  	}
> -- 

So I wanna do this ontop. Might wanna apply it and look at the result -
it shows better what the changes are.

---
From: Borislav Petkov <bp@suse.de>
Date: Fri, 1 Oct 2021 11:41:05 +0200
Subject: [PATCH] x86/sev: Carve out HV call return value verification

Carve out the verification of the HV call return value into a separate
helper and make it more readable.

No it more readable.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/sev-shared.c | 53 ++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index bf1033a62e48..f2933f740fa7 100644
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
+	int ret;
 
-	/* Fill in protocol and format specifiers */
-	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
-	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
+	ret = ghcb->save.sw_exit_info_1 & 0xffffffff;
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
