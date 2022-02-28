Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5911A4C60BF
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 03:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiB1CHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Feb 2022 21:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiB1CHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Feb 2022 21:07:13 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F9C6B084;
        Sun, 27 Feb 2022 18:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646013995; x=1677549995;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dBj8IZqKdQrN7LWqpr45uLHPvsxj4KiRmjJ+NZe7L/4=;
  b=Z8c7wj1o95ptdUePhqY22HSfUGp5TZDRRC48hvsGB0XFi/oFNt0/0iGx
   7vFYGO+/t9S3NkxgPpioJPNHUW7bS4zkalLdM8BEYTWg5bQ2jQ1BSvaVS
   SHeDUq9Agp3NqR1J+lLwbJYU980oKt/YyhdQQTMvywlIHw2gVlV98VJo6
   v7zak3+K3lV7TMVJJI9JPTXLHSogAZk5Dx1neF0nWHTiB49kKzPSGbHu/
   Qrh3Dk98UW2/PrI7TauNxZnpOyimwnmG41b/C39Gv5R5NIV9FvN7jmR3b
   n23UJQDDqBuqw866al+JgZMx6aP8FMy39VgkDzXzo2QjFivyRtW5CPjM9
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="252707116"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="252707116"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:06:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777935759"
Received: from w3.sh.intel.com ([10.74.142.175])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2022 18:06:33 -0800
From:   Yonghua Huang <yonghua.huang@intel.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        reinette.chatre@intel.com, zhi.a.wang@intel.com,
        yu1.wang@intel.com, fei1.Li@intel.com,
        Yonghua Huang <yonghua.huang@intel.com>,
        Fei Li <fei1.li@intel.com>
Subject: [PATCH] virt: acrn: obtain pa from VMA with PFNMAP flag
Date:   Mon, 28 Feb 2022 05:22:12 +0300
Message-Id: <20220228022212.419406-1-yonghua.huang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 acrn_vm_ram_map can't pin the user pages with VM_PFNMAP flag
 by calling get_user_pages_fast(), the PA(physical pages)
 may be mapped by kernel driver and set PFNMAP flag.

 This patch fixes logic to setup EPT mapping for PFN mapped RAM region
 by checking the memory attribute before adding EPT mapping for them.

Fixes: 88f537d5e8dd ("virt: acrn: Introduce EPT mapping management")
Signed-off-by: Yonghua Huang <yonghua.huang@intel.com>
Signed-off-by: Fei Li <fei1.li@intel.com>
---
 drivers/virt/acrn/mm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c
index c4f2e15c8a2b..3b1b1e7a844b 100644
--- a/drivers/virt/acrn/mm.c
+++ b/drivers/virt/acrn/mm.c
@@ -162,10 +162,34 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	void *remap_vaddr;
 	int ret, pinned;
 	u64 user_vm_pa;
+	unsigned long pfn;
+	struct vm_area_struct *vma;
 
 	if (!vm || !memmap)
 		return -EINVAL;
 
+	mmap_read_lock(current->mm);
+	vma = vma_lookup(current->mm, memmap->vma_base);
+	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
+		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
+			mmap_read_unlock(current->mm);
+			return -EINVAL;
+		}
+
+		ret = follow_pfn(vma, memmap->vma_base, &pfn);
+		mmap_read_unlock(current->mm);
+		if (ret < 0) {
+			dev_dbg(acrn_dev.this_device,
+				"Failed to lookup PFN at VMA:%pK.\n", (void *)memmap->vma_base);
+			return ret;
+		}
+
+		return acrn_mm_region_add(vm, memmap->user_vm_pa,
+			 PFN_PHYS(pfn), memmap->len,
+			 ACRN_MEM_TYPE_WB, memmap->attr);
+	}
+	mmap_read_unlock(current->mm);
+
 	/* Get the page number of the map region */
 	nr_pages = memmap->len >> PAGE_SHIFT;
 	pages = vzalloc(nr_pages * sizeof(struct page *));

base-commit: 73878e5eb1bd3c9656685ca60bc3a49d17311e0c
-- 
2.25.1

