Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5028D2ED1E9
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbhAGOT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729098AbhAGOR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FFBC23340;
        Thu,  7 Jan 2021 14:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029015;
        bh=AgyAM6uAwY/jDTnLkhu2YpKgeiOVtG0VcU/xbuvlV5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWVHwT4phuwe7xN4+hfHGg3AB5M4zdlSnfqlGODhZXntl3KulHXpCO6nvIOHhx8sw
         Dfdlw74ztVB00G1nM6hUoE0aEQtKkCCLNWIPD7UWwQlWthh6aR3Z914Q3Nkc8Mfc+f
         cuisMqUkREshTdbau8MKKsn8BTpfFwX3x3+heY9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Michael Kurth <mku@amazon.de>,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.9 27/32] xen/xenbus: Count pending messages for each watch
Date:   Thu,  7 Jan 2021 15:16:47 +0100
Message-Id: <20210107140829.157470056@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.866214702@linuxfoundation.org>
References: <20210107140827.866214702@linuxfoundation.org>
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
 drivers/xen/xenbus/xenbus_xs.c |   31 +++++++++++++++++++------------
 include/xen/xenbus.h           |    2 ++
 2 files changed, 21 insertions(+), 12 deletions(-)

--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -699,6 +699,8 @@ int register_xenbus_watch(struct xenbus_
 
 	sprintf(token, "%lX", (long)watch);
 
+	watch->nr_pending = 0;
+
 	down_read(&xs_state.watch_mutex);
 
 	spin_lock(&watches_lock);
@@ -748,12 +750,15 @@ void unregister_xenbus_watch(struct xenb
 
 	/* Cancel pending watch events. */
 	spin_lock(&watch_events_lock);
-	list_for_each_entry_safe(msg, tmp, &watch_events, list) {
-		if (msg->u.watch.handle != watch)
-			continue;
-		list_del(&msg->list);
-		kfree(msg->u.watch.vec);
-		kfree(msg);
+	if (watch->nr_pending) {
+		list_for_each_entry_safe(msg, tmp, &watch_events, list) {
+			if (msg->u.watch.handle != watch)
+				continue;
+			list_del(&msg->list);
+			kfree(msg->u.watch.vec);
+			kfree(msg);
+		}
+		watch->nr_pending = 0;
 	}
 	spin_unlock(&watch_events_lock);
 
@@ -800,7 +805,6 @@ void xs_suspend_cancel(void)
 
 static int xenwatch_thread(void *unused)
 {
-	struct list_head *ent;
 	struct xs_stored_msg *msg;
 
 	for (;;) {
@@ -813,13 +817,15 @@ static int xenwatch_thread(void *unused)
 		mutex_lock(&xenwatch_mutex);
 
 		spin_lock(&watch_events_lock);
-		ent = watch_events.next;
-		if (ent != &watch_events)
-			list_del(ent);
+		msg = list_first_entry_or_null(&watch_events,
+				struct xs_stored_msg, list);
+		if (msg) {
+			list_del(&msg->list);
+			msg->u.watch.handle->nr_pending--;
+		}
 		spin_unlock(&watch_events_lock);
 
-		if (ent != &watch_events) {
-			msg = list_entry(ent, struct xs_stored_msg, list);
+		if (msg) {
 			msg->u.watch.handle->callback(
 				msg->u.watch.handle,
 				(const char **)msg->u.watch.vec,
@@ -909,6 +915,7 @@ static int process_msg(void)
 					 msg->u.watch.vec_size))) {
 			spin_lock(&watch_events_lock);
 			list_add_tail(&msg->list, &watch_events);
+			msg->u.watch.handle->nr_pending++;
 			wake_up(&watch_events_waitq);
 			spin_unlock(&watch_events_lock);
 		} else {
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -58,6 +58,8 @@ struct xenbus_watch
 	/* Path being watched. */
 	const char *node;
 
+	unsigned int nr_pending;
+
 	/*
 	 * Called just before enqueing new event while a spinlock is held.
 	 * The event will be discarded if this callback returns false.


