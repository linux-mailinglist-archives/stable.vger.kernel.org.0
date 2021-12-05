Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6002F468AD6
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhLEMmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:42:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40824 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhLEMmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:42:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55572B80E26
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9582BC341C1;
        Sun,  5 Dec 2021 12:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638707917;
        bh=sO2JlS+NtBVwoZ4EAkVPtAOShml9sMp+stIHaIjIH7Y=;
        h=Subject:To:Cc:From:Date:From;
        b=Qh2g4PHuq34oIwRzKKEVaXiNPD5Hu1ytgrV8WvEOJN7VJmiifihLvqhzvyfrjxapt
         RVAupiajx96Vq06ec8oacxT1DPg0pU1YBedJU3C7YAOw71WKh/J/KR/cLIkiEfEFqL
         sDX4R3P7cWls4ZY7onOrwdpjl1ZRmkPrOgkHV1lI=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Handle "default" period when selectively waking" failed to apply to 5.15-stable tree
To:     seanjc@google.com, junaids@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 13:38:34 +0100
Message-ID: <1638707914234145@kroah.com>
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

From f47491d7f30b8ab084d0b1596697a7ea4561a894 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Sat, 20 Nov 2021 01:57:06 +0000
Subject: [PATCH] KVM: x86/mmu: Handle "default" period when selectively waking
 kthread

Account for the '0' being a default, "let KVM choose" period, when
determining whether or not the recovery worker needs to be awakened in
response to userspace reducing the period.  Failure to do so results in
the worker not being awakened properly, e.g. when changing the period
from '0' to any small-ish value.

Fixes: 4dfe4f40d845 ("kvm: x86: mmu: Make NX huge page recovery period configurable")
Cc: stable@vger.kernel.org
Cc: Junaid Shahid <junaids@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211120015706.3830341-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0e017a3b7c27..6354297e92ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6171,23 +6171,46 @@ void kvm_mmu_module_exit(void)
 	mmu_audit_disable();
 }
 
+/*
+ * Calculate the effective recovery period, accounting for '0' meaning "let KVM
+ * select a halving time of 1 hour".  Returns true if recovery is enabled.
+ */
+static bool calc_nx_huge_pages_recovery_period(uint *period)
+{
+	/*
+	 * Use READ_ONCE to get the params, this may be called outside of the
+	 * param setters, e.g. by the kthread to compute its next timeout.
+	 */
+	bool enabled = READ_ONCE(nx_huge_pages);
+	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+
+	if (!enabled || !ratio)
+		return false;
+
+	*period = READ_ONCE(nx_huge_pages_recovery_period_ms);
+	if (!*period) {
+		/* Make sure the period is not less than one second.  */
+		ratio = min(ratio, 3600u);
+		*period = 60 * 60 * 1000 / ratio;
+	}
+	return true;
+}
+
 static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
 {
 	bool was_recovery_enabled, is_recovery_enabled;
 	uint old_period, new_period;
 	int err;
 
-	was_recovery_enabled = nx_huge_pages_recovery_ratio;
-	old_period = nx_huge_pages_recovery_period_ms;
+	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
 
 	err = param_set_uint(val, kp);
 	if (err)
 		return err;
 
-	is_recovery_enabled = nx_huge_pages_recovery_ratio;
-	new_period = nx_huge_pages_recovery_period_ms;
+	is_recovery_enabled = calc_nx_huge_pages_recovery_period(&new_period);
 
-	if (READ_ONCE(nx_huge_pages) && is_recovery_enabled &&
+	if (is_recovery_enabled &&
 	    (!was_recovery_enabled || old_period > new_period)) {
 		struct kvm *kvm;
 
@@ -6251,18 +6274,13 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
 static long get_nx_lpage_recovery_timeout(u64 start_time)
 {
-	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
-	uint period = READ_ONCE(nx_huge_pages_recovery_period_ms);
+	bool enabled;
+	uint period;
 
-	if (!period && ratio) {
-		/* Make sure the period is not less than one second.  */
-		ratio = min(ratio, 3600u);
-		period = 60 * 60 * 1000 / ratio;
-	}
+	enabled = calc_nx_huge_pages_recovery_period(&period);
 
-	return READ_ONCE(nx_huge_pages) && ratio
-		? start_time + msecs_to_jiffies(period) - get_jiffies_64()
-		: MAX_SCHEDULE_TIMEOUT;
+	return enabled ? start_time + msecs_to_jiffies(period) - get_jiffies_64()
+		       : MAX_SCHEDULE_TIMEOUT;
 }
 
 static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)

