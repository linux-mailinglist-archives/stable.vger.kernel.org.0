Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73108E68FD
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfJ0VMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730013AbfJ0VMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:13 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ACCD2064A;
        Sun, 27 Oct 2019 21:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210732;
        bh=a5sdZr3g7A4P952zrAxsxcFA2hqawcCrTqhspGU8zyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqreZQLJQJpk4qS3k+ckYlq2mUpwDK6IG98pPKStMqi4sVMqynC0xEoycE5unmHMz
         WCsL9cvoIUQK9DbKRK7oMPHglnc6XWw+jzVFkTeGDrC4sJazVTm6OPtmACrN6hkEEa
         ywHdblBHC+8hEZacXs+Omh7wVZEXvA2h42zodvjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        "Jitindar SIngh, Suraj" <surajjs@amazon.com>
Subject: [PATCH 4.14 117/119] kvm: apic: Flush TLB after APIC mode/address change if VPIDs are in use
Date:   Sun, 27 Oct 2019 22:01:34 +0100
Message-Id: <20191027203349.948578924@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

commit a468f2dbf921d02f5107378501693137a812999b upstream.

Currently, KVM flushes the TLB after a change to the APIC access page
address or the APIC mode when EPT mode is enabled. However, even in
shadow paging mode, a TLB flush is needed if VPIDs are being used, as
specified in the Intel SDM Section 29.4.5.

So replace vmx_flush_tlb_ept_only() with vmx_flush_tlb(), which will
flush if either EPT or VPIDs are in use.

Signed-off-by: Junaid Shahid <junaids@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Cc: "Jitindar SIngh, Suraj" <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4444,12 +4444,6 @@ static void vmx_flush_tlb(struct kvm_vcp
 	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid, invalidate_gpa);
 }
 
-static void vmx_flush_tlb_ept_only(struct kvm_vcpu *vcpu)
-{
-	if (enable_ept)
-		vmx_flush_tlb(vcpu, true);
-}
-
 static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
 {
 	ulong cr0_guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
@@ -9320,7 +9314,7 @@ static void vmx_set_virtual_x2apic_mode(
 	} else {
 		sec_exec_control &= ~SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
 		sec_exec_control |= SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
-		vmx_flush_tlb_ept_only(vcpu);
+		vmx_flush_tlb(vcpu, true);
 	}
 	vmcs_write32(SECONDARY_VM_EXEC_CONTROL, sec_exec_control);
 
@@ -9348,7 +9342,7 @@ static void vmx_set_apic_access_page_add
 	    !nested_cpu_has2(get_vmcs12(&vmx->vcpu),
 			     SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
 		vmcs_write64(APIC_ACCESS_ADDR, hpa);
-		vmx_flush_tlb_ept_only(vcpu);
+		vmx_flush_tlb(vcpu, true);
 	}
 }
 
@@ -11243,7 +11237,7 @@ static int prepare_vmcs02(struct kvm_vcp
 		}
 	} else if (nested_cpu_has2(vmcs12,
 				   SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
-		vmx_flush_tlb_ept_only(vcpu);
+		vmx_flush_tlb(vcpu, true);
 	}
 
 	/*
@@ -12198,7 +12192,7 @@ static void nested_vmx_vmexit(struct kvm
 	} else if (!nested_cpu_has_ept(vmcs12) &&
 		   nested_cpu_has2(vmcs12,
 				   SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
-		vmx_flush_tlb_ept_only(vcpu);
+		vmx_flush_tlb(vcpu, true);
 	}
 
 	/* This is needed for same reason as it was needed in prepare_vmcs02 */


