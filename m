Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35C853D05F
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346444AbiFCSDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346102AbiFCSBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:01:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95304A906;
        Fri,  3 Jun 2022 10:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7F38B8241E;
        Fri,  3 Jun 2022 17:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6B7C385A9;
        Fri,  3 Jun 2022 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279018;
        bh=visI1TTHwmCqbAwL6UAvfvNG1u2FwYk4D+zDUFCK6Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEH0YNuEdLVBssrhhbFCr5rqdcryulFM1vz0YfY4NkeF9JlReHJ8rIsp3Z5wlwh6M
         TTu7PSxVRQBT0TdWVUDMe4UJssQ8qjJ9nSdOcmQlY5etXmexusyQVgGvOnoScWoYmj
         ltKR5YbQwwj09I14+mjfuuDauhgZZgZ2XbbhD2Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 26/67] KVM: x86: Drop WARNs that assert a triple fault never "escapes" from L2
Date:   Fri,  3 Jun 2022 19:43:27 +0200
Message-Id: <20220603173821.478797713@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 45846661d10422ce9e22da21f8277540b29eca22 upstream.

Remove WARNs that sanity check that KVM never lets a triple fault for L2
escape and incorrectly end up in L1.  In normal operation, the sanity
check is perfectly valid, but it incorrectly assumes that it's impossible
for userspace to induce KVM_REQ_TRIPLE_FAULT without bouncing through
KVM_RUN (which guarantees kvm_check_nested_state() will see and handle
the triple fault).

The WARN can currently be triggered if userspace injects a machine check
while L2 is active and CR4.MCE=0.  And a future fix to allow save/restore
of KVM_REQ_TRIPLE_FAULT, e.g. so that a synthesized triple fault isn't
lost on migration, will make it trivially easy for userspace to trigger
the WARN.

Clearing KVM_REQ_TRIPLE_FAULT when forcibly leaving guest mode is
tempting, but wrong, especially if/when the request is saved/restored,
e.g. if userspace restores events (including a triple fault) and then
restores nested state (which may forcibly leave guest mode).  Ignoring
the fact that KVM doesn't currently provide the necessary APIs, it's
userspace's responsibility to manage pending events during save/restore.

  ------------[ cut here ]------------
  WARNING: CPU: 7 PID: 1399 at arch/x86/kvm/vmx/nested.c:4522 nested_vmx_vmexit+0x7fe/0xd90 [kvm_intel]
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 7 PID: 1399 Comm: state_test Not tainted 5.17.0-rc3+ #808
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:nested_vmx_vmexit+0x7fe/0xd90 [kvm_intel]
  Call Trace:
   <TASK>
   vmx_leave_nested+0x30/0x40 [kvm_intel]
   vmx_set_nested_state+0xca/0x3e0 [kvm_intel]
   kvm_arch_vcpu_ioctl+0xf49/0x13e0 [kvm]
   kvm_vcpu_ioctl+0x4b9/0x660 [kvm]
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  ---[ end trace 0000000000000000 ]---

Fixes: cb6a32c2b877 ("KVM: x86: Handle triple fault in L2 without killing L1")
Cc: stable@vger.kernel.org
Cc: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220407002315.78092-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    3 ---
 arch/x86/kvm/vmx/nested.c |    3 ---
 2 files changed, 6 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -819,9 +819,6 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	struct kvm_host_map map;
 	int rc;
 
-	/* Triple faults in L2 should never escape. */
-	WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu));
-
 	rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4518,9 +4518,6 @@ void nested_vmx_vmexit(struct kvm_vcpu *
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-	/* Similarly, triple faults in L2 should never escape. */
-	WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu));
-
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 		/*
 		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map


