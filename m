Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD45561CF8
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiF3OIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbiF3OHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:07:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E0872EEA;
        Thu, 30 Jun 2022 06:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 132B061F5F;
        Thu, 30 Jun 2022 13:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230BBC341CB;
        Thu, 30 Jun 2022 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597262;
        bh=YSrChqLUMjIgAIyGJymSZd2Gm+5E0kMjXymR4Fw4Kz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xqt4fvJg53Eeg/SOdmmFnQUl9P1ZMHpLGSO9Km5tDaNjKWlQsPYuDqXoS+WCVUfXn
         I/aWZGobp6JBRU8UNCi5qGAfKzm1it0GvajzOGudUKSz2OSNux+kdKjsiGod+XRolL
         MiFFn1PYeH66voNzXU6ktUpKuz9UE6iXTbyIrL/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 09/12] xfs: remove all COW fork extents when remounting readonly
Date:   Thu, 30 Jun 2022 15:47:14 +0200
Message-Id: <20220630133230.967036087@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
References: <20220630133230.676254336@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 089558bc7ba785c03815a49c89e28ad9b8de51f9 upstream.

[backport xfs_icwalk -> xfs_eofblocks for 5.10.y]

As part of multiple customer escalations due to file data corruption
after copy on write operations, I wrote some fstests that use fsstress
to hammer on COW to shake things loose.  Regrettably, I caught some
filesystem shutdowns due to incorrect rmap operations with the following
loop:

mount <filesystem>				# (0)
fsstress <run only readonly ops> &		# (1)
while true; do
	fsstress <run all ops>
	mount -o remount,ro			# (2)
	fsstress <run only readonly ops>
	mount -o remount,rw			# (3)
done

When (2) happens, notice that (1) is still running.  xfs_remount_ro will
call xfs_blockgc_stop to walk the inode cache to free all the COW
extents, but the blockgc mechanism races with (1)'s reader threads to
take IOLOCKs and loses, which means that it doesn't clean them all out.
Call such a file (A).

When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
walks the ondisk refcount btree and frees any COW extent that it finds.
This function does not check the inode cache, which means that incore
COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
one of those former COW extents are allocated and mapped into another
file (B) and someone triggers a COW to the stale reservation in (A), A's
dirty data will be written into (B) and once that's done, those blocks
will be transferred to (A)'s data fork without bumping the refcount.

The results are catastrophic -- file (B) and the refcount btree are now
corrupt.  Solve this race by forcing the xfs_blockgc_free_space to run
synchronously, which causes xfs_icwalk to return to inodes that were
skipped because the blockgc code couldn't take the IOLOCK.  This is safe
to do here because the VFS has already prohibited new writer threads.

Fixes: 10ddf64e420f ("xfs: remove leftover CoW reservations when remounting ro")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1695,7 +1695,10 @@ static int
 xfs_remount_ro(
 	struct xfs_mount	*mp)
 {
-	int error;
+	struct xfs_eofblocks	eofb = {
+		.eof_flags	= XFS_EOF_FLAGS_SYNC,
+	};
+	int			error;
 
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
@@ -1703,8 +1706,13 @@ xfs_remount_ro(
 	 */
 	xfs_stop_block_reaping(mp);
 
-	/* Get rid of any leftover CoW reservations... */
-	error = xfs_icache_free_cowblocks(mp, NULL);
+	/*
+	 * Clear out all remaining COW staging extents and speculative post-EOF
+	 * preallocations so that we don't leave inodes requiring inactivation
+	 * cleanups during reclaim on a read-only mount.  We must process every
+	 * cached inode, so this requires a synchronous cache scan.
+	 */
+	error = xfs_icache_free_cowblocks(mp, &eofb);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;


