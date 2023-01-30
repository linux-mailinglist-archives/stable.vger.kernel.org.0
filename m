Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6616680FAD
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjA3Nz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbjA3Nzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:55:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76882392AD
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:55:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30E45B8114D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913CFC433D2;
        Mon, 30 Jan 2023 13:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086949;
        bh=zphkk/STirm+8kjrMKHxIPjeZOC7FHtDUn63nYLdnmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cc3Baa1q31a/ugXG05OxuEr3/J4IoXr6AhfmBIT7qtdraceNePGu//p5OyiAzJqvo
         XIwPd0A7ME75O9cJVior1dr8jGz4BAYQ+2PymMA0Zyn0X+L60rBlvUwnSiAXFwQFl4
         GKl4h3xQjHI7x0whf1fhUBiaK3oe6xv9tA2483h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/313] IB/hfi1: Remove user expected buffer invalidate race
Date:   Mon, 30 Jan 2023 14:48:05 +0100
Message-Id: <20230130134339.034002471@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit b3deec25847bda34e34d5d7be02f633caf000bd8 ]

During setup, there is a possible race between a page invalidate
and hardware programming.  Add a covering invalidate over the user
target range during setup.  If anything within that range is
invalidated during setup, fail the setup.  Once set up, each
TID will have its own invalidate callback and invalidate.

Fixes: 3889551db212 ("RDMA/hfi1: Use mmu_interval_notifier_insert for user_exp_rcv")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167328549178.1472310.9867497376936699488.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 58 +++++++++++++++++++++--
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |  2 +
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index f402af1e2903..b02f2f0809c8 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -23,6 +23,9 @@ static void cacheless_tid_rb_remove(struct hfi1_filedata *fdata,
 static bool tid_rb_invalidate(struct mmu_interval_notifier *mni,
 			      const struct mmu_notifier_range *range,
 			      unsigned long cur_seq);
+static bool tid_cover_invalidate(struct mmu_interval_notifier *mni,
+			         const struct mmu_notifier_range *range,
+			         unsigned long cur_seq);
 static int program_rcvarray(struct hfi1_filedata *fd, struct tid_user_buf *,
 			    struct tid_group *grp,
 			    unsigned int start, u16 count,
@@ -36,6 +39,9 @@ static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node);
 static const struct mmu_interval_notifier_ops tid_mn_ops = {
 	.invalidate = tid_rb_invalidate,
 };
+static const struct mmu_interval_notifier_ops tid_cover_ops = {
+	.invalidate = tid_cover_invalidate,
+};
 
 /*
  * Initialize context and file private data needed for Expected
@@ -254,6 +260,7 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 		tididx = 0, mapped, mapped_pages = 0;
 	u32 *tidlist = NULL;
 	struct tid_user_buf *tidbuf;
+	unsigned long mmu_seq = 0;
 
 	if (!PAGE_ALIGNED(tinfo->vaddr))
 		return -EINVAL;
@@ -264,6 +271,7 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	if (!tidbuf)
 		return -ENOMEM;
 
+	mutex_init(&tidbuf->cover_mutex);
 	tidbuf->vaddr = tinfo->vaddr;
 	tidbuf->length = tinfo->length;
 	tidbuf->psets = kcalloc(uctxt->expected_count, sizeof(*tidbuf->psets),
@@ -273,6 +281,16 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 		goto fail_release_mem;
 	}
 
+	if (fd->use_mn) {
+		ret = mmu_interval_notifier_insert(
+			&tidbuf->notifier, current->mm,
+			tidbuf->vaddr, tidbuf->npages * PAGE_SIZE,
+			&tid_cover_ops);
+		if (ret)
+			goto fail_release_mem;
+		mmu_seq = mmu_interval_read_begin(&tidbuf->notifier);
+	}
+
 	pinned = pin_rcv_pages(fd, tidbuf);
 	if (pinned <= 0) {
 		ret = (pinned < 0) ? pinned : -ENOSPC;
@@ -415,6 +433,20 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	unpin_rcv_pages(fd, tidbuf, NULL, mapped_pages, pinned - mapped_pages,
 			false);
 
+	if (fd->use_mn) {
+		/* check for an invalidate during setup */
+		bool fail = false;
+
+		mutex_lock(&tidbuf->cover_mutex);
+		fail = mmu_interval_read_retry(&tidbuf->notifier, mmu_seq);
+		mutex_unlock(&tidbuf->cover_mutex);
+
+		if (fail) {
+			ret = -EBUSY;
+			goto fail_unprogram;
+		}
+	}
+
 	tinfo->tidcnt = tididx;
 	tinfo->length = mapped_pages * PAGE_SIZE;
 
@@ -424,6 +456,8 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 		goto fail_unprogram;
 	}
 
+	if (fd->use_mn)
+		mmu_interval_notifier_remove(&tidbuf->notifier);
 	kfree(tidbuf->pages);
 	kfree(tidbuf->psets);
 	kfree(tidbuf);
@@ -442,6 +476,8 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	fd->tid_used -= pageset_count;
 	spin_unlock(&fd->tid_lock);
 fail_unpin:
+	if (fd->use_mn)
+		mmu_interval_notifier_remove(&tidbuf->notifier);
 	if (pinned > 0)
 		unpin_rcv_pages(fd, tidbuf, NULL, 0, pinned, false);
 fail_release_mem:
@@ -740,11 +776,6 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 			&tid_mn_ops);
 		if (ret)
 			goto out_unmap;
-		/*
-		 * FIXME: This is in the wrong order, the notifier should be
-		 * established before the pages are pinned by pin_rcv_pages.
-		 */
-		mmu_interval_read_begin(&node->notifier);
 	}
 	fd->entry_to_rb[node->rcventry - uctxt->expected_base] = node;
 
@@ -919,6 +950,23 @@ static bool tid_rb_invalidate(struct mmu_interval_notifier *mni,
 	return true;
 }
 
+static bool tid_cover_invalidate(struct mmu_interval_notifier *mni,
+			         const struct mmu_notifier_range *range,
+			         unsigned long cur_seq)
+{
+	struct tid_user_buf *tidbuf =
+		container_of(mni, struct tid_user_buf, notifier);
+
+	/* take action only if unmapping */
+	if (range->event == MMU_NOTIFY_UNMAP) {
+		mutex_lock(&tidbuf->cover_mutex);
+		mmu_interval_set_seq(mni, cur_seq);
+		mutex_unlock(&tidbuf->cover_mutex);
+	}
+
+	return true;
+}
+
 static void cacheless_tid_rb_remove(struct hfi1_filedata *fdata,
 				    struct tid_rb_node *tnode)
 {
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index 2ddb3dac7d91..f8ee997d0050 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -16,6 +16,8 @@ struct tid_pageset {
 };
 
 struct tid_user_buf {
+	struct mmu_interval_notifier notifier;
+	struct mutex cover_mutex;
 	unsigned long vaddr;
 	unsigned long length;
 	unsigned int npages;
-- 
2.39.0



