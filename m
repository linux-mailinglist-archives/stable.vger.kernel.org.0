Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03158797A9
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390347AbfG2TuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390640AbfG2TuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:50:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8C6205F4;
        Mon, 29 Jul 2019 19:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429808;
        bh=Cr4KOxtfi18KMBE2YdTdbktPIVeaM+SaISX20fWfnrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMB36SMBx3fO044H4FiV0BP2SeULqX1LObPcieznjhCd0PQw0GkTm5xIzYXAlsdUy
         x3cIYgbnEoJZMVksBNM1X3BUjYP7mXq7ZBzkBtuThJLEOVhlunhPiyKjZ5t24R7SsP
         QRY0GiayKAhHXjH0bcUrrEjY8EFBBf7Z/Fx5juVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugene Korenevsky <ekorenevsky@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 075/215] kvm: vmx: segment limit check: use access length
Date:   Mon, 29 Jul 2019 21:21:11 +0200
Message-Id: <20190729190753.051105082@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fdb28619a8f033c13f5d9b9e8b5536bb6e68a2c3 ]

There is an imperfection in get_vmx_mem_address(): access length is ignored
when checking the limit. To fix this, pass access length as a function argument.
The access length is usually obvious since it is used by callers after
get_vmx_mem_address() call, but for vmread/vmwrite it depends on the
state of 64-bit mode.

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 28 ++++++++++++++++------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  3 ++-
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ac98b1328124..c1d118f4dc72 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4017,7 +4017,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
  * #UD or #GP.
  */
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
-			u32 vmx_instruction_info, bool wr, gva_t *ret)
+			u32 vmx_instruction_info, bool wr, int len, gva_t *ret)
 {
 	gva_t off;
 	bool exn;
@@ -4124,7 +4124,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 */
 		if (!(s.base == 0 && s.limit == 0xffffffff &&
 		     ((s.type & 8) || !(s.type & 4))))
-			exn = exn || ((u64)off + sizeof(u64) - 1 > s.limit);
+			exn = exn || ((u64)off + len - 1 > s.limit);
 	}
 	if (exn) {
 		kvm_queue_exception_e(vcpu,
@@ -4143,7 +4143,8 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
 	struct x86_exception e;
 
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmcs_read32(VMX_INSTRUCTION_INFO), false, &gva))
+				vmcs_read32(VMX_INSTRUCTION_INFO), false,
+				sizeof(*vmpointer), &gva))
 		return 1;
 
 	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
@@ -4394,6 +4395,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	u64 field_value;
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	int len;
 	gva_t gva = 0;
 	struct vmcs12 *vmcs12;
 
@@ -4431,12 +4433,12 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		kvm_register_writel(vcpu, (((vmx_instruction_info) >> 3) & 0xf),
 			field_value);
 	} else {
+		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
-				vmx_instruction_info, true, &gva))
+				vmx_instruction_info, true, len, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
-		kvm_write_guest_virt_system(vcpu, gva, &field_value,
-					    (is_long_mode(vcpu) ? 8 : 4), NULL);
+		kvm_write_guest_virt_system(vcpu, gva, &field_value, len, NULL);
 	}
 
 	return nested_vmx_succeed(vcpu);
@@ -4446,6 +4448,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 static int handle_vmwrite(struct kvm_vcpu *vcpu)
 {
 	unsigned long field;
+	int len;
 	gva_t gva;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
@@ -4471,11 +4474,11 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		field_value = kvm_register_readl(vcpu,
 			(((vmx_instruction_info) >> 3) & 0xf));
 	else {
+		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
-				vmx_instruction_info, false, &gva))
+				vmx_instruction_info, false, len, &gva))
 			return 1;
-		if (kvm_read_guest_virt(vcpu, gva, &field_value,
-					(is_64_bit_mode(vcpu) ? 8 : 4), &e)) {
+		if (kvm_read_guest_virt(vcpu, gva, &field_value, len, &e)) {
 			kvm_inject_page_fault(vcpu, &e);
 			return 1;
 		}
@@ -4634,7 +4637,8 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	if (unlikely(to_vmx(vcpu)->nested.hv_evmcs))
 		return 1;
 
-	if (get_vmx_mem_address(vcpu, exit_qual, instr_info, true, &gva))
+	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
+				true, sizeof(gpa_t), &gva))
 		return 1;
 	/* *_system ok, nested_vmx_check_permission has verified cpl=0 */
 	if (kvm_write_guest_virt_system(vcpu, gva, (void *)&current_vmptr,
@@ -4680,7 +4684,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmx_instruction_info, false, &gva))
+			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
 		kvm_inject_page_fault(vcpu, &e);
@@ -4742,7 +4746,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmx_instruction_info, false, &gva))
+			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
 		kvm_inject_page_fault(vcpu, &e);
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index e847ff1019a2..29d205bb4e4f 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -21,7 +21,7 @@ void nested_sync_from_vmcs12(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
-			u32 vmx_instruction_info, bool wr, gva_t *ret);
+			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 306ed28569c0..924c2a79e4a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5349,7 +5349,8 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	 * is read even if it isn't needed (e.g., for type==all)
 	 */
 	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-				vmx_instruction_info, false, &gva))
+				vmx_instruction_info, false,
+				sizeof(operand), &gva))
 		return 1;
 
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-- 
2.20.1



