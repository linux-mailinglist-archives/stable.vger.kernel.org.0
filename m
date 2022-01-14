Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86C648E573
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbiANISM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239621AbiANISA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:18:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3D9C061755;
        Fri, 14 Jan 2022 00:18:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F63261E09;
        Fri, 14 Jan 2022 08:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DC4C36AE9;
        Fri, 14 Jan 2022 08:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148279;
        bh=GBaG6djcASrvQAyYGGsA+XPx7HKN/ZA4vAR4qyHAr/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVjC4yp1oEyPKNCpsoq1f6u2445cbqvB6APE8jMctdm7OEvNmSn4ihY+TWtv/f/lz
         eda+KSyjwn03uJ7ywJoFlzA1meaSgN/1skQEfNK2BRKzNZZVdjQppORlBd5SeMV+iu
         f/1AJGbh+b2yaiRnda8qUyO8GI+2Rr/iK+nkZWac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.4 09/18] drivers core: Use sysfs_emit and sysfs_emit_at for show(device *...) functions
Date:   Fri, 14 Jan 2022 09:16:16 +0100
Message-Id: <20220114081541.777374320@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
References: <20220114081541.465841464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Perches <joe@perches.com>

commit aa838896d87af561a33ecefea1caa4c15a68bc47 upstream.

Convert the various sprintf fmaily calls in sysfs device show functions
to sysfs_emit and sysfs_emit_at for PAGE_SIZE buffer safety.

Done with:

$ spatch -sp-file sysfs_emit_dev.cocci --in-place --max-width=80 .

And cocci script:

$ cat sysfs_emit_dev.cocci
@@
identifier d_show;
identifier dev, attr, buf;
@@

ssize_t d_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	<...
	return
-	sprintf(buf,
+	sysfs_emit(buf,
	...);
	...>
}

@@
identifier d_show;
identifier dev, attr, buf;
@@

ssize_t d_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	<...
	return
-	snprintf(buf, PAGE_SIZE,
+	sysfs_emit(buf,
	...);
	...>
}

@@
identifier d_show;
identifier dev, attr, buf;
@@

ssize_t d_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	<...
	return
-	scnprintf(buf, PAGE_SIZE,
+	sysfs_emit(buf,
	...);
	...>
}

@@
identifier d_show;
identifier dev, attr, buf;
expression chr;
@@

ssize_t d_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	<...
	return
-	strcpy(buf, chr);
+	sysfs_emit(buf, chr);
	...>
}

@@
identifier d_show;
identifier dev, attr, buf;
identifier len;
@@

ssize_t d_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	<...
	len =
-	sprintf(buf,
+	sysfs_emit(buf,
	...);
	...>
	return len;
}

@@
identifier d_show;
identifier dev, attr, buf;
identifier len;
@@

ssize_t d_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	<...
	len =
-	snprintf(buf, PAGE_SIZE,
+	sysfs_emit(buf,
	...);
	...>
	return len;
}

@@
identifier d_show;
identifier dev, attr, buf;
identifier len;
@@

ssize_t d_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	<...
	len =
-	scnprintf(buf, PAGE_SIZE,
+	sysfs_emit(buf,
	...);
	...>
	return len;
}

@@
identifier d_show;
identifier dev, attr, buf;
identifier len;
@@

ssize_t d_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	<...
-	len += scnprintf(buf + len, PAGE_SIZE - len,
+	len += sysfs_emit_at(buf, len,
	...);
	...>
	return len;
}

@@
identifier d_show;
identifier dev, attr, buf;
expression chr;
@@

ssize_t d_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	...
-	strcpy(buf, chr);
-	return strlen(buf);
+	return sysfs_emit(buf, chr);
}

Signed-off-by: Joe Perches <joe@perches.com>
Link: https://lore.kernel.org/r/3d033c33056d88bbe34d4ddb62afd05ee166ab9a.1600285923.git.joe@perches.com
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/arch_topology.c            |    2 -
 drivers/base/cacheinfo.c                |   18 +++++------
 drivers/base/core.c                     |    8 ++---
 drivers/base/cpu.c                      |   39 ++++++++++--------------
 drivers/base/firmware_loader/fallback.c |    2 -
 drivers/base/memory.c                   |   24 +++++++--------
 drivers/base/node.c                     |   28 ++++++++---------
 drivers/base/platform.c                 |    2 -
 drivers/base/power/sysfs.c              |   50 ++++++++++++++++----------------
 drivers/base/power/wakeup_stats.c       |   12 +++----
 drivers/base/soc.c                      |   10 +++---
 11 files changed, 95 insertions(+), 100 deletions(-)

