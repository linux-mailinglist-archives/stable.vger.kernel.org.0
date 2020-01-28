Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC35B14B214
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgA1Jvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:51:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59408 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbgA1Jvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:51:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTjEjUlMxE+1FeA+9rvGI6ZQpOmYiCnZtwWVJmVE5AQ=;
        b=b0i0YSUvKweE1TatU+VctqZYaXxB13FZ+pukP+9s7ltMdAJlMm2mn49INhM4kD2M8Nyys4
        8ivlbgOk/G720OEyHfn8QRf1Bpdk3We/+XbvSi0MQB74ytT9ksOgzwM6r9zJOO1hUt2bxO
        A8TSMeGIK4Qnminhk3al2t/Ttr8/4+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-pKYslCIqMZ-Ewfjcv9RpPA-1; Tue, 28 Jan 2020 04:51:42 -0500
X-MC-Unique: pKYslCIqMZ-Ewfjcv9RpPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA8B4100550E;
        Tue, 28 Jan 2020 09:51:40 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CE8060BE0;
        Tue, 28 Jan 2020 09:51:38 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable v3 21/24] drivers/base/node.c: simplify unregister_memory_block_under_nodes()
Date:   Tue, 28 Jan 2020 10:50:18 +0100
Message-Id: <20200128095021.8076-22-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/base/memory.c |  1 +
 drivers/base/node.c   | 39 +++++++++++++++------------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index fdda7a6d712e..fde8d34a1c16 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -693,6 +693,7 @@ static int init_memory_block(struct memory_block **me=
mory, int block_id,
 	mem->state =3D state;
 	start_pfn =3D section_nr_to_pfn(mem->start_section_nr);
 	mem->phys_device =3D arch_get_memory_phys_device(start_pfn);
+	mem->nid =3D NUMA_NO_NODE;
=20
 	ret =3D register_memory(mem);
=20
diff --git a/drivers/base/node.c b/drivers/base/node.c
index bdff237f4167..f3565c2dbc52 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -409,8 +409,6 @@ int register_mem_sect_under_node(struct memory_block =
*mem_blk, void *arg)
 	int ret, nid =3D *(int *)arg;
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
=20
-	mem_blk->nid =3D nid;
-
 	sect_start_pfn =3D section_nr_to_pfn(mem_blk->start_section_nr);
 	sect_end_pfn =3D section_nr_to_pfn(mem_blk->end_section_nr);
 	sect_end_pfn +=3D PAGES_PER_SECTION - 1;
@@ -439,6 +437,13 @@ int register_mem_sect_under_node(struct memory_block=
 *mem_blk, void *arg)
 			if (page_nid !=3D nid)
 				continue;
 		}
+
+		/*
+		 * If this memory block spans multiple nodes, we only indicate
+		 * the last processed node.
+		 */
+		mem_blk->nid =3D nid;
+
 		ret =3D sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
 					&mem_blk->dev.kobj,
 					kobject_name(&mem_blk->dev.kobj));
@@ -454,32 +459,18 @@ int register_mem_sect_under_node(struct memory_bloc=
k *mem_blk, void *arg)
 }
=20
 /*
- * Unregister memory block device under all nodes that it spans.
- * Has to be called with mem_sysfs_mutex held (due to unlinked_nodes).
+ * Unregister a memory block device under the node it spans. Memory bloc=
ks
+ * with multiple nodes cannot be offlined and therefore also never be re=
moved.
  */
 void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 {
-	unsigned long pfn, sect_start_pfn, sect_end_pfn;
-	static nodemask_t unlinked_nodes;
-
-	nodes_clear(unlinked_nodes);
-	sect_start_pfn =3D section_nr_to_pfn(mem_blk->start_section_nr);
-	sect_end_pfn =3D section_nr_to_pfn(mem_blk->end_section_nr);
-	for (pfn =3D sect_start_pfn; pfn <=3D sect_end_pfn; pfn++) {
-		int nid;
+	if (mem_blk->nid =3D=3D NUMA_NO_NODE)
+		return;
=20
-		nid =3D get_nid_for_pfn(pfn);
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
=20
 int link_mem_sections(int nid, unsigned long start_pfn, unsigned long en=
d_pfn)
--=20
2.24.1

