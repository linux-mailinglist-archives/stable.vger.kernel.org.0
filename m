Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E78C490708
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 12:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbiAQLSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 06:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239032AbiAQLSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 06:18:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8ABC06173E
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 03:18:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34550B80EF5
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 11:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE4DC36B01;
        Mon, 17 Jan 2022 11:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642418325;
        bh=scrykv58twl0w0rgtQliYBoEeyT2WkAgduHcFYwn4UQ=;
        h=Subject:To:Cc:From:Date:From;
        b=qDkfcYUsi4ZIzu3kbAgQbZhnR4PWbdj0J8E8aXNcr12ZiKvrOMycRwaRNan2UXpnk
         OBhnqG+F8c7PwOShlMH+zepTmErVJb13VmIq9I+1f5RXpRY/iGL5Vzcb48is1u4LDF
         lJrEwDZ8XgIZeKsjsgcNpl0gtdxHRlJsItHP+0RI=
Subject: FAILED: patch "[PATCH] KVM: x86: Fix wall clock writes in Xen shared_info not to" failed to apply to 5.15-stable tree
To:     dwmw@amazon.co.uk, butterflyhuangxx@gmail.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Jan 2022 12:18:42 +0100
Message-ID: <164241832261187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 55749769fe608fa3f4a075e42e89d237c8e37637 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Fri, 10 Dec 2021 16:36:24 +0000
Subject: [PATCH] KVM: x86: Fix wall clock writes in Xen shared_info not to
 mark page dirty

When dirty ring logging is enabled, any dirty logging without an active
vCPU context will cause a kernel oops. But we've already declared that
the shared_info page doesn't get dirty tracking anyway, since it would
be kind of insane to mark it dirty every time we deliver an event channel
interrupt. Userspace is supposed to just assume it's always dirty any
time a vCPU can run or event channels are routed.

So stop using the generic kvm_write_wall_clock() and just write directly
through the gfn_to_pfn_cache that we already have set up.

We can make kvm_write_wall_clock() static in x86.c again now, but let's
not remove the 'sec_hi_ofs' argument even though it's not used yet. At
some point we *will* want to use that for KVM guests too.

Fixes: 629b5348841a ("KVM: x86/xen: update wallclock region")
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <20211210163625.2886-6-dwmw2@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3050601d5d73..6492329f2e9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2135,7 +2135,7 @@ static s64 get_kvmclock_base_ns(void)
 }
 #endif
 
-void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs)
+static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs)
 {
 	int version;
 	int r;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4abcd8d9836d..da7031e80f23 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -301,7 +301,6 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
 	return is_smm(vcpu) || static_call(kvm_x86_apic_init_signal_blocked)(vcpu);
 }
 
-void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs);
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 u64 get_kvmclock_ns(struct kvm *kvm);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index ceddabd1f5c6..0e3f7d6e9fd7 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -25,8 +25,11 @@ DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 {
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
+	struct pvclock_wall_clock *wc;
 	gpa_t gpa = gfn_to_gpa(gfn);
-	int wc_ofs, sec_hi_ofs;
+	u32 *wc_sec_hi;
+	u32 wc_version;
+	u64 wall_nsec;
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
@@ -35,32 +38,63 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 		goto out;
 	}
 
-	ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, false, true, gpa,
-					PAGE_SIZE, false);
-	if (ret)
-		goto out;
+	do {
+		ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, false, true,
+						gpa, PAGE_SIZE, false);
+		if (ret)
+			goto out;
+
+		/*
+		 * This code mirrors kvm_write_wall_clock() except that it writes
+		 * directly through the pfn cache and doesn't mark the page dirty.
+		 */
+		wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
+
+		/* It could be invalid again already, so we need to check */
+		read_lock_irq(&gpc->lock);
+
+		if (gpc->valid)
+			break;
+
+		read_unlock_irq(&gpc->lock);
+	} while (1);
 
 	/* Paranoia checks on the 32-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) != 0x900);
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, arch.wc_sec_hi) != 0x924);
 	BUILD_BUG_ON(offsetof(struct pvclock_vcpu_time_info, version) != 0);
 
-	/* 32-bit location by default */
-	wc_ofs = offsetof(struct compat_shared_info, wc);
-	sec_hi_ofs = offsetof(struct compat_shared_info, arch.wc_sec_hi);
-
 #ifdef CONFIG_X86_64
 	/* Paranoia checks on the 64-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct shared_info, wc) != 0xc00);
 	BUILD_BUG_ON(offsetof(struct shared_info, wc_sec_hi) != 0xc0c);
 
-	if (kvm->arch.xen.long_mode) {
-		wc_ofs = offsetof(struct shared_info, wc);
-		sec_hi_ofs = offsetof(struct shared_info, wc_sec_hi);
-	}
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
+		struct shared_info *shinfo = gpc->khva;
+
+		wc_sec_hi = &shinfo->wc_sec_hi;
+		wc = &shinfo->wc;
+	} else
 #endif
+	{
+		struct compat_shared_info *shinfo = gpc->khva;
+
+		wc_sec_hi = &shinfo->arch.wc_sec_hi;
+		wc = &shinfo->wc;
+	}
+
+	/* Increment and ensure an odd value */
+	wc_version = wc->version = (wc->version + 1) | 1;
+	smp_wmb();
+
+	wc->nsec = do_div(wall_nsec,  1000000000);
+	wc->sec = (u32)wall_nsec;
+	*wc_sec_hi = wall_nsec >> 32;
+	smp_wmb();
+
+	wc->version = wc_version + 1;
+	read_unlock_irq(&gpc->lock);
 
-	kvm_write_wall_clock(kvm, gpa + wc_ofs, sec_hi_ofs - wc_ofs);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MASTERCLOCK_UPDATE);
 
 out:

