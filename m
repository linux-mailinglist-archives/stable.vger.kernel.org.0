Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FE63EB8A0
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241998AbhHMPOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241653AbhHMPOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9436961139;
        Fri, 13 Aug 2021 15:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867610;
        bh=Nd+i40b4xZzYd0020Mls7S7oG460kVD2Uo/5PQVREcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRV0G8sXdEm0Vy24CfffP8IREO0Q3S258rV349iwPlisjR4etrTd41/j00ndy1hzL
         1G0kKqWEe4MYZugddHZSJ+GakquXgJnPgaX784McM3g3ozq8lzX/Dct8n98Tcvofrv
         U0G5xEj2CE0baLk8NYwHXlejfonlB6oZPItJ0U6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 21/27] btrfs: transaction: Cleanup unused TRANS_STATE_BLOCKED
Date:   Fri, 13 Aug 2021 17:07:19 +0200
Message-Id: <20210813150524.066729224@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 3296bf562443a8ca35aaad959a76a49e9b412760 upstream

The state was introduced in commit 4a9d8bdee368 ("Btrfs: make the state
of the transaction more readable"), then in commit 302167c50b32
("btrfs: don't end the transaction for delayed refs in throttle") the
state is completely removed.

So we can just clean up the state since it's only compared but never
set.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/transaction.c |   15 +++------------
 fs/btrfs/transaction.h |    1 -
 3 files changed, 4 insertions(+), 14 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1748,7 +1748,7 @@ static int transaction_kthread(void *arg
 		}
 
 		now = ktime_get_seconds();
-		if (cur->state < TRANS_STATE_BLOCKED &&
+		if (cur->state < TRANS_STATE_COMMIT_START &&
 		    !test_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags) &&
 		    (now < cur->start_time ||
 		     now - cur->start_time < fs_info->commit_interval)) {
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -27,7 +27,6 @@
 
 static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 	[TRANS_STATE_RUNNING]		= 0U,
-	[TRANS_STATE_BLOCKED]		=  __TRANS_START,
 	[TRANS_STATE_COMMIT_START]	= (__TRANS_START | __TRANS_ATTACH),
 	[TRANS_STATE_COMMIT_DOING]	= (__TRANS_START |
 					   __TRANS_ATTACH |
@@ -388,7 +387,7 @@ int btrfs_record_root_in_trans(struct bt
 
 static inline int is_transaction_blocked(struct btrfs_transaction *trans)
 {
-	return (trans->state >= TRANS_STATE_BLOCKED &&
+	return (trans->state >= TRANS_STATE_COMMIT_START &&
 		trans->state < TRANS_STATE_UNBLOCKED &&
 		!TRANS_ABORTED(trans));
 }
@@ -580,7 +579,7 @@ again:
 	INIT_LIST_HEAD(&h->new_bgs);
 
 	smp_mb();
-	if (cur_trans->state >= TRANS_STATE_BLOCKED &&
+	if (cur_trans->state >= TRANS_STATE_COMMIT_START &&
 	    may_wait_transaction(fs_info, type)) {
 		current->journal_info = h;
 		btrfs_commit_transaction(h);
@@ -797,7 +796,7 @@ int btrfs_should_end_transaction(struct
 	struct btrfs_transaction *cur_trans = trans->transaction;
 
 	smp_mb();
-	if (cur_trans->state >= TRANS_STATE_BLOCKED ||
+	if (cur_trans->state >= TRANS_STATE_COMMIT_START ||
 	    cur_trans->delayed_refs.flushing)
 		return 1;
 
@@ -830,7 +829,6 @@ static int __btrfs_end_transaction(struc
 {
 	struct btrfs_fs_info *info = trans->fs_info;
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	int lock = (trans->type != TRANS_JOIN_NOLOCK);
 	int err = 0;
 
 	if (refcount_read(&trans->use_count) > 1) {
@@ -846,13 +844,6 @@ static int __btrfs_end_transaction(struc
 
 	btrfs_trans_release_chunk_metadata(trans);
 
-	if (lock && READ_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
-		if (throttle)
-			return btrfs_commit_transaction(trans);
-		else
-			wake_up_process(info->transaction_kthread);
-	}
-
 	if (trans->type & __TRANS_FREEZABLE)
 		sb_end_intwrite(info->sb);
 
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -13,7 +13,6 @@
 
 enum btrfs_trans_state {
 	TRANS_STATE_RUNNING,
-	TRANS_STATE_BLOCKED,
 	TRANS_STATE_COMMIT_START,
 	TRANS_STATE_COMMIT_DOING,
 	TRANS_STATE_UNBLOCKED,


