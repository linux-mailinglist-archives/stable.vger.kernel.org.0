Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAA54F2CAA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245610AbiDEI41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240939AbiDEIck (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC798FE7F;
        Tue,  5 Apr 2022 01:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE00CB81B13;
        Tue,  5 Apr 2022 08:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3846AC385A1;
        Tue,  5 Apr 2022 08:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147121;
        bh=+AI/eYFdOzQ5BPe3mwk7+kXqJzy15v38hVCemoGFvLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDQNDFW5765kaSVX3479bcgW+YI5OEqGOsSD9sDIMY1FRChMr8u5ECPTH8A5KwhXF
         t7EOqOkBJ8qarLmsRrPHEZcQ2H8IZckOa7Ax2jE6Imr7mvGZaiIOmZUeQm5eef7xo8
         1eNOzVoheI0tbGC6fGfojhAJu13PwIDx1T0PFrEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Liu <liu.yi24@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 1002/1126] KVM: SVM: fix panic on out-of-bounds guest IRQ
Date:   Tue,  5 Apr 2022 09:29:09 +0200
Message-Id: <20220405070436.901957788@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Wang <wang.yi59@zte.com.cn>

commit a80ced6ea514000d34bf1239d47553de0d1ee89e upstream.

As guest_irq is coming from KVM_IRQFD API call, it may trigger
crash in svm_update_pi_irte() due to out-of-bounds:

crash> bt
PID: 22218  TASK: ffff951a6ad74980  CPU: 73  COMMAND: "vcpu8"
 #0 [ffffb1ba6707fa40] machine_kexec at ffffffff8565b397
 #1 [ffffb1ba6707fa90] __crash_kexec at ffffffff85788a6d
 #2 [ffffb1ba6707fb58] crash_kexec at ffffffff8578995d
 #3 [ffffb1ba6707fb70] oops_end at ffffffff85623c0d
 #4 [ffffb1ba6707fb90] no_context at ffffffff856692c9
 #5 [ffffb1ba6707fbf8] exc_page_fault at ffffffff85f95b51
 #6 [ffffb1ba6707fc50] asm_exc_page_fault at ffffffff86000ace
    [exception RIP: svm_update_pi_irte+227]
    RIP: ffffffffc0761b53  RSP: ffffb1ba6707fd08  RFLAGS: 00010086
    RAX: ffffb1ba6707fd78  RBX: ffffb1ba66d91000  RCX: 0000000000000001
    RDX: 00003c803f63f1c0  RSI: 000000000000019a  RDI: ffffb1ba66db2ab8
    RBP: 000000000000019a   R8: 0000000000000040   R9: ffff94ca41b82200
    R10: ffffffffffffffcf  R11: 0000000000000001  R12: 0000000000000001
    R13: 0000000000000001  R14: ffffffffffffffcf  R15: 000000000000005f
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffffb1ba6707fdb8] kvm_irq_routing_update at ffffffffc09f19a1 [kvm]
 #8 [ffffb1ba6707fde0] kvm_set_irq_routing at ffffffffc09f2133 [kvm]
 #9 [ffffb1ba6707fe18] kvm_vm_ioctl at ffffffffc09ef544 [kvm]
    RIP: 00007f143c36488b  RSP: 00007f143a4e04b8  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 00007f05780041d0  RCX: 00007f143c36488b
    RDX: 00007f05780041d0  RSI: 000000004008ae6a  RDI: 0000000000000020
    RBP: 00000000000004e8   R8: 0000000000000008   R9: 00007f05780041e0
    R10: 00007f0578004560  R11: 0000000000000246  R12: 00000000000004e0
    R13: 000000000000001a  R14: 00007f1424001c60  R15: 00007f0578003bc0
    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b

Vmx have been fix this in commit 3a8b0677fc61 (KVM: VMX: Do not BUG() on
out-of-bounds guest IRQ), so we can just copy source from that to fix
this.

Co-developed-by: Yi Liu <liu.yi24@zte.com.cn>
Signed-off-by: Yi Liu <liu.yi24@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Message-Id: <20220309113025.44469-1-wang.yi59@zte.com.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -783,7 +783,7 @@ int svm_update_pi_irte(struct kvm *kvm,
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
-	int idx, ret = -EINVAL;
+	int idx, ret = 0;
 
 	if (!kvm_arch_has_assigned_device(kvm) ||
 	    !irq_remapping_cap(IRQ_POSTING_CAP))
@@ -794,7 +794,13 @@ int svm_update_pi_irte(struct kvm *kvm,
 
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
-	WARN_ON(guest_irq >= irq_rt->nr_rt_entries);
+
+	if (guest_irq >= irq_rt->nr_rt_entries ||
+		hlist_empty(&irq_rt->map[guest_irq])) {
+		pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
+			     guest_irq, irq_rt->nr_rt_entries);
+		goto out;
+	}
 
 	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
 		struct vcpu_data vcpu_info;


