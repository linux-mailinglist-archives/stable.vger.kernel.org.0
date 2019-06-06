Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1737337FF8
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 23:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbfFFVwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 17:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728735AbfFFVwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 17:52:51 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FC20212F5;
        Thu,  6 Jun 2019 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559857970;
        bh=B3Z2jZJAvgoEoGTv8WbWLB5Dx1yeyvhlhjv9Hh3NdD0=;
        h=Date:From:To:Subject:From;
        b=iHq+IUpvjXlMIW8TFOodfj79D9vRsIqUkG2IpwOeeX6eQBIEnLHVKgZZhVjW0QMGT
         0AnmDCVVwSJC0XYCn1WKgV6FfPDhQMpTAnHjwOel8oqR1DU7FS7mHVN+cCB/LHJZFw
         vOx+f0gT9fe1xZAoxHkXg36lQfgZ7+T7nNQHLhTc=
Date:   Thu, 06 Jun 2019 14:52:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, toshi.kani@hpe.com,
        stable@vger.kernel.org, rppt@linux.ibm.com, paulus@samba.org,
        pasha.tatashin@soleen.com, osalvador@suse.de, mpe@ellerman.id.au,
        mhocko@suse.com, logang@deltatee.com, jmoyer@redhat.com,
        jglisse@redhat.com, jane.chu@oracle.com, david@redhat.com,
        corbet@lwn.net, benh@kernel.crashing.org, dan.j.williams@intel.com
Subject:  +
 libnvdimm-pfn-fix-fsdax-mode-namespace-info-block-zero-fields.patch added to
 -mm tree
Message-ID: <20190606215249.5wayJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: libnvdimm/pfn: fix fsdax-mode namespace info-block zero-fields
has been added to the -mm tree.  Its filename is
     libnvdimm-pfn-fix-fsdax-mode-namespace-info-block-zero-fields.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/libnvdimm-pfn-fix-fsdax-mode-n=
amespace-info-block-zero-fields.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/libnvdimm-pfn-fix-fsdax-mode-n=
amespace-info-block-zero-fields.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: libnvdimm/pfn: fix fsdax-mode namespace info-block zero-fields

At namespace creation time there is the potential for the "expected to be
zero" fields of a 'pfn' info-block to be filled with indeterminate data.=20
While the kernel buffer is zeroed on allocation it is immediately
overwritten by nd_pfn_validate() filling it with the current contents of
the on-media info-block location.  For fields like, 'flags' and the
'padding' it potentially means that future implementations can not rely on
those fields being zero.

In preparation to stop using the 'start_pad' and 'end_trunc' fields for
section alignment, arrange for fields that are not explicitly initialized
to be guaranteed zero.  Bump the minor version to indicate it is safe to
assume the 'padding' and 'flags' are zero.  Otherwise, this corruption is
expected to be benign since all other critical fields are explicitly
initialized.

Link: http://lkml.kernel.org/r/155977193862.2443951.10284714500308539570.st=
git@dwillia2-desk3.amr.corp.intel.com
Fixes: 32ab0a3f5170 ("libnvdimm, pmem: 'struct page' for pmem")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/dax_devs.c |    2 +-
 drivers/nvdimm/pfn.h      |    1 +
 drivers/nvdimm/pfn_devs.c |   18 +++++++++++++++---
 3 files changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/nvdimm/dax_devs.c~libnvdimm-pfn-fix-fsdax-mode-namespace-info=
-block-zero-fields
+++ a/drivers/nvdimm/dax_devs.c
@@ -126,7 +126,7 @@ int nd_dax_probe(struct device *dev, str
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!dax_dev)
 		return -ENOMEM;
-	pfn_sb =3D devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	pfn_sb =3D devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn->pfn_sb =3D pfn_sb;
 	rc =3D nd_pfn_validate(nd_pfn, DAX_SIG);
 	dev_dbg(dev, "dax: %s\n", rc =3D=3D 0 ? dev_name(dax_dev) : "<none>");
--- a/drivers/nvdimm/pfn_devs.c~libnvdimm-pfn-fix-fsdax-mode-namespace-info=
-block-zero-fields
+++ a/drivers/nvdimm/pfn_devs.c
@@ -420,6 +420,15 @@ static int nd_pfn_clear_memmap_errors(st
 	return 0;
 }
