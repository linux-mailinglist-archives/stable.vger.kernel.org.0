Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E565F2A0B6C
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgJ3Qkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727204AbgJ3Qka (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 12:40:30 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16A192151B;
        Fri, 30 Oct 2020 16:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076030;
        bh=zS4ms9lpY+5i0csRVlQid6DJtYxnZFqMNVqaAUo4X8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDJ3/4os3w8+PmOFABAHJX97XQh8lUQwe69Bl4735umr+DKPlil9l6xwTVdXBHux5
         P0eeJtFzeZWzXMtDYVymOs5k8AJ5Eu+EHClujSaPGIhc2mr8VUTxU6JbRTrbbvvtN7
         gZQ9iay1rch7P4OrwsX+xrG+QaqMpRGCcm0ZFsrM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kYXS0-005noK-9W; Fri, 30 Oct 2020 16:40:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        Santosh Shukla <sashukla@nvidia.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: [PATCH 08/12] KVM: arm64: Force PTE mapping on fault resulting in a device mapping
Date:   Fri, 30 Oct 2020 16:40:13 +0000
Message-Id: <20201030164017.244287-9-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com, qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Santosh Shukla <sashukla@nvidia.com>

VFIO allows a device driver to resolve a fault by mapping a MMIO
range. This can be subsequently result in user_mem_abort() to
try and compute a huge mapping based on the MMIO pfn, which is
a sure recipe for things to go wrong.

Instead, force a PTE mapping when the pfn faulted in has a device
mapping.

Fixes: 6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
[maz: rewritten commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1603711447-11998-2-git-send-email-sashukla@nvidia.com
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e431d2d8e368..c7c6df6309d5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -851,6 +851,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (kvm_is_device_pfn(pfn)) {
 		device = true;
+		force_pte = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
-- 
2.28.0

