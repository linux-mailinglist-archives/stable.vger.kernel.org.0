Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA7250DEE4
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 13:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiDYLjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 07:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241676AbiDYLjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 07:39:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9D41F601
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 04:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4A43B8128F
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 11:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA32C385A4;
        Mon, 25 Apr 2022 11:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650886508;
        bh=JDJRutwbAy8XAlq9oStbreUc8b/1SZzkDVPx84dalwo=;
        h=Subject:To:Cc:From:Date:From;
        b=EIYF18WD5kHsvS1mrwSq1eTCAa5DtVA8+az0vtZkcD6M5GY1oHWFwtQ6sx0UNszTu
         +bStC4MTkCsr35/7yf4CSv5Idsd9ejPp/CM1GHDNC1mVdP/Xb/hq/YbQzC+q9BKcHB
         9dtVGRzoB4gCncsOiopuxwo9ZMSiZLLBdi+VDucU=
Subject: FAILED: patch "[PATCH] KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU creation to" failed to apply to 5.10-stable tree
To:     seanjc@google.com, kangel@zju.edu.cn, mlevitsk@redhat.com,
        pbonzini@redhat.com, pgn@zju.edu.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 13:35:06 +0200
Message-ID: <1650886506205229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 423ecfea77dda83823c71b0fad1c2ddb2af1e5fc Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 20 Apr 2022 01:37:31 +0000
Subject: [PATCH] KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU creation to
 fix a race

Make a KVM_REQ_APICV_UPDATE request when creating a vCPU with an
in-kernel local APIC and APICv enabled at the module level.  Consuming
kvm_apicv_activated() and stuffing vcpu->arch.apicv_active directly can
race with __kvm_set_or_clear_apicv_inhibit(), as vCPU creation happens
before the vCPU is fully onlined, i.e. it won't get the request made to
"all" vCPUs.  If APICv is globally inhibited between setting apicv_active
and onlining the vCPU, the vCPU will end up running with APICv enabled
and trigger KVM's sanity check.

Mark APICv as active during vCPU creation if APICv is enabled at the
module level, both to be optimistic about it's final state, e.g. to avoid
additional VMWRITEs on VMX, and because there are likely bugs lurking
since KVM checks apicv_active in multiple vCPU creation paths.  While
keeping the current behavior of consuming kvm_apicv_activated() is
arguably safer from a regression perspective, force apicv_active so that
vCPU creation runs with deterministic state and so that if there are bugs,
they are found sooner than later, i.e. not when some crazy race condition
is hit.

  WARNING: CPU: 0 PID: 484 at arch/x86/kvm/x86.c:9877 vcpu_enter_guest+0x2ae3/0x3ee0 arch/x86/kvm/x86.c:9877
  Modules linked in:
  CPU: 0 PID: 484 Comm: syz-executor361 Not tainted 5.16.13 #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1~cloud0 04/01/2014
  RIP: 0010:vcpu_enter_guest+0x2ae3/0x3ee0 arch/x86/kvm/x86.c:9877
  Call Trace:
   <TASK>
   vcpu_run arch/x86/kvm/x86.c:10039 [inline]
   kvm_arch_vcpu_ioctl_run+0x337/0x15e0 arch/x86/kvm/x86.c:10234
   kvm_vcpu_ioctl+0x4d2/0xc80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3727
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:874 [inline]
   __se_sys_ioctl fs/ioctl.c:860 [inline]
   __x64_sys_ioctl+0x16d/0x1d0 fs/ioctl.c:860
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

The bug was hit by a syzkaller spamming VM creation with 2 vCPUs and a
call to KVM_SET_GUEST_DEBUG.

  r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x0, 0x0)
  r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
  ioctl$KVM_CAP_SPLIT_IRQCHIP(r1, 0x4068aea3, &(0x7f0000000000)) (async)
  r2 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0) (async)
  r3 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x400000000000002)
  ioctl$KVM_SET_GUEST_DEBUG(r3, 0x4048ae9b, &(0x7f00000000c0)={0x5dda9c14aa95f5c5})
  ioctl$KVM_RUN(r2, 0xae80, 0x0)

Reported-by: Gaoning Pan <pgn@zju.edu.cn>
Reported-by: Yongkang Jia <kangel@zju.edu.cn>
Fixes: 8df14af42f00 ("kvm: x86: Add support for dynamic APICv activation")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220420013732.3308816-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d54d4a67b226..9c02217c1e47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11189,8 +11189,21 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
-		if (kvm_apicv_activated(vcpu->kvm))
+
+		/*
+		 * Defer evaluating inhibits until the vCPU is first run, as
+		 * this vCPU will not get notified of any changes until this
+		 * vCPU is visible to other vCPUs (marked online and added to
+		 * the set of vCPUs).  Opportunistically mark APICv active as
+		 * VMX in particularly is highly unlikely to have inhibits.
+		 * Ignore the current per-VM APICv state so that vCPU creation
+		 * is guaranteed to run with a deterministic value, the request
+		 * will ensure the vCPU gets the correct state before VM-Entry.
+		 */
+		if (enable_apicv) {
 			vcpu->arch.apicv_active = true;
+			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+		}
 	} else
 		static_branch_inc(&kvm_has_noapic_vcpu);
 

