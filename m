Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1501DDB5C
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgEUXyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:54:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:53225 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbgEUXyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:54:23 -0400
IronPort-SDR: 177wbTtqwiMn8sB+Xy3O05CmdLbeWfMlClGtChqA16bZtALbbxrFqy48k2szadl7AWWQb28RYP
 0d6J+xu0Kk/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:22 -0700
IronPort-SDR: ZqJXlm+G3u6fJYil8N129n5yuQzUGfBMLNNW0IWI7CjnLCnOZjqay9UvrpLZhv/gUCpLLM6/6i
 fv5Bb081zJYQ==
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="255450425"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:22 -0700
Subject: [5.4-stable PATCH 5/7] libnvdimm/namespace: Enforce
 memremap_compat_align()
From:   Dan Williams <dan.j.williams@intel.com>
To:     stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        vishal.l.verma@intel.com, hch@lst.de, linux-nvdimm@lists.01.org
Date:   Thu, 21 May 2020 16:38:10 -0700
Message-ID: <159010429083.1062454.2466252359997112899.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 6acd7d5ef264d8e9a8988cebf6eeb3567eaf60c6 upstream.

The pmem driver on PowerPC crashes with the following signature when
instantiating misaligned namespaces that map their capacity via
memremap_pages().

    BUG: Unable to handle kernel data access at 0xc001000406000000
    Faulting instruction address: 0xc000000000090790
    NIP [c000000000090790] arch_add_memory+0xc0/0x130
    LR [c000000000090744] arch_add_memory+0x74/0x130
    Call Trace:
     arch_add_memory+0x74/0x130 (unreliable)
     memremap_pages+0x74c/0xa30
     devm_memremap_pages+0x3c/0xa0
     pmem_attach_disk+0x188/0x770
     nvdimm_bus_probe+0xd8/0x470

With the assumption that only memremap_pages() has alignment
constraints, enforce memremap_compat_align() for
pmem_should_map_pages(), nd_pfn, and nd_dax cases. This includes
preventing the creation of namespaces where the base address is
misaligned and cases there infoblock padding parameters are invalid.

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Fixes: a3619190d62e ("libnvdimm/pfn: stop padding pmem namespaces to section alignment")
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   17 +++++++++++++++++
 drivers/nvdimm/pfn.h            |   12 ++++++++++++
 drivers/nvdimm/pfn_devs.c       |   32 +++++++++++++++++++++++++++++---
 3 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index cca0a3ba1d2c..b2db15250e0d 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -10,6 +10,7 @@
 #include <linux/nd.h>
 #include "nd-core.h"
 #include "pmem.h"
+#include "pfn.h"
 #include "nd.h"
 
 static void namespace_io_release(struct device *dev)
@@ -1735,6 +1736,22 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
 		return ERR_PTR(-ENODEV);
 	}
 
+	/*
+	 * Note, alignment validation for fsdax and devdax mode
+	 * namespaces happens in nd_pfn_validate() where infoblock
+	 * padding parameters can be applied.
+	 */
+	if (pmem_should_map_pages(dev)) {
+		struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+		struct resource *res = &nsio->res;
+
+		if (!IS_ALIGNED(res->start | (res->end + 1),
+					memremap_compat_align())) {
+			dev_err(&ndns->dev, "%pr misaligned, unable to map\n", res);
+			return ERR_PTR(-EOPNOTSUPP);
+		}
+	}
+
 	if (is_namespace_pmem(&ndns->dev)) {
 		struct nd_namespace_pmem *nspm;
 
diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
index acb19517f678..37cb1b8a2a39 100644
--- a/drivers/nvdimm/pfn.h
+++ b/drivers/nvdimm/pfn.h
@@ -24,6 +24,18 @@ struct nd_pfn_sb {
 	__le64 npfns;
 	__le32 mode;
 	/* minor-version-1 additions for section alignment */
+	/**
+	 * @start_pad: Deprecated attribute to pad start-misaligned namespaces
+	 *
+	 * start_pad is deprecated because the original definition did
+	 * not comprehend that dataoff is relative to the base address
+	 * of the namespace not the start_pad adjusted base. The result
+	 * is that the dax path is broken, but the block-I/O path is
+	 * not. The kernel will no longer create namespaces using start
+	 * padding, but it still supports block-I/O for legacy
+	 * configurations mainly to allow a backup, reconfigure the
+	 * namespace, and restore flow to repair dax operation.
+	 */
 	__le32 start_pad;
 	__le32 end_trunc;
 	/* minor-version-2 record the base alignment of the mapping */
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 6e5b042f453e..18a2602d93e7 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -445,6 +445,7 @@ static bool nd_supported_alignment(unsigned long align)
 int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
 	u64 checksum, offset;
+	struct resource *res;
 	enum nd_pfn_mode mode;
 	struct nd_namespace_io *nsio;
 	unsigned long align, start_pad;
@@ -577,13 +578,14 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	 * established.
 	 */
 	nsio = to_nd_namespace_io(&ndns->dev);
-	if (offset >= resource_size(&nsio->res)) {
+	res = &nsio->res;
+	if (offset >= resource_size(res)) {
 		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
 				dev_name(&ndns->dev));
 		return -EOPNOTSUPP;
 	}
 
-	if ((align && !IS_ALIGNED(nsio->res.start + offset + start_pad, align))
+	if ((align && !IS_ALIGNED(res->start + offset + start_pad, align))
 			|| !IS_ALIGNED(offset, PAGE_SIZE)) {
 		dev_err(&nd_pfn->dev,
 				"bad offset: %#llx dax disabled align: %#lx\n",
@@ -591,6 +593,18 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		return -EOPNOTSUPP;
 	}
 
+	if (!IS_ALIGNED(res->start + le32_to_cpu(pfn_sb->start_pad),
+				memremap_compat_align())) {
+		dev_err(&nd_pfn->dev, "resource start misaligned\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!IS_ALIGNED(res->end + 1 - le32_to_cpu(pfn_sb->end_trunc),
+				memremap_compat_align())) {
+		dev_err(&nd_pfn->dev, "resource end misaligned\n");
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(nd_pfn_validate);
@@ -754,7 +768,19 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	start = nsio->res.start;
 	size = resource_size(&nsio->res);
 	npfns = PHYS_PFN(size - SZ_8K);
-	align = max(nd_pfn->align, SUBSECTION_SIZE);
+	align = max(nd_pfn->align, memremap_compat_align());
+
+	/*
+	 * When @start is misaligned fail namespace creation. See
+	 * the 'struct nd_pfn_sb' commentary on why ->start_pad is not
+	 * an option.
+	 */
+	if (!IS_ALIGNED(start, memremap_compat_align())) {
+		dev_err(&nd_pfn->dev, "%s: start %pa misaligned to %#lx\n",
+				dev_name(&ndns->dev), &start,
+				memremap_compat_align());
+		return -EINVAL;
+	}
 	end_trunc = start + size - ALIGN_DOWN(start + size, align);
 	if (nd_pfn->mode == PFN_MODE_PMEM) {
 		/*

