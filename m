Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C85339E73
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfFHLtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730004AbfFHLtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:49:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010252168B;
        Sat,  8 Jun 2019 11:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994544;
        bh=Ga/Q2fsQ3x6HGX8E6Ru0cHNocZm+Y0qsmKRFrj5LVYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abHw9JoTBttfanElTateLoHJZoBkk4b9PypJ6O4gmyKVpM39XWAVCOyp3syzad6WB
         dsHPXh1JYdby17SU/0wjz26F6jR+hg91cWJZFE2YTXoqLcjk1l/6ZKc86KW49eJFqO
         tBs/gPel0Ez7fa4wGjGO3eRCnfSVra4U6U68YBTo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 10/13] KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token list
Date:   Sat,  8 Jun 2019 07:48:42 -0400
Message-Id: <20190608114847.9973-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114847.9973-1-sashal@kernel.org>
References: <20190608114847.9973-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Mackerras <paulus@ozlabs.org>

[ Upstream commit 1659e27d2bc1ef47b6d031abe01b467f18cb72d9 ]

Currently the Book 3S KVM code uses kvm->lock to synchronize access
to the kvm->arch.rtas_tokens list.  Because this list is scanned
inside kvmppc_rtas_hcall(), which is called with the vcpu mutex held,
taking kvm->lock cause a lock inversion problem, which could lead to
a deadlock.

To fix this, we add a new mutex, kvm->arch.rtas_token_lock, which nests
inside the vcpu mutexes, and use that instead of kvm->lock when
accessing the rtas token list.

This removes the lockdep_assert_held() in kvmppc_rtas_tokens_free().
At this point we don't hold the new mutex, but that is OK because
kvmppc_rtas_tokens_free() is only called when the whole VM is being
destroyed, and at that point nothing can be looking up a token in
the list.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_host.h |  1 +
 arch/powerpc/kvm/book3s.c           |  1 +
 arch/powerpc/kvm/book3s_rtas.c      | 14 ++++++--------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index a92d95aee42d..1883627eb12c 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -250,6 +250,7 @@ struct kvm_arch {
 #ifdef CONFIG_PPC_BOOK3S_64
 	struct list_head spapr_tce_tables;
 	struct list_head rtas_tokens;
+	struct mutex rtas_token_lock;
 	DECLARE_BITMAP(enabled_hcalls, MAX_HCALL_OPCODE/4 + 1);
 #endif
 #ifdef CONFIG_KVM_MPIC
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 099c79d8c160..4aab1c9c83e1 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -809,6 +809,7 @@ int kvmppc_core_init_vm(struct kvm *kvm)
 #ifdef CONFIG_PPC64
 	INIT_LIST_HEAD(&kvm->arch.spapr_tce_tables);
 	INIT_LIST_HEAD(&kvm->arch.rtas_tokens);
+	mutex_init(&kvm->arch.rtas_token_lock);
 #endif
 
 	return kvm->arch.kvm_ops->init_vm(kvm);
diff --git a/arch/powerpc/kvm/book3s_rtas.c b/arch/powerpc/kvm/book3s_rtas.c
index ef27fbd5d9c5..b1b2273d1f6d 100644
--- a/arch/powerpc/kvm/book3s_rtas.c
+++ b/arch/powerpc/kvm/book3s_rtas.c
@@ -133,7 +133,7 @@ static int rtas_token_undefine(struct kvm *kvm, char *name)
 {
 	struct rtas_token_definition *d, *tmp;
 
-	lockdep_assert_held(&kvm->lock);
+	lockdep_assert_held(&kvm->arch.rtas_token_lock);
 
 	list_for_each_entry_safe(d, tmp, &kvm->arch.rtas_tokens, list) {
 		if (rtas_name_matches(d->handler->name, name)) {
@@ -154,7 +154,7 @@ static int rtas_token_define(struct kvm *kvm, char *name, u64 token)
 	bool found;
 	int i;
 
-	lockdep_assert_held(&kvm->lock);
+	lockdep_assert_held(&kvm->arch.rtas_token_lock);
 
 	list_for_each_entry(d, &kvm->arch.rtas_tokens, list) {
 		if (d->token == token)
@@ -193,14 +193,14 @@ int kvm_vm_ioctl_rtas_define_token(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&args, argp, sizeof(args)))
 		return -EFAULT;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.rtas_token_lock);
 
 	if (args.token)
 		rc = rtas_token_define(kvm, args.name, args.token);
 	else
 		rc = rtas_token_undefine(kvm, args.name);
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.rtas_token_lock);
 
 	return rc;
 }
@@ -232,7 +232,7 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *vcpu)
 	orig_rets = args.rets;
 	args.rets = &args.args[be32_to_cpu(args.nargs)];
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.rtas_token_lock);
 
 	rc = -ENOENT;
 	list_for_each_entry(d, &vcpu->kvm->arch.rtas_tokens, list) {
@@ -243,7 +243,7 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.rtas_token_lock);
 
 	if (rc == 0) {
 		args.rets = orig_rets;
@@ -269,8 +269,6 @@ void kvmppc_rtas_tokens_free(struct kvm *kvm)
 {
 	struct rtas_token_definition *d, *tmp;
 
-	lockdep_assert_held(&kvm->lock);
-
 	list_for_each_entry_safe(d, tmp, &kvm->arch.rtas_tokens, list) {
 		list_del(&d->list);
 		kfree(d);
-- 
2.20.1

