Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BBA4201E8
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 16:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhJCONC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 10:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230207AbhJCONC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 10:13:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0772161A54;
        Sun,  3 Oct 2021 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633270274;
        bh=ljzAaXIRfTiPxChNNT1P/0wq4px2lt96QLLOLHnmCHs=;
        h=Subject:To:Cc:From:Date:From;
        b=SxKbx7GibCNCfbvr1qAX3vvQiJzz/f0lFtJrZe4/9GJ69mxVFmfEfaznSW9jyj9Yv
         dYomwNVpRAKfS6wRjxAQ+wNn5UstW20yunYjbdZKb3K/7Sy1gsdTGvtjKJCefcnmWB
         G7pDcEEADSmGNZQbJOoV0Wb1YoOgwSsR7ltClvzg=
Subject: FAILED: patch "[PATCH] KVM: x86: Clear KVM's cached guest CR3 at RESET/INIT" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Oct 2021 16:10:59 +0200
Message-ID: <163327025957181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 03a6e84069d1870f5b3d360e64cb330b66f76dee Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Sep 2021 17:02:55 -0700
Subject: [PATCH] KVM: x86: Clear KVM's cached guest CR3 at RESET/INIT

Explicitly zero the guest's CR3 and mark it available+dirty at RESET/INIT.
Per Intel's SDM and AMD's APM, CR3 is zeroed at both RESET and INIT.  For
RESET, this is a nop as vcpu is zero-allocated.  For INIT, the bug has
likely escaped notice because no firmware/kernel puts its page tables root
at PA=0, let alone relies on INIT to get the desired CR3 for such page
tables.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210921000303.400537-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 06026f3d7ea2..8a83dd1b882e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10895,6 +10895,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	kvm_rip_write(vcpu, 0xfff0);
 
+	vcpu->arch.cr3 = 0;
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+
 	/*
 	 * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
 	 * of Intel's SDM list CD/NW as being set on INIT, but they contradict

