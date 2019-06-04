Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63353539F
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfFDX0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbfFDXZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:25:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E299208CB;
        Tue,  4 Jun 2019 23:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690730;
        bh=AR4eTHwSeJQcxxIju8U2g2uV2eCRmqIjgfKgnmshzos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCCLfOLUDhE8RJ6dT7Gx+EDgypg1KTOgVPAsVBE3UkJ3yQ3vf+MbaeuC3ZiacqwPL
         bmkbK1OkVSCNXOAkuFKRz+jhViuV4IPF3Ys/QmFw4QVZPWyUgnG2niGBlF1XiDpI57
         NUaadR2BTPWpAzokiiFtGNCqHi2YFCpa4EUpl/9I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 17/17] KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION
Date:   Tue,  4 Jun 2019 19:24:58 -0400
Message-Id: <20190604232459.7745-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232459.7745-1-sashal@kernel.org>
References: <20190604232459.7745-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

[ Upstream commit 19ec166c3f39fe1d3789888a74cc95544ac266d4 ]

kselftests exposed a problem in the s390 handling for memory slots.
Right now we only do proper memory slot handling for creation of new
memory slots. Neither MOVE, nor DELETION are handled properly. Let us
implement those.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2032ab81b2d7..07f571900676 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3288,21 +3288,28 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	int rc;
-
-	/* If the basics of the memslot do not change, we do not want
-	 * to update the gmap. Every update causes several unnecessary
-	 * segment translation exceptions. This is usually handled just
-	 * fine by the normal fault handler + gmap, but it will also
-	 * cause faults on the prefix page of running guest CPUs.
-	 */
-	if (old->userspace_addr == mem->userspace_addr &&
-	    old->base_gfn * PAGE_SIZE == mem->guest_phys_addr &&
-	    old->npages * PAGE_SIZE == mem->memory_size)
-		return;
+	int rc = 0;
 
-	rc = gmap_map_segment(kvm->arch.gmap, mem->userspace_addr,
-		mem->guest_phys_addr, mem->memory_size);
+	switch (change) {
+	case KVM_MR_DELETE:
+		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
+					old->npages * PAGE_SIZE);
+		break;
+	case KVM_MR_MOVE:
+		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
+					old->npages * PAGE_SIZE);
+		if (rc)
+			break;
+		/* FALLTHROUGH */
+	case KVM_MR_CREATE:
+		rc = gmap_map_segment(kvm->arch.gmap, mem->userspace_addr,
+				      mem->guest_phys_addr, mem->memory_size);
+		break;
+	case KVM_MR_FLAGS_ONLY:
+		break;
+	default:
+		WARN(1, "Unknown KVM MR CHANGE: %d\n", change);
+	}
 	if (rc)
 		pr_warn("failed to commit memory region\n");
 	return;
-- 
2.20.1

