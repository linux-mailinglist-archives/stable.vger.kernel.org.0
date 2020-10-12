Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558C828BA17
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391003AbgJLOFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgJLNe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB17D20678;
        Mon, 12 Oct 2020 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509696;
        bh=nwsihx0hEKKxGCYZPIMOabEyuW0LWmS5jhpfaKWmdDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAZZc2NEgdNX36YFovuC76tsM0WjLZ7JbphTcWer0SQFTn682aUMFvAu1Nl6BQwao
         jBR2aLbde6tRwN/S53cBOYIZz4PFWXZ1m6bRwDGW4/uPPrsNmiaKUU0iAqEZc3yAxU
         4eCXkTcRSVlNApPhGx6L/arc1vZ+Z7gw/VxC4+jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.9 18/54] epoll: do not insert into poll queues until all sanity checks are done
Date:   Mon, 12 Oct 2020 15:26:40 +0200
Message-Id: <20201012132630.437902095@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit f8d4f44df056c5b504b0d49683fb7279218fd207 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1332,6 +1332,22 @@ static int ep_insert(struct eventpoll *e
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
@@ -1354,22 +1370,6 @@ static int ep_insert(struct eventpoll *e
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
 
@@ -1395,6 +1395,8 @@ static int ep_insert(struct eventpoll *e
 
 	return 0;
 
+error_unregister:
+	ep_unregister_pollwait(ep, epi);
 error_remove_epi:
 	spin_lock(&tfile->f_lock);
 	list_del_rcu(&epi->fllink);
@@ -1402,9 +1404,6 @@ error_remove_epi:
 
 	rb_erase(&epi->rbn, &ep->rbr);
 
-error_unregister:
-	ep_unregister_pollwait(ep, epi);
-
 	/*
 	 * We need to do this because an event could have been arrived on some
 	 * allocated wait queue. Note that we don't care about the ep->ovflist


