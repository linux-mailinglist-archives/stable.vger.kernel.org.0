Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E558B1CE9AB
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 02:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgELA2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 20:28:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:32296 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgELA2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 20:28:18 -0400
IronPort-SDR: EY+DfhLUdbFuevUPnzFBzJpA563PWLxW4ka8Lak39PZec8U5qIf7IdVzeiuV91UBgUj41GtBsx
 YisyYpY0ytCw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 17:28:16 -0700
IronPort-SDR: Q4pgQU6IlebAtMXzULjrmPYJBwOq014pIgD5ELvX1ajvEzc6NPpk1LEzewXR7pZkI9PP4OH0ju
 v5cnaIxnHB7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="265331886"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 11 May 2020 17:28:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Tobias Urdin <tobias.urdin@binero.com>
Subject: [PATCH 4.19 STABLE v2 2/2] KVM: VMX: Mark RCX, RDX and RSI as clobbered in vmx_vcpu_run()'s asm blob
Date:   Mon, 11 May 2020 17:28:15 -0700
Message-Id: <20200512002815.2708-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200512002815.2708-1-sean.j.christopherson@intel.com>
References: <20200512002815.2708-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/x86/kvm/vmx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5b06a98ffd4cb..f08c287b62426 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10771,7 +10771,7 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	else if (static_branch_unlikely(&mds_user_clear))
 		mds_clear_cpu_buffers();
 
-	asm(
+	asm volatile (
 		/* Store host registers */
 		"push %%" _ASM_DX "; push %%" _ASM_BP ";"
 		"push %%" _ASM_CX " \n\t" /* placeholder for guest rcx */
@@ -10882,7 +10882,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		".global vmx_return \n\t"
 		"vmx_return: " _ASM_PTR " 2b \n\t"
 		".popsection"
-	      : : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
+	      : "=c"((int){0}), "=d"((int){0}), "=S"((int){0})
+	      : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
 		[launched]"i"(offsetof(struct vcpu_vmx, __launched)),
 		[fail]"i"(offsetof(struct vcpu_vmx, fail)),
 		[host_rsp]"i"(offsetof(struct vcpu_vmx, host_rsp)),
-- 
2.26.0

