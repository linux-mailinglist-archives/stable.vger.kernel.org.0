Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD5245A84A
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239162AbhKWQkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239159AbhKWQkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 601CE60FC1;
        Tue, 23 Nov 2021 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685430;
        bh=s4vWiDcC5LTWsqbh3ERWV0bARR+k0Ovo6frpkWuVW8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SY3Uh7X45OHWLDm4Nns2RTcg5Dtowg/V2jCSSWwU8EaOMIW4Q2VWLM4BMKfxqNCzG
         Hg2Awg6KEoA4jP9rODNYWdNdu/JcQMGchicRpCnQxLMGs/MXloenkE8vMoo6NEGEwm
         d+3jC9xVImlieqzmSgTv9UlQ5L1Xxyk6kBUQ4dPQHQztPFJYMwrCn5uZGVaxH2nlaX
         Mk/6HXfRSbJ7UAk/uNuPpdLx9kJkDw3Rj21X/jH8P93v4Wv4j1UIgBGEqjp00MLItT
         BJsMFVP1Jgyygjm64cvrQlRLZzbjlVu6koeJpsUv++rYYiiQ9k//6DA3CR/0T1Lbni
         69oVJRd7kNkFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, frankja@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH MANUALSEL 5.4 2/4] KVM: s390: Cap KVM_CAP_NR_VCPUS by num_online_cpus()
Date:   Tue, 23 Nov 2021 11:37:01 -0500
Message-Id: <20211123163706.289562-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163706.289562-1-sashal@kernel.org>
References: <20211123163706.289562-1-sashal@kernel.org>
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
index b286818d8d54d..fa11b42683901 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -550,6 +550,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

