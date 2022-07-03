Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE770564542
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiGCFFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGCFFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:05:06 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B776AE62;
        Sat,  2 Jul 2022 22:05:05 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e28so8816603wra.0;
        Sat, 02 Jul 2022 22:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8CqxtVEKuLn9aRe7XQ1tznSxDum+RXwj5TnVmn5vKzE=;
        b=WxVl2ic3LpIusiXv+2+j2f9D6ebQqZ4NNToDZ3ySUpcpWWwkVE+Po/Tgb0dqmRm7Pe
         G/1cQUb5XkXDX5tGlfKXYdMqqLY+suEIekrvk0yGjsaW+MXodTYhz7Q5Si9ullW9xf8/
         xT3yztWxj/3qHek4ds8Woaa5meNJ7E1JxZ4iU/2MMVU3yROLRRKF/SNU852oLpPz85Qu
         cBHFVFbmZtl6E2JSkcBkM36Vv/ogQRI5EcpLkIOPd2yBWOC+1lmYp1KEi97azt+W4f8L
         FNWlQ+R3Dk3kSKrhy9DtWfQ0iaqU+PX8tfCF6SMdmD910hyC98m8zbEUjAKmdu52RKNQ
         +iFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8CqxtVEKuLn9aRe7XQ1tznSxDum+RXwj5TnVmn5vKzE=;
        b=gNnPvfpnYYauVQxD4tKtoUdXmsVW8LfYA6KGwMyB8voGIUBtiihJsxHUTXt62KBdrq
         WK3AQ5N9PW6SLgz7LS3XCipo5lSlUTVbnNBaLr84e2XSOQwLOizpOBQ6zv2/fn/ZNuHn
         6sCVLEJeNOGtoB5Qqp3+JQYuwTNgx4Bh54weZffbhToSKDaSS+TS+5cC0wO0cSWxK7nm
         HM4Ml99io41Rh8GWcJg0OUe3R2ILhDowEeQCp1X09J4iEmULxQZWR4tAE3TPPqX+ZoQ2
         xOOlEIZR5hgJTzh5h3wGDfhU0e8NdKOzSKx4b1FYlXb+41kHsuukqGKFeTcDNhpgiTQO
         kWOg==
X-Gm-Message-State: AJIora9VRtjRtmZN9PUdzyKTLMWUZNOfSPqr0flRabvr4SXbN2b5TysV
        Q5oDMLTUYOisYuVvwjZi65A=
X-Google-Smtp-Source: AGRyM1vTuqwTY52soI/9w6r0rqIAGYkmt48+19YY+QwFN/VLM1+hXFYtPEHhDOEsgAwMk1dTVVFvXQ==
X-Received: by 2002:a5d:6481:0:b0:21d:231e:83b4 with SMTP id o1-20020a5d6481000000b0021d231e83b4mr20359671wri.689.1656824703080;
        Sat, 02 Jul 2022 22:05:03 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id e2-20020adfdbc2000000b0021b9f126fd3sm27028952wrj.14.2022.07.02.22.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 22:05:02 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 v3 1/7] xfs: use current->journal_info for detecting transaction recursion
Date:   Sun,  3 Jul 2022 08:04:50 +0300
Message-Id: <20220703050456.3222610-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703050456.3222610-1-amir73il@gmail.com>
References: <20220703050456.3222610-1-amir73il@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

commit 756b1c343333a5aefcc26b0409f3fd16f72281bf upstream.

Because the iomap code using PF_MEMALLOC_NOFS to detect transaction
recursion in XFS is just wrong. Remove it from the iomap code and
replace it with XFS specific internal checks using
current->journal_info instead.

[djwong: This change also realigns the lifetime of NOFS flag changes to
match the incore transaction, instead of the inconsistent scheme we have
now.]

Fixes: 9070733b4efa ("xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c    |  7 -------
 fs/xfs/libxfs/xfs_btree.c | 12 ++++++++++--
 fs/xfs/xfs_aops.c         | 17 +++++++++++++++--
 fs/xfs/xfs_trans.c        | 20 +++++---------------
 fs/xfs/xfs_trans.h        | 30 ++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 26 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index dd33b31b0a82..86297f59b43e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1460,13 +1460,6 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
 			PF_MEMALLOC))
 		goto redirty;
 
