Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE05A627E74
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbiKNMsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiKNMsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:48:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D93821BC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA203B80EBC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A444C433D6;
        Mon, 14 Nov 2022 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430078;
        bh=bc+6JOKIivwGct9VTspX6ybeeHZUZ/XAGTKs1SZ298w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9NNNq8t8zCbzkX3kh1Id6kzhrY9Mwr/vUF8q2DxeT3iaYNESo4zfDYg6hpPc7dCR
         FIBf/2MqfJSFRoCAdoYRO/K0szhIWbl0iUB/dsAsGED7NbmtYR8g5CvLA62h4WAvlg
         JQ2+D2qat6HFCnkAg2JiW+iBZvMzTLkVg0sE6jTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/95] KVM: s390x: fix SCK locking
Date:   Mon, 14 Nov 2022 13:45:16 +0100
Message-Id: <20221114124443.434240286@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit c0573ba5c5a2244dc02060b1f374d4593c1d20b7 ]

When handling the SCK instruction, the kvm lock is taken, even though
the vcpu lock is already being held. The normal locking order is kvm
lock first and then vcpu lock. This is can (and in some circumstances
does) lead to deadlocks.

The function kvm_s390_set_tod_clock is called both by the SCK handler
and by some IOCTLs to set the clock. The IOCTLs will not hold the vcpu
lock, so they can safely take the kvm lock. The SCK handler holds the
vcpu lock, but will also somehow need to acquire the kvm lock without
relinquishing the vcpu lock.

The solution is to factor out the code to set the clock, and provide
two wrappers. One is called like the original function and does the
locking, the other is called kvm_s390_try_set_tod_clock and uses
trylock to try to acquire the kvm lock. This new wrapper is then used
in the SCK handler. If locking fails, -EAGAIN is returned, which is
eventually propagated to userspace, thus also freeing the vcpu lock and
allowing for forward progress.

This is not the most efficient or elegant way to solve this issue, but
the SCK instruction is deprecated and its performance is not critical.

The goal of this patch is just to provide a simple but correct way to
fix the bug.

Fixes: 6a3f95a6b04c ("KVM: s390: Intercept SCK instruction")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20220301143340.111129-1-imbrenda@linux.ibm.com
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Stable-dep-of: 6973091d1b50 ("KVM: s390: pv: don't allow userspace to set the clock under PV")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 19 ++++++++++++++++---
 arch/s390/kvm/kvm-s390.h |  4 ++--
 arch/s390/kvm/priv.c     | 15 ++++++++++++++-
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d8e9239c24ff..d12042ab5d54 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3862,14 +3862,12 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_s390_set_tod_clock(struct kvm *kvm,
-			    const struct kvm_s390_vm_tod_clock *gtod)
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_s390_tod_clock_ext htod;
 	int i;
 
-	mutex_lock(&kvm->lock);
 	preempt_disable();
 
 	get_tod_clock_ext((char *)&htod);
@@ -3890,7 +3888,22 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
 
 	kvm_s390_vcpu_unblock_all(kvm);
 	preempt_enable();
+}
+
+void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
+{
+	mutex_lock(&kvm->lock);
+	__kvm_s390_set_tod_clock(kvm, gtod);
+	mutex_unlock(&kvm->lock);
+}
+
+int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
+{
+	if (!mutex_trylock(&kvm->lock))
+		return 0;
+	__kvm_s390_set_tod_clock(kvm, gtod);
 	mutex_unlock(&kvm->lock);
+	return 1;
 }
 
 /**
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index a3e9b71d426f..80bfe9c3364a 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -326,8 +326,8 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-void kvm_s390_set_tod_clock(struct kvm *kvm,
-			    const struct kvm_s390_vm_tod_clock *gtod);
+void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
+int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 3b1a498e58d2..e34d518dd3d3 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -102,7 +102,20 @@ static int handle_set_clock(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 
 	VCPU_EVENT(vcpu, 3, "SCK: setting guest TOD to 0x%llx", gtod.tod);
-	kvm_s390_set_tod_clock(vcpu->kvm, &gtod);
+	/*
+	 * To set the TOD clock the kvm lock must be taken, but the vcpu lock
+	 * is already held in handle_set_clock. The usual lock order is the
+	 * opposite.  As SCK is deprecated and should not be used in several
+	 * cases, for example when the multiple epoch facility or TOD clock
+	 * steering facility is installed (see Principles of Operation),  a
+	 * slow path can be used.  If the lock can not be taken via try_lock,
+	 * the instruction will be retried via -EAGAIN at a later point in
+	 * time.
+	 */
+	if (!kvm_s390_try_set_tod_clock(vcpu->kvm, &gtod)) {
+		kvm_s390_retry_instr(vcpu);
+		return -EAGAIN;
+	}
 
 	kvm_s390_set_psw_cc(vcpu, 0);
 	return 0;
-- 
2.35.1



