Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4D612EEE3
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgABWgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:36:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730622AbgABWg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:36:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C524222C3;
        Thu,  2 Jan 2020 22:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004586;
        bh=QtvsXyVT+bhWq34joYsYBfXNCtlQBD6/ze4JqmkUxdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2rB1B7BZAu434I3WLa5qljyCBlpcWPtF4OTP5KnZQYddyKrT7PbmBib+Wm6D0zqQ
         rEHquzoVgpf5l6qJE07M74Bi4qHYsyhCcpJ8sgRB086c3sfbcnUbbto+U75RN0D2D+
         Up/jQzQkEMTIH8nap4R0A0LmDDDlZi6Db7DTGNGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 069/137] btrfs: return error pointer from alloc_test_extent_buffer
Date:   Thu,  2 Jan 2020 23:07:22 +0100
Message-Id: <20200102220555.852300521@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
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
 fs/btrfs/extent_io.c          | 6 ++++--
 fs/btrfs/tests/qgroup-tests.c | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a18f558b4477..6f5563ca70c1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4948,12 +4948,14 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 		return eb;
 	eb = alloc_dummy_extent_buffer(fs_info, start);
 	if (!eb)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	eb->fs_info = fs_info;
 again:
 	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
-	if (ret)
+	if (ret) {
+		exists = ERR_PTR(ret);
 		goto free_eb;
+	}
 	spin_lock(&fs_info->buffer_lock);
 	ret = radix_tree_insert(&fs_info->buffer_radix,
 				start >> PAGE_CACHE_SHIFT, eb);
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 2b2978c04e80..1efec40455f8 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -477,9 +477,9 @@ int btrfs_test_qgroups(void)
 	 * *cough*backref walking code*cough*
 	 */
 	root->node = alloc_test_extent_buffer(root->fs_info, 4096);
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



