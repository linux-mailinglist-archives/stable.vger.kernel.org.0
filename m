Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231DB2A99B3
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 17:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgKFQok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 11:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgKFQoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 11:44:39 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B5F9217A0;
        Fri,  6 Nov 2020 16:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604681078;
        bh=t0K1Uzu+49PExG7zsJdALxOgNu8sv7rz5YDcQXoVCJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0Knw6SXwkuIvEg2uWUQ/PrrwXU0Cup7lBqjLmSlH3uf72/RKpQZ9dOI4ig17Uf4E
         NF9jRnOkkDZgCzsf1c4qRUJIXZQfhuFdoWmvBf85dshrgexy8qMYW6oFU70shSl1hx
         13TGB/J7sIsA7MVpBxI3o7/48OIJ/3RYjg/9oYjs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kb4qq-008FYW-NV; Fri, 06 Nov 2020 16:44:36 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?q?=E5=BC=A0=E4=B8=9C=E6=97=AD?= <xu910121@sina.com>,
        dave.martin@arm.com, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH 2/5] KVM: arm64: Don't hide ID registers from userspace
Date:   Fri,  6 Nov 2020 16:44:13 +0000
Message-Id: <20201106164416.326787-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201106164416.326787-1-maz@kernel.org>
References: <20201106164416.326787-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com, xu910121@sina.com, dave.martin@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

ID registers are RAZ until they've been allocated a purpose, but
that doesn't mean they should be removed from the KVM_GET_REG_LIST
list. So far we only have one register, SYS_ID_AA64ZFR0_EL1, that
is hidden from userspace when its function, SVE, is not present.

Expose SYS_ID_AA64ZFR0_EL1 to userspace as RAZ when SVE is not
implemented. Removing the userspace visibility checks is enough
to reexpose it, as it will already return zero to userspace when
SVE is not present. The register already behaves as RAZ for the
guest when SVE is not present.

Fixes: 73433762fcae ("KVM: arm64/sve: System register context switch and access support")
Reported-by: 张东旭 <xu910121@sina.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org#v5.2+
Link: https://lore.kernel.org/r/20201105091022.15373-2-drjones@redhat.com
---
 arch/arm64/kvm/sys_regs.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 983994f01a63..3af306e6b9cd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1193,16 +1193,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
 }
 
-/* Visibility overrides for SVE-specific ID registers */
-static unsigned int sve_id_visibility(const struct kvm_vcpu *vcpu,
-				      const struct sys_reg_desc *rd)
-{
-	if (vcpu_has_sve(vcpu))
-		return 0;
-
-	return REG_HIDDEN_USER;
-}
-
 /* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
 static u64 guest_id_aa64zfr0_el1(const struct kvm_vcpu *vcpu)
 {
@@ -1229,9 +1219,6 @@ static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u64 val;
 
-	if (WARN_ON(!vcpu_has_sve(vcpu)))
-		return -ENOENT;
-
 	val = guest_id_aa64zfr0_el1(vcpu);
 	return reg_to_user(uaddr, &val, reg->id);
 }
@@ -1244,9 +1231,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 	int err;
 	u64 val;
 
-	if (WARN_ON(!vcpu_has_sve(vcpu)))
-		return -ENOENT;
-
 	err = reg_from_user(&val, uaddr, id);
 	if (err)
 		return err;
@@ -1509,7 +1493,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .visibility = sve_id_visibility },
+	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, },
 	ID_UNALLOCATED(4,5),
 	ID_UNALLOCATED(4,6),
 	ID_UNALLOCATED(4,7),
-- 
2.28.0

