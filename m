Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A22862148D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbiKHOC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiKHOCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:02:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5456C68689
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:02:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8D67615B3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA62FC433C1;
        Tue,  8 Nov 2022 14:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916139;
        bh=SAQsWMUlMObvluugsN4a+8btbp4QEegowm/L5MKFuS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CV/qeIpaeiCmYbp41gE8HVve1DihDj4ng04CRaqKiFo5bnXmRKHZ1lRN8gO3uIJev
         EnpXWba8IsSBCbMXBUUgCw+0gsaFpeMFDTaV1Ci0Z+uFYUXewKj1YXjldplWhj1Y1T
         G1cpXKZlOgznT2XdGLmPLFag4DeTuPydEU+x38pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/144] btrfs: fix ulist leaks in error paths of qgroup self tests
Date:   Tue,  8 Nov 2022 14:38:43 +0100
Message-Id: <20221108133347.220017956@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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
index 19ba7d5b7d8f..a374b62c9de9 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -232,8 +232,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
@@ -266,8 +268,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	}
 
 	ret = remove_extent_item(root, nodesize, nodesize);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return -EINVAL;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
@@ -329,8 +333,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
@@ -362,8 +368,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = add_tree_ref(root, nodesize, nodesize, 0,
 			BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
@@ -401,8 +409,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = remove_extent_ref(root, nodesize, nodesize, 0,
 				BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
-- 
2.35.1



