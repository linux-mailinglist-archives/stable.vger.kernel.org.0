Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0300D1D0F2A
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732794AbgEMKFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732741AbgEMJqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59FA206F5;
        Wed, 13 May 2020 09:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363213;
        bh=cii3RA0dRVbmrD5M0uBBg2e5sz48zv7qjEyq0VJ164Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnSN2wEqsGQHk32Xy7Q4ki9aiZFdpCgCw9aBJCTu811eQy7sPsAw5500nXfrV0h+e
         aMqvR6kdOeblluAHBcnRQAKoakK2j46xGcSKFfPSQ+7G0aFJ6ncc/v+ODrBNN3z0SW
         3FueqiHZrvR0O7D4oOqKYGN1BCXzsRa4D5JyA5Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Urdin <tobias.urdin@binero.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 32/48] KVM: VMX: Mark RCX, RDX and RSI as clobbered in vmx_vcpu_run()s asm blob
Date:   Wed, 13 May 2020 11:44:58 +0200
Message-Id: <20200513094359.588081417@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Based on upstream commit f3689e3f17f064fd4cd5f0cb01ae2395c94f39d9.

Save RCX, RDX and RSI to fake outputs to coerce the compiler into
treating them as clobbered.  RCX in particular is likely to be reused by
the compiler to dereference the 'struct vcpu_vmx' pointer, which will
result in a null pointer dereference now that RCX is zeroed by the asm
blob.

Tag the asm() blob as volatile to prevent GCC from dropping the blob,
which is possible now that the blob has output values, all of which are
unused.

Upstream commit f3689e3f17f06 ("KVM: VMX: Save RSI to an unused output
in the vCPU-run asm blob") is not a direct equivalent of this patch. As
its shortlog states, it only tagged RSI as clobbered, whereas here RCX
and RDX are also clobbered.

In upstream at the time of the offending commit (b4be98039a92 in 4.19,
0e0ab73c9a024 upstream), the inline asm blob had previously been moved
to a dedicated helper, __vmx_vcpu_run().  For unrelated reasons,
__vmx_vcpu_run() was put into its own optimization unit, which for all
intents and purposes made it impossible to consume clobbered registers
because RCX, RDX and RSI are volatile and __vmx_vcpu_run() couldn't
itself be inlined.  In other words, the bug existed but couldn't be hit.

Similarly, the lack of "volatile" was also a bug in upstream that was
hidden by an unrelated change that exists in upstream but not in 4.19.
In this case, the asm blob also uses ASM_CALL_CONSTRAINT (marks RSP as
being an input/output constraint) in upstream to play nice with objtool
due the blob making a CALL.  In 4.19, there is no CALL and thus no
ASM_CALL_CONSTRAINT.

Furthermore, both of the lurking bugs were blasted away in upstream by
commits 5e0781df1899 ("KVM: VMX: Move vCPU-run code to a proper assembly
routine") and fc2ba5a27a1a ("KVM: VMX: Call vCPU-run asm sub-routine
from C and remove clobbering"), i.e. these bugs will never be directly
fixed in upstream.

Reported-by: Tobias Urdin <tobias.urdin@binero.com>
Fixes: b4be98039a92 ("KVM: VMX: Zero out *all* general purpose registers after VM-Exit")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10771,7 +10771,7 @@ static void __noclone vmx_vcpu_run(struc
 	else if (static_branch_unlikely(&mds_user_clear))
 		mds_clear_cpu_buffers();
 
-	asm(
+	asm volatile (
 		/* Store host registers */
 		"push %%" _ASM_DX "; push %%" _ASM_BP ";"
 		"push %%" _ASM_CX " \n\t" /* placeholder for guest rcx */
@@ -10882,7 +10882,8 @@ static void __noclone vmx_vcpu_run(struc
 		".global vmx_return \n\t"
 		"vmx_return: " _ASM_PTR " 2b \n\t"
 		".popsection"
-	      : : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
+	      : "=c"((int){0}), "=d"((int){0}), "=S"((int){0})
+	      : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
 		[launched]"i"(offsetof(struct vcpu_vmx, __launched)),
 		[fail]"i"(offsetof(struct vcpu_vmx, fail)),
 		[host_rsp]"i"(offsetof(struct vcpu_vmx, host_rsp)),


