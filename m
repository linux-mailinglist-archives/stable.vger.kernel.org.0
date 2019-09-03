Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4F2A6F78
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfICQbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730435AbfICQbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:31:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A04B23878;
        Tue,  3 Sep 2019 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528299;
        bh=YyjbxgNl4LnQZCMq5LMk+9ESz9qxxJdoYR7Pz12nRbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJvX6x1UD5UrLH+bRnEY0vHe+QQk+FLxXSzwFWosrVWuSB0YcECOKmxI3bS3QHIE+
         lmQ5LY2Fs1qfOIVpKxMQRF3OpTFfC+y7hNsEWFdF2p0ceNLO10b7XGKrbQ/wHw4JUK
         LpPnLjcV3DznFrGAOBBHydkXljj/r3SJKjmA1ViE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Lianbo Jiang <lijiang@redhat.com>,
        Takashi Iwai <tiwai@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Yaowei Bai <baiyaowei@cmss.chinamobile.com>, bhe@redhat.com,
        dyoung@redhat.com, kexec@lists.infradead.org, mingo@redhat.com,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 143/167] resource: Fix find_next_iomem_res() iteration issue
Date:   Tue,  3 Sep 2019 12:24:55 -0400
Message-Id: <20190903162519.7136-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 010a93bf97c72f43aac664d0a685942f83d1a103 ]

Previously find_next_iomem_res() used "*res" as both an input parameter for
the range to search and the type of resource to search for, and an output
parameter for the resource we found, which makes the interface confusing.

The current callers use find_next_iomem_res() incorrectly because they
allocate a single struct resource and use it for repeated calls to
find_next_iomem_res().  When find_next_iomem_res() returns a resource, it
overwrites the start, end, flags, and desc members of the struct.  If we
call find_next_iomem_res() again, we must update or restore these fields.
The previous code restored res.start and res.end, but not res.flags or
res.desc.

Since the callers did not restore res.flags, if they searched for flags
IORESOURCE_MEM | IORESOURCE_BUSY and found a resource with flags
IORESOURCE_MEM | IORESOURCE_BUSY | IORESOURCE_SYSRAM, the next search would
incorrectly skip resources unless they were also marked as
IORESOURCE_SYSRAM.

Fix this by restructuring the interface so it takes explicit "start, end,
flags" parameters and uses "*res" only as an output parameter.

