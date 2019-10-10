Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D42EDD2386
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388742AbfJJIn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388735AbfJJIn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:43:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F407E2054F;
        Thu, 10 Oct 2019 08:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697007;
        bh=wA4A798QDjor7GxSK3UoqTKS91AiqFsVdwyhDLrH9FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3cLRArXzKNKcyzJtu6/LdjRVD8Z+LQfwUDFuHqYo0g0/iAGNys0K4XQnMzmuUg2A
         6u5xBIFuMXr2l/WQHFg1h2gj/elbQze4tnbxxNVRoPVZQDltf9D4pYA6rLHX1vi4aw
         8edhchoXxqkeNrOsNMXf+GNKsRBAPYfh3U8P4nbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Santosh Sivaraj <santosh@fossix.org>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.3 079/148] libnvdimm/altmap: Track namespace boundaries in altmap
Date:   Thu, 10 Oct 2019 10:35:40 +0200
Message-Id: <20191010083616.122145556@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit cf387d9644d8c78721cf9b77af9f67bb5b04da16 upstream.

With PFN_MODE_PMEM namespace, the memmap area is allocated from the device
area. Some architectures map the memmap area with large page size. On
architectures like ppc64, 16MB page for memap mapping can map 262144 pfns.
This maps a namespace size of 16G.

When populating memmap region with 16MB page from the device area,
make sure the allocated space is not used to map resources outside this
namespace. Such usage of device area will prevent a namespace destroy.

Add resource end pnf in altmap and use that to check if the memmap area
allocation can map pfn outside the namespace. On ppc64 in such case we fallback
to allocation from memory.

This fix kernel crash reported below:

[  132.034989] WARNING: CPU: 13 PID: 13719 at mm/memremap.c:133 devm_memremap_pages_release+0x2d8/0x2e0
[  133.464754] BUG: Unable to handle kernel data access at 0xc00c00010b204000
[  133.464760] Faulting instruction address: 0xc00000000007580c
[  133.464766] Oops: Kernel access of bad area, sig: 11 [#1]
[  133.464771] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
.....
[  133.464901] NIP [c00000000007580c] vmemmap_free+0x2ac/0x3d0
[  133.464906] LR [c0000000000757f8] vmemmap_free+0x298/0x3d0
[  133.464910] Call Trace:
[  133.464914] [c000007cbfd0f7b0] [c0000000000757f8] vmemmap_free+0x298/0x3d0 (unreliable)
[  133.464921] [c000007cbfd0f8d0] [c000000000370a44] section_deactivate+0x1a4/0x240
[  133.464928] [c000007cbfd0f980] [c000000000386270] __remove_pages+0x3a0/0x590
[  133.464935] [c000007cbfd0fa50] [c000000000074158] arch_remove_memory+0x88/0x160
[  133.464942] [c000007cbfd0fae0] [c0000000003be8c0] devm_memremap_pages_release+0x150/0x2e0
[  133.464949] [c000007cbfd0fb70] [c000000000738ea0] devm_action_release+0x30/0x50
[  133.464955] [c000007cbfd0fb90] [c00000000073a5a4] release_nodes+0x344/0x400
[  133.464961] [c000007cbfd0fc40] [c00000000073378c] device_release_driver_internal+0x15c/0x250
[  133.464968] [c000007cbfd0fc80] [c00000000072fd14] unbind_store+0x104/0x110
[  133.464973] [c000007cbfd0fcd0] [c00000000072ee24] drv_attr_store+0x44/0x70
[  133.464981] [c000007cbfd0fcf0] [c0000000004a32bc] sysfs_kf_write+0x6c/0xa0
[  133.464987] [c000007cbfd0fd10] [c0000000004a1dfc] kernfs_fop_write+0x17c/0x250
[  133.464993] [c000007cbfd0fd60] [c0000000003c348c] __vfs_write+0x3c/0x70
[  133.464999] [c000007cbfd0fd80] [c0000000003c75d0] vfs_write+0xd0/0x250

djbw: Aneesh notes that this crash can likely be triggered in any kernel that
supports 'papr_scm', so flagging that commit for -stable consideration.

Fixes: b5beae5e224f ("powerpc/pseries: Add driver for PAPR SCM regions")
Cc: <stable@vger.kernel.org>
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Pankaj Gupta <pagupta@redhat.com>
Tested-by: Santosh Sivaraj <santosh@fossix.org>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Link: https://lore.kernel.org/r/20190910062826.10041-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/init_64.c |   17 ++++++++++++++++-
 drivers/nvdimm/pfn_devs.c |    2 ++
 include/linux/memremap.h  |    1 +
 3 files changed, 19 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -172,6 +172,21 @@ static __meminit void vmemmap_list_popul
 	vmemmap_list = vmem_back;
 }
 
+static bool altmap_cross_boundary(struct vmem_altmap *altmap, unsigned long start,
+				unsigned long page_size)
+{
+	unsigned long nr_pfn = page_size / sizeof(struct page);
+	unsigned long start_pfn = page_to_pfn((struct page *)start);
+
+	if ((start_pfn + nr_pfn) > altmap->end_pfn)
+		return true;
+
+	if (start_pfn < altmap->base_pfn)
+		return true;
+
+	return false;
+}
+
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
@@ -194,7 +209,7 @@ int __meminit vmemmap_populate(unsigned
 		 * fail due to alignment issues when using 16MB hugepages, so
 		 * fall back to system memory if the altmap allocation fail.
 		 */
-		if (altmap) {
+		if (altmap && !altmap_cross_boundary(altmap, start, page_size)) {
 			p = altmap_alloc_block_buf(page_size, altmap);
 			if (!p)
 				pr_debug("altmap block allocation failed, falling back to system memory");
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -618,9 +618,11 @@ static int __nvdimm_setup_pfn(struct nd_
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	resource_size_t base = nsio->res.start + start_pad;
+	resource_size_t end = nsio->res.end - end_trunc;
 	struct vmem_altmap __altmap = {
 		.base_pfn = init_altmap_base(base),
 		.reserve = init_altmap_reserve(base),
+		.end_pfn = PHYS_PFN(end),
 	};
 
 	memcpy(res, &nsio->res, sizeof(*res));
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -17,6 +17,7 @@ struct device;
  */
 struct vmem_altmap {
 	const unsigned long base_pfn;
+	const unsigned long end_pfn;
 	const unsigned long reserve;
 	unsigned long free;
 	unsigned long align;


