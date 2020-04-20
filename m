Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2042B1B0B83
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgDTM42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbgDTMpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A456720736;
        Mon, 20 Apr 2020 12:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386704;
        bh=OzXZ3vFDQf5L7YQhu4WBLDY9ohBbh1tyFL9MEjkOccU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jb2VSlITQzDOMCi+ZXN+BfCg2A0KUoeDZNZuI6R8rvdvll1/kcrVC7DhkcxxA9ib4
         nt5iy1LCbHbt7i0QACu8glOxcNJCveJPwH0VyaCffGCsQb8l25v8Xn8u7jw+eJWKiw
         QqIYMY07np5Gz/7202+RiKFoNP4t7vaCSLz7UM44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.6 65/71] ext4: do not zeroout extents beyond i_disksize
Date:   Mon, 20 Apr 2020 14:39:19 +0200
Message-Id: <20200420121522.051177233@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 801674f34ecfed033b062a0f217506b93c8d5e8a upstream.

We do not want to create initialized extents beyond end of file because
for e2fsck it is impossible to distinguish them from a case of corrupted
file size / extent tree and so it complains like:

Inode 12, i_size is 147456, should be 163840.  Fix? no

Code in ext4_ext_convert_to_initialized() and
ext4_split_convert_extents() try to make sure it does not create
initialized extents beyond inode size however they check against
inode->i_size which is wrong. They should instead check against
EXT4_I(inode)->i_disksize which is the current inode size on disk.
That's what e2fsck is going to see in case of crash before all dirty
data is written. This bug manifests as generic/456 test failure (with
recent enough fstests where fsx got fixed to properly pass
FALLOC_KEEP_SIZE_FL flags to the kernel) when run with dioread_lock
mount option.

CC: stable@vger.kernel.org
Fixes: 21ca087a3891 ("ext4: Do not zero out uninitialized extents beyond i_size")
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20200331105016.8674-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3532,8 +3532,8 @@ static int ext4_ext_convert_to_initializ
 		(unsigned long long)map->m_lblk, map_len);
 
 	sbi = EXT4_SB(inode->i_sb);
-	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
-		inode->i_sb->s_blocksize_bits;
+	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
+			>> inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map_len)
 		eof_block = map->m_lblk + map_len;
 
@@ -3785,8 +3785,8 @@ static int ext4_split_convert_extents(ha
 		  __func__, inode->i_ino,
 		  (unsigned long long)map->m_lblk, map->m_len);
 
-	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
-		inode->i_sb->s_blocksize_bits;
+	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
+			>> inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map->m_len)
 		eof_block = map->m_lblk + map->m_len;
 	/*