=20
+/**
+ * nd_pfn_validate - read and validate info-block
+ * @nd_pfn: fsdax namespace runtime state / properties
+ * @sig: 'devdax' or 'fsdax' signature
+ *
+ * Upon return the info-block buffer contents (->pfn_sb) are
+ * indeterminate when validation fails, and a coherent info-block
+ * otherwise.
+ */
 int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
 	u64 checksum, offset;
@@ -565,7 +574,7 @@ int nd_pfn_probe(struct device *dev, str
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!pfn_dev)
 		return -ENOMEM;
-	pfn_sb =3D devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	pfn_sb =3D devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn =3D to_nd_pfn(pfn_dev);
 	nd_pfn->pfn_sb =3D pfn_sb;
 	rc =3D nd_pfn_validate(nd_pfn, PFN_SIG);
@@ -702,7 +711,7 @@ static int nd_pfn_init(struct nd_pfn *nd
 	u64 checksum;
 	int rc;
=20
-	pfn_sb =3D devm_kzalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
+	pfn_sb =3D devm_kmalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
 	if (!pfn_sb)
 		return -ENOMEM;
=20
@@ -711,11 +720,14 @@ static int nd_pfn_init(struct nd_pfn *nd
 		sig =3D DAX_SIG;
 	else
 		sig =3D PFN_SIG;
+
 	rc =3D nd_pfn_validate(nd_pfn, sig);
 	if (rc !=3D -ENODEV)
 		return rc;
=20
 	/* no info block, do init */;
+	memset(pfn_sb, 0, sizeof(*pfn_sb));
+
 	nd_region =3D to_nd_region(nd_pfn->dev.parent);
 	if (nd_region->ro) {
 		dev_info(&nd_pfn->dev,
@@ -768,7 +780,7 @@ static int nd_pfn_init(struct nd_pfn *nd
 	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
 	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major =3D cpu_to_le16(1);
-	pfn_sb->version_minor =3D cpu_to_le16(2);
+	pfn_sb->version_minor =3D cpu_to_le16(3);
 	pfn_sb->start_pad =3D cpu_to_le32(start_pad);
 	pfn_sb->end_trunc =3D cpu_to_le32(end_trunc);
 	pfn_sb->align =3D cpu_to_le32(nd_pfn->align);
--- a/drivers/nvdimm/pfn.h~libnvdimm-pfn-fix-fsdax-mode-namespace-info-bloc=
k-zero-fields
+++ a/drivers/nvdimm/pfn.h
@@ -36,6 +36,7 @@ struct nd_pfn_sb {
 	__le32 end_trunc;
 	/* minor-version-2 record the base alignment of the mapping */
 	__le32 align;
+	/* minor-version-3 guarantee the padding and flags are zero */
 	u8 padding[4000];
 	__le64 checksum;
 };
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-sparsemem-introduce-struct-mem_section_usage.patch
mm-sparsemem-add-helpers-track-active-portions-of-a-section-at-boot.patch
mm-hotplug-prepare-shrink_zone-pgdat_span-for-sub-section-removal.patch
mm-sparsemem-convert-kmalloc_section_memmap-to-populate_section_memmap.patch
mm-hotplug-kill-is_dev_zone-usage-in-__remove_pages.patch
mm-kill-is_dev_zone-helper.patch
mm-sparsemem-prepare-for-sub-section-ranges.patch
mm-sparsemem-support-sub-section-hotplug.patch
mm-document-zone_device-memory-model-implications.patch
mm-devm_memremap_pages-enable-sub-section-remap.patch
libnvdimm-pfn-fix-fsdax-mode-namespace-info-block-zero-fields.patch
libnvdimm-pfn-stop-padding-pmem-namespaces-to-section-alignment.patch
drivers-base-devres-introduce-devm_release_action.patch
mm-devm_memremap_pages-introduce-devm_memunmap_pages.patch
pci-p2pdma-fix-the-gen_pool_add_virt-failure-path.patch
lib-genalloc-introduce-chunk-owners.patch
pci-p2pdma-track-pgmap-references-per-resource-not-globally.patch
mm-devm_memremap_pages-fix-final-page-put-race.patch

