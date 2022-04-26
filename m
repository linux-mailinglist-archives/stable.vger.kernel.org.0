Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1376F50F77E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiDZJLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346291AbiDZJH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:07:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B777B10FDD;
        Tue, 26 Apr 2022 01:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7168FB81CFE;
        Tue, 26 Apr 2022 08:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C560DC385AE;
        Tue, 26 Apr 2022 08:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962918;
        bh=zNPS6iT5Fq80XiP8/pWJ5zzdt4yqj14wbeneztDQ/3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kI9BsoFKdQbQPA/zB+ODtcjNLvtUkTA0rwgt9l27Ej22WHewizyMFxWfyDz7jJlN7
         eDI1w/zxrZgxlzNpmPgOm+baWRkh2kmEkriULz6+ULq2aLEej2nWBymT/czHYxl4gW
         ww+XvTNm/heGNHROixYs17fVZ5OB+I4P4KaTBG5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 131/146] KVM: nVMX: Defer APICv updates while L2 is active until L1 is active
Date:   Tue, 26 Apr 2022 10:22:06 +0200
Message-Id: <20220426081753.743120268@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 7c69661e225cc484fbf44a0b99b56714a5241ae3 upstream.

Defer APICv updates that occur while L2 is active until nested VM-Exit,
i.e. until L1 regains control.  vmx_refresh_apicv_exec_ctrl() assumes L1
is active and (a) stomps all over vmcs02 and (b) neglects to ever updated
vmcs01.  E.g. if vmcs12 doesn't enable the TPR shadow for L2 (and thus no
APICv controls), L1 performs nested VM-Enter APICv inhibited, and APICv
becomes unhibited while L2 is active, KVM will set various APICv controls
in vmcs02 and trigger a failed VM-Entry.  The kicker is that, unless
running with nested_early_check=1, KVM blames L1 and chaos ensues.

In all cases, ignoring vmcs02 and always deferring the inhibition change
to vmcs01 is correct (or at least acceptable).  The ABSENT and DISABLE
inhibitions cannot truly change while L2 is active (see below).

IRQ_BLOCKING can change, but it is firmly a best effort debug feature.
Furthermore, only L2's APIC is accelerated/virtualized to the full extent
possible, e.g. even if L1 passes through its APIC to L2, normal MMIO/MSR
interception will apply to the virtual APIC managed by KVM.
The exception is the SELF_IPI register when x2APIC is enabled, but that's
an acceptable hole.

Lastly, Hyper-V's Auto EOI can technically be toggled if L1 exposes the
MSRs to L2, but for that to work in any sane capacity, L1 would need to
pass through IRQs to L2 as well, and IRQs must be intercepted to enable
virtual interrupt delivery.  I.e. exposing Auto EOI to L2 and enabling
VID for L2 are, for all intents and purposes, mutually exclusive.

Lack of dynamic toggling is also why this scenario is all but impossible
to encounter in KVM's current form.  But a future patch will pend an
APICv update request _during_ vCPU creation to plug a race where a vCPU
that's being created doesn't get included in the "all vCPUs request"
because it's not yet visible to other vCPUs.  If userspaces restores L2
after VM creation (hello, KVM selftests), the first KVM_RUN will occur
while L2 is active and thus service the APICv update request made during
VM creation.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220420013732.3308816-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    5 +++++
 arch/x86/kvm/vmx/vmx.c    |    5 +++++
 arch/x86/kvm/vmx/vmx.h    |    1 +
 3 files changed, 11 insertions(+)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4618,6 +4618,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *
 		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 	}
 
+	if (vmx->nested.update_vmcs01_apicv_status) {
+		vmx->nested.update_vmcs01_apicv_status = false;
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+	}
+
 	if ((vm_exit_reason != -1) &&
 	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4182,6 +4182,11 @@ static void vmx_refresh_apicv_exec_ctrl(
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (is_guest_mode(vcpu)) {
+		vmx->nested.update_vmcs01_apicv_status = true;
+		return;
+	}
+
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	if (cpu_has_secondary_exec_ctrls()) {
 		if (kvm_vcpu_apicv_active(vcpu))
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -183,6 +183,7 @@ struct nested_vmx {
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
 	bool update_vmcs01_cpu_dirty_logging;
+	bool update_vmcs01_apicv_status;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to


