Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3294129922
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLWRMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:12:44 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37743 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:12:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5959A21C57;
        Mon, 23 Dec 2019 12:12:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:12:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VAr9lm
        Uo4a3VqX1fZU6xd9+kIQ8Xc49lLneK/9ET+TM=; b=qVKa4+3KZ5QE3amz9dNJhw
        ltdJqgDlSek/2R/g7jcgr3jmVMCI88rHw+uGc3GLAIDPiiEE/wFHED5W1MEthiu2
        2cTtGxUguRnjJIdzWzBq2bq23VkBIyb/eu1yEtwDY4fZCDBOA8wUSR7te6wLPASz
        V4WOXflekJkAcQvqXGUwlcPwjQf26QZwmba42t8Y2xCyaj5QAZklZyRKQvdVEgwg
        idA25ofX0JIP7y3bf1Q7W5z4hHNN2SqZ4UsS5aaTza7fPhqlQLd1tdkcm5zlUGoo
        WHILThM7jX8VMqBGco/dn2qEGz9A/1wSBJZeohaCdf2wMd8RLQqVdD+cvR3ct9Vg
        ==
X-ME-Sender: <xms:i_UAXgRh3EIFtWlmPEZbYLAhxxhmFH7vRnEdIIZeMR14PQJH_skvsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:i_UAXggz-Ya8LyyC9kFS7BT9IObemWV7bGFGnhHci0TNcnU0DyBf1w>
    <xmx:i_UAXquFsOqUEsGT4yCAIWte9qIlhL3_plbGuQVuPBsfdpP3cmRTzw>
    <xmx:i_UAXrg84wU7CptLeUTevIxHRKtyDzURlsIdT5fuJS7lNOSvtWrWAQ>
    <xmx:i_UAXogKIQ-n8WLa256R3k6xwNOw6YwdFJjtln7xwuWVBeYiODPNCw>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id F153580059;
        Mon, 23 Dec 2019 12:12:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: return error pointer from alloc_test_extent_buffer" failed to apply to 4.9-stable tree
To:     dan.carpenter@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:12:37 -0500
Message-ID: <15771211577568@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b6293c821ea8fa2a631a2112cd86cd435effeb8b Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 3 Dec 2019 14:24:58 +0300
Subject: [PATCH] btrfs: return error pointer from alloc_test_extent_buffer

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

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index eb8bd0258360..2f4802f405a2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5074,12 +5074,14 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
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
index 1a846bf6e197..914eea5ba6a7 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -452,9 +452,9 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 	root->fs_info->tree_root = root;
 
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
 		test_std_err(TEST_ALLOC_EXTENT_BUFFER);
-		ret = -ENOMEM;
+		ret = PTR_ERR(root->node);
 		goto out;
 	}
 	btrfs_set_header_level(root->node, 0);
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 09aaca1efd62..ac035a6fa003 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -484,9 +484,9 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 	 * *cough*backref walking code*cough*
 	 */
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
 		test_err("couldn't allocate dummy buffer");
-		ret = -ENOMEM;
+		ret = PTR_ERR(root->node);
 		goto out;
 	}
 	btrfs_set_header_level(root->node, 0);

