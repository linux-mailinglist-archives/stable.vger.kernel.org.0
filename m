Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B8A1758A2
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 11:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgCBKso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 05:48:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37515 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726874AbgCBKso (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 05:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583146123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LKsrmNzxqIzdyp2H8w3HthUMw0Kf4oXWhCVBR9yqA/w=;
        b=HqIfkHLK2Urw8TamWlekd7dFMMk4YhNxKo7IFZzEQPEfUUpjc9KOFApptM8uLC+Lqlrza8
        NuZ8wwWm/OmMMiTTMfQLi6E98b0YiTF2E4vR7BX4Yykmm4oINMc5RiOqJ1Q5LINCY5RQMQ
        UhOf7iFRgB1F29HVOHtqQtgTsghnQog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-AqM1G4mmMVmDG4hR-B1wxA-1; Mon, 02 Mar 2020 05:48:40 -0500
X-MC-Unique: AqM1G4mmMVmDG4hR-B1wxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E49AA1005513;
        Mon,  2 Mar 2020 10:48:38 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7A008D561;
        Mon,  2 Mar 2020 10:48:34 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        stable@vger.kernel.org, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2] KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset
Date:   Mon,  2 Mar 2020 11:48:30 +0100
Message-Id: <20200302104830.5593-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
Cc: <stable@vger.kernel.org> # 4.9 and 4.14 only

---

This is a backport of 3837407c1aa1 ("KVM: arm64: pmu: Don't
increment SW_INCR if PMCR.E is unset") which did not apply on
4.9-stable and 4.14-stable trees. Compared to the original patch
__vcpu_sys_reg() is replaced by vcpu_sys_reg().

v1 -> v2:
- this patch also is candidate for 4.9-stable
---
 virt/kvm/arm/pmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 69ccce308458..9a47b0cfb01d 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -299,6 +299,9 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu=
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

