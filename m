Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D6B45FEC2
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 14:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355016AbhK0NQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 08:16:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50892 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239018AbhK0NOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 08:14:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 559C4B81B58
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 13:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4B3C53FBF;
        Sat, 27 Nov 2021 13:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638018655;
        bh=0REmCfJEHZUkZIruD9zMi4zSkibpkObELj7k7Nbmbzw=;
        h=Subject:To:Cc:From:Date:From;
        b=aiBd+BIkmt0wpZrEKqMSrCejBboBTork6m9VZjvm6S2YTv/EWW5FL/u62AhDDpfI2
         ZuecmQkq+o+Xna7K7nvKh+993yhOzJjY4m9xDfWyT1abxl+FNEzkudnsMI4QkcLp6u
         QXX04Lj2HLQQz0Z2eWzYUBag5U0X/3aGgnUXXzuc=
Subject: FAILED: patch "[PATCH] fuse: release pipe buf after last use" failed to apply to 4.4-stable tree
To:     mszeredi@redhat.com, jmforbes@linuxtx.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Nov 2021 14:10:52 +0100
Message-ID: <163801865218547@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 473441720c8616dfaf4451f9c7ea14f0eb5e5d65 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 25 Nov 2021 14:05:18 +0100
Subject: [PATCH] fuse: release pipe buf after last use

Checking buf->flags should be done before the pipe_buf_release() is called
on the pipe buffer, since releasing the buffer might modify the flags.

This is exactly what page_cache_pipe_buf_release() does, and which results
in the same VM_BUG_ON_PAGE(PageLRU(page)) that the original patch was
trying to fix.

Reported-by: Justin Forbes <jmforbes@linuxtx.org>
Fixes: 712a951025c0 ("fuse: fix page stealing")
Cc: <stable@vger.kernel.org> # v2.6.35
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 79f7eda49e06..cd54a529460d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -847,17 +847,17 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 
 	replace_page_cache_page(oldpage, newpage);
 
+	get_page(newpage);
+
+	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
+		lru_cache_add(newpage);
+
 	/*
 	 * Release while we have extra ref on stolen page.  Otherwise
 	 * anon_pipe_buf_release() might think the page can be reused.
 	 */
 	pipe_buf_release(cs->pipe, buf);
 
-	get_page(newpage);
-
-	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
-		lru_cache_add(newpage);
-
 	err = 0;
 	spin_lock(&cs->req->waitq.lock);
 	if (test_bit(FR_ABORTED, &cs->req->flags))