Based on a patch by Lianbo Jiang <lijiang@redhat.com>.

 [ bp: While at it:
   - make comments kernel-doc style.
   -

Originally-by: http://lore.kernel.org/lkml/20180921073211.20097-2-lijiang@redhat.com
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Brijesh Singh <brijesh.singh@amd.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Lianbo Jiang <lijiang@redhat.com>
CC: Takashi Iwai <tiwai@suse.de>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
CC: bhe@redhat.com
CC: dan.j.williams@intel.com
CC: dyoung@redhat.com
CC: kexec@lists.infradead.org
CC: mingo@redhat.com
CC: x86-ml <x86@kernel.org>
Link: http://lkml.kernel.org/r/153805812916.1157.177580438135143788.stgit@bhelgaas-glaptop.roam.corp.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 96 +++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 54 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 155ec873ea4d1..38b8d11c9eaf4 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -318,24 +318,27 @@ int release_resource(struct resource *old)
 
 EXPORT_SYMBOL(release_resource);
 
-/*
- * Finds the lowest iomem resource existing within [res->start..res->end].
- * The caller must specify res->start, res->end, res->flags, and optionally
- * desc.  If found, returns 0, res is overwritten, if not found, returns -1.
- * This function walks the whole tree and not just first level children until
- * and unless first_level_children_only is true.
+/**
+ * Finds the lowest iomem resource that covers part of [start..end].  The
+ * caller must specify start, end, flags, and desc (which may be
+ * IORES_DESC_NONE).
+ *
+ * If a resource is found, returns 0 and *res is overwritten with the part
+ * of the resource that's within [start..end]; if none is found, returns
+ * -1.
+ *
+ * This function walks the whole tree and not just first level children
+ * unless @first_level_children_only is true.
  */
-static int find_next_iomem_res(struct resource *res, unsigned long desc,
-			       bool first_level_children_only)
+static int find_next_iomem_res(resource_size_t start, resource_size_t end,
+			       unsigned long flags, unsigned long desc,
+			       bool first_level_children_only,
+			       struct resource *res)
 {
-	resource_size_t start, end;
 	struct resource *p;
 	bool sibling_only = false;
 
 	BUG_ON(!res);
-
-	start = res->start;
-	end = res->end;
 	BUG_ON(start >= end);
 
 	if (first_level_children_only)
@@ -344,7 +347,7 @@ static int find_next_iomem_res(struct resource *res, unsigned long desc,
 	read_lock(&resource_lock);
 
 	for (p = iomem_resource.child; p; p = next_resource(p, sibling_only)) {
-		if ((p->flags & res->flags) != res->flags)
+		if ((p->flags & flags) != flags)
 			continue;
 		if ((desc != IORES_DESC_NONE) && (desc != p->desc))
 			continue;
@@ -359,32 +362,31 @@ static int find_next_iomem_res(struct resource *res, unsigned long desc,
 	read_unlock(&resource_lock);
 	if (!p)
 		return -1;
+
 	/* copy data */
-	if (res->start < p->start)
-		res->start = p->start;
-	if (res->end > p->end)
-		res->end = p->end;
+	res->start = max(start, p->start);
+	res->end = min(end, p->end);
 	res->flags = p->flags;
 	res->desc = p->desc;
 	return 0;
 }
 
-static int __walk_iomem_res_desc(struct resource *res, unsigned long desc,
-				 bool first_level_children_only,
-				 void *arg,
+static int __walk_iomem_res_desc(resource_size_t start, resource_size_t end,
+				 unsigned long flags, unsigned long desc,
+				 bool first_level_children_only, void *arg,
 				 int (*func)(struct resource *, void *))
 {
-	u64 orig_end = res->end;
+	struct resource res;
 	int ret = -1;
 
-	while ((res->start < res->end) &&
-	       !find_next_iomem_res(res, desc, first_level_children_only)) {
-		ret = (*func)(res, arg);
+	while (start < end &&
+	       !find_next_iomem_res(start, end, flags, desc,
+				    first_level_children_only, &res)) {
+		ret = (*func)(&res, arg);
 		if (ret)
 			break;
 
-		res->start = res->end + 1;
-		res->end = orig_end;
+		start = res.end + 1;
 	}
 
 	return ret;
@@ -407,13 +409,7 @@ static int __walk_iomem_res_desc(struct resource *res, unsigned long desc,
 int walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start,
 		u64 end, void *arg, int (*func)(struct resource *, void *))
 {
-	struct resource res;
-
-	res.start = start;
-	res.end = end;
-	res.flags = flags;
-
-	return __walk_iomem_res_desc(&res, desc, false, arg, func);
+	return __walk_iomem_res_desc(start, end, flags, desc, false, arg, func);
 }
 EXPORT_SYMBOL_GPL(walk_iomem_res_desc);
 
@@ -427,13 +423,9 @@ EXPORT_SYMBOL_GPL(walk_iomem_res_desc);
 int walk_system_ram_res(u64 start, u64 end, void *arg,
 				int (*func)(struct resource *, void *))
 {
-	struct resource res;
+	unsigned long flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 
-	res.start = start;
-	res.end = end;
-	res.flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
-
-	return __walk_iomem_res_desc(&res, IORES_DESC_NONE, true,
+	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, true,
 				     arg, func);
 }
 
@@ -444,13 +436,9 @@ int walk_system_ram_res(u64 start, u64 end, void *arg,
 int walk_mem_res(u64 start, u64 end, void *arg,
 		 int (*func)(struct resource *, void *))
 {
-	struct resource res;
+	unsigned long flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 
-	res.start = start;
-	res.end = end;
-	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-
-	return __walk_iomem_res_desc(&res, IORES_DESC_NONE, true,
+	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, true,
 				     arg, func);
 }
 
@@ -464,25 +452,25 @@ int walk_mem_res(u64 start, u64 end, void *arg,
 int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
+	resource_size_t start, end;
+	unsigned long flags;
 	struct resource res;
 	unsigned long pfn, end_pfn;
-	u64 orig_end;
 	int ret = -1;
 
-	res.start = (u64) start_pfn << PAGE_SHIFT;
-	res.end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
-	res.flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
-	orig_end = res.end;
-	while ((res.start < res.end) &&
-		(find_next_iomem_res(&res, IORES_DESC_NONE, true) >= 0)) {
+	start = (u64) start_pfn << PAGE_SHIFT;
+	end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
+	flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
+	while (start < end &&
+	       !find_next_iomem_res(start, end, flags, IORES_DESC_NONE,
+				    true, &res)) {
 		pfn = (res.start + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		end_pfn = (res.end + 1) >> PAGE_SHIFT;
 		if (end_pfn > pfn)
 			ret = (*func)(pfn, end_pfn - pfn, arg);
 		if (ret)
 			break;
-		res.start = res.end + 1;
-		res.end = orig_end;
+		start = res.end + 1;
 	}
 	return ret;
 }
-- 
2.20.1

