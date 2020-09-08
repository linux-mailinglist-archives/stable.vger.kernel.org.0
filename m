Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90319261CCB
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732165AbgIHT0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731056AbgIHQAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:00:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58E722464B;
        Tue,  8 Sep 2020 15:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579560;
        bh=F6E0uU3Gz+72YBSzrH0izRjdV0y0ftaElR3dUaV65Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+7tHRIrn5U3qgeNsBuYkJcnm8msy2uIcJyo/udwWXkVBUECqw1fjzDvBBS+mIroa
         ElOSNwWh/4wA7hefAKZ5kNLLu/prGFjQNmTLvAtegqvI5hn4R20Q+MuH1kczTQIVC0
         HYW44BwxvbHr4UwYrAryyYtJkAthFSjPxuu0zQRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 128/186] btrfs: set the correct lockdep class for new nodes
Date:   Tue,  8 Sep 2020 17:24:30 +0200
Message-Id: <20200908152247.842898789@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit ad24466588ab7d7c879053c5afd919b0c555fec0 upstream.

When flipping over to the rw_semaphore I noticed I'd get a lockdep splat
in replace_path(), which is weird because we're swapping the reloc root
with the actual target root.  Turns out this is because we're using the
root->root_key.objectid as the root id for the newly allocated tree
block when setting the lockdep class, however we need to be using the
actual owner of this new block, which is saved in owner.

The affected path is through btrfs_copy_root as all other callers of
btrfs_alloc_tree_block (which calls init_new_buffer) have root_objectid
== root->root_key.objectid .

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4527,7 +4527,7 @@ btrfs_init_new_buffer(struct btrfs_trans
 		return ERR_PTR(-EUCLEAN);
 	}
 
-	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
+	btrfs_set_buffer_lockdep_class(owner, buf, level);
 	btrfs_tree_lock(buf);
 	btrfs_clean_tree_block(buf);
 	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);


