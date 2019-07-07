Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6163461419
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 07:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfGGFE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 01:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfGGFE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jul 2019 01:04:58 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C820208E4;
        Sun,  7 Jul 2019 05:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562475897;
        bh=ewI+O6KYRxJ1Pvy/q7+nzcFn06G9NUEqJIFJVkwN8vE=;
        h=Date:From:To:Subject:From;
        b=bXLfpQDi63HfdI7SXc49uX5hlQ3hA3kpTHtJOhMHYTCCQcSaMA0m5TS3JXT866mc8
         J+aLqlNrW6k2N7WCQfj3yrXkEo3GkPn9PyN55w9a6a8B1m3BfTEDH1R33EaZ1nCSOm
         KpivJFAxr0oGcnNvq3d8PvSW/+5n9lXrcYGyIQ3I=
Date:   Sat, 06 Jul 2019 22:04:55 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, corbet@lwn.net,
        dan.j.williams@intel.com, david@redhat.com, hch@lst.de,
        jane.chu@oracle.com, jgg@mellanox.com, jglisse@redhat.com,
        jmoyer@redhat.com, logang@deltatee.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, richardw.yang@linux.intel.com,
        rppt@linux.ibm.com, stable@vger.kernel.org, toshi.kani@hpe.com,
        vbabka@suse.cz
Subject:  +
 libnvdimm-pfn-fix-fsdax-mode-namespace-info-block-zero-fields.patch added
 to -mm tree
Message-ID: <20190707050455.upR_QpTYo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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
=46rom: Dan Williams <dan.j.williams@intel.com>
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
expected to benign since all other critical fields are explicitly
initialized.

Note The cc: stable is about spreading this new policy to as many kernels
as possible not fixing an issue in those kernels.  It is not until the
change titled "libnvdimm/pfn: Stop padding pmem namespaces to section
alignment" where this improper initialization becomes a problem.  So if
someone decides to backport "libnvdimm/pfn: Stop padding pmem namespaces
to section alignment" (which is not tagged for stable), make sure this
pre-requisite is flagged.

Link: http://lkml.kernel.org/r/156092356065.979959.6681003754765958296.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Fixes: 32ab0a3f5170 ("libnvdimm, pmem: 'struct page' for pmem")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>	[ppc64]
Cc: <stable@vger.kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/dax_devs.c |    2 +-
 drivers/nvdimm/pfn.h      |    1 +
 drivers/nvdimm/pfn_devs.c |   18 +++++++++++++++---
 3 files changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/nvdimm/dax_devs.c~libnvdimm-pfn-fix-fsdax-mode-namespace-info=
-block-zero-fields
+++ a/drivers/nvdimm/dax_devs.c
@@ -118,7 +118,7 @@ int nd_dax_probe(struct device *dev, str
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
@@ -412,6 +412,15 @@ static int nd_pfn_clear_memmap_errors(st
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
@@ -557,7 +566,7 @@ int nd_pfn_probe(struct device *dev, str
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!pfn_dev)
 		return -ENOMEM;
-	pfn_sb =3D devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	pfn_sb =3D devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn =3D to_nd_pfn(pfn_dev);
 	nd_pfn->pfn_sb =3D pfn_sb;
 	rc =3D nd_pfn_validate(nd_pfn, PFN_SIG);
@@ -693,7 +702,7 @@ static int nd_pfn_init(struct nd_pfn *nd
 	u64 checksum;
 	int rc;
=20
-	pfn_sb =3D devm_kzalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
+	pfn_sb =3D devm_kmalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
 	if (!pfn_sb)
 		return -ENOMEM;
=20
@@ -702,11 +711,14 @@ static int nd_pfn_init(struct nd_pfn *nd
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
@@ -759,7 +771,7 @@ static int nd_pfn_init(struct nd_pfn *nd
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
@@ -28,6 +28,7 @@ struct nd_pfn_sb {
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
mm-sparsemem-introduce-a-section_is_early-flag.patch
mm-sparsemem-add-helpers-track-active-portions-of-a-section-at-boot.patch
mm-hotplug-prepare-shrink_zone-pgdat_span-for-sub-section-removal.patch
mm-sparsemem-convert-kmalloc_section_memmap-to-populate_section_memmap.patch
mm-hotplug-kill-is_dev_zone-usage-in-__remove_pages.patch
mm-kill-is_dev_zone-helper.patch
mm-sparsemem-prepare-for-sub-section-ranges.patch
mm-sparsemem-support-sub-section-hotplug.patch
mm-document-zone_device-memory-model-implications.patch
mm-document-zone_device-memory-model-implications-fix.patch
mm-devm_memremap_pages-enable-sub-section-remap.patch
libnvdimm-pfn-fix-fsdax-mode-namespace-info-block-zero-fields.patch
libnvdimm-pfn-stop-padding-pmem-namespaces-to-section-alignment.patch
mm-sparsemem-cleanup-section-number-data-types.patch

