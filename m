Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9680725D6CB
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 12:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgIDKsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 06:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729872AbgIDKqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 06:46:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96ED820BED;
        Fri,  4 Sep 2020 10:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599216365;
        bh=YPmVVuM3L0+tzK23hJSp9aG+F13rF2rLtANdW+Ek5HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOkJNA0/4PQHNaY9m8jG6wBDgVCISM24ka7mhptQvDyC9H0Okv78DICIMZ4QDOMMo
         wEuyPxe0CpNMcYoMw/izfKqXDY3QVaeEijQ64R4Mu38J5Qiy1fRhAkFbHgoEm7EtAQ
         +3BpAxPk3J8KDqlku8fJLs27UwUgLFpCyoPWZxg4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kE9EK-0098oH-2G; Fri, 04 Sep 2020 11:46:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 7/9] KVM: arm64: Do not try to map PUDs when they are folded into PMD
Date:   Fri,  4 Sep 2020 11:45:28 +0100
Message-Id: <20200904104530.1082676-8-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200904104530.1082676-1-maz@kernel.org>
References: <20200904104530.1082676-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com, steven.price@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For the obscure cases where PMD and PUD are the same size
(64kB pages with 42bit VA, for example, which results in only
two levels of page tables), we can't map anything as a PUD,
because there is... erm... no PUD to speak of. Everything is
either a PMD or a PTE.

So let's only try and map a PUD when its size is different from
that of a PMD.

Cc: stable@vger.kernel.org
Fixes: b8e0ba7c8bea ("KVM: arm64: Add support for creating PUD hugepages at stage 2")
Reported-by: Gavin Shan <gshan@redhat.com>
Reported-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0121ef2c7c8d..16b8660ddbcc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1964,7 +1964,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		(fault_status == FSC_PERM &&
 		 stage2_is_exec(mmu, fault_ipa, vma_pagesize));
 
-	if (vma_pagesize == PUD_SIZE) {
+	/*
+	 * If PUD_SIZE == PMD_SIZE, there is no real PUD level, and
+	 * all we have is a 2-level page table. Trying to map a PUD in
+	 * this case would be fatally wrong.
+	 */
+	if (PUD_SIZE != PMD_SIZE && vma_pagesize == PUD_SIZE) {
 		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
 
 		new_pud = kvm_pud_mkhuge(new_pud);
-- 
2.27.0

