Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0835F5C52
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 00:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiJEWDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 18:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiJEWC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 18:02:58 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59437C77A;
        Wed,  5 Oct 2022 15:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665007373; x=1696543373;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=evHdjOAXPKiLJGfX1Rxa4wcF9HGFqVjvbfA3kvjlMjw=;
  b=p/DV0fSlXwaxE2PYTmURWTkC0xavENyj8xoEEHyfypR6nn8XxoOvP5yl
   KH9Pk7Ve5AYGVCpU45HYKmr9vjxgRpICTp1W734l+nMWZkWyo4I6wp9Av
   2zQJ6lnz/esBo3zUX1VnTbelrgWCPwnQflExaG4juyCo/YDEXKyqbLDFn
   k=;
X-IronPort-AV: E=Sophos;i="5.95,162,1661817600"; 
   d="scan'208";a="266550556"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 22:02:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id EB307201312;
        Wed,  5 Oct 2022 22:02:45 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 5 Oct 2022 22:02:44 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.161.69) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Wed, 5 Oct 2022 22:02:43 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@suse.de>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <peterz@infradead.org>,
        <jpoimboe@kernel.org>, <daniel.sneddon@linux.intel.com>,
        <pawan.kumar.gupta@linux.intel.com>, <benh@kernel.crashing.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with WRMSR
Date:   Wed, 5 Oct 2022 15:02:27 -0700
Message-ID: <20221005220227.1959-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D06UWC004.ant.amazon.com (10.43.162.97) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-14.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tl;dr: The existing mitigation for eIBRS PBRSB predictions uses an INT3 to
ensure a call instruction retires before a following unbalanced RET. Replace
this with a WRMSR serialising instruction which has a lower performance
penalty.

== Background ==

eIBRS (enhanced indirect branch restricted speculation) is used to prevent
predictor addresses from one privilege domain from being used for prediction
in a higher privilege domain.

== Problem ==

On processors with eIBRS protections there can be a case where upon VM exit
a guest address may be used as an RSB prediction for an unbalanced RET if a
CALL instruction hasn't yet been retired. This is termed PBRSB (Post-Barrier
Return Stack Buffer).

A mitigation for this was introduced in:
(2b1299322016731d56807aa49254a5ea3080b6b3 x86/speculation: Add RSB VM Exit protections)

This mitigation [1] has a ~1% performance impact on VM exit compared to without
it [2].

== Solution ==

The WRMSR instruction can be used as a speculation barrier and a serialising
instruction. Use this on the VM exit path instead to ensure that a CALL
instruction (in this case the call to vmx_spec_ctrl_restore_host) has retired
before the prediction of a following unbalanced RET.

This mitigation [3] has a negligible performance impact.

== Testing ==

Run the outl_to_kernel kvm-unit-tests test 200 times per configuration which
counts the cycles for an exit to kernel mode.

[1] With existing mitigation:
Average: 2026 cycles
[2] With no mitigation:
Average: 2008 cycles
[3] With proposed mitigation:
Average: 2008 cycles

Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Cc: stable@vger.kernel.org
---
 arch/x86/include/asm/nospec-branch.h | 7 +++----
 arch/x86/kvm/vmx/vmenter.S           | 3 +--
 arch/x86/kvm/vmx/vmx.c               | 5 +++++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index c936ce9f0c47..e5723e024b47 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -159,10 +159,9 @@
   * A simpler FILL_RETURN_BUFFER macro. Don't make people use the CPP
   * monstrosity above, manually.
   */
-.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2=ALT_NOT(X86_FEATURE_ALWAYS)
-	ALTERNATIVE_2 "jmp .Lskip_rsb_\@", \
-		__stringify(__FILL_RETURN_BUFFER(\reg,\nr)), \ftr, \
-		__stringify(__FILL_ONE_RETURN), \ftr2
+.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
+	ALTERNATIVE "jmp .Lskip_rsb_\@", \
+		__stringify(__FILL_RETURN_BUFFER(\reg,\nr)), \ftr
 
 .Lskip_rsb_\@:
 .endm
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 6de96b943804..eb82797bd7bf 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -231,8 +231,7 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	 * single call to retire, before the first unbalanced RET.
          */
 
-	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT,\
-			   X86_FEATURE_RSB_VMEXIT_LITE
+	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 
 
 	pop %_ASM_ARG2	/* @flags */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..fdcd8e10c2ab 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7049,8 +7049,13 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 	 * For legacy IBRS, the IBRS bit always needs to be written after
 	 * transitioning from a less privileged predictor mode, regardless of
 	 * whether the guest/host values differ.
+	 *
+	 * For eIBRS affected by Post Barrier RSB Predictions a serialising
+	 * instruction (wrmsr) must be executed to ensure a call instruction has
+	 * retired before the prediction of a following unbalanced ret.
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
+	    cpu_feature_enabled(X86_FEATURE_RSB_VMEXIT_LITE) ||
 	    vmx->spec_ctrl != hostval)
 		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
 
-- 
2.17.1

