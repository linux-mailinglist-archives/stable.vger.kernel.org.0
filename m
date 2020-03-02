Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C483E1756D1
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 10:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgCBJUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 04:20:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51915 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726390AbgCBJUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 04:20:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583140844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZJFxdajhUjFzdrLxSpnS9/s8iz/FeaFiOGrLtEOmsgI=;
        b=HzF60C8cZ1b1DCgxmiX1JpNKyBE+2YiJB0RYNhZrX3zadT9do/D8L0e6jd1tmplaulGHIX
        /CsU5pbNLinMmSojg3tBUmgJC+mM9Jyzo5PoD4DvIlY5AQeHtTbXVZqichWxA3rt4ixks0
        iIfE2N1R+Bh5qGJeDmLZ+vi9QyLns/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-mnSEhPCwNjSTOH0xBNql0Q-1; Mon, 02 Mar 2020 04:20:40 -0500
X-MC-Unique: mnSEhPCwNjSTOH0xBNql0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59FED189F760;
        Mon,  2 Mar 2020 09:20:39 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EAE860BF3;
        Mon,  2 Mar 2020 09:20:34 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        stable@vger.kernel.org, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset
Date:   Mon,  2 Mar 2020 10:20:25 +0100
Message-Id: <20200302092025.22321-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3837407c1aa1 upstream.

The specification says PMSWINC increments PMEVCNTR<n>_EL1 by 1
if PMEVCNTR<n>_EL0 is enabled and configured to count SW_INCR.

For PMEVCNTR<n>_EL0 to be enabled, we need both PMCNTENSET to
be set for the corresponding event counter but we also need
the PMCR.E bit to be set.

Fixes: 7a0adc7064b8 ("arm64: KVM: Add access handler for PMSWINC register=
")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Cc: <stable@vger.kernel.org> # 4.14 only

---

This is a backport of 3837407c1aa1 ("KVM: arm64: pmu: Don't
increment SW_INCR if PMCR.E is unset") which did not apply on
4.14-stable. Compared to the original patch
__vcpu_sys_reg() is replaced by vcpu_sys_reg().
---
 virt/kvm/arm/pmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 8a9c42366db7..3998add436da 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -316,6 +316,9 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu=
, u64 val)
 	if (val =3D=3D 0)
 		return;
=20
+	if (!(vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
+		return;
+
 	enable =3D vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	for (i =3D 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
 		if (!(val & BIT(i)))
--=20
2.20.1

