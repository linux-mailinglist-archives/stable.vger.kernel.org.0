Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C19D2DCD8C
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 09:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgLQITU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 03:19:20 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:27582 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgLQITU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 03:19:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608193159; x=1639729159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=rcPmHaa5j/+13Fv+4zTRsZospx8JHmUhPnzBfjjAKjo=;
  b=GvXpbMkSpYMHX8Vv++9805sNHNGfJfjqyJ3H+r26syjPl1IrGJQwWvli
   t5NQlgXOesDMKWzdE5ItB1pQepnGu4OyAlGQoeCWHIFRY0HoNKyKoqfu4
   y3GZq3sx9kCTqd9itXR728A4eI6MAF6joqF4HAcA7TKsFwS+d6/eX1fqB
   4=;
X-IronPort-AV: E=Sophos;i="5.78,426,1599523200"; 
   d="scan'208";a="73261965"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 17 Dec 2020 08:18:19 +0000
Received: from EX13D31EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 41007A07A7;
        Thu, 17 Dec 2020 08:18:19 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.144) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 08:18:14 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>, Author Redacted <security@xen.org>
Subject: [PATCH 4/5] xen/xenbus: Count pending messages for each watch
Date:   Thu, 17 Dec 2020 09:17:26 +0100
Message-ID: <20201217081727.8253-5-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201217081727.8253-1-sjpark@amazon.com>
References: <20201217081727.8253-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

This commit adds a counter of pending messages for each watch in the
struct.  It is used to skip unnecessary pending messages lookup in
'unregister_xenbus_watch()'.  It could also be used in 'will_handle'
callback.

This is part of XSA-349

This is upstream commit 3dc86ca6b4c8cfcba9da7996189d1b5a358a94fc

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Signed-off-by: Author Redacted <security@xen.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/xenbus/xenbus_xs.c | 30 ++++++++++++++++++------------
 include/xen/xenbus.h           |  2 ++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 0ea1c259f2f1..420d478e1708 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -701,6 +701,8 @@ int register_xenbus_watch(struct xenbus_watch *watch)
 
 	sprintf(token, "%lX", (long)watch);
 
+	watch->nr_pending = 0;
+
 	down_read(&xs_state.watch_mutex);
 
 	spin_lock(&watches_lock);
@@ -750,12 +752,15 @@ void unregister_xenbus_watch(struct xenbus_watch *watch)
 
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
 
@@ -802,7 +807,6 @@ void xs_suspend_cancel(void)
 
 static int xenwatch_thread(void *unused)
 {
-	struct list_head *ent;
 	struct xs_stored_msg *msg;
 
 	for (;;) {
@@ -815,13 +819,15 @@ static int xenwatch_thread(void *unused)
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
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 1772507dc2c9..ed9e7e3307b7 100644
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
-- 
2.17.1

