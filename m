Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0A84BDEF0
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351435AbiBUJs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:48:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352422AbiBUJr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB804427E2;
        Mon, 21 Feb 2022 01:19:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5726560F71;
        Mon, 21 Feb 2022 09:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA6AC340E9;
        Mon, 21 Feb 2022 09:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435184;
        bh=UZzJEtPpZHkwZAVOc12NZhYi/u6DMPaLPsuvQQWcqNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdB6X29TRFCObU+xLvEV1YVVcPBvaSjIe2EMjYuL3LJeAoxM+/NubgogVC+VHucdT
         fGVNacBYzBqTUphGf4f3nb1bSQqMTuWS91z/X2ngmtojGYMG4YbqaFJz0GUJElz6uU
         +iQMjCChmRMQrek7dNSoR5HTLD66fRsE3I4otukU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 073/227] KVM: x86: SVM: dont passthrough SMAP/SMEP/PKE bits in !NPT && !gCR0.PG case
Date:   Mon, 21 Feb 2022 09:48:12 +0100
Message-Id: <20220221084937.298472604@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit c53bbe2145f51d3bc0438c2db02e737b9b598bf3 upstream.

When the guest doesn't enable paging, and NPT/EPT is disabled, we
use guest't paging CR3's as KVM's shadow paging pointer and
we are technically in direct mode as if we were to use NPT/EPT.

In direct mode we create SPTEs with user mode permissions
because usually in the direct mode the NPT/EPT doesn't
need to restrict access based on guest CPL
(there are MBE/GMET extenstions for that but KVM doesn't use them).

In this special "use guest paging as direct" mode however,
and if CR4.SMAP/CR4.SMEP are enabled, that will make the CPU
fault on each access and KVM will enter endless loop of page faults.

Since page protection doesn't have any meaning in !PG case,
just don't passthrough these bits.

The fix is the same as was done for VMX in commit:
commit 656ec4a4928a ("KVM: VMX: fix SMEP and SMAP without EPT")

This fixes the boot of windows 10 without NPT for good.
(Without this patch, BSP boots, but APs were stuck in endless
loop of page faults, causing the VM boot with 1 CPU)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Message-Id: <20220207155447.840194-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1795,6 +1795,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 hcr0 = cr0;
+	bool old_paging = is_paging(vcpu);
 
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
@@ -1811,8 +1812,11 @@ void svm_set_cr0(struct kvm_vcpu *vcpu,
 #endif
 	vcpu->arch.cr0 = cr0;
 
-	if (!npt_enabled)
+	if (!npt_enabled) {
 		hcr0 |= X86_CR0_PG | X86_CR0_WP;
+		if (old_paging != is_paging(vcpu))
+			svm_set_cr4(vcpu, kvm_read_cr4(vcpu));
+	}
 
 	/*
 	 * re-enable caching here because the QEMU bios
@@ -1856,8 +1860,12 @@ void svm_set_cr4(struct kvm_vcpu *vcpu,
 		svm_flush_tlb(vcpu);
 
 	vcpu->arch.cr4 = cr4;
-	if (!npt_enabled)
+	if (!npt_enabled) {
 		cr4 |= X86_CR4_PAE;
+
+		if (!is_paging(vcpu))
+			cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
+	}
 	cr4 |= host_cr4_mce;
 	to_svm(vcpu)->vmcb->save.cr4 = cr4;
 	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);


