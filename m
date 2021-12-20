Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B2647AFAC
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbhLTPRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbhLTPPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:15:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D113C0FD23F;
        Mon, 20 Dec 2021 06:57:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 355AEB80EDE;
        Mon, 20 Dec 2021 14:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C569C36AE7;
        Mon, 20 Dec 2021 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012268;
        bh=WE5+gFqdUsXOm9xyeh+FJqO1u9OpoOa7USbiN3Bd7EE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZXJ+81m6tdhLHc1LQseorMVcv516bmx0qXe9SWGN8r8zvhuNp9UF70jndBsGjbr5
         c6AqP1mLDZv6EStpR2NNx1/XwRiTR22I0cdKZLhFD4mVbK3c5hOzZcIZCLuTxxt9f3
         RLOICtohD7w7T3Gl3cP7fWv9pF2VE697jwpckuSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        kafs-testing+fedora34_64checkkafs-build-300@auristor.com,
        Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/177] afs: Fix mmap
Date:   Mon, 20 Dec 2021 15:34:18 +0100
Message-Id: <20211220143043.713816346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 1744a22ae948799da7927b53ec97ccc877ff9d61 ]

Fix afs_add_open_map() to check that the vnode isn't already on the list
when it adds it.  It's possible that afs_drop_open_mmap() decremented
the cb_nr_mmap counter, but hadn't yet got into the locked section to
remove it.

Also vnode->cb_mmap_link should be initialised, so fix that too.

Fixes: 6e0e99d58a65 ("afs: Fix mmap coherency vs 3rd-party changes")
Reported-by: kafs-testing+fedora34_64checkkafs-build-300@auristor.com
Suggested-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: kafs-testing+fedora34_64checkkafs-build-300@auristor.com
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/686465.1639435380@warthog.procyon.org.uk/ # v1
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/file.c  | 5 +++--
 fs/afs/super.c | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index e6c447ae91f38..b165377179c3c 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -502,8 +502,9 @@ static void afs_add_open_mmap(struct afs_vnode *vnode)
 	if (atomic_inc_return(&vnode->cb_nr_mmap) == 1) {
 		down_write(&vnode->volume->cell->fs_open_mmaps_lock);
 
-		list_add_tail(&vnode->cb_mmap_link,
-			      &vnode->volume->cell->fs_open_mmaps);
+		if (list_empty(&vnode->cb_mmap_link))
+			list_add_tail(&vnode->cb_mmap_link,
+				      &vnode->volume->cell->fs_open_mmaps);
 
 		up_write(&vnode->volume->cell->fs_open_mmaps_lock);
 	}
diff --git a/fs/afs/super.c b/fs/afs/super.c
index d110def8aa8eb..34c68724c98be 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -667,6 +667,7 @@ static void afs_i_init_once(void *_vnode)
 	INIT_LIST_HEAD(&vnode->pending_locks);
 	INIT_LIST_HEAD(&vnode->granted_locks);
 	INIT_DELAYED_WORK(&vnode->lock_work, afs_lock_work);
+	INIT_LIST_HEAD(&vnode->cb_mmap_link);
 	seqlock_init(&vnode->cb_lock);
 }
 
-- 
2.33.0



