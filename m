Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0A0383394
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbhEQPAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240833AbhEQO6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:58:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BAFE614A7;
        Mon, 17 May 2021 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261547;
        bh=jnv7HwSY3xq1d30lnZfOSbHOjOdUF6aan3jGwyXcrqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6MM4wcJJ9hul+9e8JxMF7Gy0e3Z1Zq5lzyXia5dIBuUmRwxrZx6z1hn1bPrm+zLf
         AQo3GPeFWzy6xCKV0t7+ag3QL0wqaccwVuU+g8dJkXhjLuKWLM3W7tC445YWp6XuH0
         /TWdHyzhkM5rKFcOhfzxubBNIwjNYG4bPGL8Qn0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 361/363] ext4: fix debug format string warning
Date:   Mon, 17 May 2021 16:03:47 +0200
Message-Id: <20210517140314.799324416@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit fcdf3c34b7abdcbb49690c94c7fa6ce224dc9749 upstream.

Using no_printk() for jbd_debug() revealed two warnings:

fs/jbd2/recovery.c: In function 'fc_do_one_pass':
fs/jbd2/recovery.c:256:30: error: format '%d' expects a matching 'int' argument [-Werror=format=]
  256 |                 jbd_debug(3, "Processing fast commit blk with seq %d");
      |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/ext4/fast_commit.c: In function 'ext4_fc_replay_add_range':
fs/ext4/fast_commit.c:1732:30: error: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Werror=format=]
 1732 |                 jbd_debug(1, "Converting from %d to %d %lld",

The first one was added incorrectly, and was also missing a few newlines
in debug output, and the second one happened when the type of an
argument changed.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: d556435156b7 ("jbd2: avoid -Wempty-body warnings")
Fixes: 6db074618969 ("ext4: use BIT() macro for BH_** state bits")
Fixes: 5b849b5f96b4 ("jbd2: fast commit recovery path")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210409201211.1866633-1-arnd@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |    2 +-
 fs/jbd2/recovery.c    |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1736,7 +1736,7 @@ static int ext4_fc_replay_add_range(stru
 		}
 
 		/* Range is mapped and needs a state change */
-		jbd_debug(1, "Converting from %d to %d %lld",
+		jbd_debug(1, "Converting from %ld to %d %lld",
 				map.m_flags & EXT4_MAP_UNWRITTEN,
 			ext4_ext_is_unwritten(ex), map.m_pblk);
 		ret = ext4_ext_replay_update_ex(inode, cur, map.m_len,
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -245,15 +245,14 @@ static int fc_do_one_pass(journal_t *jou
 		return 0;
 
 	while (next_fc_block <= journal->j_fc_last) {
-		jbd_debug(3, "Fast commit replay: next block %ld",
+		jbd_debug(3, "Fast commit replay: next block %ld\n",
 			  next_fc_block);
 		err = jread(&bh, journal, next_fc_block);
 		if (err) {
-			jbd_debug(3, "Fast commit replay: read error");
+			jbd_debug(3, "Fast commit replay: read error\n");
 			break;
 		}
 
-		jbd_debug(3, "Processing fast commit blk with seq %d");
 		err = journal->j_fc_replay_callback(journal, bh, pass,
 					next_fc_block - journal->j_fc_first,
 					expected_commit_id);


