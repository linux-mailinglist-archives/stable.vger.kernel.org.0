Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3636250AC
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiKKChR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiKKCgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA16DD2E6;
        Thu, 10 Nov 2022 18:35:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75EA760B43;
        Fri, 11 Nov 2022 02:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2F1C433B5;
        Fri, 11 Nov 2022 02:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134128;
        bh=zCthhkU5SADcUteJDp+FGV49vpqJr2OIUfCZdgF72dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdHsI8OSwtmsgjJOP8ewoN3jhSUqKlzliFLJjDEc+HUKQFV5Sdu51yvKWfbBq/Mxr
         kgH8IaU70/tvF+RsjBirFRZ3nyoLkrKtWPyBlSabDEySd+Wtv3K6d116rL4SQ19nLx
         jU+ZM4FDXtZC0dSQ0IhjSpWc8eS+OBWAv2szjX89eamzCLNsKrrrJC8AAOX94kPh15
         ku2W8vdZWiWnO48piQuczgHhKy6KEXjLvMuj8Ysp3mjavmoyGnZuTGnQTkKFCLNzs7
         5FF8TWZfsWWyJNA5TK6z8ucwupMBmVnmhP3wLx56BMjo21HuMEzt73eKsCRVOQKxWV
         SMrt24j2fEKfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/11] btrfs: remove pointless and double ulist frees in error paths of qgroup tests
Date:   Thu, 10 Nov 2022 21:35:09 -0500
Message-Id: <20221111023511.227800-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023511.227800-1-sashal@kernel.org>
References: <20221111023511.227800-1-sashal@kernel.org>
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
index 19ba7d5b7d8f..a8c6637fe337 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -225,7 +225,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	 */
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -238,7 +237,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -250,17 +248,18 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
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
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -272,7 +271,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -322,7 +320,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -335,7 +332,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -355,7 +351,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -368,7 +363,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -394,7 +388,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -407,7 +400,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
-- 
2.35.1

