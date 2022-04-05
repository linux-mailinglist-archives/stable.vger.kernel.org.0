Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644404F38A2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242654AbiDEL0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349501AbiDEJt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02B89B;
        Tue,  5 Apr 2022 02:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5DCCCCE1C90;
        Tue,  5 Apr 2022 09:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73263C385A3;
        Tue,  5 Apr 2022 09:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152067;
        bh=AvslXiiGZCRFOeGrGZqo2rx705V5+cRos00EJU0PUxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOWe46uAWDXGbiGsj6/89e2cbBwCk5rwnEG6PNWsoyqBWG57rnrIYBSmhre/SjaQ7
         UQ1fO6zJxBUkBqBh6xwjFRJ88FQ/Pg6g8KZjaqkqGG0Y8bLECQFHWLVTeQA/4wbMbn
         UptkRSJpAl8HBqnSNeJ3gol9sXVG75JWHlnXC/cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghua Huang <yonghua.huang@intel.com>,
        Fei Li <fei1.li@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 643/913] virt: acrn: obtain pa from VMA with PFNMAP flag
Date:   Tue,  5 Apr 2022 09:28:25 +0200
Message-Id: <20220405070359.114200785@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghua Huang <yonghua.huang@intel.com>

[ Upstream commit 8a6e85f75a83d16a71077e41f2720c691f432002 ]

 acrn_vm_ram_map can't pin the user pages with VM_PFNMAP flag
 by calling get_user_pages_fast(), the PA(physical pages)
 may be mapped by kernel driver and set PFNMAP flag.

 This patch fixes logic to setup EPT mapping for PFN mapped RAM region
 by checking the memory attribute before adding EPT mapping for them.

Fixes: 88f537d5e8dd ("virt: acrn: Introduce EPT mapping management")
Signed-off-by: Yonghua Huang <yonghua.huang@intel.com>
Signed-off-by: Fei Li <fei1.li@intel.com>
Link: https://lore.kernel.org/r/20220228022212.419406-1-yonghua.huang@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
-- 
2.34.1



