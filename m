Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E47855DAC7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiF0Lvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238321AbiF0Lut (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:50:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A23262E;
        Mon, 27 Jun 2022 04:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 943DC61241;
        Mon, 27 Jun 2022 11:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56E4C3411D;
        Mon, 27 Jun 2022 11:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330230;
        bh=JB+Z5xuTScFqpEvhMHpnvXmU9O+TyBtHgf69hitFHAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omQH4orOzWF1S5C8l5g9sQhfBggSex1Tgz8aQByYhZMW0ddZcQGQHAKUet0xqe+6U
         GEHINMqmYGmCx8cXYnHXC5xLv43vEbZcccEl6eS1uQHylUCu5xVjnsmaMTUnVoCzH1
         VBVp3GDBCWw0i4G95wjhp+sO+lQ+PymuldhOCOq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 126/181] btrfs: fix deadlock with fsync+fiemap+transaction commit
Date:   Mon, 27 Jun 2022 13:21:39 +0200
Message-Id: <20220627111948.346375856@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit bf7ba8ee759b7b7a34787ddd8dc3f190a3d7fa24 upstream.

We are hitting the following deadlock in production occasionally

Task 1		Task 2		Task 3		Task 4		Task 5
		fsync(A)
		 start trans
						start commit
				falloc(A)
				 lock 5m-10m
				 start trans
				  wait for commit
fiemap(A)
 lock 0-10m
  wait for 5m-10m
   (have 0-5m locked)

		 have btrfs_need_log_full_commit
		  !full_sync
		  wait_ordered_extents
								finish_ordered_io(A)
								lock 0-5m
								DEADLOCK

We have an existing dependency of file extent lock -> transaction.
However in fsync if we tried to do the fast logging, but then had to
fall back to committing the transaction, we will be forced to call
btrfs_wait_ordered_range() to make sure all of our extents are updated.

This creates a dependency of transaction -> file extent lock, because
btrfs_finish_ordered_io() will need to take the file extent lock in
order to run the ordered extents.

Fix this by stopping the transaction if we have to do the full commit
and we attempted to do the fast logging.  Then attach to the transaction
and commit it if we need to.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   67 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 15 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2359,25 +2359,62 @@ int btrfs_sync_file(struct file *file, l
 	 */
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_MMAP);
 
-	if (ret != BTRFS_NO_LOG_SYNC) {
+	if (ret == BTRFS_NO_LOG_SYNC) {
+		ret = btrfs_end_transaction(trans);
+		goto out;
+	}
+
+	/* We successfully logged the inode, attempt to sync the log. */
+	if (!ret) {
+		ret = btrfs_sync_log(trans, root, &ctx);
 		if (!ret) {
-			ret = btrfs_sync_log(trans, root, &ctx);
-			if (!ret) {
-				ret = btrfs_end_transaction(trans);
-				goto out;
-			}
+			ret = btrfs_end_transaction(trans);
+			goto out;
 		}
-		if (!full_sync) {
-			ret = btrfs_wait_ordered_range(inode, start, len);
-			if (ret) {
-				btrfs_end_transaction(trans);
-				goto out;
-			}
-		}
-		ret = btrfs_commit_transaction(trans);
-	} else {
+	}
+
+	/*
+	 * At this point we need to commit the transaction because we had
+	 * btrfs_need_log_full_commit() or some other error.
+	 *
+	 * If we didn't do a full sync we have to stop the trans handle, wait on
+	 * the ordered extents, start it again and commit the transaction.  If
+	 * we attempt to wait on the ordered extents here we could deadlock with
+	 * something like fallocate() that is holding the extent lock trying to
+	 * start a transaction while some other thread is trying to commit the
+	 * transaction while we (fsync) are currently holding the transaction
+	 * open.
+	 */
+	if (!full_sync) {
 		ret = btrfs_end_transaction(trans);
+		if (ret)
+			goto out;
+		ret = btrfs_wait_ordered_range(inode, start, len);
+		if (ret)
+			goto out;
+
+		/*
+		 * This is safe to use here because we're only interested in
+		 * making sure the transaction that had the ordered extents is
+		 * committed.  We aren't waiting on anything past this point,
+		 * we're purely getting the transaction and committing it.
+		 */
+		trans = btrfs_attach_transaction_barrier(root);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+
+			/*
+			 * We committed the transaction and there's no currently
+			 * running transaction, this means everything we care
+			 * about made it to disk and we are done.
+			 */
+			if (ret == -ENOENT)
+				ret = 0;
+			goto out;
+		}
 	}
+
+	ret = btrfs_commit_transaction(trans);
 out:
 	ASSERT(list_empty(&ctx.list));
 	err = file_check_and_advance_wb_err(file);


