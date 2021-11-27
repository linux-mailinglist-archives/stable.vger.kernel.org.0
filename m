Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2375B45FEC4
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 14:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355040AbhK0NQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 08:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351415AbhK0NOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 08:14:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E833CC061574
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 05:11:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FBEDB817AC
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 13:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F5BC53FBF;
        Sat, 27 Nov 2021 13:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638018666;
        bh=OymOrmlEQ0KvSH2oFI8p1cA3pTyqw/YLABjcZVwxTMI=;
        h=Subject:To:Cc:From:Date:From;
        b=wphW/AwVlt+evHiNCh/2DHGg+9JTVIaUgt19Gm1ls48pr0Gw9710rKUdNZM+12qC3
         CX4hin/7RdB9cnLnbExQU8BBRGawmcQnsnWk2hTG9RD6tg3b7Sl9z6AqxWgPhegs2A
         3SgP7rz/9K9JAkcIpymlyn+J58P2jQ8Tevl2CRzw=
Subject: FAILED: patch "[PATCH] fuse: release pipe buf after last use" failed to apply to 4.19-stable tree
To:     mszeredi@redhat.com, jmforbes@linuxtx.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Nov 2021 14:10:53 +0100
Message-ID: <1638018653130222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

