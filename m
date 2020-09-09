Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F3726382C
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 23:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgIIVFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 17:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbgIIVFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 17:05:40 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775CE206D4;
        Wed,  9 Sep 2020 21:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599685539;
        bh=LunnJpliQgRjiEVetnhJXASncAl1C5s7uWNB3u6DaZc=;
        h=From:To:Cc:Subject:Date:From;
        b=yqxa7ehxphXmc1T3J8702keaNZyzLzfHp45qqOxhKoqwabHtfrEUWcq7srxebCNUI
         I4PrpOwLZw6yf0zYFngGR50EtCphaC86t+43egW+/Ze9bZQgFeAVGFmsGh1roS1WF4
         b32khP0ng3815bkR56+t2w8Q3+5NKFJK1ub5LxGk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kG7Hd-00ATLQ-Ju; Wed, 09 Sep 2020 22:05:37 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch
Date:   Wed,  9 Sep 2020 22:05:27 +0100
Message-Id: <20200909210527.1926996-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KVM currently assumes that an instruction abort can never be a write.
This is in general true, except when the abort is triggered by
a S1PTW on instruction fetch that tries to update the S1 page tables
(to set AF, for example).

This can happen if the page tables have been paged out and brought
back in without seeing a direct write to them (they are thus marked
read only), and the fault handling code will make the PT executable(!)
instead of writable. The guest gets stuck forever.

In these conditions, the permission fault must be considered as
a write so that the Stage-1 update can take place. This is essentially
the I-side equivalent of the problem fixed by 60e21a0ef54c ("arm64: KVM:
Take S1 walks into account when determining S2 write faults").

Update both kvm_is_write_fault() to return true on IABT+S1PTW, as well
as kvm_vcpu_trap_is_iabt() to return false in the same conditions.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
This could do with some cleanup (kvm_vcpu_dabt_iss1tw has nothing to do
with data aborts), but I've chosen to keep the patch simple in order to
ease backporting.

 arch/arm64/include/asm/kvm_emulate.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d21676409a24..33d7e16edaa3 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -480,7 +480,8 @@ static __always_inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
+	return (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW &&
+		!kvm_vcpu_dabt_iss1tw(vcpu));
 }
 
 static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
@@ -520,6 +521,9 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
+	if (kvm_vcpu_dabt_iss1tw(vcpu))
+		return true;
+
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;
 
-- 
2.28.0

