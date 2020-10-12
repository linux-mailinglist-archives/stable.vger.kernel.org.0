Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3644C28B6B3
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbgJLNgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388713AbgJLNgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A6BF20878;
        Mon, 12 Oct 2020 13:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509780;
        bh=Dqj8WYjt6OA+au4Mary/LhvkSCMmRFoqRFqXhFVPoCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMibZcklYpWYWPDmTuMjkDamVv1QDPctjBqPBY9pDK+0gp0YUA47snGdGpfETVb0o
         xiYUakoxbDKFLg2x5aFkLdHKa6OkETShG5iGoAaaCFLDDZICnpGtkHPjbFFjuKi1EF
         ObpzpvWmDO1JEndIBdGLDIwaZ+Zzl9/+e1VquOmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.14 27/70] epoll: replace ->visited/visited_list with generation count
Date:   Mon, 12 Oct 2020 15:26:43 +0200
Message-Id: <20201012132631.506509917@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 18306c404abe18a0972587a6266830583c60c928 upstream.

removes the need to clear it, along with the races.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -223,8 +223,7 @@ struct eventpoll {
 	struct file *file;
 
 	/* used to optimize loop detection check */
-	int visited;
-	struct list_head visited_list_link;
+	u64 gen;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* used to track busy poll napi_id */
@@ -273,6 +272,8 @@ static long max_user_watches __read_most
  */
 static DEFINE_MUTEX(epmutex);
 
+static u64 loop_check_gen = 0;
+
 /* Used to check for epoll file descriptor inclusion loops */
 static struct nested_calls poll_loop_ncalls;
 
@@ -288,9 +289,6 @@ static struct kmem_cache *epi_cache __re
 /* Slab cache used to allocate "struct eppoll_entry" */
 static struct kmem_cache *pwq_cache __read_mostly;
 
-/* Visited nodes during ep_loop_check(), so we can unset them when we finish */
-static LIST_HEAD(visited_list);
-
 /*
  * List of files with newly added links, where we may need to limit the number
  * of emanating paths. Protected by the epmutex.
@@ -1877,13 +1875,12 @@ static int ep_loop_check_proc(void *priv
 	struct epitem *epi;
 
 	mutex_lock_nested(&ep->mtx, call_nests + 1);
-	ep->visited = 1;
-	list_add(&ep->visited_list_link, &visited_list);
+	ep->gen = loop_check_gen;
 	for (rbp = rb_first_cached(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
 			ep_tovisit = epi->ffd.file->private_data;
-			if (ep_tovisit->visited)
+			if (ep_tovisit->gen == loop_check_gen)
 				continue;
 			error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
 					ep_loop_check_proc, epi->ffd.file,
@@ -1924,18 +1921,8 @@ static int ep_loop_check_proc(void *priv
  */
 static int ep_loop_check(struct eventpoll *ep, struct file *file)
 {
-	int ret;
-	struct eventpoll *ep_cur, *ep_next;
-
-	ret = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
+	return ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
 			      ep_loop_check_proc, file, ep, current);
-	/* clear visited list */
-	list_for_each_entry_safe(ep_cur, ep_next, &visited_list,
-							visited_list_link) {
-		ep_cur->visited = 0;
-		list_del(&ep_cur->visited_list_link);
-	}
-	return ret;
 }
 
 static void clear_tfile_check_list(void)
@@ -2152,6 +2139,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 error_tgt_fput:
 	if (full_check) {
 		clear_tfile_check_list();
+		loop_check_gen++;
 		mutex_unlock(&epmutex);
 	}
 


