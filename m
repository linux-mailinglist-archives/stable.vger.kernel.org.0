Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6D26354D9
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiKWJLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237165AbiKWJLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:11:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658FE11C1F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:11:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF26B81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CA0C43145;
        Wed, 23 Nov 2022 09:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194680;
        bh=aoNIfstFJaw6s/CMJvUQSKT+Q2V32rZKbtW1JkDTiUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRIMbtbqfJY/vzy0c5++CN+abfxkqoh7Q0J6b5Ju31QJykVXuXzb25Mkimio/+rC/
         9jlmw6UtSe9b7w9jv/xN6W/lZfJDs0f1PkaZml8bpYspyBQtnYn3gFfI5izCyn1Cwm
         8MG9YOqyVnAbcXWaSXGsYJ+e2bAUvGu08LYtKR20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 006/156] xfs: drain the buf delwri queue before xfsaild idles
Date:   Wed, 23 Nov 2022 09:49:23 +0100
Message-Id: <20221123084558.082635022@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit f376b45e861d8b7b34bf0eceeecfdd00dbe65cde upstream.

xfsaild is racy with respect to transaction abort and shutdown in
that the task can idle or exit with an empty AIL but buffers still
on the delwri queue. This was partly addressed by cancelling the
delwri queue before the task exits to prevent memory leaks, but it's
also possible for xfsaild to empty and idle with buffers on the
delwri queue. For example, a transaction that pins a buffer that
also happens to sit on the AIL delwri queue will explicitly remove
the associated log item from the AIL if the transaction aborts. The
side effect of this is an unmount hang in xfs_wait_buftarg() as the
associated buffers remain held by the delwri queue indefinitely.
This is reproduced on repeated runs of generic/531 with an fs format
(-mrmapbt=1 -bsize=1k) that happens to also reproduce transaction
aborts.

Update xfsaild to not idle until both the AIL and associated delwri
queue are empty and update the push code to continue delwri queue
submission attempts even when the AIL is empty. This allows the AIL
to eventually release aborted buffers stranded on the delwri queue
when they are unlocked by the associated transaction. This should
have no significant effect on normal runtime behavior because the
xfsaild currently idles only when the AIL is empty and in practice
the AIL is rarely empty with a populated delwri queue. The items
must be AIL resident to land in the queue in the first place and
generally aren't removed until writeback completes.

Note that the pre-existing delwri queue cancel logic in the exit
path is retained because task stop is external, could technically
come at any point, and xfsaild is still responsible to release its
buffer references before it exits.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans_ail.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -402,16 +402,10 @@ xfsaild_push(
 	target = ailp->ail_target;
 	ailp->ail_target_prev = target;
 
+	/* we're done if the AIL is empty or our push has reached the end */
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
-	if (!lip) {
-		/*
-		 * If the AIL is empty or our push has reached the end we are
-		 * done now.
-		 */
-		xfs_trans_ail_cursor_done(&cur);
-		spin_unlock(&ailp->ail_lock);
+	if (!lip)
 		goto out_done;
-	}
 
 	XFS_STATS_INC(mp, xs_push_ail);
 
@@ -493,6 +487,8 @@ xfsaild_push(
 			break;
 		lsn = lip->li_lsn;
 	}
+
+out_done:
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
 
@@ -500,7 +496,6 @@ xfsaild_push(
 		ailp->ail_log_flush++;
 
 	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
-out_done:
 		/*
 		 * We reached the target or the AIL is empty, so wait a bit
 		 * longer for I/O to complete and remove pushed items from the
@@ -592,7 +587,8 @@ xfsaild(
 		 */
 		smp_rmb();
 		if (!xfs_ail_min(ailp) &&
-		    ailp->ail_target == ailp->ail_target_prev) {
+		    ailp->ail_target == ailp->ail_target_prev &&
+		    list_empty(&ailp->ail_buf_list)) {
 			spin_unlock(&ailp->ail_lock);
 			freezable_schedule();
 			tout = 0;


