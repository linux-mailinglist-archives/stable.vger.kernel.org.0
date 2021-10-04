Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B5442103F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhJDNmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238364AbhJDNkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:40:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4512363242;
        Mon,  4 Oct 2021 13:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353506;
        bh=D09irdrxtdPodoeP43k512tk67bMsz+r/9cUiYRIAjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCYmsewHW7fhvYNjd341ummuS22+rU1N9P3dTfj5xYJ2nZYlrZv+DvHKfphEL6DcH
         1EjfaGmqfSHevc38Bmmq8nhDiMoZrer1QfWbAyujkQ+1D4MbEdhCDFmfyIZ+7RG+91
         2BxIwpKx6cbEz7MxqlubK2TOQcR6RMyO+a7sMxSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Eric Whitney <enwlinux@gmail.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.14 155/172] ext4: fix reserved space counter leakage
Date:   Mon,  4 Oct 2021 14:53:25 +0200
Message-Id: <20211004125049.975194364@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffle Xu <jefflexu@linux.alibaba.com>

commit 6fed83957f21eff11c8496e9f24253b03d2bc1dc upstream.

When ext4_insert_delayed block receives and recovers from an error from
ext4_es_insert_delayed_block(), e.g., ENOMEM, it does not release the
space it has reserved for that block insertion as it should. One effect
of this bug is that s_dirtyclusters_counter is not decremented and
remains incorrectly elevated until the file system has been unmounted.
This can result in premature ENOSPC returns and apparent loss of free
space.

Another effect of this bug is that
/sys/fs/ext4/<dev>/delayed_allocation_blocks can remain non-zero even
after syncfs has been executed on the filesystem.

Besides, add check for s_dirtyclusters_counter when inode is going to be
evicted and freed. s_dirtyclusters_counter can still keep non-zero until
inode is written back in .evict_inode(), and thus the check is delayed
to .destroy_inode().

Fixes: 51865fda28e5 ("ext4: let ext4 maintain extent status tree")
Cc: stable@kernel.org
Suggested-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210823061358.84473-1-jefflexu@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    5 +++++
 fs/ext4/super.c |    6 ++++++
 2 files changed, 11 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1640,6 +1640,7 @@ static int ext4_insert_delayed_block(str
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int ret;
 	bool allocated = false;
+	bool reserved = false;
 
 	/*
 	 * If the cluster containing lblk is shared with a delayed,
@@ -1656,6 +1657,7 @@ static int ext4_insert_delayed_block(str
 		ret = ext4_da_reserve_space(inode);
 		if (ret != 0)   /* ENOSPC */
 			goto errout;
+		reserved = true;
 	} else {   /* bigalloc */
 		if (!ext4_es_scan_clu(inode, &ext4_es_is_delonly, lblk)) {
 			if (!ext4_es_scan_clu(inode,
@@ -1668,6 +1670,7 @@ static int ext4_insert_delayed_block(str
 					ret = ext4_da_reserve_space(inode);
 					if (ret != 0)   /* ENOSPC */
 						goto errout;
+					reserved = true;
 				} else {
 					allocated = true;
 				}
@@ -1678,6 +1681,8 @@ static int ext4_insert_delayed_block(str
 	}
 
 	ret = ext4_es_insert_delayed_block(inode, lblk, allocated);
+	if (ret && reserved)
+		ext4_da_release_space(inode, 1);
 
 errout:
 	return ret;
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1351,6 +1351,12 @@ static void ext4_destroy_inode(struct in
 				true);
 		dump_stack();
 	}
+
+	if (EXT4_I(inode)->i_reserved_data_blocks)
+		ext4_msg(inode->i_sb, KERN_ERR,
+			 "Inode %lu (%p): i_reserved_data_blocks (%u) not cleared!",
+			 inode->i_ino, EXT4_I(inode),
+			 EXT4_I(inode)->i_reserved_data_blocks);
 }
 
 static void init_once(void *foo)


