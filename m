Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1EB13C7DD
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgAOPeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:34:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35885 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729011AbgAOPeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:34:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6teOtbquXm59JdJEc1P6I3LcG8zTWm5GuYDX9NVmUbc=;
        b=SKsJcgcg4JhLhlcQvZVLdeNXxjra2JaMrApa9h8UWJDa34EvYKM9a3P9NbcOcbwPEPjJz1
        KXlzrG2P2G99vn0UL+/+JG7cvV4f9J1BRpdbbHfvteNccYl/nHdyNg/ppBvlZtkntGWBQu
        2CryrNq6fxwRw3GFEQLT/HUBpXwlDr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-Kd3EKNLtNba2gDXN-_fF6Q-1; Wed, 15 Jan 2020 10:34:18 -0500
X-MC-Unique: Kd3EKNLtNba2gDXN-_fF6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0A388C4365;
        Wed, 15 Jan 2020 15:34:16 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FA5586CB2;
        Wed, 15 Jan 2020 15:34:14 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable 12/25] powerpc/mm: move warning from resize_hpt_for_hotplug()
Date:   Wed, 15 Jan 2020 16:33:26 +0100
Message-Id: <20200115153339.36409-13-david@redhat.com>
In-Reply-To: <20200115153339.36409-1-david@redhat.com>
References: <20200115153339.36409-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f172acbfae1a78b1a3c775f78e8d0dcd15b9d768 upstream.

resize_hpt_for_hotplug() reports a warning when it cannot
resize the hash page table ("Unable to resize hash page
table to target order") but in some cases it's not a problem
and can make user thinks something has not worked properly.

This patch moves the warning to arch_remove_memory() to
only report the problem when it is needed.

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/include/asm/sparsemem.h  |  4 ++--
 arch/powerpc/mm/hash_utils_64.c       | 19 +++++++------------
 arch/powerpc/mm/mem.c                 |  3 ++-
 arch/powerpc/platforms/pseries/lpar.c |  3 ++-
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/sparsemem.h b/arch/powerpc/include/=
asm/sparsemem.h
index 28f5dae25db6..b37c802d669c 100644
--- a/arch/powerpc/include/asm/sparsemem.h
+++ b/arch/powerpc/include/asm/sparsemem.h
@@ -28,9 +28,9 @@ extern int create_section_mapping(unsigned long start, =
unsigned long end, int ni
 extern int remove_section_mapping(unsigned long start, unsigned long end=
);
=20
 #ifdef CONFIG_PPC_BOOK3S_64
-extern void resize_hpt_for_hotplug(unsigned long new_mem_size);
+extern int resize_hpt_for_hotplug(unsigned long new_mem_size);
 #else
-static inline void resize_hpt_for_hotplug(unsigned long new_mem_size) { =
}
+static inline int resize_hpt_for_hotplug(unsigned long new_mem_size) { r=
eturn 0; }
 #endif
=20
 #ifdef CONFIG_NUMA
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils=
_64.c
index 8894c8f300ea..a5ce7082cb5f 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -764,12 +764,12 @@ static unsigned long __init htab_get_table_size(voi=
d)
 }
=20
 #ifdef CONFIG_MEMORY_HOTPLUG
-void resize_hpt_for_hotplug(unsigned long new_mem_size)
+int resize_hpt_for_hotplug(unsigned long new_mem_size)
 {
 	unsigned target_hpt_shift;
=20
 	if (!mmu_hash_ops.resize_hpt)
-		return;
+		return 0;
=20
 	target_hpt_shift =3D htab_shift_for_mem_size(new_mem_size);
=20
@@ -781,16 +781,11 @@ void resize_hpt_for_hotplug(unsigned long new_mem_s=
ize)
 	 * reduce unless the target shift is at least 2 below the
 	 * current shift
 	 */
-	if ((target_hpt_shift > ppc64_pft_size)
-	    || (target_hpt_shift < (ppc64_pft_size - 1))) {
-		int rc;
-
-		rc =3D mmu_hash_ops.resize_hpt(target_hpt_shift);
-		if (rc && (rc !=3D -ENODEV))
-			printk(KERN_WARNING
-			       "Unable to resize hash page table to target order %d: %d\n",
-			       target_hpt_shift, rc);
-	}
+	if (target_hpt_shift > ppc64_pft_size ||
+	    target_hpt_shift < ppc64_pft_size - 1)
+		return mmu_hash_ops.resize_hpt(target_hpt_shift);
+
+	return 0;
 }
=20
 int hash__create_section_mapping(unsigned long start, unsigned long end,=
 int nid)
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 625d78547fe7..e27e5bc958b4 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -170,7 +170,8 @@ int __ref arch_remove_memory(int nid, u64 start, u64 =
size,
 	 */
 	vm_unmap_aliases();
=20
-	resize_hpt_for_hotplug(memblock_phys_mem_size());
+	if (resize_hpt_for_hotplug(memblock_phys_mem_size()) =3D=3D -ENOSPC)
+		pr_warn("Hash collision while resizing HPT\n");
=20
 	return ret;
 }
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platfor=
ms/pseries/lpar.c
index 49e3a88b6a0c..51f0107950b3 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -693,8 +693,10 @@ static int pseries_lpar_resize_hpt(unsigned long shi=
ft)
 		break;
=20
 	case H_PARAMETER:
+		pr_warn("Invalid argument from H_RESIZE_HPT_PREPARE\n");
 		return -EINVAL;
 	case H_RESOURCE:
+		pr_warn("Operation not permitted from H_RESIZE_HPT_PREPARE\n");
 		return -EPERM;
 	default:
 		pr_warn("Unexpected error %d from H_RESIZE_HPT_PREPARE\n", rc);
@@ -711,7 +713,6 @@ static int pseries_lpar_resize_hpt(unsigned long shif=
t)
 	if (rc !=3D 0) {
 		switch (state.commit_rc) {
 		case H_PTEG_FULL:
-			pr_warn("Hash collision while resizing HPT\n");
 			return -ENOSPC;
=20
 		default:
--=20
2.24.1

