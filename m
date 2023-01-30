Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A686812BE
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbjA3OZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbjA3OYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:24:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9F041B45
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:23:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0330761087
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8EFC433EF;
        Mon, 30 Jan 2023 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088552;
        bh=E2TA4K6Tou73jUdfWMJpr+seil/s12NByKZyBtXxGB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNI/Zz6/7+///If7YET/d6P0q/8dUNU8tDtrresTVd1cLuZYmYrUkNZzbefR16s7S
         Dw2YZ177RedDgs/fT1K0nzcn+1G3XFxz1lkOmiYLC7MJ1Jq1WT1y0WmB6AyRZ5Ot8/
         oteRkUj247T2o5zDr/bPwejGQdOOlqzMU5UbI9Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/143] IB/hfi1: Immediately remove invalid memory from hardware
Date:   Mon, 30 Jan 2023 14:51:16 +0100
Message-Id: <20230130134307.675499522@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit 1c7edde1b5720ddb0aff5ca8c7f605a0f92526eb ]

When a user expected receive page is unmapped, it should be
immediately removed from hardware rather than depend on a
reaction from user space.

Fixes: 2677a7680e77 ("IB/hfi1: Fix memory leak during unexpected shutdown")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167328548663.1472310.7871808081861622659.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 43 +++++++++++++++--------
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |  1 +
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index ba61d327a85d..b70d1b135ee4 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -70,8 +70,9 @@ static int program_rcvarray(struct hfi1_filedata *fd, struct tid_user_buf *,
 			    unsigned int start, u16 count,
 			    u32 *tidlist, unsigned int *tididx,
 			    unsigned int *pmapped);
-static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
-			      struct tid_group **grp);
+static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo);
+static void __clear_tid_node(struct hfi1_filedata *fd,
+			     struct tid_rb_node *node);
 static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node);
 
 static const struct mmu_interval_notifier_ops tid_mn_ops = {
@@ -511,7 +512,7 @@ int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,
 
 	mutex_lock(&uctxt->exp_mutex);
 	for (tididx = 0; tididx < tinfo->tidcnt; tididx++) {
-		ret = unprogram_rcvarray(fd, tidinfo[tididx], NULL);
+		ret = unprogram_rcvarray(fd, tidinfo[tididx]);
 		if (ret) {
 			hfi1_cdbg(TID, "Failed to unprogram rcv array %d",
 				  ret);
@@ -767,6 +768,7 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 	}
 
 	node->fdata = fd;
+	mutex_init(&node->invalidate_mutex);
 	node->phys = page_to_phys(pages[0]);
 	node->npages = npages;
 	node->rcventry = rcventry;
@@ -806,8 +808,7 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 	return -EFAULT;
 }
 
-static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
-			      struct tid_group **grp)
+static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
@@ -830,9 +831,6 @@ static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 
-	if (grp)
-		*grp = node->grp;
-
 	if (fd->use_mn)
 		mmu_interval_notifier_remove(&node->notifier);
 	cacheless_tid_rb_remove(fd, node);
@@ -840,23 +838,34 @@ static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
 	return 0;
 }
 
-static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
+static void __clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 
+	mutex_lock(&node->invalidate_mutex);
+	if (node->freed)
+		goto done;
+	node->freed = true;
+
 	trace_hfi1_exp_tid_unreg(uctxt->ctxt, fd->subctxt, node->rcventry,
 				 node->npages,
 				 node->notifier.interval_tree.start, node->phys,
 				 node->dma_addr);
 
-	/*
-	 * Make sure device has seen the write before we unpin the
-	 * pages.
-	 */
+	/* Make sure device has seen the write before pages are unpinned */
 	hfi1_put_tid(dd, node->rcventry, PT_INVALID_FLUSH, 0, 0);
 
 	unpin_rcv_pages(fd, NULL, node, 0, node->npages, true);
+done:
+	mutex_unlock(&node->invalidate_mutex);
+}
+
+static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
+{
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+
+	__clear_tid_node(fd, node);
 
 	node->grp->used--;
 	node->grp->map &= ~(1 << (node->rcventry - node->grp->base));
@@ -915,10 +924,16 @@ static bool tid_rb_invalidate(struct mmu_interval_notifier *mni,
 	if (node->freed)
 		return true;
 
+	/* take action only if unmapping */
+	if (range->event != MMU_NOTIFY_UNMAP)
+		return true;
+
 	trace_hfi1_exp_tid_inval(uctxt->ctxt, fdata->subctxt,
 				 node->notifier.interval_tree.start,
 				 node->rcventry, node->npages, node->dma_addr);
-	node->freed = true;
+
+	/* clear the hardware rcvarray entry */
+	__clear_tid_node(fdata, node);
 
 	spin_lock(&fdata->invalid_lock);
 	if (fdata->invalid_tid_idx < uctxt->expected_count) {
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index d45c7b6988d4..ba06ab3b4769 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -68,6 +68,7 @@ struct tid_user_buf {
 struct tid_rb_node {
 	struct mmu_interval_notifier notifier;
 	struct hfi1_filedata *fdata;
+	struct mutex invalidate_mutex; /* covers hw removal */
 	unsigned long phys;
 	struct tid_group *grp;
 	u32 rcventry;
-- 
2.39.0



