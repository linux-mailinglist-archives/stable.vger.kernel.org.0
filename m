Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DADE14B94D
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgA1OaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729368AbgA1OaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:30:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8FC024699;
        Tue, 28 Jan 2020 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221807;
        bh=YfVryHKCUHFqeiK6OVMBMqEy9HNBIyunMElfIaNeGUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MICCQNDlsNfba5V2kaSh8aUGyn6gkt1N+cEUmInT0UzmW5ZPWjpRzYfgF3NtLbACj
         fWKEZGtDYCJ5VUnKHtfvdBVgWCkSaN89XvTWLAmwAtHJoChvx9ANgMAE+fmE1GNzpq
         gGRF1YAgtKKS57n3eTgLEssqkjSQ0foeiiEO+3Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 89/92] drivers/base/node.c: simplify unregister_memory_block_under_nodes()
Date:   Tue, 28 Jan 2020 15:08:57 +0100
Message-Id: <20200128135820.893455279@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit d84f2f5a755208da3f93e17714631485cb3da11c upstream.

We don't allow to offline memory block devices that belong to multiple
numa nodes.  Therefore, such devices can never get removed.  It is
sufficient to process a single node when removing the memory block.  No
need to iterate over each and every PFN.

We already have the nid stored for each memory block.  Make sure that the
nid always has a sane value.

Please note that checking for node_online(nid) is not required.  If we
would have a memory block belonging to a node that is no longer offline,
then we would have a BUG in the node offlining code.

Link: http://lkml.kernel.org/r/20190719135244.15242-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/memory.c |    1 +
 drivers/base/node.c   |   39 +++++++++++++++------------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -693,6 +693,7 @@ static int init_memory_block(struct memo
 	mem->state = state;
 	start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	mem->phys_device = arch_get_memory_phys_device(start_pfn);
+	mem->nid = NUMA_NO_NODE;
 
 	ret = register_memory(mem);
 
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -409,8 +409,6 @@ int register_mem_sect_under_node(struct
 	int ret, nid = *(int *)arg;
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
 
-	mem_blk->nid = nid;
-
 	sect_start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
 	sect_end_pfn = section_nr_to_pfn(mem_blk->end_section_nr);
 	sect_end_pfn += PAGES_PER_SECTION - 1;
@@ -439,6 +437,13 @@ int register_mem_sect_under_node(struct
 			if (page_nid != nid)
 				continue;
 		}
+
+		/*
+		 * If this memory block spans multiple nodes, we only indicate
+		 * the last processed node.
+		 */
+		mem_blk->nid = nid;
+
 		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
 					&mem_blk->dev.kobj,
 					kobject_name(&mem_blk->dev.kobj));
@@ -454,32 +459,18 @@ int register_mem_sect_under_node(struct
 }
 
 /*
- * Unregister memory block device under all nodes that it spans.
- * Has to be called with mem_sysfs_mutex held (due to unlinked_nodes).
+ * Unregister a memory block device under the node it spans. Memory blocks
+ * with multiple nodes cannot be offlined and therefore also never be removed.
  */
 void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 {
-	unsigned long pfn, sect_start_pfn, sect_end_pfn;
-	static nodemask_t unlinked_nodes;
-
-	nodes_clear(unlinked_nodes);
-	sect_start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
-	sect_end_pfn = section_nr_to_pfn(mem_blk->end_section_nr);
-	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
-		int nid;
+	if (mem_blk->nid == NUMA_NO_NODE)
+		return;
 
-		nid = get_nid_for_pfn(pfn);
-		if (nid < 0)
-			continue;
-		if (!node_online(nid))
-			continue;
-		if (node_test_and_set(nid, unlinked_nodes))
-			continue;
-		sysfs_remove_link(&node_devices[nid]->dev.kobj,
-			 kobject_name(&mem_blk->dev.kobj));
-		sysfs_remove_link(&mem_blk->dev.kobj,
-			 kobject_name(&node_devices[nid]->dev.kobj));
-	}
+	sysfs_remove_link(&node_devices[mem_blk->nid]->dev.kobj,
+			  kobject_name(&mem_blk->dev.kobj));
+	sysfs_remove_link(&mem_blk->dev.kobj,
+			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
 int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn)


