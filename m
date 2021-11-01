Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954F34418E9
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhKAJwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234226AbhKAJus (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A5C06147F;
        Mon,  1 Nov 2021 09:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759122;
        bh=nOgcCdRq/Hx3IXLfpdxXVnl6GWEQ7r0Xl5xkERV/QxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMcwYyQQrb4MfuESIDijCDKAnoBv+pQKnQExdVfbvKQ/wlJdZipd07ZXN2HqUGI11
         pcWkUVeF6dVyqr2Di4WTvtatslYGAUn6HpG1OzN9TVKRiM9B3bTRlhQvRNmlXjJH0C
         nDObw2Crp2nT/jPrrkXSSSq5t0biopdvs+L/9teo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 124/125] KVM: SEV-ES: fix another issue with string I/O VMGEXITs
Date:   Mon,  1 Nov 2021 10:18:17 +0100
Message-Id: <20211101082556.520070848@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 9b0971ca7fc75daca80c0bb6c02e96059daea90a upstream.

If the guest requests string I/O from the hypervisor via VMGEXIT,
SW_EXITINFO2 will contain the REP count.  However, sev_es_string_io
was incorrectly treating it as the size of the GHCB buffer in
bytes.

This fixes the "outsw" test in the experimental SEV tests of
kvm-unit-tests.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reported-by: Marc Orr <marcorr@google.com>
Tested-by: Marc Orr <marcorr@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2592,11 +2592,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *
 
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 {
-	if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
+	int count;
+	int bytes;
+
+	if (svm->vmcb->control.exit_info_2 > INT_MAX)
+		return -EINVAL;
+
+	count = svm->vmcb->control.exit_info_2;
+	if (unlikely(check_mul_overflow(count, size, &bytes)))
+		return -EINVAL;
+
+	if (!setup_vmgexit_scratch(svm, in, bytes))
 		return -EINVAL;
 
-	return kvm_sev_es_string_io(&svm->vcpu, size, port,
-				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
+	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->ghcb_sa, count, in);
 }
 
 void sev_es_init_vmcb(struct vcpu_svm *svm)


