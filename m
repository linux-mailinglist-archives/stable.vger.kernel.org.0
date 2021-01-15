Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C6C2F7BC7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbhAONFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732638AbhAOMba (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E283238E8;
        Fri, 15 Jan 2021 12:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713833;
        bh=n8GLVtX2sebaSW0ZA7xgFtuKbzGC87YbZ4+1E2AITnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFUbKa8av0MSgTNd8qy+yojUoSMpeD/U8VqCvgCNSO5tURsDBUR74UmaPEQhcYlDG
         HBf/cwxQ2Kxw2IR8sZsjNP6O/sL/M3wdwCgRdErNhLuQkU468ZivWntUHH+OP9mSZ5
         8O9D0IuYg8SoHnFUHMkYqmGNuHH8WS1kLht3AoHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.9 23/25] KVM: arm64: Dont access PMCR_EL0 when no PMU is available
Date:   Fri, 15 Jan 2021 13:27:54 +0100
Message-Id: <20210115121957.833201200@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
References: <20210115121956.679956165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 2a5f1b67ec577fb1544b563086e0377f095f88e2 upstream.

We reset the guest's view of PMCR_EL0 unconditionally, based on
the host's view of this register. It is however legal for an
implementation not to provide any PMU, resulting in an UNDEF.

The obvious fix is to skip the reset of this shadow register
when no PMU is available, sidestepping the issue entirely.
If no PMU is available, the guest is not able to request
a virtual PMU anyway, so not doing nothing is the right thing
to do!

It is unlikely that this bug can hit any HW implementation
though, as they all provide a PMU. It has been found using nested
virt with the host KVM not implementing the PMU itself.

Fixes: ab9468340d2bc ("arm64: KVM: Add access handler for PMCR register")
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201210083059.1277162-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/sys_regs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -450,6 +450,10 @@ static void reset_pmcr(struct kvm_vcpu *
 {
 	u64 pmcr, val;
 
+	/* No PMU available, PMCR_EL0 may UNDEF... */
+	if (!kvm_arm_support_pmu_v3())
+		return;
+
 	pmcr = read_sysreg(pmcr_el0);
 	/*
 	 * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN


