Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1627647F667
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 11:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhLZK0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 05:26:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52168 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhLZK0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 05:26:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D501B80D85;
        Sun, 26 Dec 2021 10:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CCCC36AE9;
        Sun, 26 Dec 2021 10:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640514395;
        bh=c01Y1sVJff7yPWEv/LS6XlE+5QNdrrtxSt0y+lgu7bc=;
        h=From:To:Cc:Subject:Date:From;
        b=RWi0TpKKCgFlzCG3UWsVPVUILW2hZm29QHyuwbWZpypalvXYp7Luyaqy1Xp28TnE2
         OmMZkgFmM9ijs/lxd+JoH3USCMXpDSgcIPSegiZk5vW9cbfyrrt9qQQc6MT43kg9BB
         n8KibIQFeFdoBV8Fq9or59FBRgEw2Z5grRdxuy7uvE+HthuUGyjto8sdE47OJnbdSr
         F0JY7Av/XOYretAXqz67GWhD6sycRQrfFVuG4bO8undd8omuRbr18lEACKMaXg/rgo
         Pq+bbHBGJXcp8Jb6plLSMatTVVbQC2Ids+Eu2DkjRexwZ6yebvLMTmZjkCW+0xwbTb
         8vcJDE7TZGXPA==
From:   SeongJae Park <sj@kernel.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] mm/damon/dbgfs: protect targets destructions with kdamond_lock
Date:   Sun, 26 Dec 2021 10:26:32 +0000
Message-Id: <20211226102632.836-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 34796417964b8d0aef45a99cf6c2d20cebe33733 upstream.

DAMON debugfs interface iterates current monitoring targets in
'dbgfs_target_ids_read()' while holding the corresponding
'kdamond_lock'.  However, it also destructs the monitoring targets in
'dbgfs_before_terminate()' without holding the lock.  This can result in
a use_after_free bug.  This commit avoids the race by protecting the
destruction with the corresponding 'kdamond_lock'.

Link: https://lkml.kernel.org/r/20211221094447.2241-1-sj@kernel.org
Reported-by: Sangwoo Bae <sangwoob@amazon.com>
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
This is a backport of a DAMON fix that merged in the mainline, for
v5.15.x stable series.

 mm/damon/dbgfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index f94d19a690df..d3bc110430f9 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -309,10 +309,12 @@ static int dbgfs_before_terminate(struct damon_ctx *ctx)
 	if (!targetid_is_pid(ctx))
 		return 0;
 
+	mutex_lock(&ctx->kdamond_lock);
 	damon_for_each_target_safe(t, next, ctx) {
 		put_pid((struct pid *)t->id);
 		damon_destroy_target(t);
 	}
+	mutex_unlock(&ctx->kdamond_lock);
 	return 0;
 }
 
-- 
2.17.1

