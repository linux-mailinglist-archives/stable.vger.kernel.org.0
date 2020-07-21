Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF8522889F
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 20:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgGUSzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 14:55:53 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48108 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGUSzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 14:55:53 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id DBA75290592
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     kernel@collabora.com, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, sashal@kernel.org,
        krisman@collabora.com,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Nikolaus Rath <Nikolaus@rath.org>,
        Hugh Dickins <hughd@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.7 1/1] fuse: fix weird page warning
Date:   Tue, 21 Jul 2020 15:54:59 -0300
Message-Id: <20200721185459.103445-1-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.27.0
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
---
 fs/fuse/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5c155437a455..ec02c3240176 100644
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
2.27.0

