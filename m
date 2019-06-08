Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE8939EAA
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbfFHLuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729703AbfFHLsf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:48:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34AEE216FD;
        Sat,  8 Jun 2019 11:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994514;
        bh=OufRU6ZKKMtbJpXE8bpNPBGZzdkVX/nTe5h+XgfYuTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R01ndFGFipbOm30eBDqf2Nxkb36HMFzMvYBuPsj9ZK9i6wAvpKLuWAMA++f1240Kf
         lOSIduo3lVJA78hYt+JM35++fptqoHmpfAvxSskqFFr3zsMZuK0qOsAOnuQbKDW+Fu
         2gM6K1AnvCk5Fb+fuDqmKspDto4krrfO5GkwYNlI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 15/20] KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu
Date:   Sat,  8 Jun 2019 07:47:51 -0400
Message-Id: <20190608114756.9742-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114756.9742-1-sashal@kernel.org>
References: <20190608114756.9742-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Mackerras <paulus@ozlabs.org>

[ Upstream commit 5a3f49364c3ffa1107bd88f8292406e98c5d206c ]

Currently the HV KVM code takes the kvm->lock around calls to
kvm_for_each_vcpu() and kvm_get_vcpu_by_id() (which can call
kvm_for_each_vcpu() internally).  However, that leads to a lock
order inversion problem, because these are called in contexts where
the vcpu mutex is held, but the vcpu mutexes nest within kvm->lock
according to Documentation/virtual/kvm/locking.txt.  Hence there
is a possibility of deadlock.

To fix this, we simply don't take the kvm->lock mutex around these
calls.  This is safe because the implementations of kvm_for_each_vcpu()
and kvm_get_vcpu_by_id() have been designed to be able to be called
locklessly.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0a2b247dbc6b..e840f943cd2c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -374,12 +374,7 @@ static void kvmppc_dump_regs(struct kvm_vcpu *vcpu)
 
 static struct kvm_vcpu *kvmppc_find_vcpu(struct kvm *kvm, int id)
 {
-	struct kvm_vcpu *ret;
-
-	mutex_lock(&kvm->lock);
-	ret = kvm_get_vcpu_by_id(kvm, id);
-	mutex_unlock(&kvm->lock);
-	return ret;
+	return kvm_get_vcpu_by_id(kvm, id);
 }
 
 static void init_vpa(struct kvm_vcpu *vcpu, struct lppaca *vpa)
@@ -1098,7 +1093,6 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	u64 mask;
 
-	mutex_lock(&kvm->lock);
 	spin_lock(&vc->lock);
 	/*
 	 * If ILE (interrupt little-endian) has changed, update the
@@ -1132,7 +1126,6 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 		mask &= 0xFFFFFFFF;
 	vc->lpcr = (vc->lpcr & ~mask) | (new_lpcr & mask);
 	spin_unlock(&vc->lock);
-	mutex_unlock(&kvm->lock);
 }
 
 static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
-- 
2.20.1

