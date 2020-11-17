Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4929F2B5F8F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 13:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgKQM5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728594AbgKQM5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCF6F2225E;
        Tue, 17 Nov 2020 12:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617836;
        bh=TQqz/JTZpMMa0VZc/TvCcTMU2ZwN+aA6Hkoh4FRvUeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SC0QZuGElEFCJF5R39lOURgz7D9Ns3xHWuepNUqJcuKrce93owhpCh7GJ+qHOKBB5
         qp8fHXowl74Fq29r75ZzUeHschzgjGZWkOTCGdJ55tQLi4n9AZ0W0EYsP9RVHww8md
         gu9gy4uDVRxPnQc2uq6ZPNCM3tdWCq0Z/W+AlLSw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 15/21] vfs: remove lockdep bogosity in __sb_start_write
Date:   Tue, 17 Nov 2020 07:56:46 -0500
Message-Id: <20201117125652.599614-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 22843291efc986ce7722610073fcf85a39b4cb13 ]

__sb_start_write has some weird looking lockdep code that claims to
exist to handle nested freeze locking requests from xfs.  The code as
written seems broken -- if we think we hold a read lock on any of the
higher freeze levels (e.g. we hold SB_FREEZE_WRITE and are trying to
lock SB_FREEZE_PAGEFAULT), it converts a blocking lock attempt into a
trylock.

However, it's not correct to downgrade a blocking lock attempt to a
trylock unless the downgrading code or the callers are prepared to deal
with that situation.  Neither __sb_start_write nor its callers handle
this at all.  For example:

sb_start_pagefault ignores the return value completely, with the result
that if xfs_filemap_fault loses a race with a different thread trying to
fsfreeze, it will proceed without pagefault freeze protection (thereby
breaking locking rules) and then unlocks the pagefault freeze lock that
it doesn't own on its way out (thereby corrupting the lock state), which
leads to a system hang shortly afterwards.

Normally, this won't happen because our ownership of a read lock on a
higher freeze protection level blocks fsfreeze from grabbing a write
lock on that higher level.  *However*, if lockdep is offline,
lock_is_held_type unconditionally returns 1, which means that
percpu_rwsem_is_held returns 1, which means that __sb_start_write
unconditionally converts blocking freeze lock attempts into trylocks,
even when we *don't* hold anything that would block a fsfreeze.

Apparently this all held together until 5.10-rc1, when bugs in lockdep
caused lockdep to shut itself off early in an fstests run, and once
fstests gets to the "race writes with freezer" tests, kaboom.  This
might explain the long trail of vanishingly infrequent livelocks in
fstests after lockdep goes offline that I've never been able to
diagnose.

We could fix it by spinning on the trylock if wait==true, but AFAICT the
locking works fine if lockdep is not built at all (and I didn't see any
complaints running fstests overnight), so remove this snippet entirely.

NOTE: Commit f4b554af9931 in 2015 created the current weird logic (which
used to exist in a different form in commit 5accdf82ba25c from 2012) in
__sb_start_write.  XFS solved this whole problem in the late 2.6 era by
creating a variant of transactions (XFS_TRANS_NO_WRITECOUNT) that don't
grab intwrite freeze protection, thus making lockdep's solution
unnecessary.  The commit claims that Dave Chinner explained that the
trylock hack + comment could be removed, but nobody ever did.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/super.c | 33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 904459b351199..3a0777612c49b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1645,36 +1645,11 @@ EXPORT_SYMBOL(__sb_end_write);
  */
 int __sb_start_write(struct super_block *sb, int level, bool wait)
 {
-	bool force_trylock = false;
-	int ret = 1;
+	if (!wait)
+		return percpu_down_read_trylock(sb->s_writers.rw_sem + level-1);
 
-#ifdef CONFIG_LOCKDEP
-	/*
-	 * We want lockdep to tell us about possible deadlocks with freezing
-	 * but it's it bit tricky to properly instrument it. Getting a freeze
-	 * protection works as getting a read lock but there are subtle
-	 * problems. XFS for example gets freeze protection on internal level
-	 * twice in some cases, which is OK only because we already hold a
-	 * freeze protection also on higher level. Due to these cases we have
-	 * to use wait == F (trylock mode) which must not fail.
-	 */
-	if (wait) {
-		int i;
-
-		for (i = 0; i < level - 1; i++)
-			if (percpu_rwsem_is_held(sb->s_writers.rw_sem + i)) {
-				force_trylock = true;
-				break;
-			}
-	}
-#endif
-	if (wait && !force_trylock)
-		percpu_down_read(sb->s_writers.rw_sem + level-1);
-	else
-		ret = percpu_down_read_trylock(sb->s_writers.rw_sem + level-1);
-
-	WARN_ON(force_trylock && !ret);
-	return ret;
+	percpu_down_read(sb->s_writers.rw_sem + level-1);
+	return 1;
 }
 EXPORT_SYMBOL(__sb_start_write);
 
-- 
2.27.0

