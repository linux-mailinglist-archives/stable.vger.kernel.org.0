Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31013CDDD2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344011AbhGSPAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343893AbhGSO7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CED061409;
        Mon, 19 Jul 2021 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709060;
        bh=AE2ODXO1OyHIAhGncv2pn4YNtNxzIUeIs4tpORT9ccE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4SwLhnG1roCgdTsCrIgRT0nY3Gw7kzXfiOnyTFj0rrIls1oo8CuEAgb2abY9TyLL
         Y15vQGk5OXzIX8n8aTXHa7M0MCuh5eKW3ZM5YhFZrt4+7Y2Fvg2LdysD0hpZCeoiab
         yjHk7lDaKU3ex5RDozfYWeciIUTirZ8v1e8OKLjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0ba9909df31c6a36974d@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 237/421] reiserfs: add check for invalid 1st journal block
Date:   Mon, 19 Jul 2021 16:50:48 +0200
Message-Id: <20210719144954.630566874@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 8a76f9d14bc6..78be6dbcd762 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2772,6 +2772,20 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
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



