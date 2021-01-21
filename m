Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBF02FE840
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 12:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbhAUK7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 05:59:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729851AbhAUK5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 05:57:23 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A1D423787;
        Thu, 21 Jan 2021 10:56:42 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l2Xdn-009ATF-Tw; Thu, 21 Jan 2021 10:56:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Filter out v8.1+ events on v8.0 HW
Date:   Thu, 21 Jan 2021 10:56:36 +0000
Message-Id: <20210121105636.1478491-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When running on v8.0 HW, make sure we don't try to advertise
events in the 0x4000-0x403f range.

Cc: stable@vger.kernel.org
Fixes: 88865beca9062 ("KVM: arm64: Mask out filtered events in PCMEID{0,1}_EL1")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 4ad66a532e38..247422ac78a9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -788,7 +788,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 {
 	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
 	u64 val, mask = 0;
-	int base, i;
+	int base, i, nr_events;
 
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
@@ -801,13 +801,17 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	if (!bmap)
 		return val;
 
+	nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
+
 	for (i = 0; i < 32; i += 8) {
 		u64 byte;
 
 		byte = bitmap_get_value8(bmap, base + i);
 		mask |= byte << i;
-		byte = bitmap_get_value8(bmap, 0x4000 + base + i);
-		mask |= byte << (32 + i);
+		if (nr_events >= (0x4000 + base + 32)) {
+			byte = bitmap_get_value8(bmap, 0x4000 + base + i);
+			mask |= byte << (32 + i);
+		}
 	}
 
 	return val & mask;
-- 
2.29.2

