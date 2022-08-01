Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7CC586928
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiHAL6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiHAL5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:57:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E815F48CB9;
        Mon,  1 Aug 2022 04:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BC3DB81163;
        Mon,  1 Aug 2022 11:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4B0C433D7;
        Mon,  1 Aug 2022 11:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354713;
        bh=0atg/WLGqvcXOneyB0XbF0ONAKguXUMw5CxnEXrF6dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRpL9lAn2ACRwL+RaN00e+2ypKFRhKe2DA8JdBv4hH/TC9wswEQ0pNNoK65aESsoU
         wF/B/2LmAZKAfchBQ7Ubj5zdaEehhHY4F+87j4kbOjfJWBo6ZmEBEdTJQuqaowgi6N
         N+RidVEdG4AjS9K9NhIP5sI15NIDWDM0bldOXR7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 59/65] xfs: remove dead stale buf unpin handling code
Date:   Mon,  1 Aug 2022 13:47:16 +0200
Message-Id: <20220801114136.130926922@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit e53d3aa0b605c49d780e1b2fd0b49dba4154f32b upstream.

This code goes back to a time when transaction commits wrote
directly to iclogs. The associated log items were pinned, written to
the log, and then "uncommitted" if some part of the log write had
failed. This uncommit sequence called an ->iop_unpin_remove()
handler that was eventually folded into ->iop_unpin() via the remove
parameter. The log subsystem has since changed significantly in that
transactions commit to the CIL instead of direct to iclogs, though
log items must still be aborted in the event of an eventual log I/O
error. However, the context for a log item abort is now asynchronous
from transaction commit, which means the committing transaction has
been freed by this point in time and the transaction uncommit
sequence of events is no longer relevant.

Further, since stale buffers remain locked at transaction commit
through unpin, we can be certain that the buffer is not associated
with any transaction when the unpin callback executes. Remove this
unused hunk of code and replace it with an assertion that the buffer
is disassociated from transaction context.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -435,28 +435,11 @@ xfs_buf_item_unpin(
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_flags & XBF_STALE);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(list_empty(&lip->li_trans));
+		ASSERT(!bp->b_transp);
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
-		if (remove) {
-			/*
-			 * If we are in a transaction context, we have to
-			 * remove the log item from the transaction as we are
-			 * about to release our reference to the buffer.  If we
-			 * don't, the unlock that occurs later in
-			 * xfs_trans_uncommit() will try to reference the
-			 * buffer which we no longer have a hold on.
-			 */
-			if (!list_empty(&lip->li_trans))
-				xfs_trans_del_item(lip);
-
-			/*
-			 * Since the transaction no longer refers to the buffer,
-			 * the buffer should no longer refer to the transaction.
-			 */
-			bp->b_transp = NULL;
-		}
-
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will


