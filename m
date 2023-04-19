Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C5F6E7F68
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 18:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjDSQS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 12:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjDSQSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 12:18:21 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD29273B;
        Wed, 19 Apr 2023 09:18:20 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id q5so17396774wmo.4;
        Wed, 19 Apr 2023 09:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681921098; x=1684513098;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bPbBUkq+UJhlsKaVe40uitnmx81R5jNbDC+Tu3XDd+8=;
        b=SyE1RoBpA+TNKMitt+cmt1NwwWaVw/Kg6PM8f6c5g5wbPsvpXtKf9769Col+yIbb4M
         6cIa36q3ay5iwF37q90mSZs4l/vJZD53uQovwj/sw/fXSMm9yxD/L5SH8cUlrKYEmo3Z
         RKLP5edwP4DCMlC76lZMiB4QGxObd7TaYr1tUMOqreCWO61D5VFJgRVYI4e532KnrzHZ
         kTu3m+FXYx+SXPLTfe9xnk2toNb/Hqz3lbPGQIlphmgjGkr4T+1vRSsWl/aWuqqB05qa
         JYP8Wq+GoLy+YeVPzNa39IFYRori3gXiZaHTNSbHuYblly/kKh+RRXBPXysy2c9NezAb
         pq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921098; x=1684513098;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bPbBUkq+UJhlsKaVe40uitnmx81R5jNbDC+Tu3XDd+8=;
        b=CPXRmi1FMSRa07KkLiE2RbkRGZQ8lnrcQbkii4XNj8FZjrvMYLRO9sYhrZqwn38cYj
         fTOKHBc8Dpy1bhn86oBi70pTlMEKclaAdB+7LDPJ4kgAl5z7fVHWeEwQDrglG8uz0fI1
         EZiD5w+i3/D6QNQMXgf7IOKxjvvWVYwoM3KXb65voO+WFlFiOrTj8No8Yn8SDognQ5io
         DTEEcKIJxw6IenB5ksiGgmnF5JXANhnfmn9ttKOCF/fgR8Vs0amkxJ2pU4+drx1hDW1F
         7hJfVj//XRtY7B2rFul2XoFkzJ4lhTfVBX0yHL0NGVmNenDbLXUt/mPFZAHoDfW+0D9b
         OMDQ==
X-Gm-Message-State: AAQBX9fXTBr29KWvf5LiFQs4poLop2gEM2ZrvR22/Vwf8n7NikJ71Z3y
        GHiJm4JO9gPPJF53hmoQHQHxATXkGug=
X-Google-Smtp-Source: AKy350Z0kCRMHAFCDDUqpoWE90GT+15XzBY0+g3DzHOl91xXRRrQS1sQrXGGe0sI16jUiFlSxdhqaw==
X-Received: by 2002:a05:600c:b49:b0:3f1:79ad:f3a8 with SMTP id k9-20020a05600c0b4900b003f179adf3a8mr4937433wmr.16.1681921098408;
        Wed, 19 Apr 2023 09:18:18 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id iw18-20020a05600c54d200b003f174cafcdasm2684106wmb.7.2023.04.19.09.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:18:18 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Theune <ct@flyingcircus.io>
Subject: [PATCH 5.10] xfs: drop submit side trans alloc for append ioends
Date:   Wed, 19 Apr 2023 19:18:13 +0300
Message-Id: <20230419161813.2044576-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 7cd3099f4925d7c15887d1940ebd65acd66100f5 upstream.

Per-inode ioend completion batching has a log reservation deadlock
vector between preallocated append transactions and transactions
that are acquired at completion time for other purposes (i.e.,
unwritten extent conversion or COW fork remaps). For example, if the
ioend completion workqueue task executes on a batch of ioends that
are sorted such that an append ioend sits at the tail, it's possible
for the outstanding append transaction reservation to block
allocation of transactions required to process preceding ioends in
the list.

Append ioend completion is historically the common path for on-disk
inode size updates. While file extending writes may have completed
sometime earlier, the on-disk inode size is only updated after
successful writeback completion. These transactions are preallocated
serially from writeback context to mitigate concurrency and
associated log reservation pressure across completions processed by
multi-threaded workqueue tasks.

However, now that delalloc blocks unconditionally map to unwritten
extents at physical block allocation time, size updates via append
ioends are relatively rare. This means that inode size updates most
commonly occur as part of the preexisting completion time
transaction to convert unwritten extents. As a result, there is no
longer a strong need to preallocate size update transactions.

Remove the preallocation of inode size update transactions to avoid
the ioend completion processing log reservation deadlock. Instead,
continue to send all potential size extending ioends to workqueue
context for completion and allocate the transaction from that
context. This ensures that no outstanding log reservation is owned
by the ioend completion worker task when it begins to process
ioends.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Christian Theune <ct@flyingcircus.io>
Link: https://lore.kernel.org/linux-xfs/CAOQ4uxjj2UqA0h4Y31NbmpHksMhVrXfXjLG4Tnz3zq_UR-3gSA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---

Greg,

One more fix from v5.13 that I missed from my backports.

Thanks,
Amir.

 fs/xfs/xfs_aops.c | 45 +++------------------------------------------
 1 file changed, 3 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 953de843d9c3..e341d6531e68 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -39,33 +39,6 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
 		XFS_I(ioend->io_inode)->i_d.di_size;
 }
 
-STATIC int
-xfs_setfilesize_trans_alloc(
-	struct iomap_ioend	*ioend)
-{
-	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	ioend->io_private = tp;
-
-	/*
-	 * We may pass freeze protection with a transaction.  So tell lockdep
-	 * we released it.
-	 */
-	__sb_writers_release(ioend->io_inode->i_sb, SB_FREEZE_FS);
-	/*
-	 * We hand off the transaction to the completion thread now, so
-	 * clear the flag here.
-	 */
-	xfs_trans_clear_context(tp);
-	return 0;
-}
-
 /*
  * Update on-disk file size now that data has been written to disk.
  */
@@ -191,12 +164,10 @@ xfs_end_ioend(
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_type == IOMAP_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
-	else
-		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
 
+	if (!error && xfs_ioend_is_append(ioend))
+		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 done:
-	if (ioend->io_private)
-		error = xfs_setfilesize_ioend(ioend, error);
 	iomap_finish_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
 }
@@ -246,7 +217,7 @@ xfs_end_io(
 
 static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
 {
-	return ioend->io_private ||
+	return xfs_ioend_is_append(ioend) ||
 		ioend->io_type == IOMAP_UNWRITTEN ||
 		(ioend->io_flags & IOMAP_F_SHARED);
 }
@@ -259,8 +230,6 @@ xfs_end_bio(
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	unsigned long		flags;
 
-	ASSERT(xfs_ioend_needs_workqueue(ioend));
-
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
 	if (list_empty(&ip->i_ioend_list))
 		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
@@ -510,14 +479,6 @@ xfs_prepare_ioend(
 				ioend->io_offset, ioend->io_size);
 	}
 
-	/* Reserve log space if we might write beyond the on-disk inode size. */
-	if (!status &&
-	    ((ioend->io_flags & IOMAP_F_SHARED) ||
-	     ioend->io_type != IOMAP_UNWRITTEN) &&
-	    xfs_ioend_is_append(ioend) &&
-	    !ioend->io_private)
-		status = xfs_setfilesize_trans_alloc(ioend);
-
 	memalloc_nofs_restore(nofs_flag);
 
 	if (xfs_ioend_needs_workqueue(ioend))
-- 
2.34.1

