Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE8045C5C8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352803AbhKXOAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355723AbhKXN6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AA76633C4;
        Wed, 24 Nov 2021 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759309;
        bh=AdBQTILVH1VSPtDncmrqhaeOKxTsArEHgLiHYXspLug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PDDvKyGpGL159voTb1vbytif3eOtOpxbAjuaHoyhGRIMvjDbFqPiieaqoJ4nfxqr
         vXKRs+gkFCdQgP3qz9X7XIY6kJyLAVxEIpNYeUsLeXcYj33AwuJH7FPILXtHJtUeTU
         yAzHPKMcHuASufzAHOY3Wb67sZGyxL4LDjQy8vmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 199/279] mm/damon/dbgfs: use __GFP_NOWARN for user-specified size buffer allocation
Date:   Wed, 24 Nov 2021 12:58:06 +0100
Message-Id: <20211124115725.609573824@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/damon/dbgfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -32,7 +32,7 @@ static char *user_input_str(const char _
 	if (*ppos)
 		return ERR_PTR(-EINVAL);
 
-	kbuf = kmalloc(count + 1, GFP_KERNEL);
+	kbuf = kmalloc(count + 1, GFP_KERNEL | __GFP_NOWARN);
 	if (!kbuf)
 		return ERR_PTR(-ENOMEM);
 
@@ -247,7 +247,7 @@ static ssize_t dbgfs_kdamond_pid_read(st
 	char *kbuf;
 	ssize_t len;
 
-	kbuf = kmalloc(count, GFP_KERNEL);
+	kbuf = kmalloc(count, GFP_KERNEL | __GFP_NOWARN);
 	if (!kbuf)
 		return -ENOMEM;
 


