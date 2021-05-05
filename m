Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E366374267
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhEEQqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235768AbhEEQo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A6856192A;
        Wed,  5 May 2021 16:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232539;
        bh=iey4tCQW5JeiD6vUoCwVFoz8LR6aKR+s5t6HbTA3be4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acSQXyyytGiOyz2xV2s56oeffmpbO1ml7Q8C5GF53QzbMxSuKgxkzedSLinrelCaN
         LJ5GQTzI2FbY3fRWvCLG6EDZD4CXBRxH9TwpoI51FsMDtDJQiNHIBET+9xhTQi75O8
         h62DrJcsR06PvLPiSkTMLgIgRtlq9WHmnxeHeRhVcQQ187hQgJYbauV2c1QxrXc7Bp
         HyYNAOgWE9VytiqGKLc2neL64a94McvKi+slORyE7FV04/KCBdHRndFZYyaC6wbT9C
         N7ARsxiUwI1g4b5gR43zM4u+5SVthtVopY6MFOPrDzr7Nd2LXICH+W+ipzs+9Rymld
         MjghC21WremRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 059/104] fuse: invalidate attrs when page writeback completes
Date:   Wed,  5 May 2021 12:33:28 -0400
Message-Id: <20210505163413.3461611-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

[ Upstream commit 3466958beb31a8e9d3a1441a34228ed088b84f3e ]

In fuse when a direct/write-through write happens we invalidate attrs
because that might have updated mtime/ctime on server and cached
mtime/ctime will be stale.

What about page writeback path.  Looks like we don't invalidate attrs
there.  To be consistent, invalidate attrs in writeback path as well.  Only
exception is when writeback_cache is enabled.  In that case we strust local
mtime/ctime and there is no need to invalidate attrs.

Recently users started experiencing failure of xfstests generic/080,
geneirc/215 and generic/614 on virtiofs.  This happened only newer "stat"
utility and not older one.  This patch fixes the issue.

So what's the root cause of the issue.  Here is detailed explanation.

generic/080 test does mmap write to a file, closes the file and then checks
if mtime has been updated or not.  When file is closed, it leads to
flushing of dirty pages (and that should update mtime/ctime on server).
But we did not explicitly invalidate attrs after writeback finished.  Still
generic/080 passed so far and reason being that we invalidated atime in
fuse_readpages_end().  This is called in fuse_readahead() path and always
seems to trigger before mmaped write.

So after mmaped write when lstat() is called, it sees that atleast one of
the fields being asked for is invalid (atime) and that results in
generating GETATTR to server and mtime/ctime also get updated and test
passes.

But newer /usr/bin/stat seems to have moved to using statx() syscall now
(instead of using lstat()).  And statx() allows it to query only ctime or
mtime (and not rest of the basic stat fields).  That means when querying
for mtime, fuse_update_get_attr() sees that mtime is not invalid (only
atime is invalid).  So it does not generate a new GETATTR and fill stat
with cached mtime/ctime.  And that means updated mtime is not seen by
xfstest and tests start failing.

Invalidating attrs after writeback completion should solve this problem in
a generic manner.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 8cccecb55fb8..654cccc85c6b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1759,8 +1759,17 @@ static void fuse_writepage_end(struct fuse_mount *fm, struct fuse_args *args,
 		container_of(args, typeof(*wpa), ia.ap.args);
 	struct inode *inode = wpa->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	mapping_set_error(inode->i_mapping, error);
+	/*
+	 * A writeback finished and this might have updated mtime/ctime on
+	 * server making local mtime/ctime stale.  Hence invalidate attrs.
+	 * Do this only if writeback_cache is not enabled.  If writeback_cache
+	 * is enabled, we trust local ctime/mtime.
+	 */
+	if (!fc->writeback_cache)
+		fuse_invalidate_attr(inode);
 	spin_lock(&fi->lock);
 	rb_erase(&wpa->writepages_entry, &fi->writepages);
 	while (wpa->next) {
-- 
2.30.2

