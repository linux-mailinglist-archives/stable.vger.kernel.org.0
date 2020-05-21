Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C691DDB60
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgEUXye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:54:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:44942 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbgEUXye (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:54:34 -0400
IronPort-SDR: 1r6g6CflE8l2remSlFHFlZCaP6sDXUDhmmg5WWFBGq4JyQP3zygtPGa9B/ebKRkIyiETOxd8dc
 2r5w/XGDXaKQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:33 -0700
IronPort-SDR: 5Ud6ZE47rEf3Iem7nxhueUy8uYmGlg1u2XprUu6TAS1G9rG1iDz8ZnjrkasDd1n+jkjnSYCrcG
 yC5W/cJPcAQA==
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="412582849"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:33 -0700
Subject: [5.4-stable PATCH 7/7] libnvdimm/region: Introduce an 'align'
 attribute
From:   Dan Williams <dan.j.williams@intel.com>
To:     stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>, vishal.l.verma@intel.com,
        hch@lst.de, linux-nvdimm@lists.01.org
Date:   Thu, 21 May 2020 16:38:22 -0700
Message-ID: <159010430200.1062454.8543650231999164978.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Commit 2522afb86a8cceba0f67dbf05772d21b76d79f06 upstream.

The align attribute applies an alignment constraint for namespace
creation in a region. Whereas the 'align' attribute of a namespace
applied alignment padding via an info block, the 'align' attribute
applies alignment constraints to the free space allocation.

The default for 'align' is the maximum known memremap_compat_align()
across all archs (16MiB from PowerPC at time of writing) multiplied by
the number of interleave ways if there is blk-aliasing. The minimum is
PAGE_SIZE and allows for the creation of cross-arch incompatible
namespaces, just as previous kernels allowed, but the expectation is
cross-arch and mode-independent compatibility by default.

The regression risk with this change is limited to cases that were
dependent on the ability to create unaligned namespaces, *and* for some
reason are unable to opt-out of aligned namespaces by writing to
'regionX/align'. If such a scenario arises the default can be flipped
from opt-out to opt-in of compat-aligned namespace creation, but that is
a last resort. The kernel will otherwise continue to support existing
defined misaligned namespaces.

Unfortunately this change needs to touch several parts of the
implementation at once:

- region/available_size: expand busy extents to current align
- region/max_available_extent: expand busy extents to current align
- namespace/size: trim free space to current align

...to keep the free space accounting conforming to the dynamic align
setting.

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Link: https://lore.kernel.org/r/158041478371.3889308.14542630147672668068.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c      |   86 +++++++++++++++++++++++-----
 drivers/nvdimm/namespace_devs.c |    9 ++-
 drivers/nvdimm/nd.h             |    1 
 drivers/nvdimm/region_devs.c    |  120 ++++++++++++++++++++++++++++++++++++---
 4 files changed, 190 insertions(+), 26 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index def5c2846bea..8c773fb60296 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -557,6 +557,21 @@ int nvdimm_security_freeze(struct nvdimm *nvdimm)
 	return rc;
 }
 
