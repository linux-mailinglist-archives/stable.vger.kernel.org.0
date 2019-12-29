Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32EA12C41F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbfL2R0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:26:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbfL2R0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:26:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17AD1207FD;
        Sun, 29 Dec 2019 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640399;
        bh=qmjQZXLwpiz6dj+OqdqhlwVlbZRkDdAYIIti/LZ0RbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzpQLcXtrIoR6ZaISW8p5c4f6sRIaysfCp9w0o+f1NIQ0fsoJ1w2B0UorL5Y65h1/
         Hf+AnPTDQ6DYt8KDJ3rmBLX1FCTxcD+iGiz7pCw85GtvX4qhSGEmIg8tCBEmB/5Rk5
         NfCza/4dKSJoeZlEEMDNEaeKAZWvgn9J7cn3cR60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 142/161] btrfs: return error pointer from alloc_test_extent_buffer
Date:   Sun, 29 Dec 2019 18:19:50 +0100
Message-Id: <20191229162442.063046325@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b6293c821ea8fa2a631a2112cd86cd435effeb8b ]

Callers of alloc_test_extent_buffer have not correctly interpreted the
return value as error pointer, as alloc_test_extent_buffer should behave
as alloc_extent_buffer. The self-tests were unaffected but
btrfs_find_create_tree_block could call both functions and that would
cause problems up in the call chain.

Fixes: faa2dbf004e8 ("Btrfs: add sanity tests for new qgroup accounting code")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c                   | 6 ++++--
 fs/btrfs/tests/free-space-tree-tests.c | 6 +++---
 fs/btrfs/tests/qgroup-tests.c          | 4 ++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4cc534584665..fced434bbddc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4949,12 +4949,14 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 		return eb;
 	eb = alloc_dummy_extent_buffer(fs_info, start);
 	if (!eb)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	eb->fs_info = fs_info;
 again:
 	ret = radix_tree_preload(GFP_NOFS);
-	if (ret)
+	if (ret) {
+		exists = ERR_PTR(ret);
 		goto free_eb;
+	}
 	spin_lock(&fs_info->buffer_lock);
 	ret = radix_tree_insert(&fs_info->buffer_radix,
 				start >> PAGE_SHIFT, eb);
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 8444a018cca2..f6c783e959b7 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -475,9 +475,9 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 	root->fs_info->tree_root = root;
 
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
-	if (!root->node) {
-		test_msg("Couldn't allocate dummy buffer\n");
-		ret = -ENOMEM;
+	if (IS_ERR(root->node)) {
+		test_msg("couldn't allocate dummy buffer\n");
+		ret = PTR_ERR(root->node);
 		goto out;
 	}
 	btrfs_set_header_level(root->node, 0);
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 578fd045e859..eb72cf280546 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -487,9 +487,9 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 	 * *cough*backref walking code*cough*
 	 */
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
 		test_msg("Couldn't allocate dummy buffer\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(root->node);
 		goto out;
 	}
 	btrfs_set_header_level(root->node, 0);
-- 
2.20.1