-	/*
-	 * Given that we do not allow direct reclaim to call us, we should
-	 * never be called in a recursive filesystem reclaim context.
-	 */
-	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
-		goto redirty;
-
 	/*
 	 * Is this page beyond the end of the file?
 	 *
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 98c82f4935e1..24c7d30e41df 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2811,7 +2811,7 @@ xfs_btree_split_worker(
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
 	unsigned long		pflags;
-	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
+	unsigned long		new_pflags = 0;
 
 	/*
 	 * we are in a transaction context here, but may also be doing work
@@ -2823,12 +2823,20 @@ xfs_btree_split_worker(
 		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 
 	current_set_flags_nested(&pflags, new_pflags);
+	xfs_trans_set_context(args->cur->bc_tp);
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
-	complete(args->done);
 
+	xfs_trans_clear_context(args->cur->bc_tp);
 	current_restore_flags_nested(&pflags, new_pflags);
+
+	/*
+	 * Do not access args after complete() has run here. We don't own args
+	 * and the owner may run and free args before we return here.
+	 */
+	complete(args->done);
+
 }
 
 /*
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4b76a32d2f16..953de843d9c3 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -62,7 +62,7 @@ xfs_setfilesize_trans_alloc(
 	 * We hand off the transaction to the completion thread now, so
 	 * clear the flag here.
 	 */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	xfs_trans_clear_context(tp);
 	return 0;
 }
 
@@ -125,7 +125,7 @@ xfs_setfilesize_ioend(
 	 * thus we need to mark ourselves as being in a transaction manually.
 	 * Similarly for freeze protection.
 	 */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	xfs_trans_set_context(tp);
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
 
 	/* we abort the update if there was an IO error */
@@ -577,6 +577,12 @@ xfs_vm_writepage(
 {
 	struct xfs_writepage_ctx wpc = { };
 
+	if (WARN_ON_ONCE(current->journal_info)) {
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+		return 0;
+	}
+
 	return iomap_writepage(page, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
 
@@ -587,6 +593,13 @@ xfs_vm_writepages(
 {
 	struct xfs_writepage_ctx wpc = { };
 
+	/*
+	 * Writing back data in a transaction context can result in recursive
+	 * transactions. This is bad, so issue a warning and get out of here.
+	 */
+	if (WARN_ON_ONCE(current->journal_info))
+		return 0;
+
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c94e71f741b6..2d7deacea2cf 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -68,6 +68,7 @@ xfs_trans_free(
 	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	trace_xfs_trans_free(tp, _RET_IP_);
+	xfs_trans_clear_context(tp);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
@@ -119,7 +120,8 @@ xfs_trans_dup(
 
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
-	ntp->t_pflags = tp->t_pflags;
+
+	xfs_trans_switch_context(tp, ntp);
 
 	/* move deferred ops over to the new tp */
 	xfs_defer_move(ntp, tp);
@@ -153,9 +155,6 @@ xfs_trans_reserve(
 	int			error = 0;
 	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
-	/* Mark this thread as being in a transaction */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	/*
 	 * Attempt to reserve the needed disk blocks by decrementing
 	 * the number needed from the number available.  This will
@@ -163,10 +162,8 @@ xfs_trans_reserve(
 	 */
 	if (blocks > 0) {
 		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
-		if (error != 0) {
-			current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+		if (error != 0)
 			return -ENOSPC;
-		}
 		tp->t_blk_res += blocks;
 	}
 
@@ -240,9 +237,6 @@ xfs_trans_reserve(
 		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
-
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	return error;
 }
 
@@ -266,6 +260,7 @@ xfs_trans_alloc(
 	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
+	xfs_trans_set_context(tp);
 
 	/*
 	 * Zero-reservation ("empty") transactions can't modify anything, so
@@ -878,7 +873,6 @@ __xfs_trans_commit(
 
 	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
 
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free(tp);
 
 	/*
@@ -910,7 +904,6 @@ __xfs_trans_commit(
 			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free_items(tp, !!error);
 	xfs_trans_free(tp);
 
@@ -970,9 +963,6 @@ xfs_trans_cancel(
 		tp->t_ticket = NULL;
 	}
 
-	/* mark this thread as no longer being in a transaction */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	xfs_trans_free_items(tp, dirty);
 	xfs_trans_free(tp);
 }
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 084658946cc8..075eeade4f7d 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -268,4 +268,34 @@ xfs_trans_item_relog(
 	return lip->li_ops->iop_relog(lip, tp);
 }
 
+static inline void
+xfs_trans_set_context(
+	struct xfs_trans	*tp)
+{
+	ASSERT(current->journal_info == NULL);
+	tp->t_pflags = memalloc_nofs_save();
+	current->journal_info = tp;
+}
+
+static inline void
+xfs_trans_clear_context(
+	struct xfs_trans	*tp)
+{
+	if (current->journal_info == tp) {
+		memalloc_nofs_restore(tp->t_pflags);
+		current->journal_info = NULL;
+	}
+}
+
+static inline void
+xfs_trans_switch_context(
+	struct xfs_trans	*old_tp,
+	struct xfs_trans	*new_tp)
+{
+	ASSERT(current->journal_info == old_tp);
+	new_tp->t_pflags = old_tp->t_pflags;
+	old_tp->t_pflags = 0;
+	current->journal_info = new_tp;
+}
+
 #endif	/* __XFS_TRANS_H__ */
-- 
2.25.1

