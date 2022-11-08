Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AA36217DD
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 16:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbiKHPRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 10:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbiKHPRe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 10:17:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD33C58BEB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 07:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667920539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oznpp/mqmqNugn0rBMm9hyJCzpsMUJC1y5VapRQROM8=;
        b=jO+78sIwFxl5L7Dojvc/WiqRm/S9h3nx9QifdJLWTiPh+vvZkIJfOaJKzfu1r+N3awae8d
        t2vyUUrU5PKQYDHsFMadZDTrFIJZ1qu84OoGqi+PYfUmTWyIynEaZQZz+yvn/nJfZFQv8+
        QQ0tO/VAoKd8mQcXu37+xdwL87FXiuw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-dadrY8dDO52eMzfC-olqAg-1; Tue, 08 Nov 2022 10:15:35 -0500
X-MC-Unique: dadrY8dDO52eMzfC-olqAg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F17463816EAF;
        Tue,  8 Nov 2022 15:15:33 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B686240C6FA3;
        Tue,  8 Nov 2022 15:15:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH v2 3/8] KVM: SVM: adjust register allocation for __svm_vcpu_run
Date:   Tue,  8 Nov 2022 10:15:27 -0500
Message-Id: <20221108151532.1377783-4-pbonzini@redhat.com>
In-Reply-To: <20221108151532.1377783-1-pbonzini@redhat.com>
References: <20221108151532.1377783-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In preparation for moving vmload/vmsave to __svm_vcpu_run,
keep the pointer to the struct vcpu_svm in %rdi.  This way
it is possible to load svm->vmcb01.pa in %rax without
clobbering the pointer to svm itself.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/vmenter.S | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index f0ff41103e4c..531510ab6072 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -54,29 +54,29 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Save @vmcb. */
 	push %_ASM_ARG1
 
-	/* Move @svm to RAX. */
-	mov %_ASM_ARG2, %_ASM_AX
+	/* Move @svm to RDI. */
+	mov %_ASM_ARG2, %_ASM_DI
+
+	/* "POP" @vmcb to RAX. */
+	pop %_ASM_AX
 
 	/* Load guest registers. */
-	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
-	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
-	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
-	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
-	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
-	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
+	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
+	mov VCPU_RDX(%_ASM_DI), %_ASM_DX
+	mov VCPU_RBX(%_ASM_DI), %_ASM_BX
+	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
+	mov VCPU_RSI(%_ASM_DI), %_ASM_SI
 #ifdef CONFIG_X86_64
-	mov VCPU_R8 (%_ASM_AX),  %r8
-	mov VCPU_R9 (%_ASM_AX),  %r9
-	mov VCPU_R10(%_ASM_AX), %r10
-	mov VCPU_R11(%_ASM_AX), %r11
-	mov VCPU_R12(%_ASM_AX), %r12
-	mov VCPU_R13(%_ASM_AX), %r13
-	mov VCPU_R14(%_ASM_AX), %r14
-	mov VCPU_R15(%_ASM_AX), %r15
+	mov VCPU_R8 (%_ASM_DI),  %r8
+	mov VCPU_R9 (%_ASM_DI),  %r9
+	mov VCPU_R10(%_ASM_DI), %r10
+	mov VCPU_R11(%_ASM_DI), %r11
+	mov VCPU_R12(%_ASM_DI), %r12
+	mov VCPU_R13(%_ASM_DI), %r13
+	mov VCPU_R14(%_ASM_DI), %r14
+	mov VCPU_R15(%_ASM_DI), %r15
 #endif
-
-	/* "POP" @vmcb to RAX. */
-	pop %_ASM_AX
+	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Enter guest mode */
 	sti
-- 
2.31.1


