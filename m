Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78E93CA5B6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhGOSoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231145AbhGOSoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 640CF613CF;
        Thu, 15 Jul 2021 18:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374469;
        bh=QPgQE2G1/gCeuN/4WN1kwXiMfVifxrdMfmmLcWoYOf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPgGJ1pebMKdCeHFAEjX0QugYjKvB/maaLpKEraGlcXzCRbor3l983itn262lBGyi
         md+V/LSKeLhw4XccP2GXBpaJdWp3SMkrrjwNPaqWcSmQW2U9OJboMNsNbz++Le1h+j
         a32rClzIwSRPw0VbA7Jv4XXOu4Uxpq/ov9Gvlees=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0ba9909df31c6a36974d@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/122] reiserfs: add check for invalid 1st journal block
Date:   Thu, 15 Jul 2021 20:37:40 +0200
Message-Id: <20210715182452.558874251@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4b3e3e73b512..09ad022a78a5 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2763,6 +2763,20 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
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



