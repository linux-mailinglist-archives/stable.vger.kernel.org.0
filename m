Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9055322671E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387463AbgGTQI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387451AbgGTQIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:08:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B47462065E;
        Mon, 20 Jul 2020 16:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261334;
        bh=CF6EDp1F7vDRsTW2YzIEOzRl80/jC/p3QUaG5pBk6Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0IdFL+r385AJP9HxeQyIDfoWzBQzS+J35CW18VJ7ZB3hEZr4UOuhhW/dhRO+ytqf
         5CptJJL5ebVGt0WwU1EsKEC/NHzk1PGsgeGfe7cpxr+CaqJwzMQc12s0uWnjrCnEFD
         Dhd/nGo4ngNLNWM/cpE0dIxeioUdReuNLbMC74gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 048/244] xen/xenbus: avoid large structs and arrays on the stack
Date:   Mon, 20 Jul 2020 17:35:19 +0200
Message-Id: <20200720152828.145267472@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 3848e4e0a32afb96dc3b84e1358c3b9d103c6a2c ]

xenbus_map_ring_valloc() and its sub-functions are putting quite large
structs and arrays on the stack. This is problematic at runtime, but
might also result in build failures (e.g. with clang due to the option
-Werror,-Wframe-larger-than=... used).

Fix that by moving most of the data from the stack into a dynamically
allocated struct. Performance is no issue here, as
xenbus_map_ring_valloc() is used only when adding a new PV device to
a backend driver.

While at it move some duplicated code from pv/hvm specific mapping
functions to the single caller.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20200701121638.19840-2-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_client.c | 161 +++++++++++++++--------------
 1 file changed, 83 insertions(+), 78 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 040d2a43e8e35..9f8372079ecfa 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -69,11 +69,27 @@ struct xenbus_map_node {
 	unsigned int   nr_handles;
 };
 
