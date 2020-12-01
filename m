Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC4F2C9C45
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390247AbgLAJQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388834AbgLAJNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58FBF2067D;
        Tue,  1 Dec 2020 09:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813951;
        bh=nBkX6aprXiLnsZZnO8p5F53hUQl92crM455RDrMnX54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuspRbRDojamifkIOPYsCs8qvvp5r67abF2OP0Fz0LJBGs/ZKKqHsjeOChBI0DnTD
         F9QZt1ZYB2xUM5EVa2zK/7fYB6z+nZlorZcUaYqAdO/I3QlKtH29tJX9KQpCPVh8U+
         i/Z0dpFoSw35qEih2GnFszkJS+jUQkelJCS8t//I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 076/152] KVM: s390: pv: Mark mm as protected after the set secure parameters and improve cleanup
Date:   Tue,  1 Dec 2020 09:53:11 +0100
Message-Id: <20201201084721.858629644@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

[ Upstream commit 1ed576a20cd5c93295f57d6b7400357bd8d01b21 ]

We can only have protected guest pages after a successful set secure
parameters call as only then the UV allows imports and unpacks.

By moving the test we can now also check for it in s390_reset_acc()
and do an early return if it is 0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 29b40f105ec8 ("KVM: s390: protvirt: Add initial vm and cpu lifecycle handling")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 arch/s390/kvm/pv.c       | 3 ++-
 arch/s390/mm/gmap.c      | 2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a586..08ea6c4735cdc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2312,7 +2312,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		struct kvm_s390_pv_unp unp = {};
 
 		r = -EINVAL;
-		if (!kvm_s390_pv_is_protected(kvm))
+		if (!kvm_s390_pv_is_protected(kvm) || !mm_is_protected(kvm->mm))
 			break;
 
 		r = -EFAULT;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index eb99e2f95ebed..f5847f9dec7c9 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -208,7 +208,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EIO;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
-	atomic_set(&kvm->mm->context.is_protected, 1);
 	return 0;
 }
 
@@ -228,6 +227,8 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
 		     *rc, *rrc);
+	if (!cc)
+		atomic_set(&kvm->mm->context.is_protected, 1);
 	return cc ? -EINVAL : 0;
 }
 
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 373542ca1113e..78dbba6a4500c 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2690,6 +2690,8 @@ static const struct mm_walk_ops reset_acc_walk_ops = {
 #include <linux/sched/mm.h>
 void s390_reset_acc(struct mm_struct *mm)
 {
+	if (!mm_is_protected(mm))
+		return;
 	/*
 	 * we might be called during
 	 * reset:                             we walk the pages and clear
-- 
2.27.0



