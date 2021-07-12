Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D693C447D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbhGLGTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233857AbhGLGTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:19:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C31E610D0;
        Mon, 12 Jul 2021 06:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070585;
        bh=E3CTIgm+XqwSBAwNNrnsywctrVqznE7HhfSIOEL1Yjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBfJZ3HJjSSPLS1boKP764K7Y/Ey+kRB+yOpIbhUjmKXjcdBHDBOd6F9Hh+hrdOwr
         baSla9ykHbvUIFAKMCOFU7+7nVS5XS0fhkH6WJHbrHFHKePwwxk/SuNiQchdeJbVpY
         BS/rSEAZb2/18u7KuRhJyP35NDkWRCnql/sqcrdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        syzbot+2dcfeaf8cb49b05e8f1a@syzkaller.appspotmail.com,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 026/348] ext4: fix kernel infoleak via ext4_extent_header
Date:   Mon, 12 Jul 2021 08:06:50 +0200
Message-Id: <20210712060703.947244249@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

commit ce3aba43599f0b50adbebff133df8d08a3d5fffe upstream.

Initialize eh_generation of struct ext4_extent_header to prevent leaking
info to userspace. Fixes KMSAN kernel-infoleak bug reported by syzbot at:
http://syzkaller.appspot.com/bug?id=78e9ad0e6952a3ca16e8234724b2fa92d041b9b8

Cc: stable@kernel.org
Reported-by: syzbot+2dcfeaf8cb49b05e8f1a@syzkaller.appspotmail.com
Fixes: a86c61812637 ("[PATCH] ext3: add extent map support")
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20210506185655.7118-1-mail@anirudhrb.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -862,6 +862,7 @@ int ext4_ext_tree_init(handle_t *handle,
 	eh->eh_entries = 0;
 	eh->eh_magic = EXT4_EXT_MAGIC;
 	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode, 0));
+	eh->eh_generation = 0;
 	ext4_mark_inode_dirty(handle, inode);
 	return 0;
 }
@@ -1118,6 +1119,7 @@ static int ext4_ext_split(handle_t *hand
 	neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
 	neh->eh_magic = EXT4_EXT_MAGIC;
 	neh->eh_depth = 0;
+	neh->eh_generation = 0;
 
 	/* move remainder of path[depth] to the new leaf */
 	if (unlikely(path[depth].p_hdr->eh_entries !=
@@ -1195,6 +1197,7 @@ static int ext4_ext_split(handle_t *hand
 		neh->eh_magic = EXT4_EXT_MAGIC;
 		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode, 0));
 		neh->eh_depth = cpu_to_le16(depth - i);
+		neh->eh_generation = 0;
 		fidx = EXT_FIRST_INDEX(neh);
 		fidx->ei_block = border;
 		ext4_idx_store_pblock(fidx, oldblock);


