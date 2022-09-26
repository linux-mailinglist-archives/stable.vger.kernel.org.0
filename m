Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6465EA1B1
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbiIZKzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236948AbiIZKyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:54:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6F25A3F3;
        Mon, 26 Sep 2022 03:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C31160AF0;
        Mon, 26 Sep 2022 10:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3765C433C1;
        Mon, 26 Sep 2022 10:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188066;
        bh=hHRz2E5J/ZR57vbCMbyiREn4E4IpbW/zsRjMDzFY5Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZSIyFvFHjSIbK4TaQSOZbguNmks7N1OnrubCvugLrbVuHCxHi14sjtS7ekgmOMSy
         aOxSEdynkB+3zBAhMQBRdvhPLns8DzB4B2Jfshd2hYTB1NuFc8Owdoz70pryo1Y/w8
         2K0Q83w7LUKPYxOj8dtDOsXpa3msL5mth9Kam2VY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/141] vfio/type1: Change success value of vaddr_get_pfn()
Date:   Mon, 26 Sep 2022 12:10:56 +0200
Message-Id: <20220926100755.607176191@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit be16c1fd99f41abebc0bf965d5d29cd18c9d271e ]

vaddr_get_pfn() simply returns 0 on success.  Have it report the number
of pfns successfully gotten instead, whether from page pinning or
follow_fault_pfn(), which will be used later when batching pinning.

Change the last check in vfio_pin_pages_remote() for consistency with
the other two.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Stable-dep-of: 873aefb376bb ("vfio/type1: Unpin zero pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index fbd438e9b9b0..2d26244f9c32 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -464,6 +464,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 	return ret;
 }
 
+/*
+ * Returns the positive number of pfns successfully obtained or a negative
+ * error code.
+ */
 static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 			 int prot, unsigned long *pfn)
 {
@@ -480,7 +484,6 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 				    page, NULL, NULL);
 	if (ret == 1) {
 		*pfn = page_to_pfn(page[0]);
-		ret = 0;
 		goto done;
 	}
 
@@ -494,8 +497,12 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 		if (ret == -EAGAIN)
 			goto retry;
 
-		if (!ret && !is_invalid_reserved_pfn(*pfn))
-			ret = -EFAULT;
+		if (!ret) {
+			if (is_invalid_reserved_pfn(*pfn))
+				ret = 1;
+			else
+				ret = -EFAULT;
+		}
 	}
 done:
 	mmap_read_unlock(mm);
@@ -521,7 +528,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		return -ENODEV;
 
 	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	pinned++;
@@ -548,7 +555,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
 		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
-		if (ret)
+		if (ret < 0)
 			break;
 
 		if (pfn != *pfn_base + pinned ||
@@ -574,7 +581,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-	if (ret) {
+	if (ret < 0) {
 		if (!rsvd) {
 			for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
 				put_pfn(pfn, dma->prot);
@@ -618,7 +625,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 		return -ENODEV;
 
 	ret = vaddr_get_pfn(mm, vaddr, dma->prot, pfn_base);
-	if (!ret && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
+	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
-- 
2.35.1



