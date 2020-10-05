Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A2728382F
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgJEOpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgJEOpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 716D820874;
        Mon,  5 Oct 2020 14:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909104;
        bh=jmWnWZe5acst/3sUWGd0eaV2feqgRYfuuSrfTJDFm94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttNAd/4F9DG7otja65Hb8tPUgu49S49+6GOt8rLrZH0bmWAiXWUsmNrD8phmXL6AQ
         Os9OOIErkK7DgZ/47wqJsapEKQsMVfSte1d8AthnjZ1p4la7ed1IS1HCQHZP+6OHb7
         JBfyK914N/G5r2k6wbWSzgmiCEZcDELkJWcl1POo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 02/12] epoll: replace ->visited/visited_list with generation count
Date:   Mon,  5 Oct 2020 10:44:50 -0400
Message-Id: <20201005144501.2527477-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005144501.2527477-1-sashal@kernel.org>
References: <20201005144501.2527477-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 18306c404abe18a0972587a6266830583c60c928 ]

removes the need to clear it, along with the races.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 5207dfc85b786..82ab9a25f12f2 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -218,8 +218,7 @@ struct eventpoll {
 	struct file *file;
 
 	/* used to optimize loop detection check */
-	struct list_head visited_list_link;
-	int visited;
+	u64 gen;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* used to track busy poll napi_id */
@@ -274,6 +273,8 @@ static long max_user_watches __read_mostly;
  */
 static DEFINE_MUTEX(epmutex);
 
+static u64 loop_check_gen = 0;
+
 /* Used to check for epoll file descriptor inclusion loops */
 static struct nested_calls poll_loop_ncalls;
 
@@ -283,9 +284,6 @@ static struct kmem_cache *epi_cache __read_mostly;
 /* Slab cache used to allocate "struct eppoll_entry" */
 static struct kmem_cache *pwq_cache __read_mostly;
 
-/* Visited nodes during ep_loop_check(), so we can unset them when we finish */
-static LIST_HEAD(visited_list);
-
 /*
  * List of files with newly added links, where we may need to limit the number
  * of emanating paths. Protected by the epmutex.
@@ -1971,13 +1969,12 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
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
 			error = ep_call_nested(&poll_loop_ncalls,
 					ep_loop_check_proc, epi->ffd.file,
@@ -2018,18 +2015,8 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
  */
 static int ep_loop_check(struct eventpoll *ep, struct file *file)
 {
-	int ret;
-	struct eventpoll *ep_cur, *ep_next;
-
-	ret = ep_call_nested(&poll_loop_ncalls,
+	return ep_call_nested(&poll_loop_ncalls,
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
@@ -2199,6 +2186,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 			error = epoll_mutex_lock(&epmutex, 0, nonblock);
 			if (error)
 				goto error_tgt_fput;
+			loop_check_gen++;
 			full_check = 1;
 			if (is_file_epoll(tf.file)) {
 				error = -ELOOP;
@@ -2262,6 +2250,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 error_tgt_fput:
 	if (full_check) {
 		clear_tfile_check_list();
+		loop_check_gen++;
 		mutex_unlock(&epmutex);
 	}
 
-- 
2.25.1

