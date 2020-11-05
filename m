Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879BB2A7A1D
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 10:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgKEJKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 04:10:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730648AbgKEJKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 04:10:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604567433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gBUo5HypwA4PuYQyt1U4d6R+DIGqPE+gmLZ1KTreC+w=;
        b=SjeCKOVuYEdTdQlOggwk/B/pbArEeoaO3Q9EPM5Smnly2g6U8X2m9Xtjtlw3CV8i0ItJ06
        pKJ+5o5BLxuGSPLtXwbc6OiwJRq8CcYKghM5G48oOw3RtVQLe+ndF5LWL1ZnW0EV3bzWkQ
        leFgYZmihJxEpKmpB4yCoOEIiUHi18g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-8fIEmcnxMFqCLCKXmevYTw-1; Thu, 05 Nov 2020 04:10:29 -0500
X-MC-Unique: 8fIEmcnxMFqCLCKXmevYTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 387B610866D4;
        Thu,  5 Nov 2020 09:10:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A75F60C17;
        Thu,  5 Nov 2020 09:10:26 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, xu910121@sina.com, Dave.Martin@arm.com,
        stable@vger.kernel.org
Subject: [PATCH v3 1/4] KVM: arm64: Don't hide ID registers from userspace
Date:   Thu,  5 Nov 2020 10:10:19 +0100
Message-Id: <20201105091022.15373-2-drjones@redhat.com>
In-Reply-To: <20201105091022.15373-1-drjones@redhat.com>
References: <20201105091022.15373-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org#v5.2+
Reported-by: 张东旭 <xu910121@sina.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fb12d3ef423a..6ff0c15531ca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1195,16 +1195,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
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
@@ -1231,9 +1221,6 @@ static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u64 val;
 
-	if (WARN_ON(!vcpu_has_sve(vcpu)))
-		return -ENOENT;
-
 	val = guest_id_aa64zfr0_el1(vcpu);
 	return reg_to_user(uaddr, &val, reg->id);
 }
@@ -1246,9 +1233,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 	int err;
 	u64 val;
 
-	if (WARN_ON(!vcpu_has_sve(vcpu)))
-		return -ENOENT;
-
 	err = reg_from_user(&val, uaddr, id);
 	if (err)
 		return err;
@@ -1518,7 +1502,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .visibility = sve_id_visibility },
+	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, },
 	ID_UNALLOCATED(4,5),
 	ID_UNALLOCATED(4,6),
 	ID_UNALLOCATED(4,7),
-- 
2.26.2

