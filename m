Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4805B68112B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbjA3OKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237249AbjA3OKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:10:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79283BD93
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:10:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65C1761049
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14411C433EF;
        Mon, 30 Jan 2023 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087833;
        bh=QuXOCLgTApXLN9OlnL3MqZnNiKcAuDnCqPXRHHO7ycI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2OSHc5j7ya/V2sZhBZsWhfAqz/y0OuL0UKDhont7RJoAmge6Uq1jg3AkxNMGEYUI
         lO+rhuHg0wNi6MXuQVl5GRXjDmTjf3q4ARZEXj8EVpMhjZ0z0TQALl5oNyg2kxAKWf
         UAeF+fTXFki1YeuQgCTYf44WtOGu9dtVI4nw8IZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/204] IB/hfi1: Immediately remove invalid memory from hardware
Date:   Mon, 30 Jan 2023 14:49:49 +0100
Message-Id: <20230130134317.353781268@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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
index 5b93a1aace9d..8337d995aa26 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -28,8 +28,9 @@ static int program_rcvarray(struct hfi1_filedata *fd, struct tid_user_buf *,
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
@@ -469,7 +470,7 @@ int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,
 
 	mutex_lock(&uctxt->exp_mutex);
 	for (tididx = 0; tididx < tinfo->tidcnt; tididx++) {
-		ret = unprogram_rcvarray(fd, tidinfo[tididx], NULL);
+		ret = unprogram_rcvarray(fd, tidinfo[tididx]);
 		if (ret) {
 			hfi1_cdbg(TID, "Failed to unprogram rcv array %d",
 				  ret);
@@ -724,6 +725,7 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 	}
 
 	node->fdata = fd;
+	mutex_init(&node->invalidate_mutex);
 	node->phys = page_to_phys(pages[0]);
 	node->npages = npages;
 	node->rcventry = rcventry;
@@ -763,8 +765,7 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 	return -EFAULT;
 }
 
-static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
-			      struct tid_group **grp)
+static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
@@ -787,9 +788,6 @@ static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 
-	if (grp)
-		*grp = node->grp;
-
 	if (fd->use_mn)
 		mmu_interval_notifier_remove(&node->notifier);
 	cacheless_tid_rb_remove(fd, node);
@@ -797,23 +795,34 @@ static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
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
@@ -872,10 +881,16 @@ static bool tid_rb_invalidate(struct mmu_interval_notifier *mni,
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
index 8c53e416bf84..2ddb3dac7d91 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -27,6 +27,7 @@ struct tid_user_buf {
 struct tid_rb_node {
 	struct mmu_interval_notifier notifier;
 	struct hfi1_filedata *fdata;
+	struct mutex invalidate_mutex; /* covers hw removal */
 	unsigned long phys;
 	struct tid_group *grp;
 	u32 rcventry;
-- 
2.39.0



