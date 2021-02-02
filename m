Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DD630CC9B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbhBBUBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:01:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232953AbhBBNrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3413064F94;
        Tue,  2 Feb 2021 13:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273309;
        bh=WwJUMvfJcEuTYVj7En++z0rTVSt7vyOWTEyPOIwWW28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+B69C0bFlGFp6qpJUwDNl0cL1+qf3f9fTIbRszo9TTxaB1oq3vlwEhOoljxCz9IG
         etNr6OiqlMLXzOC3BMz3lGMcO9VwktUsyEA74WmU8LgrafXCYV7mSGUlDGE6LrxLbi
         0QKnzX+lEOudh6uUYemXUF7Btjc8IB3DEdK2cnNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 041/142] KVM: arm64: Filter out v8.1+ events on v8.0 HW
Date:   Tue,  2 Feb 2021 14:36:44 +0100
Message-Id: <20210202132959.413917011@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 9529aaa056edc76b3a41df616c71117ebe11e049 upstream.

When running on v8.0 HW, make sure we don't try to advertise
events in the 0x4000-0x403f range.

Cc: stable@vger.kernel.org
Fixes: 88865beca9062 ("KVM: arm64: Mask out filtered events in PCMEID{0,1}_EL1")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210121105636.1478491-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/pmu-emul.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -788,7 +788,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *
 {
 	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
 	u64 val, mask = 0;
-	int base, i;
+	int base, i, nr_events;
 
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
@@ -801,13 +801,17 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *
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


