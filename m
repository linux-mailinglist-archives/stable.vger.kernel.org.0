Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7A46250CC
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiKKCi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiKKChL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:37:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A6F6828F;
        Thu, 10 Nov 2022 18:36:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7EE161E7E;
        Fri, 11 Nov 2022 02:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1FBC433D6;
        Fri, 11 Nov 2022 02:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134163;
        bh=e/nGFqC7jzHZbnLyLx/zgtC4Kn7vVPsPVBx9M/mUfs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5cnP29s/LSwOjB39V4If8yT5+Yk3iO9MOCMA3Pkv2cmXEXhAI5bvpgJxd/Xe4t3p
         DlrUj7DlSu9Z/2sEM2fJ1wiUo9ra6eOWL4i75UFkte2T+d9/efU1hbK9NBFTm6cuFb
         tUmCEWscHcY8kQ3pWPEi4Mpm3PzJXNYr+/pP7xd6p9Dyem7QOWIX/SCrH7y1Wsi0jt
         3Y0WTcGhXxY69iki34VQI8U0/qXFatQCe1yilsWv7J4QEsIXRn02F3FzgF4vp1wHzo
         6BHiGcFl9tmwKiCADZi6b+lkz2nl7CzEDXO1qYKvpdiWZqH1hARmfjd4tdz0/iClUx
         VFbaNKR62t/5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/4] btrfs: remove pointless and double ulist frees in error paths of qgroup tests
Date:   Thu, 10 Nov 2022 21:35:55 -0500
Message-Id: <20221111023556.228125-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023556.228125-1-sashal@kernel.org>
References: <20221111023556.228125-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit d0ea17aec12ea0f7b9d2ed727d8ef8169d1e7699 ]

Several places in the qgroup self tests follow the pattern of freeing the
ulist pointer they passed to btrfs_find_all_roots() if the call to that
function returned an error. That is pointless because that function always
frees the ulist in case it returns an error.

Also In some places like at test_multiple_refs(), after a call to
btrfs_qgroup_account_extent() we also leave "old_roots" and "new_roots"
pointing to ulists that were freed, because btrfs_qgroup_account_extent()
has freed those ulists, and if after that the next call to
btrfs_find_all_roots() fails, we call ulist_free() on the "old_roots"
ulist again, resulting in a double free.

So remove those calls to reduce the code size and avoid double ulist
free in case of an error.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tests/qgroup-tests.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index d07dd26194b1..93c5236b945a 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -230,7 +230,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -244,7 +243,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -256,18 +254,19 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 		return ret;
 	}
 
+	/* btrfs_qgroup_account_extent() always frees the ulists passed to it. */
+	old_roots = NULL;
+	new_roots = NULL;
+
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
 				nodesize, nodesize)) {
 		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
-	old_roots = NULL;
-	new_roots = NULL;
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -280,7 +279,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -331,7 +329,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -345,7 +342,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -366,7 +362,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -380,7 +375,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -407,7 +401,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -421,7 +414,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
-- 
2.35.1

