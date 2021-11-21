Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09735458305
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 12:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhKULFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 06:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238036AbhKULFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 06:05:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60C660E75;
        Sun, 21 Nov 2021 11:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637492546;
        bh=3WQ4Hy7C4N5e4Mvc456YSywZpMU1nWyWDKWdhSHcNnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnFzF2aA3uKsbVnIMdsR+RLFjNe1tXP0MbB5i1nVyhrrqjApWcsueb/B8SOzynnwY
         OEFmo/XVkpyCvv0aR8wZ4hzphjiT+uWsWQ8EsluTRaUuKaiOJBOomPN/3F1K74sjzx
         ymwiXeksCEmPM7dlaglJ9g4oai2za8L3UXKMGzqW01epFW/F3LFuJWpAOHdNASxI0l
         KmV1TpNCQY6tbn/QVYu4Cbfz27WIAlDPCHc2UW161w3w23MznuhnfKd6ADgVQiU17z
         SUZvMFRBD8WolDjiSSAjypWIJefIYIvDSaNXiGYvGEdwH/vbYrltN50AhVyPYqV4nC
         PflKb1MCumrmw==
From:   SeongJae Park <sj@kernel.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for-5.15.x 1/2] mm/damon/dbgfs: use '__GFP_NOWARN' for user-specified size buffer allocation
Date:   Sun, 21 Nov 2021 11:02:10 +0000
Message-Id: <20211121110211.17032-2-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211121110211.17032-1-sj@kernel.org>
References: <20211121110211.17032-1-sj@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit db7a347b26fe05d2e8c115bb24dfd908d0252bc3 upstream.

Patch series "DAMON fixes".

This patch (of 2):

DAMON users can trigger below warning in '__alloc_pages()' by invoking
write() to some DAMON debugfs files with arbitrarily high count
argument, because DAMON debugfs interface allocates some buffers based
on the user-specified 'count'.

        if (unlikely(order >= MAX_ORDER)) {
                WARN_ON_ONCE(!(gfp & __GFP_NOWARN));
                return NULL;
        }

Because the DAMON debugfs interface code checks failure of the
'kmalloc()', this commit simply suppresses the warnings by adding
'__GFP_NOWARN' flag.

Link: https://lkml.kernel.org/r/20211110145758.16558-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211110145758.16558-2-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/damon/dbgfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index faee070977d8..2741ff79e8e8 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -32,7 +32,7 @@ static char *user_input_str(const char __user *buf, size_t count, loff_t *ppos)
 	if (*ppos)
 		return ERR_PTR(-EINVAL);
 
-	kbuf = kmalloc(count + 1, GFP_KERNEL);
+	kbuf = kmalloc(count + 1, GFP_KERNEL | __GFP_NOWARN);
 	if (!kbuf)
 		return ERR_PTR(-ENOMEM);
 
@@ -247,7 +247,7 @@ static ssize_t dbgfs_kdamond_pid_read(struct file *file,
 	char *kbuf;
 	ssize_t len;
 
-	kbuf = kmalloc(count, GFP_KERNEL);
+	kbuf = kmalloc(count, GFP_KERNEL | __GFP_NOWARN);
 	if (!kbuf)
 		return -ENOMEM;
 
-- 
2.17.1

