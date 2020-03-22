Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640DB18E5C7
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 02:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgCVBWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 21:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCVBWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 21:22:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D02820722;
        Sun, 22 Mar 2020 01:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584840151;
        bh=G/4G/K/YHYsvZVa/KDb6FCH90TVO5lVZcgGrhR9ftpk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=i5iG9Ih2SFUPRn4S9elw69bcNcnfUGfLZUqb+WnOj/BzP5G5nhklYCHbNC4sXoWzs
         Jodg0ypvKUcTm9j9O5RIbBphJZlnUus2T7HCUfc0KdYfHOwyQr50USE7IqY/eNkajc
         2spcSAlSQZTmf7+dN85ZW7VAcRzNIZzXSb5AnozY=
Date:   Sat, 21 Mar 2020 18:22:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris.kohlhoff@clearpool.io,
        dbueso@suse.de, jbaron@akamai.com, jes.sorensen@gmail.com,
        kuba@kernel.org, linux-mm@kvack.org, max@arangodb.com,
        mm-commits@vger.kernel.org, rpenyaev@suse.de,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 07/10] epoll: fix possible lost wakeup on
 epoll_ctl() path
Message-ID: <20200322012230.v8ERPHp_B%akpm@linux-foundation.org>
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Penyaev <rpenyaev@suse.de>
Subject: epoll: fix possible lost wakeup on epoll_ctl() path

This fixes possible lost wakeup introduced by commit a218cc491420. 
Originally modifications to ep->wq were serialized by ep->wq.lock, but in
the a218cc491420 new rw lock was introduced in order to relax fd event
path, i.e.  callers of ep_poll_callback() function.

After the change ep_modify and ep_insert (both are called on epoll_ctl()
path) were switched to ep->lock, but ep_poll (epoll_wait) was using
ep->wq.lock on wqueue list modification.

The bug doesn't lead to any wqueue list corruptions, because wake up path
and list modifications were serialized by ep->wq.lock internally, but
actual waitqueue_active() check prior wake_up() call can be reordered with
modifications of ep ready list, thus wake up can be lost.

And yes, can be healed by explicit smp_mb():

  list_add_tail(&epi->rdlink, &ep->rdllist);
  smp_mb();
  if (waitqueue_active(&ep->wq))
	wake_up(&ep->wp);

But let's make it simple, thus current patch replaces ep->wq.lock with the
ep->lock for wqueue modifications, thus wake up path always observes
activeness of the wqueue correcty.

Link: http://lkml.kernel.org/r/20200214170211.561524-1-rpenyaev@suse.de
Fixes: a218cc491420 ("epoll: use rwlock in order to reduce ep_poll_callback() contention")
References: https://bugzilla.kernel.org/show_bug.cgi?id=205933
Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Reported-by: Max Neunhoeffer <max@arangodb.com>
Bisected-by: Max Neunhoeffer <max@arangodb.com>
Tested-by: Max Neunhoeffer <max@arangodb.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Christopher Kohlhoff <chris.kohlhoff@clearpool.io>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jes Sorensen <jes.sorensen@gmail.com>
Cc: <stable@vger.kernel.org>	[5.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/eventpoll.c~epoll-fix-possible-lost-wakeup-on-epoll_ctl-path
+++ a/fs/eventpoll.c
@@ -1854,9 +1854,9 @@ fetch_events:
 		waiter = true;
 		init_waitqueue_entry(&wait, current);
 
-		spin_lock_irq(&ep->wq.lock);
+		write_lock_irq(&ep->lock);
 		__add_wait_queue_exclusive(&ep->wq, &wait);
-		spin_unlock_irq(&ep->wq.lock);
+		write_unlock_irq(&ep->lock);
 	}
 
 	for (;;) {
@@ -1904,9 +1904,9 @@ send_events:
 		goto fetch_events;
 
 	if (waiter) {
-		spin_lock_irq(&ep->wq.lock);
+		write_lock_irq(&ep->lock);
 		__remove_wait_queue(&ep->wq, &wait);
-		spin_unlock_irq(&ep->wq.lock);
+		write_unlock_irq(&ep->lock);
 	}
 
 	return res;
_