+static unsigned long dpa_align(struct nd_region *nd_region)
+{
+	struct device *dev = &nd_region->dev;
+
+	if (dev_WARN_ONCE(dev, !is_nvdimm_bus_locked(dev),
+				"bus lock required for capacity provision\n"))
+		return 0;
+	if (dev_WARN_ONCE(dev, !nd_region->ndr_mappings || nd_region->align
+				% nd_region->ndr_mappings,
+				"invalid region align %#lx mappings: %d\n",
+				nd_region->align, nd_region->ndr_mappings))
+		return 0;
+	return nd_region->align / nd_region->ndr_mappings;
+}
+
 int alias_dpa_busy(struct device *dev, void *data)
 {
 	resource_size_t map_end, blk_start, new;
@@ -565,6 +580,7 @@ int alias_dpa_busy(struct device *dev, void *data)
 	struct nd_region *nd_region;
 	struct nvdimm_drvdata *ndd;
 	struct resource *res;
+	unsigned long align;
 	int i;
 
 	if (!is_memory(dev))
@@ -602,13 +618,21 @@ int alias_dpa_busy(struct device *dev, void *data)
 	 * Find the free dpa from the end of the last pmem allocation to
 	 * the end of the interleave-set mapping.
 	 */
+	align = dpa_align(nd_region);
+	if (!align)
+		return 0;
+
 	for_each_dpa_resource(ndd, res) {
+		resource_size_t start, end;
+
 		if (strncmp(res->name, "pmem", 4) != 0)
 			continue;
-		if ((res->start >= blk_start && res->start < map_end)
-				|| (res->end >= blk_start
-					&& res->end <= map_end)) {
-			new = max(blk_start, min(map_end + 1, res->end + 1));
+
+		start = ALIGN_DOWN(res->start, align);
+		end = ALIGN(res->end + 1, align) - 1;
+		if ((start >= blk_start && start < map_end)
+				|| (end >= blk_start && end <= map_end)) {
+			new = max(blk_start, min(map_end, end) + 1);
 			if (new != blk_start) {
 				blk_start = new;
 				goto retry;
@@ -648,6 +672,7 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
 		.res = NULL,
 	};
 	struct resource *res;
+	unsigned long align;
 
 	if (!ndd)
 		return 0;
@@ -655,10 +680,20 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
 	device_for_each_child(&nvdimm_bus->dev, &info, alias_dpa_busy);
 
 	/* now account for busy blk allocations in unaliased dpa */
+	align = dpa_align(nd_region);
+	if (!align)
+		return 0;
 	for_each_dpa_resource(ndd, res) {
+		resource_size_t start, end, size;
+
 		if (strncmp(res->name, "blk", 3) != 0)
 			continue;
-		info.available -= resource_size(res);
+		start = ALIGN_DOWN(res->start, align);
+		end = ALIGN(res->end + 1, align) - 1;
+		size = end - start + 1;
+		if (size >= info.available)
+			return 0;
+		info.available -= size;
 	}
 
 	return info.available;
@@ -677,19 +712,31 @@ resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
 	struct nvdimm_bus *nvdimm_bus;
 	resource_size_t max = 0;
 	struct resource *res;
+	unsigned long align;
 
 	/* if a dimm is disabled the available capacity is zero */
 	if (!ndd)
 		return 0;
 
+	align = dpa_align(nd_region);
+	if (!align)
+		return 0;
+
 	nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
 	if (__reserve_free_pmem(&nd_region->dev, nd_mapping->nvdimm))
 		return 0;
 	for_each_dpa_resource(ndd, res) {
+		resource_size_t start, end;
+
 		if (strcmp(res->name, "pmem-reserve") != 0)
 			continue;
-		if (resource_size(res) > max)
-			max = resource_size(res);
+		/* trim free space relative to current alignment setting */
+		start = ALIGN(res->start, align);
+		end = ALIGN_DOWN(res->end + 1, align) - 1;
+		if (end < start)
+			continue;
+		if (end - start + 1 > max)
+			max = end - start + 1;
 	}
 	release_free_pmem(nvdimm_bus, nd_mapping);
 	return max;
@@ -717,24 +764,33 @@ resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct resource *res;
 	const char *reason;
+	unsigned long align;
 
 	if (!ndd)
 		return 0;
 
+	align = dpa_align(nd_region);
+	if (!align)
+		return 0;
+
 	map_start = nd_mapping->start;
 	map_end = map_start + nd_mapping->size - 1;
 	blk_start = max(map_start, map_end + 1 - *overlap);
 	for_each_dpa_resource(ndd, res) {
-		if (res->start >= map_start && res->start < map_end) {
+		resource_size_t start, end;
+
+		start = ALIGN_DOWN(res->start, align);
+		end = ALIGN(res->end + 1, align) - 1;
+		if (start >= map_start && start < map_end) {
 			if (strncmp(res->name, "blk", 3) == 0)
 				blk_start = min(blk_start,
-						max(map_start, res->start));
-			else if (res->end > map_end) {
+						max(map_start, start));
+			else if (end > map_end) {
 				reason = "misaligned to iset";
 				goto err;
 			} else
-				busy += resource_size(res);
-		} else if (res->end >= map_start && res->end <= map_end) {
+				busy += end - start + 1;
+		} else if (end >= map_start && end <= map_end) {
 			if (strncmp(res->name, "blk", 3) == 0) {
 				/*
 				 * If a BLK allocation overlaps the start of
@@ -743,8 +799,8 @@ resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 				 */
 				blk_start = map_start;
 			} else
-				busy += resource_size(res);
-		} else if (map_start > res->start && map_start < res->end) {
+				busy += end - start + 1;
+		} else if (map_start > start && map_start < end) {
 			/* total eclipse of the mapping */
 			busy += nd_mapping->size;
 			blk_start = map_start;
@@ -754,7 +810,7 @@ resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 	*overlap = map_end + 1 - blk_start;
 	available = blk_start - map_start;
 	if (busy < available)
-		return available - busy;
+		return ALIGN_DOWN(available - busy, align);
 	return 0;
 
  err:
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 8cf1c8932a3b..e80de9b9ccce 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -568,6 +568,11 @@ static void space_valid(struct nd_region *nd_region, struct nvdimm_drvdata *ndd,
 {
 	bool is_reserve = strcmp(label_id->id, "pmem-reserve") == 0;
 	bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
+	unsigned long align;
+
+	align = nd_region->align / nd_region->ndr_mappings;
+	valid->start = ALIGN(valid->start, align);
+	valid->end = ALIGN_DOWN(valid->end + 1, align) - 1;
 
 	if (valid->start >= valid->end)
 		goto invalid;
@@ -1007,10 +1012,10 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 		return -ENXIO;
 	}
 
-	div_u64_rem(val, PAGE_SIZE * nd_region->ndr_mappings, &remainder);
+	div_u64_rem(val, nd_region->align, &remainder);
 	if (remainder) {
 		dev_dbg(dev, "%llu is not %ldK aligned\n", val,
-				(PAGE_SIZE * nd_region->ndr_mappings) / SZ_1K);
+				nd_region->align / SZ_1K);
 		return -EINVAL;
 	}
 
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 4a946c019e0f..e37c79c340d6 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -146,6 +146,7 @@ struct nd_region {
 	struct device *btt_seed;
 	struct device *pfn_seed;
 	struct device *dax_seed;
+	unsigned long align;
 	u16 ndr_mappings;
 	u64 ndr_size;
 	u64 ndr_start;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index b1b13debffbc..7d5ab00c7b45 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -246,21 +246,25 @@ int nd_region_to_nstype(struct nd_region *nd_region)
 }
 EXPORT_SYMBOL(nd_region_to_nstype);
 
-static ssize_t size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static unsigned long long region_size(struct nd_region *nd_region)
 {
-	struct nd_region *nd_region = to_nd_region(dev);
-	unsigned long long size = 0;
-
-	if (is_memory(dev)) {
-		size = nd_region->ndr_size;
+	if (is_memory(&nd_region->dev)) {
+		return nd_region->ndr_size;
 	} else if (nd_region->ndr_mappings == 1) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[0];
 
-		size = nd_mapping->size;
+		return nd_mapping->size;
 	}
 
-	return sprintf(buf, "%llu\n", size);
+	return 0;
+}
+
+static ssize_t size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	return sprintf(buf, "%llu\n", region_size(nd_region));
 }
 static DEVICE_ATTR_RO(size);
 
@@ -559,6 +563,54 @@ static ssize_t read_only_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(read_only);
 
+static ssize_t align_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	return sprintf(buf, "%#lx\n", nd_region->align);
+}
+
+static ssize_t align_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	unsigned long val, dpa;
+	u32 remainder;
+	int rc;
+
+	rc = kstrtoul(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	if (!nd_region->ndr_mappings)
+		return -ENXIO;
+
+	/*
+	 * Ensure space-align is evenly divisible by the region
+	 * interleave-width because the kernel typically has no facility
+	 * to determine which DIMM(s), dimm-physical-addresses, would
+	 * contribute to the tail capacity in system-physical-address
+	 * space for the namespace.
+	 */
+	dpa = div_u64_rem(val, nd_region->ndr_mappings, &remainder);
+	if (!is_power_of_2(dpa) || dpa < PAGE_SIZE
+			|| val > region_size(nd_region) || remainder)
+		return -EINVAL;
+
+	/*
+	 * Given that space allocation consults this value multiple
+	 * times ensure it does not change for the duration of the
+	 * allocation.
+	 */
+	nvdimm_bus_lock(dev);
+	nd_region->align = val;
+	nvdimm_bus_unlock(dev);
+
+	return len;
+}
+static DEVICE_ATTR_RW(align);
+
 static ssize_t region_badblocks_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -601,6 +653,7 @@ static DEVICE_ATTR_RO(persistence_domain);
 
 static struct attribute *nd_region_attributes[] = {
 	&dev_attr_size.attr,
+	&dev_attr_align.attr,
 	&dev_attr_nstype.attr,
 	&dev_attr_mappings.attr,
 	&dev_attr_btt_seed.attr,
@@ -660,6 +713,19 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 		return a->mode;
 	}
 
+	if (a == &dev_attr_align.attr) {
+		int i;
+
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
+			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+			struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+			if (test_bit(NDD_LABELING, &nvdimm->flags))
+				return a->mode;
+		}
+		return 0;
+	}
+
 	if (a != &dev_attr_set_cookie.attr
 			&& a != &dev_attr_available_size.attr)
 		return a->mode;
@@ -930,6 +996,41 @@ void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
 }
 EXPORT_SYMBOL(nd_region_release_lane);
 
+/*
+ * PowerPC requires this alignment for memremap_pages(). All other archs
+ * should be ok with SUBSECTION_SIZE (see memremap_compat_align()).
+ */
+#define MEMREMAP_COMPAT_ALIGN_MAX SZ_16M
+
+static unsigned long default_align(struct nd_region *nd_region)
+{
+	unsigned long align;
+	int i, mappings;
+	u32 remainder;
+
+	if (is_nd_blk(&nd_region->dev))
+		align = PAGE_SIZE;
+	else
+		align = MEMREMAP_COMPAT_ALIGN_MAX;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		if (test_bit(NDD_ALIASING, &nvdimm->flags)) {
+			align = MEMREMAP_COMPAT_ALIGN_MAX;
+			break;
+		}
+	}
+
+	mappings = max_t(u16, 1, nd_region->ndr_mappings);
+	div_u64_rem(align, mappings, &remainder);
+	if (remainder)
+		align *= mappings;
+
+	return align;
+}
+
 static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc, struct device_type *dev_type,
 		const char *caller)
@@ -1034,6 +1135,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	dev->of_node = ndr_desc->of_node;
 	nd_region->ndr_size = resource_size(ndr_desc->res);
 	nd_region->ndr_start = ndr_desc->res->start;
+	nd_region->align = default_align(nd_region);
 	if (ndr_desc->flush)
 		nd_region->flush = ndr_desc->flush;
 	else

