Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908C41B41CE
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgDVKGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgDVKGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:06:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50F5720575;
        Wed, 22 Apr 2020 10:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549964;
        bh=zMxR76d63ZCfvoPS1JehDQViBiTPeOazz91jRXSDdM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EVWjoqejLxn90jejcfQqGr2RWwzUNn2Juk6JmZrPIRwKc+3fWi8x5UTFzImju4IY
         l7JXCn0g+WUqKrc/3oon2BlW5IqhnOpw/YUYxwr4htiZXB2oS3uMhD9XjMMuh9aYmV
         qLedEQe5EkXdqIXjwWdKNajm0ph3kQn4IlcHZqJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 079/125] ext4: do not zeroout extents beyond i_disksize
Date:   Wed, 22 Apr 2020 11:56:36 +0200
Message-Id: <20200422095045.854537584@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
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
@@ -3445,8 +3445,8 @@ static int ext4_ext_convert_to_initializ
 		(unsigned long long)map->m_lblk, map_len);
 
 	sbi = EXT4_SB(inode->i_sb);
-	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
-		inode->i_sb->s_blocksize_bits;
+	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
+			>> inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map_len)
 		eof_block = map->m_lblk + map_len;
 
@@ -3701,8 +3701,8 @@ static int ext4_split_convert_extents(ha
 		  __func__, inode->i_ino,
 		  (unsigned long long)map->m_lblk, map->m_len);
 
-	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
-		inode->i_sb->s_blocksize_bits;
+	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
+			>> inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map->m_len)
 		eof_block = map->m_lblk + map->m_len;
 	/*


