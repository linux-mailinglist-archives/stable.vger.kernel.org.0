Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623D27F21B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404226AbfHBJpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405382AbfHBJpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:45:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0613F20679;
        Fri,  2 Aug 2019 09:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739108;
        bh=NM9zABleW9StZIplu4nj7djsdSzyIEkNozYMoBSBTMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpPJcGD0s36foGDsDzu+7XfDZAQSkW7FkH4CD/fHfuUMqQvUJoHm9KLsemi9A9Hf7
         6wAk65A9Vi6gzeeMHZ4w/vvE25j0U79s1tgrs1J/95K4TVyyeLYnI06OXTMwKE53vw
         qXrs+Auj5MNPLlmDQ1S2eFsI0qwQiGdz3MQMHG+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Jane Chu <jane.chu@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Logan Gunthorpe <logang@deltatee.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Toshi Kani <toshi.kani@hpe.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richardw.yang@linux.intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH 4.9 102/223] libnvdimm/pfn: fix fsdax-mode namespace info-block zero-fields
Date:   Fri,  2 Aug 2019 11:35:27 +0200
Message-Id: <20190802092245.820051507@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 7e3e888dfc138089f4c15a81b418e88f0978f744 upstream.

At namespace creation time there is the potential for the "expected to
be zero" fields of a 'pfn' info-block to be filled with indeterminate
data.  While the kernel buffer is zeroed on allocation it is immediately
overwritten by nd_pfn_validate() filling it with the current contents of
the on-media info-block location.  For fields like, 'flags' and the
'padding' it potentially means that future implementations can not rely on
those fields being zero.

In preparation to stop using the 'start_pad' and 'end_trunc' fields for
section alignment, arrange for fields that are not explicitly
initialized to be guaranteed zero.  Bump the minor version to indicate
it is safe to assume the 'padding' and 'flags' are zero.  Otherwise,
this corruption is expected to benign since all other critical fields
are explicitly initialized.

Note The cc: stable is about spreading this new policy to as many
kernels as possible not fixing an issue in those kernels.  It is not
until the change titled "libnvdimm/pfn: Stop padding pmem namespaces to
section alignment" where this improper initialization becomes a problem.
So if someone decides to backport "libnvdimm/pfn: Stop padding pmem
namespaces to section alignment" (which is not tagged for stable), make
sure this pre-requisite is flagged.

Link: http://lkml.kernel.org/r/156092356065.979959.6681003754765958296.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: 32ab0a3f5170 ("libnvdimm, pmem: 'struct page' for pmem")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>	[ppc64]
Cc: <stable@vger.kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvdimm/dax_devs.c |    2 +-
 drivers/nvdimm/pfn.h      |    1 +
 drivers/nvdimm/pfn_devs.c |   18 +++++++++++++++---
 3 files changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -118,7 +118,7 @@ int nd_dax_probe(struct device *dev, str
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!dax_dev)
 		return -ENOMEM;
-	pfn_sb = devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
 	dev_dbg(dev, "%s: dax: %s\n", __func__,
--- a/drivers/nvdimm/pfn.h
+++ b/drivers/nvdimm/pfn.h
@@ -36,6 +36,7 @@ struct nd_pfn_sb {
 	__le32 end_trunc;
 	/* minor-version-2 record the base alignment of the mapping */
 	__le32 align;
+	/* minor-version-3 guarantee the padding and flags are zero */
 	u8 padding[4000];
 	__le64 checksum;
 };
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -349,6 +349,15 @@ struct device *nd_pfn_create(struct nd_r
 	return dev;
 }
 
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
@@ -486,7 +495,7 @@ int nd_pfn_probe(struct device *dev, str
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!pfn_dev)
 		return -ENOMEM;
-	pfn_sb = devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn = to_nd_pfn(pfn_dev);
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn, PFN_SIG);
@@ -584,7 +593,7 @@ static int nd_pfn_init(struct nd_pfn *nd
 	u64 checksum;
 	int rc;
 
-	pfn_sb = devm_kzalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
+	pfn_sb = devm_kmalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
 	if (!pfn_sb)
 		return -ENOMEM;
 
@@ -593,11 +602,14 @@ static int nd_pfn_init(struct nd_pfn *nd
 		sig = DAX_SIG;
 	else
 		sig = PFN_SIG;
+
 	rc = nd_pfn_validate(nd_pfn, sig);
 	if (rc != -ENODEV)
 		return rc;
 
 	/* no info block, do init */;
+	memset(pfn_sb, 0, sizeof(*pfn_sb));
+
 	nd_region = to_nd_region(nd_pfn->dev.parent);
 	if (nd_region->ro) {
 		dev_info(&nd_pfn->dev,
@@ -673,7 +685,7 @@ static int nd_pfn_init(struct nd_pfn *nd
 	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
 	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major = cpu_to_le16(1);
-	pfn_sb->version_minor = cpu_to_le16(2);
+	pfn_sb->version_minor = cpu_to_le16(3);
 	pfn_sb->start_pad = cpu_to_le32(start_pad);
 	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
 	pfn_sb->align = cpu_to_le32(nd_pfn->align);


