Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD9F4125CF
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384666AbhITSsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384097AbhITSqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:46:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27A766335C;
        Mon, 20 Sep 2021 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159213;
        bh=CR846wXXXHl/Ng8G88sA14qia9OWfF1CL4/79f+daRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sj/8i3yKeaZ3/Re7XqH4Mjpd3N1Ux+fZgKS0DP1PmUh3W7jF5KdNmVPALncZcTHxi
         4e2R3HoO6cWU+F0z3wnFnA0o/6Mv77mu3QTb4BBEPqoyeYwvt0foxTOq5zR+eekusg
         P204089QZ+FWIwK8lrgvTRBmIHGsAH11ZlWHz+20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 127/168] KVM: arm64: Restrict IPA size to maximum 48 bits on 4K and 16K page size
Date:   Mon, 20 Sep 2021 18:44:25 +0200
Message-Id: <20210920163925.839290093@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 5e5df9571c319fb107d7a523cc96fcc99961ee70 ]

Even though ID_AA64MMFR0.PARANGE reports 52 bit PA size support, it cannot
be enabled as guest IPA size on 4K or 16K page size configurations. Hence
kvm_ipa_limit must be restricted to 48 bits. This change achieves required
IPA capping.

Before the commit c9b69a0cf0b4 ("KVM: arm64: Don't constrain maximum IPA
size based on host configuration"), the problem here would have been just
latent via PHYS_MASK_SHIFT (which earlier in turn capped kvm_ipa_limit),
which remains capped at 48 bits on 4K and 16K configs.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org
Fixes: c9b69a0cf0b4 ("KVM: arm64: Don't constrain maximum IPA size based on host configuration")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1628680275-16578-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/reset.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index cba7872d69a8..78d4bd897fbc 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -317,6 +317,14 @@ int kvm_set_ipa_limit(void)
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	parange = cpuid_feature_extract_unsigned_field(mmfr0,
 				ID_AA64MMFR0_PARANGE_SHIFT);
+	/*
+	 * IPA size beyond 48 bits could not be supported
+	 * on either 4K or 16K page size. Hence let's cap
+	 * it to 48 bits, in case it's reported as larger
+	 * on the system.
+	 */
+	if (PAGE_SIZE != SZ_64K)
+		parange = min(parange, (unsigned int)ID_AA64MMFR0_PARANGE_48);
 
 	/*
 	 * Check with ARMv8.5-GTG that our PAGE_SIZE is supported at
-- 
2.30.2



