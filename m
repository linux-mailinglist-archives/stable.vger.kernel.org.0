Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA7D47BD19
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 10:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbhLUJoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 04:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbhLUJoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 04:44:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61DDC061574;
        Tue, 21 Dec 2021 01:44:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD537614B4;
        Tue, 21 Dec 2021 09:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDC3C36AE2;
        Tue, 21 Dec 2021 09:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640079892;
        bh=Pz/iubvYizxlg2FCVM2vG0pRngm0zhdsMP6AU472feQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Tw7kNDzUE9l4ONjircCWFj8twDmqDRtDd+2y/4yo9BOFzGQIg7NFI0qDH6+uHs/Gh
         6E15FzvsxR/+cF6jDSWWBr4RuoNJMxd8ESBUprZECJJZbfxkaoGgIoytaLUY0aTDwr
         deFzjw5Vpy8JQoferKqpmPl0CcRLtdlKE2fFBL3F6gXrP4lDC22OyL9XEIou1bZDLa
         Cn3Q0nu+PJRwkGdjNs7qhACocrDdYvZ6EE5x1Y0Mg9r8XJaN1fMv9zigqgbDmuqnwj
         nbLzvkoVzETN+jS36/detHVCMDT0ZRF+hxidE+rMvzXBnk0w8ywDX2WP7XB1GsXuIH
         Vrzu6lKBI8Unw==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] mm/damon/dbgfs: Protect targets destructions with kdamond_lock
Date:   Tue, 21 Dec 2021 09:44:47 +0000
Message-Id: <20211221094447.2241-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DAMON debugfs interface iterates current monitoring targets in
'dbgfs_target_ids_read()' while holding the corresponding
'kdamond_lock'.  However, it also destructs the monitoring targets in
'dbgfs_before_terminate()' without holding the lock.  This can result in
a use_after_free bug.  This commit avoids the race by protecting the
destruction with the corresponding 'kdamond_lock'.

Reported-by: Sangwoo Bae <sangwoob@amazon.com>
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
---
This cannot cleanly applied on 5.15.y tree.  I will post a backport as
soon as this is applied on the mainline.

 mm/damon/dbgfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index 58dbb9692279..489be9c830c4 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -659,10 +659,12 @@ static void dbgfs_before_terminate(struct damon_ctx *ctx)
 	if (!targetid_is_pid(ctx))
 		return;
 
+	mutex_lock(&ctx->kdamond_lock);
 	damon_for_each_target_safe(t, next, ctx) {
 		put_pid((struct pid *)t->id);
 		damon_destroy_target(t);
 	}
+	mutex_unlock(&ctx->kdamond_lock);
 }
 
 static struct damon_ctx *dbgfs_new_ctx(void)
-- 
2.17.1

