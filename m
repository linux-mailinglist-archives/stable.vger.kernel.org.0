Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A64F6212C2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiKHNmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiKHNm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:42:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFB44FF87
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:42:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3623AB81AF1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8510EC433C1;
        Tue,  8 Nov 2022 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914941;
        bh=IMjqFjAgsW60mB+ZzARYkQAww7qLuv+MyM/ZoF+Fq2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcTspeEi/71LAAufZfKr45Xp8TuY5BKfhyNS9oYZKsrP9xRJqy/Xx6URtNC4yjLxG
         7GuWWi51SEGwaqr32Txqx+jEkE9DQLReZmMKAbhwN6xIgGv0yXyBeTEyf2nslin4W+
         cjhcM+9MrHgqhoJcojw8faxY2fJBqTMs+9tgcIXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 13/30] btrfs: fix ulist leaks in error paths of qgroup self tests
Date:   Tue,  8 Nov 2022 14:39:01 +0100
Message-Id: <20221108133327.175232608@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit d37de92b38932d40e4a251e876cc388f9aee5f42 ]

In the test_no_shared_qgroup() and test_multiple_refs() qgroup self tests,
if we fail to add the tree ref, remove the extent item or remove the
extent ref, we are returning from the test function without freeing the
"old_roots" ulist that was allocated by the previous calls to
btrfs_find_all_roots(). Fix that by calling ulist_free() before returning.

Fixes: 442244c96332 ("btrfs: qgroup: Switch self test to extent-oriented qgroup mechanism.")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tests/qgroup-tests.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index e0aa6b9786fa..ef9ff6dda173 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -249,8 +249,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
@@ -283,8 +285,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	}
 
 	ret = remove_extent_item(root, nodesize, nodesize);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return -EINVAL;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
@@ -346,8 +350,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
@@ -379,8 +385,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = add_tree_ref(root, nodesize, nodesize, 0,
 			BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
@@ -418,8 +426,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = remove_extent_ref(root, nodesize, nodesize, 0,
 				BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
-- 
2.35.1