--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -48,7 +48,7 @@ static ssize_t cpu_capacity_show(struct
 {
 	struct cpu *cpu = container_of(dev, struct cpu, dev);
 
-	return sprintf(buf, "%lu\n", topology_get_cpu_scale(cpu->dev.id));
+	return sysfs_emit(buf, "%lu\n", topology_get_cpu_scale(cpu->dev.id));
 }
 
 static void update_topology_flags_workfn(struct work_struct *work);
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -377,7 +377,7 @@ static ssize_t size_show(struct device *
 {
 	struct cacheinfo *this_leaf = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%uK\n", this_leaf->size >> 10);
+	return sysfs_emit(buf, "%uK\n", this_leaf->size >> 10);
 }
 
 static ssize_t shared_cpumap_show_func(struct device *dev, bool list, char *buf)
@@ -407,11 +407,11 @@ static ssize_t type_show(struct device *
 
 	switch (this_leaf->type) {
 	case CACHE_TYPE_DATA:
-		return sprintf(buf, "Data\n");
+		return sysfs_emit(buf, "Data\n");
 	case CACHE_TYPE_INST:
-		return sprintf(buf, "Instruction\n");
+		return sysfs_emit(buf, "Instruction\n");
 	case CACHE_TYPE_UNIFIED:
-		return sprintf(buf, "Unified\n");
+		return sysfs_emit(buf, "Unified\n");
 	default:
 		return -EINVAL;
 	}
@@ -425,11 +425,11 @@ static ssize_t allocation_policy_show(st
 	int n = 0;
 
 	if ((ci_attr & CACHE_READ_ALLOCATE) && (ci_attr & CACHE_WRITE_ALLOCATE))
-		n = sprintf(buf, "ReadWriteAllocate\n");
+		n = sysfs_emit(buf, "ReadWriteAllocate\n");
 	else if (ci_attr & CACHE_READ_ALLOCATE)
-		n = sprintf(buf, "ReadAllocate\n");
+		n = sysfs_emit(buf, "ReadAllocate\n");
 	else if (ci_attr & CACHE_WRITE_ALLOCATE)
-		n = sprintf(buf, "WriteAllocate\n");
+		n = sysfs_emit(buf, "WriteAllocate\n");
 	return n;
 }
 
@@ -441,9 +441,9 @@ static ssize_t write_policy_show(struct
 	int n = 0;
 
 	if (ci_attr & CACHE_WRITE_THROUGH)
-		n = sprintf(buf, "WriteThrough\n");
+		n = sysfs_emit(buf, "WriteThrough\n");
 	else if (ci_attr & CACHE_WRITE_BACK)
-		n = sprintf(buf, "WriteBack\n");
+		n = sysfs_emit(buf, "WriteBack\n");
 	return n;
 }
 
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1027,7 +1027,7 @@ ssize_t device_show_ulong(struct device
 			  char *buf)
 {
 	struct dev_ext_attribute *ea = to_ext_attr(attr);
-	return snprintf(buf, PAGE_SIZE, "%lx\n", *(unsigned long *)(ea->var));
+	return sysfs_emit(buf, "%lx\n", *(unsigned long *)(ea->var));
 }
 EXPORT_SYMBOL_GPL(device_show_ulong);
 
@@ -1057,7 +1057,7 @@ ssize_t device_show_int(struct device *d
 {
 	struct dev_ext_attribute *ea = to_ext_attr(attr);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", *(int *)(ea->var));
+	return sysfs_emit(buf, "%d\n", *(int *)(ea->var));
 }
 EXPORT_SYMBOL_GPL(device_show_int);
 
@@ -1078,7 +1078,7 @@ ssize_t device_show_bool(struct device *
 {
 	struct dev_ext_attribute *ea = to_ext_attr(attr);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", *(bool *)(ea->var));
+	return sysfs_emit(buf, "%d\n", *(bool *)(ea->var));
 }
 EXPORT_SYMBOL_GPL(device_show_bool);
 
@@ -1310,7 +1310,7 @@ static ssize_t online_show(struct device
 	device_lock(dev);
 	val = !dev->offline;
 	device_unlock(dev);
-	return sprintf(buf, "%u\n", val);
+	return sysfs_emit(buf, "%u\n", val);
 }
 
 static ssize_t online_store(struct device *dev, struct device_attribute *attr,
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -156,7 +156,7 @@ static ssize_t show_crash_notes(struct d
 	 * operation should be safe. No locking required.
 	 */
 	addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum));
-	rc = sprintf(buf, "%Lx\n", addr);
+	rc = sysfs_emit(buf, "%Lx\n", addr);
 	return rc;
 }
 static DEVICE_ATTR(crash_notes, 0400, show_crash_notes, NULL);
@@ -167,7 +167,7 @@ static ssize_t show_crash_notes_size(str
 {
 	ssize_t rc;
 
-	rc = sprintf(buf, "%zu\n", sizeof(note_buf_t));
+	rc = sysfs_emit(buf, "%zu\n", sizeof(note_buf_t));
 	return rc;
 }
 static DEVICE_ATTR(crash_notes_size, 0400, show_crash_notes_size, NULL);
@@ -231,8 +231,7 @@ static struct cpu_attr cpu_attrs[] = {
 static ssize_t print_cpus_kernel_max(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
-	int n = snprintf(buf, PAGE_SIZE-2, "%d\n", NR_CPUS - 1);
-	return n;
+	return sprintf(buf, "%d\n", NR_CPUS - 1);
 }
 static DEVICE_ATTR(kernel_max, 0444, print_cpus_kernel_max, NULL);
 
@@ -272,7 +271,7 @@ static DEVICE_ATTR(offline, 0444, print_
 static ssize_t print_cpus_isolated(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	int n = 0, len = PAGE_SIZE-2;
+	int n;
 	cpumask_var_t isolated;
 
 	if (!alloc_cpumask_var(&isolated, GFP_KERNEL))
@@ -280,7 +279,7 @@ static ssize_t print_cpus_isolated(struc
 
 	cpumask_andnot(isolated, cpu_possible_mask,
 		       housekeeping_cpumask(HK_FLAG_DOMAIN));
-	n = scnprintf(buf, len, "%*pbl\n", cpumask_pr_args(isolated));
+	n = sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(isolated));
 
 	free_cpumask_var(isolated);
 
@@ -292,11 +291,7 @@ static DEVICE_ATTR(isolated, 0444, print
 static ssize_t print_cpus_nohz_full(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	int n = 0, len = PAGE_SIZE-2;
-
-	n = scnprintf(buf, len, "%*pbl\n", cpumask_pr_args(tick_nohz_full_mask));
-
-	return n;
+	return sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(tick_nohz_full_mask));
 }
 static DEVICE_ATTR(nohz_full, 0444, print_cpus_nohz_full, NULL);
 #endif
@@ -328,8 +323,8 @@ static ssize_t print_cpu_modalias(struct
 	ssize_t n;
 	u32 i;
 
-	n = sprintf(buf, "cpu:type:" CPU_FEATURE_TYPEFMT ":feature:",
-		    CPU_FEATURE_TYPEVAL);
+	n = sysfs_emit(buf, "cpu:type:" CPU_FEATURE_TYPEFMT ":feature:",
+		       CPU_FEATURE_TYPEVAL);
 
 	for (i = 0; i < MAX_CPU_FEATURES; i++)
 		if (cpu_have_feature(i)) {
@@ -521,56 +516,56 @@ static void __init cpu_dev_register_gene
 ssize_t __weak cpu_show_meltdown(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "Not affected\n");
+	return sysfs_emit(buf, "Not affected\n");
 }
 
 ssize_t __weak cpu_show_spectre_v1(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "Not affected\n");
+	return sysfs_emit(buf, "Not affected\n");
 }
 
 ssize_t __weak cpu_show_spectre_v2(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "Not affected\n");
+	return sysfs_emit(buf, "Not affected\n");
 }
 
 ssize_t __weak cpu_show_spec_store_bypass(struct device *dev,
 					  struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "Not affected\n");
+	return sysfs_emit(buf, "Not affected\n");
 }
 
 ssize_t __weak cpu_show_l1tf(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "Not affected\n");
+	return sysfs_emit(buf, "Not affected\n");
 }
 
 ssize_t __weak cpu_show_mds(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "Not affected\n");
+	return sysfs_emit(buf, "Not affected\n");
 }
 
 ssize_t __weak cpu_show_tsx_async_abort(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	return sprintf(buf, "Not affected\n");
+	return sysfs_emit(buf, "Not affected\n");
 }
 
 ssize_t __weak cpu_show_itlb_multihit(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "Not affected\n");
+	return sysfs_emit(buf, "Not affected\n");
 }
 
 ssize_t __weak cpu_show_srbds(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "Not affected\n");
+	return sysfs_emit(buf, "Not affected\n");
 }
 
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -215,7 +215,7 @@ static ssize_t firmware_loading_show(str
 		loading = fw_sysfs_loading(fw_sysfs->fw_priv);
 	mutex_unlock(&fw_lock);
 
-	return sprintf(buf, "%d\n", loading);
+	return sysfs_emit(buf, "%d\n", loading);
 }
 
 /**
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -110,7 +110,7 @@ static ssize_t phys_index_show(struct de
 	unsigned long phys_index;
 
 	phys_index = mem->start_section_nr / sections_per_block;
-	return sprintf(buf, "%08lx\n", phys_index);
+	return sysfs_emit(buf, "%08lx\n", phys_index);
 }
 
 /*
@@ -120,7 +120,7 @@ static ssize_t phys_index_show(struct de
 static ssize_t removable_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
-	return sprintf(buf, "%d\n", (int)IS_ENABLED(CONFIG_MEMORY_HOTREMOVE));
+	return sysfs_emit(buf, "%d\n", (int)IS_ENABLED(CONFIG_MEMORY_HOTREMOVE));
 }
 
 /*
@@ -138,17 +138,17 @@ static ssize_t state_show(struct device
 	 */
 	switch (mem->state) {
 	case MEM_ONLINE:
-		len = sprintf(buf, "online\n");
+		len = sysfs_emit(buf, "online\n");
 		break;
 	case MEM_OFFLINE:
-		len = sprintf(buf, "offline\n");
+		len = sysfs_emit(buf, "offline\n");
 		break;
 	case MEM_GOING_OFFLINE:
-		len = sprintf(buf, "going-offline\n");
+		len = sysfs_emit(buf, "going-offline\n");
 		break;
 	default:
-		len = sprintf(buf, "ERROR-UNKNOWN-%ld\n",
-				mem->state);
+		len = sysfs_emit(buf, "ERROR-UNKNOWN-%ld\n",
+				 mem->state);
 		WARN_ON(1);
 		break;
 	}
@@ -358,7 +358,7 @@ static ssize_t phys_device_show(struct d
 				struct device_attribute *attr, char *buf)
 {
 	struct memory_block *mem = to_memory_block(dev);
-	return sprintf(buf, "%d\n", mem->phys_device);
+	return sysfs_emit(buf, "%d\n", mem->phys_device);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
@@ -396,7 +396,7 @@ static ssize_t valid_zones_show(struct d
 		 */
 		if (!test_pages_in_a_zone(start_pfn, start_pfn + nr_pages,
 					  &valid_start_pfn, &valid_end_pfn))
-			return sprintf(buf, "none\n");
+			return sysfs_emit(buf, "none\n");
 		start_pfn = valid_start_pfn;
 		strcat(buf, page_zone(pfn_to_page(start_pfn))->name);
 		goto out;
@@ -429,7 +429,7 @@ static DEVICE_ATTR_RO(removable);
 static ssize_t block_size_bytes_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lx\n", memory_block_size_bytes());
+	return sysfs_emit(buf, "%lx\n", memory_block_size_bytes());
 }
 
 static DEVICE_ATTR_RO(block_size_bytes);
@@ -442,9 +442,9 @@ static ssize_t auto_online_blocks_show(s
 				       struct device_attribute *attr, char *buf)
 {
 	if (memhp_auto_online)
-		return sprintf(buf, "online\n");
+		return sysfs_emit(buf, "online\n");
 	else
-		return sprintf(buf, "offline\n");
+		return sysfs_emit(buf, "offline\n");
 }
 
 static ssize_t auto_online_blocks_store(struct device *dev,
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -368,7 +368,7 @@ static ssize_t node_read_meminfo(struct
 	si_meminfo_node(&i, nid);
 	sreclaimable = node_page_state(pgdat, NR_SLAB_RECLAIMABLE);
 	sunreclaimable = node_page_state(pgdat, NR_SLAB_UNRECLAIMABLE);
-	n = sprintf(buf,
+	n = sysfs_emit(buf,
 		       "Node %d MemTotal:       %8lu kB\n"
 		       "Node %d MemFree:        %8lu kB\n"
 		       "Node %d MemUsed:        %8lu kB\n"
@@ -469,19 +469,19 @@ static DEVICE_ATTR(meminfo, S_IRUGO, nod
 static ssize_t node_read_numastat(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf,
-		       "numa_hit %lu\n"
-		       "numa_miss %lu\n"
-		       "numa_foreign %lu\n"
-		       "interleave_hit %lu\n"
-		       "local_node %lu\n"
-		       "other_node %lu\n",
-		       sum_zone_numa_state(dev->id, NUMA_HIT),
-		       sum_zone_numa_state(dev->id, NUMA_MISS),
-		       sum_zone_numa_state(dev->id, NUMA_FOREIGN),
-		       sum_zone_numa_state(dev->id, NUMA_INTERLEAVE_HIT),
-		       sum_zone_numa_state(dev->id, NUMA_LOCAL),
-		       sum_zone_numa_state(dev->id, NUMA_OTHER));
+	return sysfs_emit(buf,
+			  "numa_hit %lu\n"
+			  "numa_miss %lu\n"
+			  "numa_foreign %lu\n"
+			  "interleave_hit %lu\n"
+			  "local_node %lu\n"
+			  "other_node %lu\n",
+			  sum_zone_numa_state(dev->id, NUMA_HIT),
+			  sum_zone_numa_state(dev->id, NUMA_MISS),
+			  sum_zone_numa_state(dev->id, NUMA_FOREIGN),
+			  sum_zone_numa_state(dev->id, NUMA_INTERLEAVE_HIT),
+			  sum_zone_numa_state(dev->id, NUMA_LOCAL),
+			  sum_zone_numa_state(dev->id, NUMA_OTHER));
 }
 static DEVICE_ATTR(numastat, S_IRUGO, node_read_numastat, NULL);
 
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1009,7 +1009,7 @@ static ssize_t driver_override_show(stru
 	ssize_t len;
 
 	device_lock(dev);
-	len = sprintf(buf, "%s\n", pdev->driver_override);
+	len = sysfs_emit(buf, "%s\n", pdev->driver_override);
 	device_unlock(dev);
 	return len;
 }
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -100,7 +100,7 @@ static const char ctrl_on[] = "on";
 static ssize_t control_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
-	return sprintf(buf, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 				dev->power.runtime_auto ? ctrl_auto : ctrl_on);
 }
 
@@ -126,7 +126,7 @@ static ssize_t runtime_active_time_show(
 	int ret;
 	u64 tmp = pm_runtime_active_time(dev);
 	do_div(tmp, NSEC_PER_MSEC);
-	ret = sprintf(buf, "%llu\n", tmp);
+	ret = sysfs_emit(buf, "%llu\n", tmp);
 	return ret;
 }
 
@@ -138,7 +138,7 @@ static ssize_t runtime_suspended_time_sh
 	int ret;
 	u64 tmp = pm_runtime_suspended_time(dev);
 	do_div(tmp, NSEC_PER_MSEC);
-	ret = sprintf(buf, "%llu\n", tmp);
+	ret = sysfs_emit(buf, "%llu\n", tmp);
 	return ret;
 }
 
@@ -171,7 +171,7 @@ static ssize_t runtime_status_show(struc
 			return -EIO;
 		}
 	}
-	return sprintf(buf, p);
+	return sysfs_emit(buf, p);
 }
 
 static DEVICE_ATTR_RO(runtime_status);
@@ -181,7 +181,7 @@ static ssize_t autosuspend_delay_ms_show
 {
 	if (!dev->power.use_autosuspend)
 		return -EIO;
-	return sprintf(buf, "%d\n", dev->power.autosuspend_delay);
+	return sysfs_emit(buf, "%d\n", dev->power.autosuspend_delay);
 }
 
 static ssize_t autosuspend_delay_ms_store(struct device *dev,
@@ -210,11 +210,11 @@ static ssize_t pm_qos_resume_latency_us_
 	s32 value = dev_pm_qos_requested_resume_latency(dev);
 
 	if (value == 0)
-		return sprintf(buf, "n/a\n");
+		return sysfs_emit(buf, "n/a\n");
 	if (value == PM_QOS_RESUME_LATENCY_NO_CONSTRAINT)
 		value = 0;
 
-	return sprintf(buf, "%d\n", value);
+	return sysfs_emit(buf, "%d\n", value);
 }
 
 static ssize_t pm_qos_resume_latency_us_store(struct device *dev,
@@ -254,11 +254,11 @@ static ssize_t pm_qos_latency_tolerance_
 	s32 value = dev_pm_qos_get_user_latency_tolerance(dev);
 
 	if (value < 0)
-		return sprintf(buf, "auto\n");
+		return sysfs_emit(buf, "auto\n");
 	if (value == PM_QOS_LATENCY_ANY)
-		return sprintf(buf, "any\n");
+		return sysfs_emit(buf, "any\n");
 
-	return sprintf(buf, "%d\n", value);
+	return sysfs_emit(buf, "%d\n", value);
 }
 
 static ssize_t pm_qos_latency_tolerance_us_store(struct device *dev,
@@ -290,8 +290,8 @@ static ssize_t pm_qos_no_power_off_show(
 					struct device_attribute *attr,
 					char *buf)
 {
-	return sprintf(buf, "%d\n", !!(dev_pm_qos_requested_flags(dev)
-					& PM_QOS_FLAG_NO_POWER_OFF));
+	return sysfs_emit(buf, "%d\n", !!(dev_pm_qos_requested_flags(dev)
+					  & PM_QOS_FLAG_NO_POWER_OFF));
 }
 
 static ssize_t pm_qos_no_power_off_store(struct device *dev,
@@ -319,9 +319,9 @@ static const char _disabled[] = "disable
 static ssize_t wakeup_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-	return sprintf(buf, "%s\n", device_can_wakeup(dev)
-		? (device_may_wakeup(dev) ? _enabled : _disabled)
-		: "");
+	return sysfs_emit(buf, "%s\n", device_can_wakeup(dev)
+			  ? (device_may_wakeup(dev) ? _enabled : _disabled)
+			  : "");
 }
 
 static ssize_t wakeup_store(struct device *dev, struct device_attribute *attr,
@@ -507,7 +507,7 @@ static DEVICE_ATTR_RO(wakeup_prevent_sle
 static ssize_t runtime_usage_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", atomic_read(&dev->power.usage_count));
+	return sysfs_emit(buf, "%d\n", atomic_read(&dev->power.usage_count));
 }
 static DEVICE_ATTR_RO(runtime_usage);
 
@@ -515,8 +515,8 @@ static ssize_t runtime_active_kids_show(
 					struct device_attribute *attr,
 					char *buf)
 {
-	return sprintf(buf, "%d\n", dev->power.ignore_children ?
-		0 : atomic_read(&dev->power.child_count));
+	return sysfs_emit(buf, "%d\n", dev->power.ignore_children ?
+			  0 : atomic_read(&dev->power.child_count));
 }
 static DEVICE_ATTR_RO(runtime_active_kids);
 
@@ -524,12 +524,12 @@ static ssize_t runtime_enabled_show(stru
 				    struct device_attribute *attr, char *buf)
 {
 	if (dev->power.disable_depth && (dev->power.runtime_auto == false))
-		return sprintf(buf, "disabled & forbidden\n");
+		return sysfs_emit(buf, "disabled & forbidden\n");
 	if (dev->power.disable_depth)
-		return sprintf(buf, "disabled\n");
+		return sysfs_emit(buf, "disabled\n");
 	if (dev->power.runtime_auto == false)
-		return sprintf(buf, "forbidden\n");
-	return sprintf(buf, "enabled\n");
+		return sysfs_emit(buf, "forbidden\n");
+	return sysfs_emit(buf, "enabled\n");
 }
 static DEVICE_ATTR_RO(runtime_enabled);
 
@@ -537,9 +537,9 @@ static DEVICE_ATTR_RO(runtime_enabled);
 static ssize_t async_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	return sprintf(buf, "%s\n",
-			device_async_suspend_enabled(dev) ?
-				_enabled : _disabled);
+	return sysfs_emit(buf, "%s\n",
+			  device_async_suspend_enabled(dev) ?
+			  _enabled : _disabled);
 }
 
 static ssize_t async_store(struct device *dev, struct device_attribute *attr,
--- a/drivers/base/power/wakeup_stats.c
+++ b/drivers/base/power/wakeup_stats.c
@@ -42,7 +42,7 @@ static ssize_t active_time_ms_show(struc
 	ktime_t active_time =
 		ws->active ? ktime_sub(ktime_get(), ws->last_time) : 0;
 
-	return sprintf(buf, "%lld\n", ktime_to_ms(active_time));
+	return sysfs_emit(buf, "%lld\n", ktime_to_ms(active_time));
 }
 static DEVICE_ATTR_RO(active_time_ms);
 
@@ -57,7 +57,7 @@ static ssize_t total_time_ms_show(struct
 		active_time = ktime_sub(ktime_get(), ws->last_time);
 		total_time = ktime_add(total_time, active_time);
 	}
-	return sprintf(buf, "%lld\n", ktime_to_ms(total_time));
+	return sysfs_emit(buf, "%lld\n", ktime_to_ms(total_time));
 }
 static DEVICE_ATTR_RO(total_time_ms);
 
@@ -73,7 +73,7 @@ static ssize_t max_time_ms_show(struct d
 		if (active_time > max_time)
 			max_time = active_time;
 	}
-	return sprintf(buf, "%lld\n", ktime_to_ms(max_time));
+	return sysfs_emit(buf, "%lld\n", ktime_to_ms(max_time));
 }
 static DEVICE_ATTR_RO(max_time_ms);
 
@@ -82,7 +82,7 @@ static ssize_t last_change_ms_show(struc
 {
 	struct wakeup_source *ws = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%lld\n", ktime_to_ms(ws->last_time));
+	return sysfs_emit(buf, "%lld\n", ktime_to_ms(ws->last_time));
 }
 static DEVICE_ATTR_RO(last_change_ms);
 
@@ -91,7 +91,7 @@ static ssize_t name_show(struct device *
 {
 	struct wakeup_source *ws = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", ws->name);
+	return sysfs_emit(buf, "%s\n", ws->name);
 }
 static DEVICE_ATTR_RO(name);
 
@@ -106,7 +106,7 @@ static ssize_t prevent_suspend_time_ms_s
 		prevent_sleep_time = ktime_add(prevent_sleep_time,
 			ktime_sub(ktime_get(), ws->start_prevent_time));
 	}
-	return sprintf(buf, "%lld\n", ktime_to_ms(prevent_sleep_time));
+	return sysfs_emit(buf, "%lld\n", ktime_to_ms(prevent_sleep_time));
 }
 static DEVICE_ATTR_RO(prevent_suspend_time_ms);
 
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -76,15 +76,15 @@ static ssize_t soc_info_get(struct devic
 	struct soc_device *soc_dev = container_of(dev, struct soc_device, dev);
 
 	if (attr == &dev_attr_machine)
-		return sprintf(buf, "%s\n", soc_dev->attr->machine);
+		return sysfs_emit(buf, "%s\n", soc_dev->attr->machine);
 	if (attr == &dev_attr_family)
-		return sprintf(buf, "%s\n", soc_dev->attr->family);
+		return sysfs_emit(buf, "%s\n", soc_dev->attr->family);
 	if (attr == &dev_attr_revision)
-		return sprintf(buf, "%s\n", soc_dev->attr->revision);
+		return sysfs_emit(buf, "%s\n", soc_dev->attr->revision);
 	if (attr == &dev_attr_serial_number)
-		return sprintf(buf, "%s\n", soc_dev->attr->serial_number);
+		return sysfs_emit(buf, "%s\n", soc_dev->attr->serial_number);
 	if (attr == &dev_attr_soc_id)
-		return sprintf(buf, "%s\n", soc_dev->attr->soc_id);
+		return sysfs_emit(buf, "%s\n", soc_dev->attr->soc_id);
 
 	return -EINVAL;
 


