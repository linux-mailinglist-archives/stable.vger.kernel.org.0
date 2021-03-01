Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3973290DA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242902AbhCAUQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:16:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241833AbhCAUGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:06:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5970C64E68;
        Mon,  1 Mar 2021 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621545;
        bh=Yal0T4gG3moBuK91NmCwiWdoeDfjBytZU4DBxiDTiAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzOmtqqELxaXibUGnGZv4yiDeqk4NZodlJVrxFKidJ3W/GYUUIHl030rT+rub4jyY
         HDOtVHzAsCJr5cZv9AIX6BxIIyHJZULC6RQZVhF1DUmTEtz7nFKzH/4Q1jdVi8MI/W
         hPMfdPoNa2dtTeXqZpysaMAmEbYNByT9p7W3fXZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 555/775] KVM: SVM: Intercept INVPCID when its disabled to inject #UD
Date:   Mon,  1 Mar 2021 17:12:03 +0100
Message-Id: <20210301161228.907985744@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 0a8ed2eaac102c746d8d114f2787f06cb3e55dfb ]

Intercept INVPCID if it's disabled in the guest, even when using NPT,
as KVM needs to inject #UD in this case.

Fixes: 4407a797e941 ("KVM: SVM: Enable INVPCID feature on AMD")
Cc: Babu Moger <babu.moger@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210212003411.1102677-2-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3442d44ca53b8..825ef6d281c98 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1105,12 +1105,12 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 static void svm_check_invpcid(struct vcpu_svm *svm)
 {
 	/*
-	 * Intercept INVPCID instruction only if shadow page table is
-	 * enabled. Interception is not required with nested page table
-	 * enabled.
+	 * Intercept INVPCID if shadow paging is enabled to sync/free shadow
+	 * roots, or if INVPCID is disabled in the guest to inject #UD.
 	 */
 	if (kvm_cpu_cap_has(X86_FEATURE_INVPCID)) {
-		if (!npt_enabled)
+		if (!npt_enabled ||
+		    !guest_cpuid_has(&svm->vcpu, X86_FEATURE_INVPCID))
 			svm_set_intercept(svm, INTERCEPT_INVPCID);
 		else
 			svm_clr_intercept(svm, INTERCEPT_INVPCID);
-- 
2.27.0



