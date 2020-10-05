Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B491E283849
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgJEOpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgJEOph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31EE8208A9;
        Mon,  5 Oct 2020 14:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909136;
        bh=Wi7QxXgy94wOlaQDq/KWGfhyrMHjIhQDYdG5fCh7ss0=;
        h=From:To:Cc:Subject:Date:From;
        b=PCopsENNQcpCCPWj92wu5AKDqjWAk/bVkPHiJfdjmfefxWdibj6CbAyfFMlqlRXWc
         AayHiOCx1QNfM40c6puA5GGACftmfMgsfSseHIGxqNY2ISbMRDPcS9UkqqxohsDTo3
         QljSRyDuhsNsxOyyq9xNzO0NVOfP3/w8nwpTZMN0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4] epoll: do not insert into poll queues until all sanity checks are done
Date:   Mon,  5 Oct 2020 10:45:34 -0400
Message-Id: <20201005144535.2527911-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit f8d4f44df056c5b504b0d49683fb7279218fd207 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e5324642023d6..f287ec04b9a99 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1304,6 +1304,22 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		RCU_INIT_POINTER(epi->ws, NULL);
 	}
 
+	/* Add the current item to the list of active epoll hook for this file */
+	spin_lock(&tfile->f_lock);
+	list_add_tail_rcu(&epi->fllink, &tfile->f_ep_links);
+	spin_unlock(&tfile->f_lock);
+
+	/*
+	 * Add the current item to the RB tree. All RB tree operations are
+	 * protected by "mtx", and ep_insert() is called with "mtx" held.
+	 */
+	ep_rbtree_insert(ep, epi);
+
+	/* now check if we've created too many backpaths */
+	error = -EINVAL;
+	if (full_check && reverse_path_check())
+		goto error_remove_epi;
+
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
@@ -1326,22 +1342,6 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	if (epi->nwait < 0)
 		goto error_unregister;
 
-	/* Add the current item to the list of active epoll hook for this file */
-	spin_lock(&tfile->f_lock);
-	list_add_tail_rcu(&epi->fllink, &tfile->f_ep_links);
-	spin_unlock(&tfile->f_lock);
-
-	/*
-	 * Add the current item to the RB tree. All RB tree operations are
-	 * protected by "mtx", and ep_insert() is called with "mtx" held.
-	 */
-	ep_rbtree_insert(ep, epi);
-
-	/* now check if we've created too many backpaths */
-	error = -EINVAL;
-	if (full_check && reverse_path_check())
-		goto error_remove_epi;
-
 	/* We have to drop the new item inside our item list to keep track of it */
 	spin_lock_irqsave(&ep->lock, flags);
 
@@ -1367,6 +1367,8 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	return 0;
 
+error_unregister:
+	ep_unregister_pollwait(ep, epi);
 error_remove_epi:
 	spin_lock(&tfile->f_lock);
 	list_del_rcu(&epi->fllink);
@@ -1374,9 +1376,6 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	rb_erase(&epi->rbn, &ep->rbr);
 
-error_unregister:
-	ep_unregister_pollwait(ep, epi);
-
 	/*
 	 * We need to do this because an event could have been arrived on some
 	 * allocated wait queue. Note that we don't care about the ep->ovflist
-- 
2.25.1

