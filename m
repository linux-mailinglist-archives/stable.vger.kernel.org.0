Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26D62CC371
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 18:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388984AbgLBRVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 12:21:21 -0500
Received: from mga06.intel.com ([134.134.136.31]:44144 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387462AbgLBRVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 12:21:21 -0500
IronPort-SDR: c4+MILHmL6zf6D1rlGF3sLqNsmOaCll+8Mh6JaIMGa4zUmWAkC7z6QP9X2xRQPvzhkgui1ZY+D
 UpinEQxzUsvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="234659469"
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="234659469"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 09:20:39 -0800
IronPort-SDR: fDjedfGRWQCzG19jh45PcOcIsP0AOetr7n/XofgRr+8o3TW6guoTWk9s024E0M7T2KB1ccldml
 F1Po1SvaJsmA==
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="550144914"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.134.28])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 09:20:38 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     stable@vger.kernel.org
Cc:     jgg@nvidia.com, "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Di Zhu <zhudi21@huawei.com>
Subject: [PATCH 4.19-stable] RDMA/i40iw: Address an mmap handler exploit in i40iw
Date:   Wed,  2 Dec 2020 11:20:11 -0600
Message-Id: <20201202172012.801-2-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201202172012.801-1-shiraz.saleem@intel.com>
References: <20201202172012.801-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Saleem, Shiraz" <shiraz.saleem@intel.com>

backport of commit 2ed381439e89fa6d1a0839ef45ccd45d99d8e915 upstream.

i40iw_mmap manipulates the vma->vm_pgoff to differentiate a push page mmap
vs a doorbell mmap, and uses it to compute the pfn in remap_pfn_range
without any validation. This is vulnerable to an mmap exploit as described
in: https://lore.kernel.org/r/20201119093523.7588-1-zhudi21@huawei.com

The push feature is disabled in the driver currently and therefore no push
mmaps are issued from user-space. The feature does not work as expected in
the x722 product.

Remove the push module parameter and all VMA attribute manipulations for
this feature in i40iw_mmap. Update i40iw_mmap to only allow DB user
mmapings at offset = 0. Check vm_pgoff for zero and if the mmaps are bound
to a single page.

Fixes: d37498417947 ("i40iw: add files for iwarp interface")
Link: https://lore.kernel.org/r/20201125005616.1800-2-shiraz.saleem@intel.com
Reported-by: Di Zhu <zhudi21@huawei.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c  |  5 -----
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 36 ++++++-------------------------
 2 files changed, 7 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 68095f0..41227d9 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -54,10 +54,6 @@
 #define DRV_VERSION	__stringify(DRV_VERSION_MAJOR) "."		\
 	__stringify(DRV_VERSION_MINOR) "." __stringify(DRV_VERSION_BUILD)
 
-static int push_mode;
-module_param(push_mode, int, 0644);
-MODULE_PARM_DESC(push_mode, "Low latency mode: 0=disabled (default), 1=enabled)");
-
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "debug flags: 0=disabled (default), 0x7fffffff=all");
@@ -1584,7 +1580,6 @@ static enum i40iw_status_code i40iw_setup_init_state(struct i40iw_handler *hdl,
 	if (status)
 		goto exit;
 	iwdev->obj_next = iwdev->obj_mem;
-	iwdev->push_mode = push_mode;
 
 	init_waitqueue_head(&iwdev->vchnl_waitq);
 	init_waitqueue_head(&dev->vf_reqs);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index a5e3349..314d191 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -201,38 +201,16 @@ static int i40iw_dealloc_ucontext(struct ib_ucontext *context)
  */
 static int i40iw_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
-	struct i40iw_ucontext *ucontext;
-	u64 db_addr_offset;
-	u64 push_offset;
-
-	ucontext = to_ucontext(context);
-	if (ucontext->iwdev->sc_dev.is_pf) {
-		db_addr_offset = I40IW_DB_ADDR_OFFSET;
-		push_offset = I40IW_PUSH_OFFSET;
-		if (vma->vm_pgoff)
-			vma->vm_pgoff += I40IW_PF_FIRST_PUSH_PAGE_INDEX - 1;
-	} else {
-		db_addr_offset = I40IW_VF_DB_ADDR_OFFSET;
-		push_offset = I40IW_VF_PUSH_OFFSET;
-		if (vma->vm_pgoff)
-			vma->vm_pgoff += I40IW_VF_FIRST_PUSH_PAGE_INDEX - 1;
-	}
+	struct i40iw_ucontext *ucontext = to_ucontext(context);
+	u64 dbaddr;
 
-	vma->vm_pgoff += db_addr_offset >> PAGE_SHIFT;
+	if (vma->vm_pgoff || vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
 
-	if (vma->vm_pgoff == (db_addr_offset >> PAGE_SHIFT)) {
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-		vma->vm_private_data = ucontext;
-	} else {
-		if ((vma->vm_pgoff - (push_offset >> PAGE_SHIFT)) % 2)
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-		else
-			vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	}
+	dbaddr = I40IW_DB_ADDR_OFFSET + pci_resource_start(ucontext->iwdev->ldev->pcidev, 0);
 
-	if (io_remap_pfn_range(vma, vma->vm_start,
-			       vma->vm_pgoff + (pci_resource_start(ucontext->iwdev->ldev->pcidev, 0) >> PAGE_SHIFT),
-			       PAGE_SIZE, vma->vm_page_prot))
+	if (io_remap_pfn_range(vma, vma->vm_start, dbaddr >> PAGE_SHIFT, PAGE_SIZE,
+			       pgprot_noncached(vma->vm_page_prot)))
 		return -EAGAIN;
 
 	return 0;
-- 
1.8.3.1

