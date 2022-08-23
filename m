Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1A359DE1B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354352AbiHWKZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353962AbiHWKTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:19:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2CC80F76;
        Tue, 23 Aug 2022 02:01:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 410666123D;
        Tue, 23 Aug 2022 09:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFD2C433D6;
        Tue, 23 Aug 2022 09:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245313;
        bh=oID5j7W1etVpFo98qZ2qRgVPF5c8DaT2ka0ifLBd6l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwWkm585SYnHAsnyzgYmdgzGGy2OI/B+EOYRG6TDBADHhPYTU7rdrCZMBsy+DbG3/
         kTNlD92KxOZJNmuQrTUEm2NPUDDfmcpoBxsfS5rK3vAtRUjBZuzW/eNJw/iStWGYeK
         YdJcVY4SnzZaFvzxSkaB0+T/jV9Alm2BgT7fo9Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 009/287] KVM: SVM: Dont BUG if userspace injects an interrupt with GIF=0
Date:   Tue, 23 Aug 2022 10:22:58 +0200
Message-Id: <20220823080100.585260592@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

commit f17c31c48e5cde9895a491d91c424eeeada3e134 upstream.

Don't BUG/WARN on interrupt injection due to GIF being cleared,
since it's trivial for userspace to force the situation via
KVM_SET_VCPU_EVENTS (even if having at least a WARN there would be correct
for KVM internally generated injections).

  kernel BUG at arch/x86/kvm/svm/svm.c:3386!
  invalid opcode: 0000 [#1] SMP
  CPU: 15 PID: 926 Comm: smm_test Not tainted 5.17.0-rc3+ #264
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:svm_inject_irq+0xab/0xb0 [kvm_amd]
  Code: <0f> 0b 0f 1f 00 0f 1f 44 00 00 80 3d ac b3 01 00 00 55 48 89 f5 53
  RSP: 0018:ffffc90000b37d88 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff88810a234ac0 RCX: 0000000000000006
  RDX: 0000000000000000 RSI: ffffc90000b37df7 RDI: ffff88810a234ac0
  RBP: ffffc90000b37df7 R08: ffff88810a1fa410 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
  R13: ffff888109571000 R14: ffff88810a234ac0 R15: 0000000000000000
  FS:  0000000001821380(0000) GS:ffff88846fdc0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f74fc550008 CR3: 000000010a6fe000 CR4: 0000000000350ea0
  Call Trace:
   <TASK>
   inject_pending_event+0x2f7/0x4c0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x791/0x17a0 [kvm]
   kvm_vcpu_ioctl+0x26d/0x650 [kvm]
   __x64_sys_ioctl+0x82/0xb0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

Fixes: 219b65dcf6c0 ("KVM: SVM: Improve nested interrupt injection")
Cc: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Message-Id: <35426af6e123cbe91ec7ce5132ce72521f02b1b5.1651440202.git.maciej.szmigiero@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5142,8 +5142,6 @@ static void svm_set_irq(struct kvm_vcpu
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	BUG_ON(!(gif_set(svm)));
-
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
 	++vcpu->stat.irq_injections;
 


