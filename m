Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D028461E16
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379095AbhK2ScY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:32:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35070 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352287AbhK2SaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:30:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3A5DB815B1;
        Mon, 29 Nov 2021 18:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24000C53FCD;
        Mon, 29 Nov 2021 18:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210422;
        bh=XMhFXhCx2JdXAbtMICOI0/Qn84NvHuijMCKkJ101IfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmhphBaPXcMHyw4fIkOkNeswXexaz12BlC83PpsR/aG8la6w+sSHwTnVae5+/r5zG
         fywLn6fSoKusPB6lIYUg9zXF4kE1dCuGHHK54d3naqDEKdWWSLNZzOfkGRUhr8Mj8n
         MVzAG8C5LboMVWwWgWmIZYPxe56UnOH8ouMeSupw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 83/92] fuse: release pipe buf after last use
Date:   Mon, 29 Nov 2021 19:18:52 +0100
Message-Id: <20211129181710.167817946@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 473441720c8616dfaf4451f9c7ea14f0eb5e5d65 upstream.

Checking buf->flags should be done before the pipe_buf_release() is called
on the pipe buffer, since releasing the buffer might modify the flags.

This is exactly what page_cache_pipe_buf_release() does, and which results
in the same VM_BUG_ON_PAGE(PageLRU(page)) that the original patch was
trying to fix.

Reported-by: Justin Forbes <jmforbes@linuxtx.org>
Fixes: 712a951025c0 ("fuse: fix page stealing")
Cc: <stable@vger.kernel.org> # v2.6.35
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -839,17 +839,17 @@ static int fuse_try_move_page(struct fus
 		goto out_put_old;
 	}
 
+	get_page(newpage);
+
+	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
+		lru_cache_add_file(newpage);
+
 	/*
 	 * Release while we have extra ref on stolen page.  Otherwise
 	 * anon_pipe_buf_release() might think the page can be reused.
 	 */
 	pipe_buf_release(cs->pipe, buf);
 
-	get_page(newpage);
-
-	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
-		lru_cache_add_file(newpage);
-
 	err = 0;
 	spin_lock(&cs->req->waitq.lock);
 	if (test_bit(FR_ABORTED, &cs->req->flags))


