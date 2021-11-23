Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C453E45A83A
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbhKWQkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237967AbhKWQkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F5A760F6F;
        Tue, 23 Nov 2021 16:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685416;
        bh=LC0osWohjJLAISJJ25jrzYfD4MDeQ2TSrRLwRQquBOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X45CWHv9/PQMnF2x66W/gdx8BOvkAQuVae5Y/2c8OExH4Equ40MSbvRf7xWXp6IHb
         PS1GL/AHSz/uYg1alc9AW8ffTpvAkhYc67WlKj61pKtu8bgKLtuLkQiIvuxf5EmArS
         vh2l2ik1kf9JIbMaQIP43llGjlfn4Z6K/4m62+vR+curcP24DvQTJc3giSEmuwD3W0
         lJGMYZXEURYtTpbwAR7RtIBtW+jNZK7/WNPVkYOtF8gtk4pzhFwLOd5lmj/3RrF2ar
         x03k5ZX36rkTVW8rO7q8rVlQi29n+g2ZiPr7Ac12rst5u3Bm6qI0MZoc1e5lgTxjrs
         vOjB9eG6CX84A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, frankja@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 2/5] KVM: s390: Cap KVM_CAP_NR_VCPUS by num_online_cpus()
Date:   Tue, 23 Nov 2021 11:36:46 -0500
Message-Id: <20211123163652.289483-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163652.289483-1-sashal@kernel.org>
References: <20211123163652.289483-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 82cc27eff4486f8e79ef8faac1af1f5573039aa4 ]

KVM_CAP_NR_VCPUS is a legacy advisory value which on other architectures
return num_online_cpus() caped by KVM_CAP_NR_VCPUS or something else
(ppc and arm64 are special cases). On s390, KVM_CAP_NR_VCPUS returns
the same as KVM_CAP_MAX_VCPUS and this may turn out to be a bad
'advice'. Switch s390 to returning caped num_online_cpus() too.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Message-Id: <20211116163443.88707-6-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 00f03f363c9b0..25ca18ed07bdc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -564,6 +564,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = KVM_MAX_VCPUS;
 		else if (sclp.has_esca && sclp.has_64bscao)
 			r = KVM_S390_ESCA_CPU_SLOTS;
+		if (ext == KVM_CAP_NR_VCPUS)
+			r = min_t(unsigned int, num_online_cpus(), r);
 		break;
 	case KVM_CAP_S390_COW:
 		r = MACHINE_HAS_ESOP;
-- 
2.33.0

