Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1577D4AFC47
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241017AbiBIS50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241376AbiBIS4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:56:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2554C03F93F;
        Wed,  9 Feb 2022 10:56:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DA49617DF;
        Wed,  9 Feb 2022 18:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F7AC340E7;
        Wed,  9 Feb 2022 18:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432997;
        bh=VxO4XPl+QmBhcVfF5MuAsalw3aGiwdnmI8+KlQ1LE3o=;
        h=From:To:Cc:Subject:Date:From;
        b=RgR1f4RUuuNN4iDm/gfV/SF+MJfvl8ft3tklJajKMGofY8i9QtwCzRWLaKPG6R7/C
         I/YKCMAcLJ9uGoo5C2VULV8W8AWXnOoOOFzV8wZuqflW0TOXQC1npLXZ/OsJtGlAsJ
         2u1z1KR1dnrXThiYNgnfJdxtaRRqIgA0HURcsCUkLawZgEJ85yW4n28kbGj8I0yd2t
         NEFDwZUf6agMUqwMtz4BJlbo9eeuS9EEXLQTL5XMwEHmcqWe5Cvfdm1ZwZ51Ss8b83
         tvBm1BHBwKBsr41WSsZRoFX1KQJFRlueAiaACV9+3O04+SUIQphZL0oxxgHZn94TJs
         kazUt90tPRmTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.16 1/8] KVM: eventfd: Fix false positive RCU usage warning
Date:   Wed,  9 Feb 2022 13:56:27 -0500
Message-Id: <20220209185635.48730-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hou Wenlong <houwenlong93@linux.alibaba.com>

[ Upstream commit 6a0c61703e3a5d67845a4b275e1d9d7bc1b5aad7 ]

Fix the following false positive warning:
 =============================
 WARNING: suspicious RCU usage
 5.16.0-rc4+ #57 Not tainted
 -----------------------------
 arch/x86/kvm/../../../virt/kvm/eventfd.c:484 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 3 locks held by fc_vcpu 0/330:
  #0: ffff8884835fc0b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x88/0x6f0 [kvm]
  #1: ffffc90004c0bb68 (&kvm->srcu){....}-{0:0}, at: vcpu_enter_guest+0x600/0x1860 [kvm]
  #2: ffffc90004c0c1d0 (&kvm->irq_srcu){....}-{0:0}, at: kvm_notify_acked_irq+0x36/0x180 [kvm]

 stack backtrace:
 CPU: 26 PID: 330 Comm: fc_vcpu 0 Not tainted 5.16.0-rc4+
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x44/0x57
  kvm_notify_acked_gsi+0x6b/0x70 [kvm]
  kvm_notify_acked_irq+0x8d/0x180 [kvm]
  kvm_ioapic_update_eoi+0x92/0x240 [kvm]
  kvm_apic_set_eoi_accelerated+0x2a/0xe0 [kvm]
  handle_apic_eoi_induced+0x3d/0x60 [kvm_intel]
  vmx_handle_exit+0x19c/0x6a0 [kvm_intel]
  vcpu_enter_guest+0x66e/0x1860 [kvm]
  kvm_arch_vcpu_ioctl_run+0x438/0x7f0 [kvm]
  kvm_vcpu_ioctl+0x38a/0x6f0 [kvm]
  __x64_sys_ioctl+0x89/0xc0
  do_syscall_64+0x3a/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Since kvm_unregister_irq_ack_notifier() does synchronize_srcu(&kvm->irq_srcu),
kvm->irq_ack_notifier_list is protected by kvm->irq_srcu. In fact,
kvm->irq_srcu SRCU read lock is held in kvm_notify_acked_irq(), making it
a false positive warning. So use hlist_for_each_entry_srcu() instead of
hlist_for_each_entry_rcu().

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
Message-Id: <f98bac4f5052bad2c26df9ad50f7019e40434512.1643265976.git.houwenlong.hwl@antgroup.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/eventfd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2ad013b8bde96..59b1dd4a549ee 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -463,8 +463,8 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
 	if (gsi != -1)
-		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
-					 link)
+		hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
+					  link, srcu_read_lock_held(&kvm->irq_srcu))
 			if (kian->gsi == gsi) {
 				srcu_read_unlock(&kvm->irq_srcu, idx);
 				return true;
@@ -480,8 +480,8 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 {
 	struct kvm_irq_ack_notifier *kian;
 
-	hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
-				 link)
+	hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
+				  link, srcu_read_lock_held(&kvm->irq_srcu))
 		if (kian->gsi == gsi)
 			kian->irq_acked(kian);
 }
-- 
2.34.1

