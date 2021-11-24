Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE1B45C603
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350840AbhKXOEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350835AbhKXOBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:01:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4C3C632EC;
        Wed, 24 Nov 2021 13:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759391;
        bh=4NRCtwfMiFc7Gi/1y4lICIIBH1/SOrSIwPxOzmD4nyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFsiIBstDPrqepEKhoDcMkgJ2Vnh9BDUQ7EGMYij2gjsPgai/vnHNPocUAXqTm+P/
         UsxMDIgq/t0O+sndpd94+nNj12cqLwdzPIbH+9bStp0NceTAw1NMRO+qO5KUUq6eZH
         wrCMzCQDBa8h77jYcXlREfwECElzZ3lWJ3HyHFPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 224/279] KVM: SEV: Disallow COPY_ENC_CONTEXT_FROM if target has created vCPUs
Date:   Wed, 24 Nov 2021 12:58:31 +0100
Message-Id: <20211124115726.473855152@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 79b11142763791bdead8b6460052cbdde8e08e2f upstream.

Reject COPY_ENC_CONTEXT_FROM if the destination VM has created vCPUs.
KVM relies on SEV activation to occur before vCPUs are created, e.g. to
set VMCB flags and intercepts correctly.

Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
Cc: stable@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Nathan Tempelman <natet@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211109215101.2211373-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1787,7 +1787,12 @@ int svm_vm_copy_asid_from(struct kvm *kv
 	mutex_unlock(&source_kvm->lock);
 	mutex_lock(&kvm->lock);
 
-	if (sev_guest(kvm)) {
+	/*
+	 * Disallow out-of-band SEV/SEV-ES init if the target is already an
+	 * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
+	 * created after SEV/SEV-ES initialization, e.g. to init intercepts.
+	 */
+	if (sev_guest(kvm) || kvm->created_vcpus) {
 		ret = -EINVAL;
 		goto e_mirror_unlock;
 	}


