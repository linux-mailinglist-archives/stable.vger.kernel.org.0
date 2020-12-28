Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB4C2E3F40
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392305AbgL1OiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504142AbgL1OcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 769CF2063A;
        Mon, 28 Dec 2020 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165914;
        bh=9ssjzMwYka8fIx+hvUzcJBCprK54wHmDvbZlEVUhIHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUFSepV9C0u0WxEpmIolWSDO4kFx37ZhgJERZpDBba7/79P6AYOemTI1LJ1D1GqEZ
         Yd9vzA8WkEjll5Qpi714ONLlYLQtWi4mVEPK9zIY7lT7GaOJeroDf+FrwDbT1HjLm0
         gqVPklKAQvyj5RdW+N6oI/+4oKSsqyAZxlP/ORHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Michael Kurth <mku@amazon.de>,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 699/717] xen/xenbus: Count pending messages for each watch
Date:   Mon, 28 Dec 2020 13:51:37 +0100
Message-Id: <20201228125054.474872245@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

commit 3dc86ca6b4c8cfcba9da7996189d1b5a358a94fc upstream.

This commit adds a counter of pending messages for each watch in the
struct.  It is used to skip unnecessary pending messages lookup in
'unregister_xenbus_watch()'.  It could also be used in 'will_handle'
callback.

This is part of XSA-349

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xenbus/xenbus_xs.c |   29 ++++++++++++++++++-----------
 include/xen/xenbus.h           |    2 ++
 2 files changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -711,6 +711,7 @@ int xs_watch_msg(struct xs_watch_event *
 				 event->path, event->token))) {
 		spin_lock(&watch_events_lock);
 		list_add_tail(&event->list, &watch_events);
+		event->handle->nr_pending++;
 		wake_up(&watch_events_waitq);
 		spin_unlock(&watch_events_lock);
 	} else
@@ -768,6 +769,8 @@ int register_xenbus_watch(struct xenbus_
 
 	sprintf(token, "%lX", (long)watch);
 
+	watch->nr_pending = 0;
+
 	down_read(&xs_watch_rwsem);
 
 	spin_lock(&watches_lock);
@@ -817,11 +820,14 @@ void unregister_xenbus_watch(struct xenb
 
 	/* Cancel pending watch events. */
 	spin_lock(&watch_events_lock);
-	list_for_each_entry_safe(event, tmp, &watch_events, list) {
-		if (event->handle != watch)
-			continue;
-		list_del(&event->list);
-		kfree(event);
+	if (watch->nr_pending) {
+		list_for_each_entry_safe(event, tmp, &watch_events, list) {
+			if (event->handle != watch)
+				continue;
+			list_del(&event->list);
+			kfree(event);
+		}
+		watch->nr_pending = 0;
 	}
 	spin_unlock(&watch_events_lock);
 
@@ -868,7 +874,6 @@ void xs_suspend_cancel(void)
 
 static int xenwatch_thread(void *unused)
 {
-	struct list_head *ent;
 	struct xs_watch_event *event;
 
 	xenwatch_pid = current->pid;
@@ -883,13 +888,15 @@ static int xenwatch_thread(void *unused)
 		mutex_lock(&xenwatch_mutex);
 
 		spin_lock(&watch_events_lock);
-		ent = watch_events.next;
-		if (ent != &watch_events)
-			list_del(ent);
+		event = list_first_entry_or_null(&watch_events,
+				struct xs_watch_event, list);
+		if (event) {
+			list_del(&event->list);
+			event->handle->nr_pending--;
+		}
 		spin_unlock(&watch_events_lock);
 
-		if (ent != &watch_events) {
-			event = list_entry(ent, struct xs_watch_event, list);
+		if (event) {
 			event->handle->callback(event->handle, event->path,
 						event->token);
 			kfree(event);
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -61,6 +61,8 @@ struct xenbus_watch
 	/* Path being watched. */
 	const char *node;
 
+	unsigned int nr_pending;
+
 	/*
 	 * Called just before enqueing new event while a spinlock is held.
 	 * The event will be discarded if this callback returns false.


