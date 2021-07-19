Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDD93CD74B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbhGSOP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241368AbhGSOPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:15:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78EC1610F7;
        Mon, 19 Jul 2021 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706590;
        bh=k+8omI6Nwz23v/k5b2CTWMW6fyxyul0QZhMg9yGEjnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAdATaA8RNm0H9tFcsJy1/cFdnXLAdywEnrmf0HR+1utucD4SpJu/f+tSJGfdesDD
         KRLxaAhH4ojSDdc5xAyF1hSGyogKL5+WGIcAawr9HI4gofMatZN3RxAhxBH1MRtsrh
         Jm3SrReFry2K6T1noFfl8atqohapfqO+TPe57sY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        syzbot+2dcfeaf8cb49b05e8f1a@syzkaller.appspotmail.com,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.4 012/188] ext4: fix kernel infoleak via ext4_extent_header
Date:   Mon, 19 Jul 2021 16:49:56 +0200
Message-Id: <20210719144915.980025466@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
@@ -865,6 +865,7 @@ int ext4_ext_tree_init(handle_t *handle,
 	eh->eh_entries = 0;
 	eh->eh_magic = EXT4_EXT_MAGIC;
 	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode, 0));
+	eh->eh_generation = 0;
 	ext4_mark_inode_dirty(handle, inode);
 	return 0;
 }
@@ -1128,6 +1129,7 @@ static int ext4_ext_split(handle_t *hand
 	neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
 	neh->eh_magic = EXT4_EXT_MAGIC;
 	neh->eh_depth = 0;
+	neh->eh_generation = 0;
 
 	/* move remainder of path[depth] to the new leaf */
 	if (unlikely(path[depth].p_hdr->eh_entries !=
@@ -1205,6 +1207,7 @@ static int ext4_ext_split(handle_t *hand
 		neh->eh_magic = EXT4_EXT_MAGIC;
 		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode, 0));
 		neh->eh_depth = cpu_to_le16(depth - i);
+		neh->eh_generation = 0;
 		fidx = EXT_FIRST_INDEX(neh);
 		fidx->ei_block = border;
 		ext4_idx_store_pblock(fidx, oldblock);


