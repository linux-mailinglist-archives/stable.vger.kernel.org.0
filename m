Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF342367E
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389104AbfETMZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389098AbfETMZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF290216C4;
        Mon, 20 May 2019 12:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355133;
        bh=/KBB10b3sjd1NJl6j+0onVYFXB2Ef5Uw5BZYUkumP+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VV823iDE9pyehh/GlYUw56kL9IhPKb8nsf2pvGxl/iqYiBkw5HcuJk05QJwB3tvZQ
         nHpcNPNOB4LDytSaWS2d5V+HGw1ufTsOSlpYwYtc3JZF4w+OnVSbvwP1qFL1VubpvG
         DfGkCrtVx5QkZUlZn//qb4+a4bPVAs03JR1muTVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 093/105] KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes
Date:   Mon, 20 May 2019 14:14:39 +0200
Message-Id: <20190520115253.674476913@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 11988499e62b310f3bf6f6d0a807a06d3f9ccc96 upstream.

KVM allows userspace to violate consistency checks related to the
guest's CPUID model to some degree.  Generally speaking, userspace has
carte blanche when it comes to guest state so long as jamming invalid
state won't negatively affect the host.

Currently this is seems to be a non-issue as most of the interesting
EFER checks are missing, e.g. NX and LME, but those will be added
shortly.  Proactively exempt userspace from the CPUID checks so as not
to break userspace.

Note, the efer_reserved_bits check still applies to userspace writes as
that mask reflects the host's capabilities, e.g. KVM shouldn't allow a
guest to run with NX=1 if it has been disabled in the host.

Fixes: d80174745ba39 ("KVM: SVM: Only allow setting of EFER_SVME when CPUID SVM is set")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1162,31 +1162,42 @@ static int do_get_msr_feature(struct kvm
 	return 0;
 }
 
-bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
+static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	if (efer & efer_reserved_bits)
-		return false;
-
 	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
-			return false;
+		return false;
 
 	if (efer & EFER_SVME && !guest_cpuid_has(vcpu, X86_FEATURE_SVM))
-			return false;
+		return false;
 
 	return true;
+
+}
+bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
+{
+	if (efer & efer_reserved_bits)
+		return false;
+
+	return __kvm_valid_efer(vcpu, efer);
 }
 EXPORT_SYMBOL_GPL(kvm_valid_efer);
 
-static int set_efer(struct kvm_vcpu *vcpu, u64 efer)
+static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	u64 old_efer = vcpu->arch.efer;
+	u64 efer = msr_info->data;
 
-	if (!kvm_valid_efer(vcpu, efer))
-		return 1;
+	if (efer & efer_reserved_bits)
+		return false;
 
-	if (is_paging(vcpu)
-	    && (vcpu->arch.efer & EFER_LME) != (efer & EFER_LME))
-		return 1;
+	if (!msr_info->host_initiated) {
+		if (!__kvm_valid_efer(vcpu, efer))
+			return 1;
+
+		if (is_paging(vcpu) &&
+		    (vcpu->arch.efer & EFER_LME) != (efer & EFER_LME))
+			return 1;
+	}
 
 	efer &= ~EFER_LMA;
 	efer |= vcpu->arch.efer & EFER_LMA;
@@ -2356,7 +2367,7 @@ int kvm_set_msr_common(struct kvm_vcpu *
 		vcpu->arch.arch_capabilities = data;
 		break;
 	case MSR_EFER:
-		return set_efer(vcpu, data);
+		return set_efer(vcpu, msr_info);
 	case MSR_K7_HWCR:
 		data &= ~(u64)0x40;	/* ignore flush filter disable */
 		data &= ~(u64)0x100;	/* ignore ignne emulation enable */


