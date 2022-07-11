Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488CB56FCFA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiGKJtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiGKJtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:49:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D3174353;
        Mon, 11 Jul 2022 02:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37568612B7;
        Mon, 11 Jul 2022 09:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF84C34115;
        Mon, 11 Jul 2022 09:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531432;
        bh=zigCpVn/B3vzOaksBD336+TQT3rmGIw/ZQWAKwCVs9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZH2WKAKy1p27LcfOOTP4EiPA7UwaLAgpCPywtQdyT5OhYSmJN6UX9e/4UZcFaf9+S
         JKjqHxXUiJeDDdGNIWxJqjpAfMtAoLakjbT3vPfbQN2EQ+nC/OXE3LcloAOoo/3NDf
         Pqpy+/lmCZuqvDhHHvsFJXV1R35Kdskbcr1IghsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/230] KVM: s390x: fix SCK locking
Date:   Mon, 11 Jul 2022 11:06:00 +0200
Message-Id: <20220711090607.019176476@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 19 ++++++++++++++++---
 arch/s390/kvm/kvm-s390.h |  4 ++--
 arch/s390/kvm/priv.c     | 15 ++++++++++++++-
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 402597f9d050..b456aa196c04 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3913,14 +3913,12 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_s390_set_tod_clock(struct kvm *kvm,
-			    const struct kvm_s390_vm_tod_clock *gtod)
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
 {
 	struct kvm_vcpu *vcpu;
 	union tod_clock clk;
 	int i;
 
-	mutex_lock(&kvm->lock);
 	preempt_disable();
 
 	store_tod_clock_ext(&clk);
@@ -3941,7 +3939,22 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
 
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
index 1539dd981104..f8803bf0ff17 100644
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
index 417154b314a6..6a765fe22eaf 100644
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



