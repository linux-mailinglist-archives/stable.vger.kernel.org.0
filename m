Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074D526F2F8
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgIRCFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbgIRCFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5255B23888;
        Fri, 18 Sep 2020 02:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394702;
        bh=aHxsQgvwNnbGIwSSy69r9VE0YCKcjB1WtDe7bHMU8QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MA/hRaJda772Wog2nl3fb95K8ntJWyzHoWgBP3bm1OwYJpAUZaJY0I2fp08bzzOmu
         2B3hMMhjcG1D5bYp9hAK7A9kDgNScHHe6rqv8NQoo2Hxrtl2uhPEfiN6itQei42KZU
         ye4h3VLSjA3Q2SepzQrM51qFPn+QodIAuZvm2D58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 188/330] btrfs: free the reloc_control in a consistent way
Date:   Thu, 17 Sep 2020 21:58:48 -0400
Message-Id: <20200918020110.2063155-188-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

