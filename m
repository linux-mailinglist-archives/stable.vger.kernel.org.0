Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF5B498E70
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349412AbiAXTle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:41:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34990 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354870AbiAXTjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:39:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 141506141C;
        Mon, 24 Jan 2022 19:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAFEC340E5;
        Mon, 24 Jan 2022 19:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053171;
        bh=4KubBFmDsVrKB9scUEaiucazOFxFpJPrDKsfzlgOojM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIlFtQZTnd4p1ZIlrUGQg+W0f584gekzdSAC5+nzzL9WPoO4zN7X/k+kRsvJcyRfK
         0w+n9gkMqDEQtzEhO2hXMQ49p6gNvZPAbevCBp3/ktx3pdSYEbbST828dB0OLuWslx
         eM2H84d0qhtpuOTQ6kZ5aPLluSMqVutkBS5Fmv8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 299/320] inet: frags: annotate races around fqdir->dead and fqdir->high_thresh
Date:   Mon, 24 Jan 2022 19:44:43 +0100
Message-Id: <20220124184004.126011562@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 91341fa0003befd097e190ec2a4bf63ad957c49a upstream.

Both fields can be read/written without synchronization,
add proper accessors and documentation.

Fixes: d5dd88794a13 ("inet: fix various use-after-free in defrags units")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_frag.h  |   11 +++++++++--
 include/net/ipv6_frag.h  |    3 ++-
 net/ipv4/inet_fragment.c |    8 +++++---
 net/ipv4/ip_fragment.c   |    3 ++-
 4 files changed, 18 insertions(+), 7 deletions(-)

--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -116,8 +116,15 @@ int fqdir_init(struct fqdir **fqdirp, st
 
 static inline void fqdir_pre_exit(struct fqdir *fqdir)
 {
-	fqdir->high_thresh = 0; /* prevent creation of new frags */
-	fqdir->dead = true;
+	/* Prevent creation of new frags.
+	 * Pairs with READ_ONCE() in inet_frag_find().
+	 */
+	WRITE_ONCE(fqdir->high_thresh, 0);
+
+	/* Pairs with READ_ONCE() in inet_frag_kill(), ip_expire()
+	 * and ip6frag_expire_frag_queue().
+	 */
+	WRITE_ONCE(fqdir->dead, true);
 }
 void fqdir_exit(struct fqdir *fqdir);
 
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -67,7 +67,8 @@ ip6frag_expire_frag_queue(struct net *ne
 	struct sk_buff *head;
 
 	rcu_read_lock();
-	if (fq->q.fqdir->dead)
+	/* Paired with the WRITE_ONCE() in fqdir_pre_exit(). */
+	if (READ_ONCE(fq->q.fqdir->dead))
 		goto out_rcu_unlock;
 	spin_lock(&fq->q.lock);
 
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -204,9 +204,9 @@ void inet_frag_kill(struct inet_frag_que
 		/* The RCU read lock provides a memory barrier
 		 * guaranteeing that if fqdir->dead is false then
 		 * the hash table destruction will not start until
-		 * after we unlock.  Paired with inet_frags_exit_net().
+		 * after we unlock.  Paired with fqdir_pre_exit().
 		 */
-		if (!fqdir->dead) {
+		if (!READ_ONCE(fqdir->dead)) {
 			rhashtable_remove_fast(&fqdir->rhashtable, &fq->node,
 					       fqdir->f->rhash_params);
 			refcount_dec(&fq->refcnt);
@@ -321,9 +321,11 @@ static struct inet_frag_queue *inet_frag
 /* TODO : call from rcu_read_lock() and no longer use refcount_inc_not_zero() */
 struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key)
 {
+	/* This pairs with WRITE_ONCE() in fqdir_pre_exit(). */
+	long high_thresh = READ_ONCE(fqdir->high_thresh);
 	struct inet_frag_queue *fq = NULL, *prev;
 
-	if (!fqdir->high_thresh || frag_mem_limit(fqdir) > fqdir->high_thresh)
+	if (!high_thresh || frag_mem_limit(fqdir) > high_thresh)
 		return NULL;
 
 	rcu_read_lock();
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -144,7 +144,8 @@ static void ip_expire(struct timer_list
 
 	rcu_read_lock();
 
-	if (qp->q.fqdir->dead)
+	/* Paired with WRITE_ONCE() in fqdir_pre_exit(). */
+	if (READ_ONCE(qp->q.fqdir->dead))
 		goto out_rcu_unlock;
 
 	spin_lock(&qp->q.lock);


