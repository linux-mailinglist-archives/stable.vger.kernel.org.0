Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD5D63DFF3
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiK3SwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiK3SwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149A763D71
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97FE7B81CA9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F3FC433D7;
        Wed, 30 Nov 2022 18:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834318;
        bh=q51cfXcAd2IEW0MTKUE22THgyYxqezUhnFjD4AwEMaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCifcmprtTe6NirNkcGqEHMvnW2ur9889IZk5J97zQSILwkiOwd/God64onulsFbO
         bnRUISifSwR6HahDBJCOdYfQmrm3vLo9Ux1UGdLZ0LodFN2v/3J3OIdpnVSdzL9F1I
         1ld37ZAPRGa30S5JH5nPy4bsHd53F/P4OlsYbaSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 210/289] KVM: x86: add kvm_leave_nested
Date:   Wed, 30 Nov 2022 19:23:15 +0100
Message-Id: <20221130180548.881195643@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit f9697df251438b0798780900e8b43bdb12a56d64 upstream.

add kvm_leave_nested which wraps a call to nested_ops->leave_nested
into a function.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-4-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    3 ---
 arch/x86/kvm/vmx/nested.c |    3 ---
 arch/x86/kvm/x86.c        |    8 +++++++-
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1164,9 +1164,6 @@ void svm_free_nested(struct vcpu_svm *sv
 	svm->nested.initialized = false;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void svm_leave_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6294,9 +6294,6 @@ out:
 	return kvm_state.size;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void vmx_leave_nested(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu)) {
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -611,6 +611,12 @@ void kvm_deliver_exception_payload(struc
 }
 EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
 
+/* Forcibly leave the nested mode in cases like a vCPU reset */
+static void kvm_leave_nested(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops.nested_ops->leave_nested(vcpu);
+}
+
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 	        bool has_payload, unsigned long payload, bool reinject)
@@ -5154,7 +5160,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_e
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
 		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
-			kvm_x86_ops.nested_ops->leave_nested(vcpu);
+			kvm_leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
 		}
 


