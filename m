Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139B227C5BE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgI2Lif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729431AbgI2Lia (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1239F21924;
        Tue, 29 Sep 2020 11:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379483;
        bh=aHxsQgvwNnbGIwSSy69r9VE0YCKcjB1WtDe7bHMU8QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnLtJGgDpK2yCAvwb1qfWJ5cpBRiti9EYJGw2lhcBKF4kAg46iLUeV4jVyrXzG5De
         VqOc/6nChNCN7N2fqPjIFDAg11gXp/UCBP69yxO5Ih3pTh2LlK0eKGGNdFACvToLqJ
         9jeKvEHJUSPOJli0PaLgrTm1HcBFd38sFsLOQjIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/388] btrfs: free the reloc_control in a consistent way
Date:   Tue, 29 Sep 2020 12:58:33 +0200
Message-Id: <20200929110019.289691352@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1a0afa0ecfc4dbc8d7583d03cafd3f68f781df0c ]

If we have an error while processing the reloc roots we could leak roots
that were added to rc->reloc_roots before we hit the error.  We could
have also not removed the reloc tree mapping from our rb_tree, so clean
up any remaining nodes in the reloc root rb_tree.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ use rbtree_postorder_for_each_entry_safe ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1313506a7ecb5..ece53d2f55ae3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4354,6 +4354,18 @@ static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
 	return rc;
 }
 
+static void free_reloc_control(struct reloc_control *rc)
+{
+	struct mapping_node *node, *tmp;
+
+	free_reloc_roots(&rc->reloc_roots);
+	rbtree_postorder_for_each_entry_safe(node, tmp,
+			&rc->reloc_root_tree.rb_root, rb_node)
+		kfree(node);
+
+	kfree(rc);
+}
+
 /*
  * Print the block group being relocated
  */
@@ -4486,7 +4498,7 @@ out:
 		btrfs_dec_block_group_ro(rc->block_group);
 	iput(rc->data_inode);
 	btrfs_put_block_group(rc->block_group);
-	kfree(rc);
+	free_reloc_control(rc);
 	return err;
 }
 
@@ -4659,7 +4671,7 @@ out_clean:
 		err = ret;
 out_unset:
 	unset_reloc_control(rc);
-	kfree(rc);
+	free_reloc_control(rc);
 out:
 	if (!list_empty(&reloc_roots))
 		free_reloc_roots(&reloc_roots);
-- 
2.25.1



