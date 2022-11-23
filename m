Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552C063579E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237752AbiKWJoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiKWJnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E961C24965
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 402AECE20DB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EDDC433D6;
        Wed, 23 Nov 2022 09:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196494;
        bh=ABFzZ2dPMWvouzix5kVUQzh1HvcVoBLAhDgOBSlR2J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooEjaJ8m1LIAfpKDvvO7ytjR4OclP0htXHZ0UqsPt62tHEfYbyex4XBxTKfntTP2s
         rrpB51UfIoz6kJaSpGrcBDbAP1K981BUYWl+Bou8sz1V7KHTT+FjOwl3mHvj2OwCab
         lmetZ/9YFwSPcannbVcB1h/cNtCKMJ+Lyv1gNNmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 048/314] btrfs: remove pointless and double ulist frees in error paths of qgroup tests
Date:   Wed, 23 Nov 2022 09:48:13 +0100
Message-Id: <20221123084627.699399953@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index 843dd3d3adbe..63676ea19f29 100644
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
@@ -240,7 +239,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -252,17 +250,18 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
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
@@ -276,7 +275,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -326,7 +324,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -341,7 +338,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -361,7 +357,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -376,7 +371,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -402,7 +396,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -417,7 +410,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
-- 
2.35.1



