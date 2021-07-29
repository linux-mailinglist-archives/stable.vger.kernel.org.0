Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C323DA503
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbhG2N5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237789AbhG2N5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:57:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EDC960EB2;
        Thu, 29 Jul 2021 13:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567041;
        bh=ZgYjrjVfXUcydEKwdoLCKbh6pLx5YHoRym9sok9+W2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8ZVCP4QELhF5JuAec3aMljPMENQ5CqLi8HA6AbnfclUfm/qH/kLaU1BC2VHmOoNO
         rOlCNAZdkHLf26cD+/CVu+E0qhDarw9ZYJ9ocz2fonO90UPB6mL/RpmyprAwAERdc/
         XO42/6mCuaSJBIyMgRF558DTRDLlH/tQp7oTkncc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 5.4 03/21] KVM: x86: determine if an exception has an error code only when injecting it.
Date:   Thu, 29 Jul 2021 15:54:10 +0200
Message-Id: <20210729135143.030739379@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
References: <20210729135142.920143237@linuxfoundation.org>
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
@@ -475,8 +475,6 @@ static void kvm_multiple_exception(struc
 
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
-		if (has_error && !is_protmode(vcpu))
-			has_error = false;
 		if (reinject) {
 			/*
 			 * On vmentry, vcpu->arch.exception.pending is only
@@ -7592,6 +7590,13 @@ static void update_cr8_intercept(struct
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
@@ -7599,7 +7604,7 @@ static int inject_pending_event(struct k
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected)
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 	/*
 	 * Do not inject an NMI or interrupt if there is a pending
 	 * exception.  Exceptions and interrupts are recognized at
@@ -7665,7 +7670,7 @@ static int inject_pending_event(struct k
 			}
 		}
 
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 	}
 
 	/* Don't consider new event if we re-injected an event */


