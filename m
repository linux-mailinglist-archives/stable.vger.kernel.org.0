Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A064920C0
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 08:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245003AbiARH6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 02:58:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40448 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243889AbiARH6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 02:58:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EC06B81052
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324FDC00446;
        Tue, 18 Jan 2022 07:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642492723;
        bh=R7ygboKvUqgNqUir7N50Dm4UA66E5bOmZfP4pO8irS4=;
        h=Subject:To:Cc:From:Date:From;
        b=sUmVkdb+JpHsUWppalJpR/mRKjGG7HuXiEeDIzRceP5v8ywU66+JbVfVOlzO6+cAo
         1JI2ySAZ8KoKHihTHVfwQRB8asHEjiUNBklzecDXKiVkki6YsWkTiTmdrtfWGC1fZ2
         gJXdct6TO6Y3Py4nfv1Ye/xQzH1E4OhsOVmt4Fag=
Subject: FAILED: patch "[PATCH] KVM: x86: don't print when fail to read/write pv eoi memory" failed to apply to 5.10-stable tree
To:     lirongqing@baidu.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 08:58:33 +0100
Message-ID: <1642492713198132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From ce5977b181c1613072eafbc7546bcb6c463ea68c Mon Sep 17 00:00:00 2001
From: Li RongQing <lirongqing@baidu.com>
Date: Thu, 4 Nov 2021 19:56:13 +0800
Subject: [PATCH] KVM: x86: don't print when fail to read/write pv eoi memory

If guest gives MSR_KVM_PV_EOI_EN a wrong value, this printk() will
be trigged, and kernel log is spammed with the useless message

Fixes: 0d88800d5472 ("kvm: x86: ioapic and apic debug macros cleanup")
Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: stable@kernel.org
Message-Id: <1636026974-50555-1-git-send-email-lirongqing@baidu.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index bbac8477b3ec..8f4d872f3ffa 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -676,31 +676,25 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
 static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
 {
 	u8 val;
-	if (pv_eoi_get_user(vcpu, &val) < 0) {
-		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+	if (pv_eoi_get_user(vcpu, &val) < 0)
 		return false;
-	}
+
 	return val & KVM_PV_EOI_ENABLED;
 }
 
 static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
 {
-	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
-		printk(KERN_WARNING "Can't set EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0)
 		return;
-	}
+
 	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 
 static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
 {
-	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
-		printk(KERN_WARNING "Can't clear EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0)
 		return;
-	}
+
 	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 

