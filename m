Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF8E19102B
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgCXNZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgCXNZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:25:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C3C2206F6;
        Tue, 24 Mar 2020 13:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056354;
        bh=NEdggw3DsZKGNplSv0bxIHQE0OgYMgZZ0r2Y/Xougek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDmn222XkyoT106peec8CD2EXdtFNCU1T6EmpapuF4nAdCFXmf3Ia2KqlBJH2UxV7
         cuKZYMcGzI0DQCHLCzHUE0AshH04GPynzHIcSbduLNRzj3PTSLHfAsME9vUifxsgUH
         cEzgF1nFuYAvwzaNIn2q6ekGvnNxZXfXCDUAFNUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Neunhoeffer <max@arangodb.com>,
        Roman Penyaev <rpenyaev@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Christopher Kohlhoff <chris.kohlhoff@clearpool.io>,
        Davidlohr Bueso <dbueso@suse.de>,
        Jason Baron <jbaron@akamai.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 097/119] epoll: fix possible lost wakeup on epoll_ctl() path
Date:   Tue, 24 Mar 2020 14:11:22 +0100
Message-Id: <20200324130817.843646270@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Penyaev <rpenyaev@suse.de>

commit 1b53734bd0b2feed8e7761771b2e76fc9126ea0c upstream.

This fixes possible lost wakeup introduced by commit a218cc491420.
Originally modifications to ep->wq were serialized by ep->wq.lock, but
in commit a218cc491420 ("epoll: use rwlock in order to reduce
ep_poll_callback() contention") a new rw lock was introduced in order to
relax fd event path, i.e. callers of ep_poll_callback() function.

After the change ep_modify and ep_insert (both are called on epoll_ctl()
path) were switched to ep->lock, but ep_poll (epoll_wait) was using
ep->wq.lock on wqueue list modification.

The bug doesn't lead to any wqueue list corruptions, because wake up
path and list modifications were serialized by ep->wq.lock internally,
but actual waitqueue_active() check prior wake_up() call can be
reordered with modifications of ep ready list, thus wake up can be lost.

And yes, can be healed by explicit smp_mb():

  list_add_tail(&epi->rdlink, &ep->rdllist);
  smp_mb();
  if (waitqueue_active(&ep->wq))
	wake_up(&ep->wp);

But let's make it simple, thus current patch replaces ep->wq.lock with
the ep->lock for wqueue modifications, thus wake up path always observes
activeness of the wqueue correcty.

Fixes: a218cc491420 ("epoll: use rwlock in order to reduce ep_poll_callback() contention")
Reported-by: Max Neunhoeffer <max@arangodb.com>
Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Max Neunhoeffer <max@arangodb.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Christopher Kohlhoff <chris.kohlhoff@clearpool.io>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jes Sorensen <jes.sorensen@gmail.com>
Cc: <stable@vger.kernel.org>	[5.1+]
Link: http://lkml.kernel.org/r/20200214170211.561524-1-rpenyaev@suse.de
Bisected-by: Max Neunhoeffer <max@arangodb.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1860,9 +1860,9 @@ fetch_events:
 		waiter = true;
 		init_waitqueue_entry(&wait, current);
 
-		spin_lock_irq(&ep->wq.lock);
+		write_lock_irq(&ep->lock);
 		__add_wait_queue_exclusive(&ep->wq, &wait);
-		spin_unlock_irq(&ep->wq.lock);
+		write_unlock_irq(&ep->lock);
 	}
 
 	for (;;) {
@@ -1910,9 +1910,9 @@ send_events:
 		goto fetch_events;
 
 	if (waiter) {
-		spin_lock_irq(&ep->wq.lock);
+		write_lock_irq(&ep->lock);
 		__remove_wait_queue(&ep->wq, &wait);
-		spin_unlock_irq(&ep->wq.lock);
+		write_unlock_irq(&ep->lock);
 	}
 
 	return res;


