Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3649420DDC
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbhJDNTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236100AbhJDNRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98B0C6140B;
        Mon,  4 Oct 2021 13:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352832;
        bh=RIL/+FetrdQsM3QDEaP1T7W6PTzOS2m9SLR+75p0IaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOuC3bkdu1t0IN4AdHaP5shjESrUtGxWglIfdLckbYksU4iaRseMRgHXhT/TT3Hgq
         ODMKnHMSM8+sjmxfIpovHdXbGuyY/fe8Rw9zMugirCfA/wT4iOxni50a3+4LwCt7l5
         4/rwYQLEFHPM1+5/pFcNPU834YZOyTQITKe7Q5Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Eric Whitney <enwlinux@gmail.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 42/56] ext4: fix reserved space counter leakage
Date:   Mon,  4 Oct 2021 14:53:02 +0200
Message-Id: <20211004125031.327804120@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
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
@@ -1782,6 +1782,7 @@ static int ext4_insert_delayed_block(str
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int ret;
 	bool allocated = false;
+	bool reserved = false;
 
 	/*
 	 * If the cluster containing lblk is shared with a delayed,
@@ -1798,6 +1799,7 @@ static int ext4_insert_delayed_block(str
 		ret = ext4_da_reserve_space(inode);
 		if (ret != 0)   /* ENOSPC */
 			goto errout;
+		reserved = true;
 	} else {   /* bigalloc */
 		if (!ext4_es_scan_clu(inode, &ext4_es_is_delonly, lblk)) {
 			if (!ext4_es_scan_clu(inode,
@@ -1810,6 +1812,7 @@ static int ext4_insert_delayed_block(str
 					ret = ext4_da_reserve_space(inode);
 					if (ret != 0)   /* ENOSPC */
 						goto errout;
+					reserved = true;
 				} else {
 					allocated = true;
 				}
@@ -1820,6 +1823,8 @@ static int ext4_insert_delayed_block(str
 	}
 
 	ret = ext4_es_insert_delayed_block(inode, lblk, allocated);
+	if (ret && reserved)
+		ext4_da_release_space(inode, 1);
 
 errout:
 	return ret;
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1141,6 +1141,12 @@ static void ext4_destroy_inode(struct in
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


