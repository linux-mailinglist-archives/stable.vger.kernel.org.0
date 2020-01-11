Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F88138050
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgAKK2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:28:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731015AbgAKK2O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:28:14 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 887752087F;
        Sat, 11 Jan 2020 10:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738493;
        bh=6RF8CgifYq6GlZQcRrfg/748cIyvvvT7HpOr7gPbsg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woqgwqgTe6Yqhfo2uINc2CdgvrXzwHp3bpM+/cjP1KwTUsqZxL7e080rFaEfSuuqG
         zd74ApxdgK718HviCvuaRnD1etBMPsnnBrTvHrdLaF+tVe4S8VJt3zoHLXc4Auo2kw
         Fue6q8yYx+F/LANghXaV+Ke6NBF7y4O9pkskdzA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/165] fs: call fsnotify_sb_delete after evict_inodes
Date:   Sat, 11 Jan 2020 10:50:24 +0100
Message-Id: <20200111094930.916003137@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 1edc8eb2e93130e36ac74ac9c80913815a57d413 ]

When a filesystem is unmounted, we currently call fsnotify_sb_delete()
before evict_inodes(), which means that fsnotify_unmount_inodes()
must iterate over all inodes on the superblock looking for any inodes
with watches.  This is inefficient and can lead to livelocks as it
iterates over many unwatched inodes.

At this point, SB_ACTIVE is gone and dropping refcount to zero kicks
the inode out out immediately, so anything processed by
fsnotify_sb_delete / fsnotify_unmount_inodes gets evicted in that loop.

After that, the call to evict_inodes will evict everything else with a
zero refcount.

This should speed things up overall, and avoid livelocks in
fsnotify_unmount_inodes().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fsnotify.c | 3 +++
 fs/super.c           | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index ac9eb273e28c..f44e39c68328 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -57,6 +57,9 @@ static void fsnotify_unmount_inodes(struct super_block *sb)
 		 * doing an __iget/iput with SB_ACTIVE clear would actually
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
+		 * However, we should have been called /after/ evict_inodes
+		 * removed all zero refcount inodes, in any case.  Test to
+		 * be sure.
 		 */
 		if (!atomic_read(&inode->i_count)) {
 			spin_unlock(&inode->i_lock);
diff --git a/fs/super.c b/fs/super.c
index cfadab2cbf35..cd352530eca9 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -448,10 +448,12 @@ void generic_shutdown_super(struct super_block *sb)
 		sync_filesystem(sb);
 		sb->s_flags &= ~SB_ACTIVE;
 
-		fsnotify_sb_delete(sb);
 		cgroup_writeback_umount();
 
+		/* evict all inodes with zero refcount */
 		evict_inodes(sb);
+		/* only nonzero refcount inodes can have marks */
+		fsnotify_sb_delete(sb);
 
 		if (sb->s_dio_done_wq) {
 			destroy_workqueue(sb->s_dio_done_wq);
-- 
2.20.1



