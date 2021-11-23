Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5C945A85A
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239015AbhKWQk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238442AbhKWQk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE0660F6E;
        Tue, 23 Nov 2021 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685439;
        bh=ZC3Mk0PUk1pg2ALye5gUx1SO8qk8Qc9/BKa2B7rBmyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYnwWx7mcDslD/U92E2pVhgB4Nru/h7yjA0AaSw+bFE/XO18SCd8D9gCrkv5xZPQd
         schLfvYvO2OIrXG7ppPfCOw6zRqDcWzSqGcdlrYD9gJNw+jX5PEBgQqvCBJP7TpvoH
         hhTZxFFit8an7oVIYOpuEn0sToAgwGq7BlUtcPh+sNda6Lw+zbNbHCx1sXGUa9tqmW
         OM/Tm0x6FRNqrKdkPPS3xKqRrKoruh9zwJPGlLJUJ7w+8atOldyS5X0fehyctQqSeC
         wetEVZIkkrrQeainV2kg1XmG0igx/rNDlKNCiOTg9DJ6bIZiFmHeQzGFvkA/WVDJZn
         AhcP3zErwM8wA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, frankja@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH MANUALSEL 4.19 2/4] KVM: s390: Cap KVM_CAP_NR_VCPUS by num_online_cpus()
Date:   Tue, 23 Nov 2021 11:37:13 -0500
Message-Id: <20211123163715.289631-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163715.289631-1-sashal@kernel.org>
References: <20211123163715.289631-1-sashal@kernel.org>
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
index 71c67a1d2849a..fd1fa49176603 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -506,6 +506,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = KVM_MAX_VCPUS;
 		else if (sclp.has_esca && sclp.has_64bscao)
 			r = KVM_S390_ESCA_CPU_SLOTS;
+		if (ext == KVM_CAP_NR_VCPUS)
+			r = min_t(unsigned int, num_online_cpus(), r);
 		break;
 	case KVM_CAP_NR_MEMSLOTS:
 		r = KVM_USER_MEM_SLOTS;
-- 
2.33.0

