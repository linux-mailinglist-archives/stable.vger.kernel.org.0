Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9042A334C
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 19:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgKBSur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 13:50:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbgKBSur (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 13:50:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604343046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WarnExKV2VXUqG/qe/UCSIgZycztg/vXjgJOImCnVMw=;
        b=hFNTdO8nhAh3m8DHYphhLkPYkY4WoN8UkApsLl2P9Fnm5UGY7187QFhDWkQD8W5jpLfadY
        UoAvIFRetfSNjxLhf0jzWfES/WIGB8O8+mGK+6quYk+PinO8O/LcUISMGoTgnuJw3g0s9g
        9Pr+Mo7DpR4JDVNBLJRL8qG5AYv1oA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-3uBJKwGbNqurjoh4Nt5a7w-1; Mon, 02 Nov 2020 13:50:44 -0500
X-MC-Unique: 3uBJKwGbNqurjoh4Nt5a7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 105B31009E23;
        Mon,  2 Nov 2020 18:50:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 960E25C22A;
        Mon,  2 Nov 2020 18:50:41 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, Dave.Martin@arm.com, xu910121@sina.com,
        stable@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: arm64: Don't hide ID registers from userspace
Date:   Mon,  2 Nov 2020 19:50:35 +0100
Message-Id: <20201102185037.49248-2-drjones@redhat.com>
In-Reply-To: <20201102185037.49248-1-drjones@redhat.com>
References: <20201102185037.49248-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ID registers are RAZ until they've been allocated a purpose, but
that doesn't mean they should be removed from the KVM_GET_REG_LIST
list. So far we only have one register, SYS_ID_AA64ZFR0_EL1, that
is hidden from userspace when its function is not present. Removing
the userspace visibility checks is enough to reexpose it, as it
already behaves as RAZ when the function is not present.

Fixes: 73433762fcae ("KVM: arm64/sve: System register context switch and access support")
Cc: <stable@vger.kernel.org> # v5.2+
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

