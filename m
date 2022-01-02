Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A885482ACF
	for <lists+stable@lfdr.de>; Sun,  2 Jan 2022 12:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiABLV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Jan 2022 06:21:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39618 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiABLV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Jan 2022 06:21:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34B85B80B4F;
        Sun,  2 Jan 2022 11:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6176AC36AEB;
        Sun,  2 Jan 2022 11:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641122516;
        bh=e5c93iVmg9zZH1VDOZ3D2QktHR1jOLFH92mK2h8O/qo=;
        h=From:To:Cc:Subject:Date:From;
        b=FrkSk2yK6ynCWcpoytw3s39fVXouH1yIsFWqc+cc/OLaOSajXVTbbAxrps77vZMja
         JviXvxQ3TXSvC78VQt153CvLtu6AQgIDlu1GN+lKYFFKEp1j0CGKI0dtFNoLWWZB8O
         t8oDp3QkT2Iiq01aAxnXRfBbpyK5OgcncODWqiN601SeJadQmGOoUNhCjMsnFALHNi
         KDkyR4XAMbyOvOBPmyXzVbFRy/UJxdUoxTFW82pFlvWZdu+Spc+bPyx5QyiZYsAh5z
         8LHW8j3KW6C8y8K13xaTYd8fXkAHrMKaCjReDSP6+ZAuZSr23WBi2BunuycWiXv+ru
         z76WZnGjVs4rg==
From:   SeongJae Park <sj@kernel.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for-v5.15.x] mm/damon/dbgfs: fix 'struct pid' leaks in 'dbgfs_target_ids_write()'
Date:   Sun,  2 Jan 2022 11:21:41 +0000
Message-Id: <20220102112141.12281-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ebb3f994dd92f8fb4d70c7541091216c1e10cb71 upstream.

DAMON debugfs interface increases the reference counts of 'struct pid's
for targets from the 'target_ids' file write callback
('dbgfs_target_ids_write()'), but decreases the counts only in DAMON
monitoring termination callback ('dbgfs_before_terminate()').

Therefore, when 'target_ids' file is repeatedly written without DAMON
monitoring start/termination, the reference count is not decreased and
therefore memory for the 'struct pid' cannot be freed.  This commit
fixes this issue by decreasing the reference counts when 'target_ids' is
written.

Link: https://lkml.kernel.org/r/20211229124029.23348-1-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
This is a backport of a DAMON fix that merged in the mainline, for
v5.15.x stable series.

 mm/damon/dbgfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index d3bc110430f9..36624990b577 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -185,6 +185,7 @@ static ssize_t dbgfs_target_ids_write(struct file *file,
 		const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct damon_ctx *ctx = file->private_data;
+	struct damon_target *t, *next_t;
 	char *kbuf, *nrs;
 	unsigned long *targets;
 	ssize_t nr_targets;
@@ -224,6 +225,13 @@ static ssize_t dbgfs_target_ids_write(struct file *file,
 		goto unlock_out;
 	}
 
+	/* remove previously set targets */
+	damon_for_each_target_safe(t, next_t, ctx) {
+		if (targetid_is_pid(ctx))
+			put_pid((struct pid *)t->id);
+		damon_destroy_target(t);
+	}
+
 	err = damon_set_targets(ctx, targets, nr_targets);
 	if (err) {
 		if (targetid_is_pid(ctx))
-- 
2.17.1

