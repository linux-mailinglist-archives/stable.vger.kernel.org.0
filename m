Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31ACE3DD828
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhHBNuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234592AbhHBNsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:48:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E420E61107;
        Mon,  2 Aug 2021 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912108;
        bh=TUWF7pC9bbQD+WsDAERejsnRof4qp+LWg45M6s2YuWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQFM5HqIPHFPWpy5ZioNI5Z5X8CP/ZDnqz5ox6Rgxh00KylLNQqPOdSiXIEd2ZkWe
         3vlyzxpHvh/lClvcGQufgu7tPOKuc93acnllAXGuN1EkhfIoI6i15r/9IsILWyYkf1
         qfNJUjV1CMcHA8KAI8QUBg5dROAwuu9aZOKarb3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 4.14 02/38] KVM: x86: determine if an exception has an error code only when injecting it.
Date:   Mon,  2 Aug 2021 15:44:24 +0200
Message-Id: <20210802134334.913798979@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit b97f074583736c42fb36f2da1164e28c73758912 upstream.

A page fault can be queued while vCPU is in real paged mode on AMD, and
AMD manual asks the user to always intercept it
(otherwise result is undefined).
The resulting VM exit, does have an error code.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210225154135.405125-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -400,8 +400,6 @@ static void kvm_multiple_exception(struc
 
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
-		if (has_error && !is_protmode(vcpu))
-			has_error = false;
 		if (reinject) {
 			/*
 			 * On vmentry, vcpu->arch.exception.pending is only
@@ -6624,13 +6622,20 @@ static void update_cr8_intercept(struct
 	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
+static void kvm_inject_exception(struct kvm_vcpu *vcpu)
+{
+       if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
+               vcpu->arch.exception.error_code = false;
+       kvm_x86_ops->queue_exception(vcpu);
+}
+
 static int inject_pending_event(struct kvm_vcpu *vcpu)
 {
 	int r;
 
 	/* try to reinject previous events if any */
 	if (vcpu->arch.exception.injected) {
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 		return 0;
 	}
 
@@ -6675,7 +6680,7 @@ static int inject_pending_event(struct k
 			kvm_update_dr7(vcpu);
 		}
 
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 	} else if (vcpu->arch.smi_pending && !is_smm(vcpu)) {
 		vcpu->arch.smi_pending = false;
 		enter_smm(vcpu);


