Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5D32E86A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhCEM0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:26:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhCEM0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:26:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E88365029;
        Fri,  5 Mar 2021 12:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947182;
        bh=c2v4MScSFJPscGDVWoy42cNFoQC37VrwYN6Okn4Ways=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLPBbYqeVEmSh/ZMr6FyvcbnPatNXXgOjuMqEkLAq95Bzgha/rQs3q9DcUTTpxm8Z
         aWE9x0jMKIopOcRfWsluocCfH/hVlgXMaqdPLMzJU7Z4bt5EgwTQCeneZsWS5Fl7Nl
         /h8g/yKkDhPzgj4Xh1ShjWitmnchnEK3Z8TT4/rE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 078/104] btrfs: fix error handling in commit_fs_roots
Date:   Fri,  5 Mar 2021 13:21:23 +0100
Message-Id: <20210305120906.988528750@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4f4317c13a40194940acf4a71670179c4faca2b5 ]

While doing error injection I would sometimes get a corrupt file system.
This is because I was injecting errors at btrfs_search_slot, but would
only do it one time per stack.  This uncovered a problem in
commit_fs_roots, where if we get an error we would just break.  However
we're in a nested loop, the first loop being a loop to find all the
dirty fs roots, and then subsequent root updates would succeed clearing
the error value.

This isn't likely to happen in real scenarios, however we could
potentially get a random ENOMEM once and then not again, and we'd end up
with a corrupted file system.  Fix this by moving the error checking
around a bit to the main loop, as this is the only place where something
will fail, and return the error as soon as it occurs.

With this patch my reproducer no longer corrupts the file system.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/transaction.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6af7f2bf92de..fbf93067642a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1319,7 +1319,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 	struct btrfs_root *gang[8];
 	int i;
 	int ret;
-	int err = 0;
 
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	while (1) {
@@ -1331,6 +1330,8 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			break;
 		for (i = 0; i < ret; i++) {
 			struct btrfs_root *root = gang[i];
+			int ret2;
+
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
@@ -1350,17 +1351,17 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 						    root->node);
 			}
 
-			err = btrfs_update_root(trans, fs_info->tree_root,
+			ret2 = btrfs_update_root(trans, fs_info->tree_root,
 						&root->root_key,
 						&root->root_item);
+			if (ret2)
+				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
-			if (err)
-				break;
 			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-	return err;
+	return 0;
 }
 
 /*
-- 
2.30.1



