Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6661722EFF2
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbgG0OUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731573AbgG0OUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23F172070A;
        Mon, 27 Jul 2020 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859635;
        bh=bmnCTZY3O0KpK89X3zYxFlN4vf9HYQ0a1eKFlA+zyic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7FNK9kDqv4QkhU0uhmBQCDu2CQW2JpHBv7YiEJIu/i6IXPzaqxVInAaZ3U2nK1YL
         OlLVEhsYz+dOiPe/KYCjV5lcGf9gux2srI5b9LzRKOGqKGLwOU0z2AZW9F0HuZGMCH
         jUttLxl4B3uvxXcYVdynkQ7pc4/GrQ8V/uWrD6f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolaus Rath <Nikolaus@rath.org>,
        Hugh Dickins <hughd@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 019/179] fuse: fix weird page warning
Date:   Mon, 27 Jul 2020 16:03:14 +0200
Message-Id: <20200727134933.606252746@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit a5005c3cda6eeb6b95645e6cc32f58dafeffc976 upstream.

When PageWaiters was added, updating this check was missed.

Reported-by: Nikolaus Rath <Nikolaus@rath.org>
Reported-by: Hugh Dickins <hughd@google.com>
Fixes: 62906027091f ("mm: add PageWaiters indicating tasks are waiting for a page bit")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: André Almeida <andrealmeid@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5c155437a455d..ec02c3240176c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -771,7 +771,8 @@ static int fuse_check_page(struct page *page)
 	       1 << PG_uptodate |
 	       1 << PG_lru |
 	       1 << PG_active |
-	       1 << PG_reclaim))) {
+	       1 << PG_reclaim |
+	       1 << PG_waiters))) {
 		pr_warn("trying to steal weird page\n");
 		pr_warn("  page=%p index=%li flags=%08lx, count=%i, mapcount=%i, mapping=%p\n", page, page->index, page->flags, page_count(page), page_mapcount(page), page->mapping);
 		return 1;
-- 
2.25.1



