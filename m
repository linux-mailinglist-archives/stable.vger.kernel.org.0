Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75C43C52AC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344514AbhGLHsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346514AbhGLHqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7935B61152;
        Mon, 12 Jul 2021 07:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075715;
        bh=rQrYfrm0nXM2qJBQkx21iUm4Z/fRcEmyrGKvSsAnrWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJ2+t2qOrtBRLNmOJ3VbYyi5BG+ZkH1s96pX7VWD28cS+tRSHiJh5yU654RNz1pBy
         SJd4tqBPZzEMw5MtIOHUfRXXzzsQHmw1NU4J4yo8Xt4TJGUa/GbDQezAi1DubGvr2L
         qJkfYX/8GAcvuCEjjV747w5toXuowV7QgwbkAXoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 331/800] KVM: arm64: Dont zero the cycle count register when PMCR_EL0.P is set
Date:   Mon, 12 Jul 2021 08:05:54 +0200
Message-Id: <20210712061001.672970087@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

[ Upstream commit 2a71fabf6a1bc9162a84e18d6ab991230ca4d588 ]

According to ARM DDI 0487G.a, page D13-3895, setting the PMCR_EL0.P bit to
1 has the following effect:

"Reset all event counters accessible in the current Exception level, not
including PMCCNTR_EL0, to zero."

Similar behaviour is described for AArch32 on page G8-7022. Make it so.

Fixes: c01d6a18023b ("KVM: arm64: pmu: Only handle supported event counters")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210618105139.83795-1-alexandru.elisei@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a0bbb7111f57..f33825c995cb 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -578,6 +578,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
+		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_counter_value(vcpu, i, 0);
 	}
-- 
2.30.2



