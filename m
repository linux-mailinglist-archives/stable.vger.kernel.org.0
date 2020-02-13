Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC9415C418
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgBMP0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729268AbgBMP0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:51 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2134A222C2;
        Thu, 13 Feb 2020 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607611;
        bh=uEqBD+pRryWe/jG4/xFJ/zSOq1zd6Fja6rU94sP9RLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqEluBXNDvUn3XVMp3Q9b/tjk66hcFWY+1Dh9+1Ii8ds18y+8xrr/p4vXYxg4m5V/
         6Or2mnZoFqvs8Uoj5kgwD/TKRhNdlWukAhfGF4jNKqerVltThPjxue/oKmQdMT1dxX
         1P/twHa5LQMX/CjQgnnhoLJqM7qmm+g6RNUO3zI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 36/52] KVM: arm/arm64: Fix young bit from mmu notifier
Date:   Thu, 13 Feb 2020 07:21:17 -0800
Message-Id: <20200213151825.176692550@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

commit cf2d23e0bac9f6b5cd1cba8898f5f05ead40e530 upstream.

kvm_test_age_hva() is called upon mmu_notifier_test_young(), but wrong
address range has been passed to handle_hva_to_gpa(). With the wrong
address range, no young bits will be checked in handle_hva_to_gpa().
It means zero is always returned from mmu_notifier_test_young().

This fixes the issue by passing correct address range to the underly
function handle_hva_to_gpa(), so that the hardware young (access) bit
will be visited.

Fixes: 35307b9a5f7e ("arm/arm64: KVM: Implement Stage-2 page aging")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200121055659.19560-1-gshan@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1925,7 +1925,8 @@ int kvm_test_age_hva(struct kvm *kvm, un
 	if (!kvm->arch.pgd)
 		return 0;
 	trace_kvm_test_age_hva(hva);
-	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
+	return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
+				 kvm_test_age_hva_handler, NULL);
 }
 
 void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)


