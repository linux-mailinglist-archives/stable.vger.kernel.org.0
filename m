Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EEE45A868
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbhKWQlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:41:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239101AbhKWQkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A49560FC3;
        Tue, 23 Nov 2021 16:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685447;
        bh=M4XuyOmh6kxG/84L1f4XVB9maEzzr/aNARXo7jXW3nE=;
        h=From:To:Cc:Subject:Date:From;
        b=RIf4ASGovapCngHqn5jR/ICKOEPnS8eP/C9Rklz2ehWq9mjPJoPD+8N6hV1jTilQj
         RbA2t2Hwi9NI2wSpMv+HqAGreCnXLIyD752I6GtcJy7OZ8JONlJsUwSccYy1R6AB7d
         8fgA1ooKPdfv1n8/nTxGyr54Jcq70Fa73BthRvoAdoQjtQH0WCdZf+4sJGAeEeNqml
         GfcZgMJD/wBc+bNnMOGtuXmeoZijIgMgkvdRs56bOM010JaQ99lL29MtnXE65yLiLD
         V2M9zfZbucG5G2n/xxRVA30PxT1e1P3mm1gPxzc6P8xVGpQHCrht5Xy90qYJAHB8zn
         6/EsCWSPBdtqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, frankja@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH MANUALSEL 4.14 1/3] KVM: s390: Cap KVM_CAP_NR_VCPUS by num_online_cpus()
Date:   Tue, 23 Nov 2021 11:37:22 -0500
Message-Id: <20211123163725.289694-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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
index 05bd517528450..bc74a3056ac72 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -445,6 +445,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

