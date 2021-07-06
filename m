Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7508B3BD260
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237583AbhGFLmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237632AbhGFLgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5CA761F4A;
        Tue,  6 Jul 2021 11:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570937;
        bh=PZXYuut4wmd+WgVsl4d2dnci3renyfwjVzoF4ECIl1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdXEDd7oMOYhFiHvmlqR3J3iMP+ncInLYtZZr7Oi5lEO7+622YBBeNbhgkdXpOibf
         YarBZacFL0vfMzULbTbvj2FErfZAHlswlqA2tOVDrx4pGwD569NNU0VhAyUX+lV1aG
         SUEyHnJ3phoFGqjAK3XhWgmxWVkIrrX2vgSiCUV6jz0pTXRLYV5t83pH09YpvvqoA8
         rt14EH04Tgnq7+WNzfoshaMHiRQzK0XJwHDpfhttK0GsWim428sdpE9+YuTRA50vld
         P7rqM00+1fa3av4AI6C5yzr9BDsByWaIs0zftZGc9XZOtVmHI0FbPH6+TbhFJFbmBm
         RDo4/BP3c+IFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+0ba9909df31c6a36974d@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 07/35] reiserfs: add check for invalid 1st journal block
Date:   Tue,  6 Jul 2021 07:28:19 -0400
Message-Id: <20210706112848.2066036-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit a149127be52fa7eaf5b3681a0317a2bbb772d5a9 ]

syzbot reported divide error in reiserfs.
The problem was in incorrect journal 1st block.

Syzbot's reproducer manualy generated wrong superblock
with incorrect 1st block. In journal_init() wasn't
any checks about this particular case.

For example, if 1st journal block is before superblock
1st block, it can cause zeroing important superblock members
in do_journal_end().

Link: https://lore.kernel.org/r/20210517121545.29645-1-paskripkin@gmail.com
Reported-by: syzbot+0ba9909df31c6a36974d@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/journal.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 2a5c4813c47d..94871f611fa8 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2766,6 +2766,20 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 		goto free_and_return;
 	}
 
+	/*
+	 * Sanity check to see if journal first block is correct.
+	 * If journal first block is invalid it can cause
+	 * zeroing important superblock members.
+	 */
+	if (!SB_ONDISK_JOURNAL_DEVICE(sb) &&
+	    SB_ONDISK_JOURNAL_1st_BLOCK(sb) < SB_JOURNAL_1st_RESERVED_BLOCK(sb)) {
+		reiserfs_warning(sb, "journal-1393",
+				 "journal 1st super block is invalid: 1st reserved block %d, but actual 1st block is %d",
+				 SB_JOURNAL_1st_RESERVED_BLOCK(sb),
+				 SB_ONDISK_JOURNAL_1st_BLOCK(sb));
+		goto free_and_return;
+	}
+
 	if (journal_init_dev(sb, journal, j_dev_name) != 0) {
 		reiserfs_warning(sb, "sh-462",
 				 "unable to initialize journal device");
-- 
2.30.2

