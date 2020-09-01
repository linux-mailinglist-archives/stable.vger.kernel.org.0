Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0776259C05
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgIARKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729384AbgIAPRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:17:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CA5220BED;
        Tue,  1 Sep 2020 15:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973432;
        bh=wTvkF6vhLaFYgW45kqnAV3ZrQrcm0/5IEZgDjgn4oPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQuptt+OhtzxVgpu6Yq10BQkyT4wgU9U8DPi0ImgWS6oiLa3nN2qyt6Vf/r31bNYx
         SBWr0LFZnXhEeJ5mdkuSR+2HfZF92QoKciRne7UBy8uyxzjZCZPAHdWVZTpOTgzoUM
         9RjkQ0qYLMPQBGEUsbt+5wkhtM40uKMXYMBSA9Ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 76/78] btrfs: check the right error variable in btrfs_del_dir_entries_in_log
Date:   Tue,  1 Sep 2020 17:10:52 +0200
Message-Id: <20200901150928.552772177@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
References: <20200901150924.680106554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit fb2fecbad50964b9f27a3b182e74e437b40753ef ]

With my new locking code dbench is so much faster that I tripped over a
transaction abort from ENOSPC.  This turned out to be because
btrfs_del_dir_entries_in_log was checking for ret == -ENOSPC, but this
function sets err on error, and returns err.  So instead of properly
marking the inode as needing a full commit, we were returning -ENOSPC
and aborting in __btrfs_unlink_inode.  Fix this by checking the proper
variable so that we return the correct thing in the case of ENOSPC.

The ENOENT needs to be checked, because btrfs_lookup_dir_item_index()
can return -ENOENT if the dir item isn't in the tree log (which would
happen if we hadn't fsync'ed this guy).  We actually handle that case in
__btrfs_unlink_inode, so it's an expected error to get back.

Fixes: 4a500fd178c8 ("Btrfs: Metadata ENOSPC handling for tree log")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add note and comment about ENOENT ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c28ac9c464251..5bd1758f57b64 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3191,11 +3191,13 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	btrfs_free_path(path);
 out_unlock:
 	mutex_unlock(&BTRFS_I(dir)->log_mutex);
-	if (ret == -ENOSPC) {
+	if (err == -ENOSPC) {
 		btrfs_set_log_full_commit(root->fs_info, trans);
-		ret = 0;
-	} else if (ret < 0)
-		btrfs_abort_transaction(trans, ret);
+		err = 0;
+	} else if (err < 0 && err != -ENOENT) {
+		/* ENOENT can be returned if the entry hasn't been fsynced yet */
+		btrfs_abort_transaction(trans, err);
+	}
 
 	btrfs_end_log_trans(root);
 
-- 
2.25.1



