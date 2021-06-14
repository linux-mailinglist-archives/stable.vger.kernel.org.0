Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45113A63E2
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhFNLSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234540AbhFNLQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:16:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3B9661965;
        Mon, 14 Jun 2021 10:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667785;
        bh=APiLZQUz8xYo9+cHTkDE0fLVZDCDzYp2BJpYxgmZsAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8gunphjfIUd/szw9M97dGRURbVHBnf2bYrxEuzKLz+N22q5JKOuZeiEylxIpCRJg
         YXW343Zaf7TU4m4fjpQNQaVKDEcL2sp+ZYMM+Y4gGzPZwc+69pCB9JtU7NQODLiKgv
         aoP9yQ3s0inwI4C8BRwlAMb1gWdYdS+liIbyB6aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 074/173] btrfs: do not write supers if we have an fs error
Date:   Mon, 14 Jun 2021 12:26:46 +0200
Message-Id: <20210614102700.624532260@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 165ea85f14831f27fc6fe3b02b35e42e50b9ed94 upstream.

Error injection testing uncovered a pretty severe problem where we could
end up committing a super that pointed to the wrong tree roots,
resulting in transid mismatch errors.

The way we commit the transaction is we update the super copy with the
current generations and bytenrs of the important roots, and then copy
that into our super_for_commit.  Then we allow transactions to continue
again, we write out the dirty pages for the transaction, and then we
write the super.  If the write out fails we'll bail and skip writing the
supers.

However since we've allowed a new transaction to start, we can have a
log attempting to sync at this point, which would be blocked on
fs_info->tree_log_mutex.  Once the commit fails we're allowed to do the
log tree commit, which uses super_for_commit, which now points at fs
tree's that were not written out.

Fix this by checking BTRFS_FS_STATE_ERROR once we acquire the
tree_log_mutex.  This way if the transaction commit fails we're sure to
see this bit set and we can skip writing the super out.  This patch
fixes this specific transid mismatch error I was seeing with this
particular error path.

CC: stable@vger.kernel.org # 5.12+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3302,6 +3302,22 @@ int btrfs_sync_log(struct btrfs_trans_ha
 	 *    begins and releases it only after writing its superblock.
 	 */
 	mutex_lock(&fs_info->tree_log_mutex);
+
+	/*
+	 * The previous transaction writeout phase could have failed, and thus
+	 * marked the fs in an error state.  We must not commit here, as we
+	 * could have updated our generation in the super_for_commit and
+	 * writing the super here would result in transid mismatches.  If there
+	 * is an error here just bail.
+	 */
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
+		ret = -EIO;
+		btrfs_set_log_full_commit(trans);
+		btrfs_abort_transaction(trans, ret);
+		mutex_unlock(&fs_info->tree_log_mutex);
+		goto out_wake_log_root;
+	}
+
 	btrfs_set_super_log_root(fs_info->super_for_commit, log_root_start);
 	btrfs_set_super_log_root_level(fs_info->super_for_commit, log_root_level);
 	ret = write_all_supers(fs_info, 1);


