Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B11263546A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbiKWJFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237035AbiKWJFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:05:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC08102E49
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:05:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A29861B4C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7486EC433C1;
        Wed, 23 Nov 2022 09:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194345;
        bh=uDggigpDJRDiYbWLddfipDH/i/sSGP0MyvjLxImHF+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBuSlb8nEV3N6t1/C5gpDlNaiGegyoue1Z6kxgkvO1KoOSaviYSxJJrU2U4T7vuih
         n6ys4Un0SrlTo8F68e17P0kJgmxiRS2VgXEx8t37uDp0f3DgRcrZSUDMrMCroyUVy1
         Qt2xzyhuTmxT4/yx584S8by5H6Sjg708TNumzzw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/114] btrfs: remove pointless and double ulist frees in error paths of qgroup tests
Date:   Wed, 23 Nov 2022 09:50:39 +0100
Message-Id: <20221123084553.947753291@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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
index 24a61e524861..9b43907324a3 100644
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
@@ -246,7 +245,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -258,18 +256,19 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
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
@@ -284,7 +283,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -335,7 +333,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -351,7 +348,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -372,7 +368,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -388,7 +383,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -415,7 +409,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -431,7 +424,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
-- 
2.35.1



