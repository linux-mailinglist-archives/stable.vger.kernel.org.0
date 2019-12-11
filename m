Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985BE11ACAE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfLKOCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:02:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51793 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727554AbfLKOCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 09:02:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576072940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pAIQs/su1irMaYF7zW2o03DKf+s0tfEL66x4jFEX6MI=;
        b=GOxR2CmxXEO2egFoY8rWG5oyvw3qsCRwUoEhEfUZgECRx/SPEt3oB2bDTmouznwtcwPKMY
        rtWDSGOLLyjQKaec0U0HQeTr7jt57hPqeKQS9hNmJckrCcSp2xWKkz4ECOiIJMxrC5gWje
        d1lGLmgthpKaz1G4YjgLMzRprQ1r6dw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-A8B2s7oFMPaeC8TSDcsgJA-1; Wed, 11 Dec 2019 09:02:18 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 117B51005502;
        Wed, 11 Dec 2019 14:02:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.43.17.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CE7060BF1;
        Wed, 11 Dec 2019 14:02:02 +0000 (UTC)
From:   Denys Vlasenko <dvlasenk@redhat.com>
To:     rhkernel-list@redhat.com
Cc:     Denys Vlasenko <dvlasenk@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Radomir Vrbovsky <rvrbovsk@redhat.com>,
        "Monroy, Rodrigo Axel" <rodrigo.axel.monroy@intel.com>,
        "Orrala Contreras, Alfredo" <alfredo.orrala.contreras@intel.com>,
        stable@vger.kernel.org, Hang Yuan <hang.yuan@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [RHEL-7.4.z PATCH BZ1739309] drm/i915/gvt: Fix mmap range check
Date:   Wed, 11 Dec 2019 15:01:54 +0100
Message-Id: <20191211140154.13425-1-dvlasenk@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: A8B2s7oFMPaeC8TSDcsgJA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bugzilla: 1713567
Z-Bugzilla: 1739309
CVE: CVE-2019-11085
Build Info: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=3D2=
5302094

This is a backport of 7.6.z patch to 7.4.z - 7.4.z needs
intel_vgpu_in_aperture(), so add it.

7.6.z patch tested: Win10 VM with assigned Intel vGPU still works

This is to fix missed mmap range check on vGPU bar2 region
and only allow to map vGPU allocated GMADDR range, which means
user space should support sparse mmap to get proper offset for
mmap vGPU aperture. And this takes care of actual pgoff in mmap
request as original code always does from beginning of vGPU
aperture.

Fixes: 659643f7d814 ("drm/i915/gvt/kvmgt: add vfio/mdev support to KVMGT")
Cc: "Monroy, Rodrigo Axel" <rodrigo.axel.monroy@intel.com>
Cc: "Orrala Contreras, Alfredo" <alfredo.orrala.contreras@intel.com>
Cc: stable@vger.kernel.org # v4.10+
Reviewed-by: Hang Yuan <hang.yuan@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
(cherry picked from commit 51b00d8509dc69c98740da2ad07308b630d3eb7d)
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kv=
mgt.c
index e466259034e..d2696636f82 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -85,6 +85,12 @@ static inline bool handle_valid(unsigned long handle)
 =09return !!(handle & ~0xff);
 }
=20
+static inline bool intel_vgpu_in_aperture(struct intel_vgpu *vgpu, uint64_=
t off)
+{
+=09return off >=3D vgpu_aperture_offset(vgpu) &&
+=09       off < vgpu_aperture_offset(vgpu) + vgpu_aperture_sz(vgpu);
+}
+
 static int kvmgt_guest_init(struct mdev_device *mdev);
 static void intel_vgpu_release_work(struct work_struct *work);
 static bool kvmgt_guest_exit(struct kvmgt_guest_info *info);
@@ -803,7 +809,7 @@ static int intel_vgpu_mmap(struct mdev_device *mdev, st=
ruct vm_area_struct *vma)
 {
 =09unsigned int index;
 =09u64 virtaddr;
-=09unsigned long req_size, pgoff =3D 0;
+=09unsigned long req_size, pgoff, req_start;
 =09pgprot_t pg_prot;
 =09struct intel_vgpu *vgpu =3D mdev_get_drvdata(mdev);
=20
@@ -821,7 +827,17 @@ static int intel_vgpu_mmap(struct mdev_device *mdev, s=
truct vm_area_struct *vma)
 =09pg_prot =3D vma->vm_page_prot;
 =09virtaddr =3D vma->vm_start;
 =09req_size =3D vma->vm_end - vma->vm_start;
-=09pgoff =3D vgpu_aperture_pa_base(vgpu) >> PAGE_SHIFT;
+=09pgoff =3D vma->vm_pgoff &
+=09=09((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+=09req_start =3D pgoff << PAGE_SHIFT;
+
+=09if (!intel_vgpu_in_aperture(vgpu, req_start))
+=09=09return -EINVAL;
+=09if (req_start + req_size >
+=09    vgpu_aperture_offset(vgpu) + vgpu_aperture_sz(vgpu))
+=09=09return -EINVAL;
+
+=09pgoff =3D (gvt_aperture_pa_base(vgpu->gvt) >> PAGE_SHIFT) + pgoff;
=20
 =09return remap_pfn_range(vma, virtaddr, pgoff, req_size, pg_prot);
 }
--=20
2.21.0

