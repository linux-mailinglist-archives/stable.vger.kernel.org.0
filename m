Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFEF29BCCF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811094AbgJ0QhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801918AbgJ0PpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0CD32417A;
        Tue, 27 Oct 2020 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813497;
        bh=Nsc+vdMVVxGn8wdqk9SGl+mmLa+HUBahzJhaoV78yRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17XkKBYau1tlh/X553QtvDynJTumnFjkyMKdeTpR8X9nyF5d6uuXOxGvS+KQUKWgf
         MqjbEMdiuM69UuO4NjTHLq7zJqVMsJPYX9+epYLHOlbEP+h5NaSL5YgRx1nX1hv1fr
         zKVPmBEva/DmSNAHF09av+b1jDm+kFe6JW7DBbJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 570/757] KVM: nSVM: CR3 MBZ bits are only 63:52
Date:   Tue, 27 Oct 2020 14:53:40 +0100
Message-Id: <20201027135517.245182087@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krish Sadhukhan <krish.sadhukhan@oracle.com>

[ Upstream commit fb0f33fdefe9f473dc5f7b71345096c8d60ab9dd ]

Commit 761e4169346553c180bbd4a383aedd72f905bc9a created a wrong mask for the
CR3 MBZ bits. According to APM vol 2, only the upper 12 bits are MBZ.

Fixes: 761e41693465 ("KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests", 2020-07-08)
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-Id: <20200829004824.4577-2-krish.sadhukhan@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 arch/x86/kvm/svm/svm.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e90bc436f5849..27042c9ea40d6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -243,7 +243,7 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
 	} else {
 		if (!(vmcb->save.cr4 & X86_CR4_PAE) ||
 		    !(vmcb->save.cr0 & X86_CR0_PE) ||
-		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
+		    (vmcb->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
 			return false;
 	}
 	if (kvm_valid_cr4(&svm->vcpu, vmcb->save.cr4))
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e17317094..c0d75b1e06645 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -345,7 +345,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 /* svm.c */
 #define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
 #define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
-#define MSR_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
+#define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
-- 
2.25.1



