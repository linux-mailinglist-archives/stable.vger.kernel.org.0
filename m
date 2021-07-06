Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCF13BD4CA
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbhGFMRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235469AbhGFLbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1510861CEF;
        Tue,  6 Jul 2021 11:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570550;
        bh=TAJ0SnSUpJfc+Cqj1aFA6K5OlqU8tHyKbd/ynWD3xIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhJ1DOB+w3uhSbHBiWUp9gQOq87CarQgpcXlKaRv5YoxTLj1ffjjyzv83zVI9CyMq
         E560Atd8OIsSReBs5RXSxMg2W1bePiNxEGzzE81wupbXi9/+ietDYm4YxF30WBY2q/
         V92BWePexrAmPcONORjLA2U1s1RIlsYq7xXDIzwmPsWsAkPzeD+1aKlEo8rY/DWX/P
         5SlQMXJ9C8XHI2pYx5Y5K+jfuxLW6qXFsJlbq0loa3VRkpjxYfiqWMLkBYmA6apzeP
         kedmtabBFPtRpfEtiveDL031XJJWTS54+1u3pIe4gU2972FJeGSN/uRNW3BBwO4Lhl
         wA0qBBW9RLcgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+0ba9909df31c6a36974d@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 020/137] reiserfs: add check for invalid 1st journal block
Date:   Tue,  6 Jul 2021 07:20:06 -0400
Message-Id: <20210706112203.2062605-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index e98f99338f8f..df5fc12a6cee 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2760,6 +2760,20 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
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

