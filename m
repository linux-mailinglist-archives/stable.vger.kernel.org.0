Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A411171A4E
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbgB0Nw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:52:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731528AbgB0Nw0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:52:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EB8420801;
        Thu, 27 Feb 2020 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811545;
        bh=3QgU0zVYU/DB0NZNSNdbXIMHpD8QXRb9p3oe8blVHA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjusFdXG0yxy9Bq+HhRIeQ1DZ5AxYiIt/vfbxD8Jx4s+cc+TpW/lkH8A+v5QTdicC
         ffyVO9H2ToPnroSFrXyW2zlUB02Ya2Ds7H1xmXO+oOMlKsAXrmuSo6K/GTijEwjDpO
         GDZBxJVsF+pNCZi9qE5JmTYOyctJLBKnij2HrDXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpeng.li@hotmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 001/237] KVM: x86: emulate RDPID
Date:   Thu, 27 Feb 2020 14:33:35 +0100
Message-Id: <20200227132255.491283768@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit fb6d4d340e0532032c808a9933eaaa7b8de435ab upstream.

This is encoded as F3 0F C7 /7 with a register argument.  The register
argument is the second array in the group9 GroupDual, while F3 is the
fourth element of a Prefix.

Reviewed-by: Wanpeng Li <wanpeng.li@hotmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/cpuid.c   |    7 ++++++-
 arch/x86/kvm/emulate.c |   22 +++++++++++++++++++++-
 arch/x86/kvm/vmx.c     |   15 +++++++++++++++
 3 files changed, 42 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -291,13 +291,18 @@ static int __do_cpuid_ent_emulated(struc
 {
 	switch (func) {
 	case 0:
-		entry->eax = 1;		/* only one leaf currently */
+		entry->eax = 7;
 		++*nent;
 		break;
 	case 1:
 		entry->ecx = F(MOVBE);
 		++*nent;
 		break;
+	case 7:
+		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+		if (index == 0)
+			entry->ecx = F(RDPID);
+		++*nent;
 	default:
 		break;
 	}
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3539,6 +3539,16 @@ static int em_cwd(struct x86_emulate_ctx
 	return X86EMUL_CONTINUE;
 }
 
+static int em_rdpid(struct x86_emulate_ctxt *ctxt)
+{
+	u64 tsc_aux = 0;
+
+	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
+		return emulate_gp(ctxt, 0);
+	ctxt->dst.val = tsc_aux;
+	return X86EMUL_CONTINUE;
+}
+
 static int em_rdtsc(struct x86_emulate_ctxt *ctxt)
 {
 	u64 tsc = 0;
@@ -4431,10 +4441,20 @@ static const struct opcode group8[] = {
 	F(DstMem | SrcImmByte | Lock | PageTable,	em_btc),
 };
 
+/*
+ * The "memory" destination is actually always a register, since we come
+ * from the register case of group9.
+ */
+static const struct gprefix pfx_0f_c7_7 = {
+	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdtscp),
+};
+
+
 static const struct group_dual group9 = { {
 	N, I(DstMem64 | Lock | PageTable, em_cmpxchg8b), N, N, N, N, N, N,
 }, {
-	N, N, N, N, N, N, N, N,
+	N, N, N, N, N, N, N,
+	GP(0, &pfx_0f_c7_7),
 } };
 
 static const struct opcode group11[] = {
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -12322,6 +12322,21 @@ static int vmx_check_intercept(struct kv
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage)
 {
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+
+	/*
+	 * RDPID causes #UD if disabled through secondary execution controls.
+	 * Because it is marked as EmulateOnUD, we need to intercept it here.
+	 */
+	if (info->intercept == x86_intercept_rdtscp &&
+	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_RDTSCP)) {
+		ctxt->exception.vector = UD_VECTOR;
+		ctxt->exception.error_code_valid = false;
+		return X86EMUL_PROPAGATE_FAULT;
+	}
+
+	/* TODO: check more intercepts... */
 	return X86EMUL_CONTINUE;
 }
 


