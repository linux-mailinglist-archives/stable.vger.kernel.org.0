Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5EF2B698A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 17:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgKQQL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 11:11:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgKQQL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 11:11:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7F62168B;
        Tue, 17 Nov 2020 16:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605629487;
        bh=2J3aQk2RMCcV/YNBP2sRQqNYi+R+20F8reknkyJhP6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wu5/ZNwD6M7LNZxTe4UWWucvf7mY9oEMbe9UPHLfqGTOuOGWZJ1TzNfAUy1ESQAdM
         fut6Xr/lJbkPHY2KJr6KvxeQ2BEWoRRjjn4ZGZU0gYg7xGP3uySTRQXAMNcTGpM335
         i/rLrkAMaOll1zxL951DVYgOrEBMmXboxV50EH/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E5=BC=A0=E4=B8=9C=E6=97=AD?= <xu910121@sina.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 112/151] KVM: arm64: Dont hide ID registers from userspace
Date:   Tue, 17 Nov 2020 14:05:42 +0100
Message-Id: <20201117122126.880479175@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

commit f81cb2c3ad41ac6d8cb2650e3d72d5f67db1aa28 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/sys_regs.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1132,16 +1132,6 @@ static unsigned int sve_visibility(const
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
@@ -1168,9 +1158,6 @@ static int get_id_aa64zfr0_el1(struct kv
 {
 	u64 val;
 
-	if (WARN_ON(!vcpu_has_sve(vcpu)))
-		return -ENOENT;
-
 	val = guest_id_aa64zfr0_el1(vcpu);
 	return reg_to_user(uaddr, &val, reg->id);
 }
@@ -1183,9 +1170,6 @@ static int set_id_aa64zfr0_el1(struct kv
 	int err;
 	u64 val;
 
-	if (WARN_ON(!vcpu_has_sve(vcpu)))
-		return -ENOENT;
-
 	err = reg_from_user(&val, uaddr, id);
 	if (err)
 		return err;
@@ -1448,7 +1432,7 @@ static const struct sys_reg_desc sys_reg
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .visibility = sve_id_visibility },
+	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, },
 	ID_UNALLOCATED(4,5),
 	ID_UNALLOCATED(4,6),
 	ID_UNALLOCATED(4,7),