+struct map_ring_valloc {
+	struct xenbus_map_node *node;
+
+	/* Why do we need two arrays? See comment of __xenbus_map_ring */
+	union {
+		unsigned long addrs[XENBUS_MAX_RING_GRANTS];
+		pte_t *ptes[XENBUS_MAX_RING_GRANTS];
+	};
+	phys_addr_t phys_addrs[XENBUS_MAX_RING_GRANTS];
+
+	struct gnttab_map_grant_ref map[XENBUS_MAX_RING_GRANTS];
+	struct gnttab_unmap_grant_ref unmap[XENBUS_MAX_RING_GRANTS];
+
+	unsigned int idx;	/* HVM only. */
+};
+
 static DEFINE_SPINLOCK(xenbus_valloc_lock);
 static LIST_HEAD(xenbus_valloc_pages);
 
 struct xenbus_ring_ops {
-	int (*map)(struct xenbus_device *dev,
+	int (*map)(struct xenbus_device *dev, struct map_ring_valloc *info,
 		   grant_ref_t *gnt_refs, unsigned int nr_grefs,
 		   void **vaddr);
 	int (*unmap)(struct xenbus_device *dev, void *vaddr);
@@ -449,12 +465,32 @@ int xenbus_map_ring_valloc(struct xenbus_device *dev, grant_ref_t *gnt_refs,
 			   unsigned int nr_grefs, void **vaddr)
 {
 	int err;
+	struct map_ring_valloc *info;
+
+	*vaddr = NULL;
+
+	if (nr_grefs > XENBUS_MAX_RING_GRANTS)
+		return -EINVAL;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->node = kzalloc(sizeof(*info->node), GFP_KERNEL);
+	if (!info->node) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ring_ops->map(dev, info, gnt_refs, nr_grefs, vaddr);
 
-	err = ring_ops->map(dev, gnt_refs, nr_grefs, vaddr);
 	/* Some hypervisors are buggy and can return 1. */
 	if (err > 0)
 		err = GNTST_general_error;
 
+ out:
+	kfree(info->node);
+	kfree(info);
 	return err;
 }
 EXPORT_SYMBOL_GPL(xenbus_map_ring_valloc);
@@ -466,12 +502,10 @@ static int __xenbus_map_ring(struct xenbus_device *dev,
 			     grant_ref_t *gnt_refs,
 			     unsigned int nr_grefs,
 			     grant_handle_t *handles,
-			     phys_addr_t *addrs,
+			     struct map_ring_valloc *info,
 			     unsigned int flags,
 			     bool *leaked)
 {
-	struct gnttab_map_grant_ref map[XENBUS_MAX_RING_GRANTS];
-	struct gnttab_unmap_grant_ref unmap[XENBUS_MAX_RING_GRANTS];
 	int i, j;
 	int err = GNTST_okay;
 
@@ -479,23 +513,22 @@ static int __xenbus_map_ring(struct xenbus_device *dev,
 		return -EINVAL;
 
 	for (i = 0; i < nr_grefs; i++) {
-		memset(&map[i], 0, sizeof(map[i]));
-		gnttab_set_map_op(&map[i], addrs[i], flags, gnt_refs[i],
-				  dev->otherend_id);
+		gnttab_set_map_op(&info->map[i], info->phys_addrs[i], flags,
+				  gnt_refs[i], dev->otherend_id);
 		handles[i] = INVALID_GRANT_HANDLE;
 	}
 
-	gnttab_batch_map(map, i);
+	gnttab_batch_map(info->map, i);
 
 	for (i = 0; i < nr_grefs; i++) {
-		if (map[i].status != GNTST_okay) {
-			err = map[i].status;
-			xenbus_dev_fatal(dev, map[i].status,
+		if (info->map[i].status != GNTST_okay) {
+			err = info->map[i].status;
+			xenbus_dev_fatal(dev, info->map[i].status,
 					 "mapping in shared page %d from domain %d",
 					 gnt_refs[i], dev->otherend_id);
 			goto fail;
 		} else
-			handles[i] = map[i].handle;
+			handles[i] = info->map[i].handle;
 	}
 
 	return GNTST_okay;
@@ -503,19 +536,19 @@ static int __xenbus_map_ring(struct xenbus_device *dev,
  fail:
 	for (i = j = 0; i < nr_grefs; i++) {
 		if (handles[i] != INVALID_GRANT_HANDLE) {
-			memset(&unmap[j], 0, sizeof(unmap[j]));
-			gnttab_set_unmap_op(&unmap[j], (phys_addr_t)addrs[i],
+			gnttab_set_unmap_op(&info->unmap[j],
+					    info->phys_addrs[i],
 					    GNTMAP_host_map, handles[i]);
 			j++;
 		}
 	}
 
-	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap, j))
+	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, info->unmap, j))
 		BUG();
 
 	*leaked = false;
 	for (i = 0; i < j; i++) {
-		if (unmap[i].status != GNTST_okay) {
+		if (info->unmap[i].status != GNTST_okay) {
 			*leaked = true;
 			break;
 		}
@@ -566,21 +599,12 @@ static int xenbus_unmap_ring(struct xenbus_device *dev, grant_handle_t *handles,
 	return err;
 }
 
-struct map_ring_valloc_hvm
-{
-	unsigned int idx;
-
-	/* Why do we need two arrays? See comment of __xenbus_map_ring */
-	phys_addr_t phys_addrs[XENBUS_MAX_RING_GRANTS];
-	unsigned long addrs[XENBUS_MAX_RING_GRANTS];
-};
-
 static void xenbus_map_ring_setup_grant_hvm(unsigned long gfn,
 					    unsigned int goffset,
 					    unsigned int len,
 					    void *data)
 {
-	struct map_ring_valloc_hvm *info = data;
+	struct map_ring_valloc *info = data;
 	unsigned long vaddr = (unsigned long)gfn_to_virt(gfn);
 
 	info->phys_addrs[info->idx] = vaddr;
@@ -589,39 +613,28 @@ static void xenbus_map_ring_setup_grant_hvm(unsigned long gfn,
 	info->idx++;
 }
 
-static int xenbus_map_ring_valloc_hvm(struct xenbus_device *dev,
-				      grant_ref_t *gnt_ref,
-				      unsigned int nr_grefs,
-				      void **vaddr)
+static int xenbus_map_ring_hvm(struct xenbus_device *dev,
+			       struct map_ring_valloc *info,
+			       grant_ref_t *gnt_ref,
+			       unsigned int nr_grefs,
+			       void **vaddr)
 {
-	struct xenbus_map_node *node;
+	struct xenbus_map_node *node = info->node;
 	int err;
 	void *addr;
 	bool leaked = false;
-	struct map_ring_valloc_hvm info = {
-		.idx = 0,
-	};
 	unsigned int nr_pages = XENBUS_PAGES(nr_grefs);
 
-	if (nr_grefs > XENBUS_MAX_RING_GRANTS)
-		return -EINVAL;
-
-	*vaddr = NULL;
-
-	node = kzalloc(sizeof(*node), GFP_KERNEL);
-	if (!node)
-		return -ENOMEM;
-
 	err = alloc_xenballooned_pages(nr_pages, node->hvm.pages);
 	if (err)
 		goto out_err;
 
 	gnttab_foreach_grant(node->hvm.pages, nr_grefs,
 			     xenbus_map_ring_setup_grant_hvm,
-			     &info);
+			     info);
 
 	err = __xenbus_map_ring(dev, gnt_ref, nr_grefs, node->handles,
-				info.phys_addrs, GNTMAP_host_map, &leaked);
+				info, GNTMAP_host_map, &leaked);
 	node->nr_handles = nr_grefs;
 
 	if (err)
@@ -641,11 +654,13 @@ static int xenbus_map_ring_valloc_hvm(struct xenbus_device *dev,
 	spin_unlock(&xenbus_valloc_lock);
 
 	*vaddr = addr;
+	info->node = NULL;
+
 	return 0;
 
  out_xenbus_unmap_ring:
 	if (!leaked)
-		xenbus_unmap_ring(dev, node->handles, nr_grefs, info.addrs);
+		xenbus_unmap_ring(dev, node->handles, nr_grefs, info->addrs);
 	else
 		pr_alert("leaking %p size %u page(s)",
 			 addr, nr_pages);
@@ -653,7 +668,6 @@ static int xenbus_map_ring_valloc_hvm(struct xenbus_device *dev,
 	if (!leaked)
 		free_xenballooned_pages(nr_pages, node->hvm.pages);
  out_err:
-	kfree(node);
 	return err;
 }
 
@@ -676,40 +690,30 @@ int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr)
 EXPORT_SYMBOL_GPL(xenbus_unmap_ring_vfree);
 
 #ifdef CONFIG_XEN_PV
-static int xenbus_map_ring_valloc_pv(struct xenbus_device *dev,
-				     grant_ref_t *gnt_refs,
-				     unsigned int nr_grefs,
-				     void **vaddr)
+static int xenbus_map_ring_pv(struct xenbus_device *dev,
+			      struct map_ring_valloc *info,
+			      grant_ref_t *gnt_refs,
+			      unsigned int nr_grefs,
+			      void **vaddr)
 {
-	struct xenbus_map_node *node;
+	struct xenbus_map_node *node = info->node;
 	struct vm_struct *area;
-	pte_t *ptes[XENBUS_MAX_RING_GRANTS];
-	phys_addr_t phys_addrs[XENBUS_MAX_RING_GRANTS];
 	int err = GNTST_okay;
 	int i;
 	bool leaked;
 
-	*vaddr = NULL;
-
-	if (nr_grefs > XENBUS_MAX_RING_GRANTS)
-		return -EINVAL;
-
-	node = kzalloc(sizeof(*node), GFP_KERNEL);
-	if (!node)
-		return -ENOMEM;
-
-	area = alloc_vm_area(XEN_PAGE_SIZE * nr_grefs, ptes);
+	area = alloc_vm_area(XEN_PAGE_SIZE * nr_grefs, info->ptes);
 	if (!area) {
 		kfree(node);
 		return -ENOMEM;
 	}
 
 	for (i = 0; i < nr_grefs; i++)
-		phys_addrs[i] = arbitrary_virt_to_machine(ptes[i]).maddr;
+		info->phys_addrs[i] =
+			arbitrary_virt_to_machine(info->ptes[i]).maddr;
 
 	err = __xenbus_map_ring(dev, gnt_refs, nr_grefs, node->handles,
-				phys_addrs,
-				GNTMAP_host_map | GNTMAP_contains_pte,
+				info, GNTMAP_host_map | GNTMAP_contains_pte,
 				&leaked);
 	if (err)
 		goto failed;
@@ -722,6 +726,8 @@ static int xenbus_map_ring_valloc_pv(struct xenbus_device *dev,
 	spin_unlock(&xenbus_valloc_lock);
 
 	*vaddr = area->addr;
+	info->node = NULL;
+
 	return 0;
 
 failed:
@@ -730,11 +736,10 @@ failed:
 	else
 		pr_alert("leaking VM area %p size %u page(s)", area, nr_grefs);
 
-	kfree(node);
 	return err;
 }
 
-static int xenbus_unmap_ring_vfree_pv(struct xenbus_device *dev, void *vaddr)
+static int xenbus_unmap_ring_pv(struct xenbus_device *dev, void *vaddr)
 {
 	struct xenbus_map_node *node;
 	struct gnttab_unmap_grant_ref unmap[XENBUS_MAX_RING_GRANTS];
@@ -798,12 +803,12 @@ static int xenbus_unmap_ring_vfree_pv(struct xenbus_device *dev, void *vaddr)
 }
 
 static const struct xenbus_ring_ops ring_ops_pv = {
-	.map = xenbus_map_ring_valloc_pv,
-	.unmap = xenbus_unmap_ring_vfree_pv,
+	.map = xenbus_map_ring_pv,
+	.unmap = xenbus_unmap_ring_pv,
 };
 #endif
 
-struct unmap_ring_vfree_hvm
+struct unmap_ring_hvm
 {
 	unsigned int idx;
 	unsigned long addrs[XENBUS_MAX_RING_GRANTS];
@@ -814,19 +819,19 @@ static void xenbus_unmap_ring_setup_grant_hvm(unsigned long gfn,
 					      unsigned int len,
 					      void *data)
 {
-	struct unmap_ring_vfree_hvm *info = data;
+	struct unmap_ring_hvm *info = data;
 
 	info->addrs[info->idx] = (unsigned long)gfn_to_virt(gfn);
 
 	info->idx++;
 }
 
-static int xenbus_unmap_ring_vfree_hvm(struct xenbus_device *dev, void *vaddr)
+static int xenbus_unmap_ring_hvm(struct xenbus_device *dev, void *vaddr)
 {
 	int rv;
 	struct xenbus_map_node *node;
 	void *addr;
-	struct unmap_ring_vfree_hvm info = {
+	struct unmap_ring_hvm info = {
 		.idx = 0,
 	};
 	unsigned int nr_pages;
@@ -887,8 +892,8 @@ enum xenbus_state xenbus_read_driver_state(const char *path)
 EXPORT_SYMBOL_GPL(xenbus_read_driver_state);
 
 static const struct xenbus_ring_ops ring_ops_hvm = {
-	.map = xenbus_map_ring_valloc_hvm,
-	.unmap = xenbus_unmap_ring_vfree_hvm,
+	.map = xenbus_map_ring_hvm,
+	.unmap = xenbus_unmap_ring_hvm,
 };
 
 void __init xenbus_ring_ops_init(void)
-- 
2.25.1



