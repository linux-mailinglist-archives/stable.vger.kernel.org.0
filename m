Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D296AF2C5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCGS4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjCGS4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:56:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8EAA18BF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:43:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82F8DB819DC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D16C433EF;
        Tue,  7 Mar 2023 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214604;
        bh=Clc2LlgU3DfcK5nn/4ngzN3/NLuDljWS9YTrhLlzDE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUtpmyWmaVEQOMKb4W0kUaynzC7UtKEkKFI2XhR65mZZUQsTYkMVJDf3Yxb3DLOln
         tHexGA/kDkpoiuyWP8/XuokP3gdzhGFkFkjxu7Xm8dAqDfBpYHRhE2+ZIqP7F7kP8E
         ZUQUPOC5d20YU1B7M8Tuq+bJzQiEUWV3RzhgcNa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve Sistare <steven.sistare@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.1 876/885] vfio/type1: track locked_vm per dma
Date:   Tue,  7 Mar 2023 18:03:30 +0100
Message-Id: <20230307170039.846599476@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Sistare <steven.sistare@oracle.com>

commit 18e292705ba21cc9b3227b9ad5b1c28973605ee5 upstream.

Track locked_vm per dma struct, and create a new subroutine, both for use
in a subsequent patch.  No functional change.

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1675184289-267876-4-git-send-email-steven.sistare@oracle.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/vfio_iommu_type1.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -101,6 +101,7 @@ struct vfio_dma {
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
 	struct mm_struct	*mm;
+	size_t			locked_vm;
 };
 
 struct vfio_batch {
@@ -413,6 +414,19 @@ static int vfio_iova_put_vfio_pfn(struct
 	return ret;
 }
 
+static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
+			bool lock_cap, long npage)
+{
+	int ret = mmap_write_lock_killable(mm);
+
+	if (ret)
+		return ret;
+
+	ret = __account_locked_vm(mm, abs(npage), npage > 0, task, lock_cap);
+	mmap_write_unlock(mm);
+	return ret;
+}
+
 static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 {
 	struct mm_struct *mm;
@@ -425,12 +439,9 @@ static int vfio_lock_acct(struct vfio_dm
 	if (async && !mmget_not_zero(mm))
 		return -ESRCH; /* process exited */
 
-	ret = mmap_write_lock_killable(mm);
-	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
-					  dma->lock_cap);
-		mmap_write_unlock(mm);
-	}
+	ret = mm_lock_acct(dma->task, mm, dma->lock_cap, npage);
+	if (!ret)
+		dma->locked_vm += npage;
 
 	if (async)
 		mmput(mm);


