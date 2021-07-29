Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99233DA54C
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238419AbhG2OAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhG2N6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:58:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B39C60EE2;
        Thu, 29 Jul 2021 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567109;
        bh=+YYZygSpjsHwvtHjlTPhJkXxxFkAGF48iI4zCw+ZprY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dyo85IUdkeZXtTiUS8+infvSD8ron9F8Bc9vhl5rjw5lNC8gsq5chJiQtmMvewPV6
         w2QAPovcAoerB92Gw++0OLQXLGPN+VbvkA0GH2JByo1Bv3k6CeQ8XJmROYceh2R9fV
         kPofMrFgejnxs7BTHDatdFZrlNsLs043wspSbSac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 5.10 03/24] KVM: x86: determine if an exception has an error code only when injecting it.
Date:   Thu, 29 Jul 2021 15:54:23 +0200
Message-Id: <20210729135137.371970070@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
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
@@ -541,8 +541,6 @@ static void kvm_multiple_exception(struc
 
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
-		if (has_error && !is_protmode(vcpu))
-			has_error = false;
 		if (reinject) {
 			/*
 			 * On vmentry, vcpu->arch.exception.pending is only
@@ -8265,6 +8263,13 @@ static void update_cr8_intercept(struct
 	kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
+static void kvm_inject_exception(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
+		vcpu->arch.exception.error_code = false;
+	kvm_x86_ops.queue_exception(vcpu);
+}
+
 static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
 	int r;
@@ -8273,7 +8278,7 @@ static void inject_pending_event(struct
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected) {
-		kvm_x86_ops.queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 		can_inject = false;
 	}
 	/*
@@ -8336,7 +8341,7 @@ static void inject_pending_event(struct
 			}
 		}
 
-		kvm_x86_ops.queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 		can_inject = false;
 	}
 


