Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43F4348F1D
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhCYL0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230223AbhCYLZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 229F561A24;
        Thu, 25 Mar 2021 11:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671533;
        bh=L9K+An1mAexKxxJjd9SicPaNHcs34iGZOFdaZ2GdXc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lvzabexfpky+aaaTW2+H+TcQlvSjR6QZR/HbWPMjhoRUWo3QobFHnCwRpO6+xq8Dt
         YbZ90uCiMt7D+qbKVTpFdjAgz3t2cd1CfOdfV3NG9+3uR0faceL3X8A5SYX6y/JTv2
         i6aSPRD1o3gELMGuFNe3G9v4QN/OljatRhITKjb78rp+iVY4IFkSz4doONYWlMneXW
         jD7xKB9WK+W+5vtrmA8isYleG8XH2SeDkgPNI59s0D5BTteodv5B1YZ6GoN9s4ORco
         FVnciDJeNT6/uYhPZCxV1LyQqvEBTjMle6cqgiCNy90aTJjquzNo8ZM9Ern9uqgwz3
         WWGnsvMg+TpBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 26/44] btrfs: track qgroup released data in own variable in insert_prealloc_file_extent
Date:   Thu, 25 Mar 2021 07:24:41 -0400
Message-Id: <20210325112459.1926846-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit fbf48bb0b197e6894a04c714728c952af7153bf3 ]

There is a piece of weird code in insert_prealloc_file_extent(), which
looks like:

	ret = btrfs_qgroup_release_data(inode, file_offset, len);
	if (ret < 0)
		return ERR_PTR(ret);
	if (trans) {
		ret = insert_reserved_file_extent(trans, inode,
						  file_offset, &stack_fi,
						  true, ret);
	...
	}
	extent_info.is_new_extent = true;
	extent_info.qgroup_reserved = ret;
	...

Note how the variable @ret is abused here, and if anyone is adding code
just after btrfs_qgroup_release_data() call, it's super easy to
overwrite the @ret and cause tons of qgroup related bugs.

Fix such abuse by introducing new variable @qgroup_released, so that we
won't reuse the existing variable @ret.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9b4f75568261..8f36071769fa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9674,6 +9674,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	struct btrfs_path *path;
 	u64 start = ins->objectid;
 	u64 len = ins->offset;
+	int qgroup_released;
 	int ret;
 
 	memset(&stack_fi, 0, sizeof(stack_fi));
@@ -9686,14 +9687,14 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	btrfs_set_stack_file_extent_compression(&stack_fi, BTRFS_COMPRESS_NONE);
 	/* Encryption and other encoding is reserved and all 0 */
 
-	ret = btrfs_qgroup_release_data(inode, file_offset, len);
-	if (ret < 0)
-		return ERR_PTR(ret);
+	qgroup_released = btrfs_qgroup_release_data(inode, file_offset, len);
+	if (qgroup_released < 0)
+		return ERR_PTR(qgroup_released);
 
 	if (trans) {
 		ret = insert_reserved_file_extent(trans, inode,
 						  file_offset, &stack_fi,
-						  true, ret);
+						  true, qgroup_released);
 		if (ret)
 			return ERR_PTR(ret);
 		return trans;
@@ -9706,7 +9707,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.file_offset = file_offset;
 	extent_info.extent_buf = (char *)&stack_fi;
 	extent_info.is_new_extent = true;
-	extent_info.qgroup_reserved = ret;
+	extent_info.qgroup_reserved = qgroup_released;
 	extent_info.insertions = 0;
 
 	path = btrfs_alloc_path();
-- 
2.30.1

