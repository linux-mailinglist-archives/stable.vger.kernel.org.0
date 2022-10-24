Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCD960B088
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiJXQGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiJXQEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:04:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6173F11E47D;
        Mon, 24 Oct 2022 07:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B423B8149C;
        Mon, 24 Oct 2022 12:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5389C4347C;
        Mon, 24 Oct 2022 12:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614053;
        bh=BCxFshy9jgZajd0Dv3BRZtJX69rjxlktrDgUo09c0OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pan2IMChyz0l5MhOmQQ365N7lMvMSX1jUW7fpbi6NhYmmyPGehrLoREHi6E4bOlFQ
         WAu6CYhvJclahEUMDYwwL9qGWmKGc02iMIKsW9jSJ4WT/dU4B7WqcC+8a+CEFiJDnH
         F1N/phjsvrbGDozutcYPp8/BvFGBi8GPa/++y5LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 084/390] KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS
Date:   Mon, 24 Oct 2022 13:28:01 +0200
Message-Id: <20221024113026.186431777@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit eba9799b5a6efe2993cf92529608e4aa8163d73b upstream.

Deliberately truncate the exception error code when shoving it into the
VMCS (VM-Entry field for vmcs01 and vmcs02, VM-Exit field for vmcs12).
Intel CPUs are incapable of handling 32-bit error codes and will never
generate an error code with bits 31:16, but userspace can provide an
arbitrary error code via KVM_SET_VCPU_EVENTS.  Failure to drop the bits
on exception injection results in failed VM-Entry, as VMX disallows
setting bits 31:16.  Setting the bits on VM-Exit would at best confuse
L1, and at worse induce a nested VM-Entry failure, e.g. if L1 decided to
reinject the exception back into L2.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20220830231614.3580124-3-seanjc@google.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   11 ++++++++++-
 arch/x86/kvm/vmx/vmx.c    |   12 +++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3776,7 +3776,16 @@ static void nested_vmx_inject_exception_
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
 	if (vcpu->arch.exception.has_error_code) {
-		vmcs12->vm_exit_intr_error_code = vcpu->arch.exception.error_code;
+		/*
+		 * Intel CPUs do not generate error codes with bits 31:16 set,
+		 * and more importantly VMX disallows setting bits 31:16 in the
+		 * injected error code for VM-Entry.  Drop the bits to mimic
+		 * hardware and avoid inducing failure on nested VM-Entry if L1
+		 * chooses to inject the exception back to L2.  AMD CPUs _do_
+		 * generate "full" 32-bit error codes, so KVM allows userspace
+		 * to inject exception error codes with bits 31:16 set.
+		 */
+		vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1737,7 +1737,17 @@ static void vmx_queue_exception(struct k
 	kvm_deliver_exception_payload(vcpu);
 
 	if (has_error_code) {
-		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
+		/*
+		 * Despite the error code being architecturally defined as 32
+		 * bits, and the VMCS field being 32 bits, Intel CPUs and thus
+		 * VMX don't actually supporting setting bits 31:16.  Hardware
+		 * will (should) never provide a bogus error code, but AMD CPUs
+		 * do generate error codes with bits 31:16 set, and so KVM's
+		 * ABI lets userspace shove in arbitrary 32-bit values.  Drop
+		 * the upper bits to avoid VM-Fail, losing information that
+		 * does't really exist is preferable to killing the VM.
+		 */
+		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 


