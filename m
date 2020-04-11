Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1E91A56B2
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgDKXOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730297AbgDKXOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:14:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1217B216FD;
        Sat, 11 Apr 2020 23:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646850;
        bh=2OdZ3JfjRylc9rYSG0ohjEloDXrkW0YDQ8XREtiJ5qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMwNXXJQjpgix47tJ4NSw9JVxUlFhQtcbGrQlVw0+/C6yiUHht1W0J0+1vXsRippX
         JEJj7/JUgwEkjvzaZvAwuXulv6WGmEJScrHoiAqCg2SDhmCWjGBCKsp37kDjDMYFs1
         hfqucwSM35bACKXXI05gSyGHPLvxktlw6ZU8Szbg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 36/37] ext4: avoid ENOSPC when avoiding to reuse recently deleted inodes
Date:   Sat, 11 Apr 2020 19:13:25 -0400
Message-Id: <20200411231327.26550-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit d05466b27b19af8e148376590ed54d289b607f0a ]

When ext4 is running on a filesystem without a journal, it tries not to
reuse recently deleted inodes to provide better chances for filesystem
recovery in case of crash. However this logic forbids reuse of freed
inodes for up to 5 minutes and especially for filesystems with smaller
number of inodes can lead to ENOSPC errors returned when allocating new
inodes.

Fix the problem by allowing to reuse recently deleted inode if there's
no other inode free in the scanned range.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200318121317.31941-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ialloc.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2a480c0ef1bc1..0f92276b795d6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -722,21 +722,34 @@ static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
 static int find_inode_bit(struct super_block *sb, ext4_group_t group,
 			  struct buffer_head *bitmap, unsigned long *ino)
 {
+	bool check_recently_deleted = EXT4_SB(sb)->s_journal == NULL;
+	unsigned long recently_deleted_ino = EXT4_INODES_PER_GROUP(sb);
+
 next:
 	*ino = ext4_find_next_zero_bit((unsigned long *)
 				       bitmap->b_data,
 				       EXT4_INODES_PER_GROUP(sb), *ino);
 	if (*ino >= EXT4_INODES_PER_GROUP(sb))
-		return 0;
+		goto not_found;
 
-	if ((EXT4_SB(sb)->s_journal == NULL) &&
-	    recently_deleted(sb, group, *ino)) {
+	if (check_recently_deleted && recently_deleted(sb, group, *ino)) {
+		recently_deleted_ino = *ino;
 		*ino = *ino + 1;
 		if (*ino < EXT4_INODES_PER_GROUP(sb))
 			goto next;
-		return 0;
+		goto not_found;
 	}
-
+	return 1;
+not_found:
+	if (recently_deleted_ino >= EXT4_INODES_PER_GROUP(sb))
+		return 0;
+	/*
+	 * Not reusing recently deleted inodes is mostly a preference. We don't
+	 * want to report ENOSPC or skew allocation patterns because of that.
+	 * So return even recently deleted inode if we could find better in the
+	 * given range.
+	 */
+	*ino = recently_deleted_ino;
 	return 1;
 }
 
-- 
2.20.1

