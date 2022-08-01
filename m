Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CC158666B
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 10:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiHAIfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 04:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiHAIfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 04:35:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E3E26D6
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 01:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69C03B80E87
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 08:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85390C433D7;
        Mon,  1 Aug 2022 08:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659342906;
        bh=YwUpGsJtau4xryDMVmQX5udVDTMP8v6+75eIcVX0gbE=;
        h=Subject:To:Cc:From:Date:From;
        b=eKSW6Ix9aEF20oWg72fHwzwmFUQav42dA9zBtnjiO2jP7B7HsAJnKdBrz4eJ4G4/a
         2tKysIpJonymr3aRpwwRit6jH2vYD3ezpEZ/rIf/d3wFxpjNmrz7ptlnzPxGehzOnK
         Aukwr1FZNPOCfW8Hv7D8RSv2oS2eHFYSCs/V0bvg=
Subject: FAILED: patch "[PATCH] Revert "x86/sev: Expose sev_es_ghcb_hv_call() for use by" failed to apply to 5.18-stable tree
To:     bp@suse.de, tiala@microsoft.com, wei.liu@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Aug 2022 10:35:02 +0200
Message-ID: <1659342902131124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5bb6c1d1126ebcbcd6314f80d82f50b021a9e351 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Wed, 27 Jul 2022 13:24:21 +0200
Subject: [PATCH] Revert "x86/sev: Expose sev_es_ghcb_hv_call() for use by
 HyperV"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This reverts commit 007faec014cb5d26983c1f86fd08c6539b41392e.

Now that hyperv does its own protocol negotiation:

  49d6a3c062a1 ("x86/Hyper-V: Add SEV negotiate protocol support in Isolation VM")

revert this exposure of the sev_es_ghcb_hv_call() helper.

Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by：Tianyu Lan <tiala@microsoft.com>
Link: https://lore.kernel.org/r/20220614014553.1915929-1-ltykernel@gmail.com

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 19514524f0f8..4a23e52fe0ee 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -72,7 +72,6 @@ static inline u64 lower_bits(u64 val, unsigned int bits)
 
 struct real_mode_header;
 enum stack_type;
-struct ghcb;
 
 /* Early IDT entry points for #VC handler */
 extern void vc_no_ghcb(void);
@@ -156,11 +155,7 @@ static __always_inline void sev_es_nmi_complete(void)
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
-extern enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
-					  bool set_ghcb_msr,
-					  struct es_em_ctxt *ctxt,
-					  u64 exit_code, u64 exit_info_1,
-					  u64 exit_info_2);
+
 static inline int rmpadjust(unsigned long vaddr, bool rmp_psize, unsigned long attrs)
 {
 	int rc;
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index b478edf43bec..3a5b0c9c4fcc 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -219,9 +219,10 @@ static enum es_result verify_exception_info(struct ghcb *ghcb, struct es_em_ctxt
 	return ES_VMM_ERROR;
 }
 
-enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool set_ghcb_msr,
-				   struct es_em_ctxt *ctxt, u64 exit_code,
-				   u64 exit_info_1, u64 exit_info_2)
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2)
 {
 	/* Fill in protocol and format specifiers */
 	ghcb->protocol_version = ghcb_version;
@@ -231,14 +232,7 @@ enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool set_ghcb_msr,
 	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
 	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
 
-	/*
-	 * Hyper-V unenlightened guests use a paravisor for communicating and
-	 * GHCB pages are being allocated and set up by that paravisor. Linux
-	 * should not change the GHCB page's physical address.
-	 */
-	if (set_ghcb_msr)
-		sev_es_wr_ghcb_msr(__pa(ghcb));
-
+	sev_es_wr_ghcb_msr(__pa(ghcb));
 	VMGEXIT();
 
 	return verify_exception_info(ghcb, ctxt);
@@ -795,7 +789,7 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		 */
 		sw_scratch = __pa(ghcb) + offsetof(struct ghcb, shared_buffer);
 		ghcb_set_sw_scratch(ghcb, sw_scratch);
-		ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_IOIO,
+		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO,
 					  exit_info_1, exit_info_2);
 		if (ret != ES_OK)
 			return ret;
@@ -837,8 +831,7 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 
 		ghcb_set_rax(ghcb, rax);
 
-		ret = sev_es_ghcb_hv_call(ghcb, true, ctxt,
-					  SVM_EXIT_IOIO, exit_info_1, 0);
+		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO, exit_info_1, 0);
 		if (ret != ES_OK)
 			return ret;
 
@@ -894,7 +887,7 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 		/* xgetbv will cause #GP - use reset value for xcr0 */
 		ghcb_set_xcr0(ghcb, 1);
 
-	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_CPUID, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
@@ -919,7 +912,7 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
-	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, exit_code, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index c05f0124c410..63dc626627a0 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -786,7 +786,7 @@ static int vmgexit_psc(struct snp_psc_desc *desc)
 		ghcb_set_sw_scratch(ghcb, (u64)__pa(data));
 
 		/* This will advance the shared buffer data points to. */
-		ret = sev_es_ghcb_hv_call(ghcb, true, &ctxt, SVM_VMGEXIT_PSC, 0, 0);
+		ret = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_PSC, 0, 0);
 
 		/*
 		 * Page State Change VMGEXIT can pass error code through
@@ -1212,8 +1212,7 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		ghcb_set_rdx(ghcb, regs->dx);
 	}
 
-	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_MSR,
-				  exit_info_1, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MSR, exit_info_1, 0);
 
 	if ((ret == ES_OK) && (!exit_info_1)) {
 		regs->ax = ghcb->save.rax;
@@ -1452,7 +1451,7 @@ static enum es_result vc_do_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
 
 	ghcb_set_sw_scratch(ghcb, ghcb_pa + offsetof(struct ghcb, shared_buffer));
 
-	return sev_es_ghcb_hv_call(ghcb, true, ctxt, exit_code, exit_info_1, exit_info_2);
+	return sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1, exit_info_2);
 }
 
 /*
@@ -1628,7 +1627,7 @@ static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
 
 	/* Using a value of 0 for ExitInfo1 means RAX holds the value */
 	ghcb_set_rax(ghcb, val);
-	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_WRITE_DR7, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WRITE_DR7, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
@@ -1658,7 +1657,7 @@ static enum es_result vc_handle_dr7_read(struct ghcb *ghcb,
 static enum es_result vc_handle_wbinvd(struct ghcb *ghcb,
 				       struct es_em_ctxt *ctxt)
 {
-	return sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_WBINVD, 0, 0);
+	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WBINVD, 0, 0);
 }
 
 static enum es_result vc_handle_rdpmc(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
@@ -1667,7 +1666,7 @@ static enum es_result vc_handle_rdpmc(struct ghcb *ghcb, struct es_em_ctxt *ctxt
 
 	ghcb_set_rcx(ghcb, ctxt->regs->cx);
 
-	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_RDPMC, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_RDPMC, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
@@ -1708,7 +1707,7 @@ static enum es_result vc_handle_vmmcall(struct ghcb *ghcb,
 	if (x86_platform.hyper.sev_es_hcall_prepare)
 		x86_platform.hyper.sev_es_hcall_prepare(ghcb, ctxt->regs);
 
-	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_VMMCALL, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_VMMCALL, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
@@ -2197,7 +2196,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned
 		ghcb_set_rbx(ghcb, input->data_npages);
 	}
 
-	ret = sev_es_ghcb_hv_call(ghcb, true, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
 	if (ret)
 		goto e_put;
 

