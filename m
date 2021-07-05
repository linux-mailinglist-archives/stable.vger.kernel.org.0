Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26763BC052
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhGEPfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhGEPeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB488619CD;
        Mon,  5 Jul 2021 15:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499073;
        bh=VfZMHmrMkR5FKZSV0EAtpTsIsFOSua5Z84CgBXwadr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kdk5GG0CPI5OVvOq6fsYbAM5qIQUPzWxk0q8i0OuH1sQjmK4V2U+dBbsfmXnV1/qb
         i0u3Nw1p+IpGMdwT3lakgOUMSRWtebYIb/jY4xSpvImZWTqADyIeoxTWopb1vcXc41
         E2hE57JJCAUusawCxvVizy6oaMZaxCJ38f5u520o4+L8qT3rCBeStpMz1FsrdYcq10
         IepFJHpvujg9UJApQciEktKR/rvjw54S8jRCqhk1uNg5X9Ik7tPcXotMoCyKuimMLE
         FY4A/tluWpbwTOOj0z1R8Cy8hZn3Sj1bAdUS4J/ll1eAPcluJ8Enji46uZD4mw+jFM
         pblDGYQhPAGjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Gushchin <guro@fb.com>, Jan Kara <jack@suse.com>,
        Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <dchinner@redhat.com>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/26] writeback, cgroup: increment isw_nr_in_flight before grabbing an inode
Date:   Mon,  5 Jul 2021 11:30:39 -0400
Message-Id: <20210705153039.1521781-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

[ Upstream commit 8826ee4fe75051f8cbfa5d4a9aa70565938e724c ]

isw_nr_in_flight is used to determine whether the inode switch queue
should be flushed from the umount path.  Currently it's increased after
grabbing an inode and even scheduling the switch work.  It means the
umount path can walk past cleanup_offline_cgwb() with active inode
references, which can result in a "Busy inodes after unmount." message and
use-after-free issues (with inode->i_sb which gets freed).

Fix it by incrementing isw_nr_in_flight before doing anything with the
inode and decrementing in the case when switching wasn't scheduled.

The problem hasn't yet been seen in the real life and was discovered by
Jan Kara by looking into the code.

Link: https://lkml.kernel.org/r/20210608230225.2078447-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Jan Kara <jack@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fd6b50582c87..3a0d7b8af141 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -505,6 +505,8 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 	if (!isw)
 		return;
 
+	atomic_inc(&isw_nr_in_flight);
+
 	/* find and pin the new wb */
 	rcu_read_lock();
 	memcg_css = css_from_id(new_wb_id, &memory_cgrp_subsys);
@@ -535,11 +537,10 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
-
-	atomic_inc(&isw_nr_in_flight);
 	return;
 
 out_free:
+	atomic_dec(&isw_nr_in_flight);
 	if (isw->new_wb)
 		wb_put(isw->new_wb);
 	kfree(isw);
-- 
2.30.2

