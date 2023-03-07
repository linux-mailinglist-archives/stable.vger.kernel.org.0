Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36906AED83
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjCGSFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCGSEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:04:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9B0A42E7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:57:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1587D6150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063C2C433EF;
        Tue,  7 Mar 2023 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211838;
        bh=Clc2LlgU3DfcK5nn/4ngzN3/NLuDljWS9YTrhLlzDE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvNbZYwQSLgQ7/KSiZk3b28/0a2hsQaacR32gWoP0Sen1dbVVmA4gx+FA/k/dvCwj
         ZccpXKt4NSYtKvNfjFmF2ZGtDfeEIjOitSWjpSWEAP81+E1FVCMt72V0zU2DjRWKq7
         3FubCGFNMXbrlZzF002qeDuonPWiw7uPU1LnIK7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve Sistare <steven.sistare@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.2 0992/1001] vfio/type1: track locked_vm per dma
Date:   Tue,  7 Mar 2023 18:02:44 +0100
Message-Id: <20230307170105.325908701@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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


