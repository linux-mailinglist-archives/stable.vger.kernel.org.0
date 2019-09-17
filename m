Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12293B4B35
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 11:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbfIQJpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 05:45:46 -0400
Received: from smtpbgeu1.qq.com ([52.59.177.22]:40589 "EHLO smtpbgeu1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbfIQJpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 05:45:46 -0400
X-QQ-mid: bizesmtp20t1568712767tu1yv8ng
Received: from localhost.localdomain (unknown [218.76.23.26])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 17 Sep 2019 17:32:46 +0800 (CST)
X-QQ-SSF: 00400000000000R0YS90000D0000000
X-QQ-FEAT: oO8b1q/I8cwqhDMOGV6LhFbTAYHfJCU81hD76JJSIvrpHAGzIAY5TPqZ2PJqx
        UV5AOlLRa8kq6CV8fnXREjemFWr58rZD2o1YDFRjVJiuygBXXX1Anrft6a6WkL9czn68tkq
        lepNnl2ujugtcXy9f2lJbkAwaOVpJfAXwKKLlvF25osn/31/kxEDLSo6PWlsjFTCqxWmEMP
        orKrsGQoBgBSAPDOqWwEgrqPfnFP+UdyqrwqyFzDEzHJKUfbB2c17UuNcCoy8XQWZlE6IAg
        MOyc1CCkQvZzCTJTIycEuzQ82FwHfycEWeKtCgu1dPReR9txfWaG5NLf8LQASy0h8MyOtdF
        ZZ9FU4bn334PvfrIpo4y9LB8tUYH3xdH8SP7sjfZJ8JFX7glas=
X-QQ-GoodBg: 2
From:   Jackie Liu <liuyun01@kylinos.cn>
To:     wangqi@kylinos.cn
Cc:     nh@kylinos.cn,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>
Subject: [PATCH 2/4] CVE-2016-9777: KVM: x86: fix out-of-bounds accesses of rtc_eoi map
Date:   Tue, 17 Sep 2019 17:32:39 +0800
Message-Id: <1568712761-11089-2-git-send-email-liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568712761-11089-1-git-send-email-liuyun01@kylinos.cn>
References: <1568712761-11089-1-git-send-email-liuyun01@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radim Krčmář <rkrcmar@redhat.com>

KVM was using arrays of size KVM_MAX_VCPUS with vcpu_id, but ID can be
bigger that the maximal number of VCPUs, resulting in out-of-bounds
access.

Found by syzkaller:

  BUG: KASAN: slab-out-of-bounds in __apic_accept_irq+0xb33/0xb50 at addr [...]
  Write of size 1 by task a.out/27101
  CPU: 1 PID: 27101 Comm: a.out Not tainted 4.9.0-rc5+ #49
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
   [...]
  Call Trace:
   [...] __apic_accept_irq+0xb33/0xb50 arch/x86/kvm/lapic.c:905
   [...] kvm_apic_set_irq+0x10e/0x180 arch/x86/kvm/lapic.c:495
   [...] kvm_irq_delivery_to_apic+0x732/0xc10 arch/x86/kvm/irq_comm.c:86
   [...] ioapic_service+0x41d/0x760 arch/x86/kvm/ioapic.c:360
   [...] ioapic_set_irq+0x275/0x6c0 arch/x86/kvm/ioapic.c:222
   [...] kvm_ioapic_inject_all arch/x86/kvm/ioapic.c:235
   [...] kvm_set_ioapic+0x223/0x310 arch/x86/kvm/ioapic.c:670
   [...] kvm_vm_ioctl_set_irqchip arch/x86/kvm/x86.c:3668
   [...] kvm_arch_vm_ioctl+0x1a08/0x23c0 arch/x86/kvm/x86.c:3999
   [...] kvm_vm_ioctl+0x1fa/0x1a70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3099

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: stable@vger.kernel.org
Fixes: af1bae5497b9 ("KVM: x86: bump KVM_MAX_VCPU_ID to 1023")
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 arch/x86/kvm/ioapic.c | 2 +-
 arch/x86/kvm/ioapic.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index ec62df3..d25cbac 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -94,7 +94,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
 {
 	ioapic->rtc_status.pending_eoi = 0;
-	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPUS);
+	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
 }
 
 static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 7d2692a..1cc6e54 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -42,13 +42,13 @@ struct kvm_vcpu;
 
 struct dest_map {
 	/* vcpu bitmap where IRQ has been sent */
-	DECLARE_BITMAP(map, KVM_MAX_VCPUS);
+	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
 
 	/*
 	 * Vector sent to a given vcpu, only valid when
 	 * the vcpu's bit in map is set
 	 */
-	u8 vectors[KVM_MAX_VCPUS];
+	u8 vectors[KVM_MAX_VCPU_ID];
 };
 
 
-- 
2.7.4



