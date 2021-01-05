Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304202EA972
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 12:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbhAELD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 06:03:29 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:14777 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729463AbhAELDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 06:03:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1609844597; x=1641380597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=xjHY5J/WYul7+xwIEcWyaKX9q1gd+fu132oSR5IfpOM=;
  b=dY8aNAIiKQ/GPkOUIqLgkW+VvjU00/9Ck68zUvVxc/49mdPVCqhsKv6M
   38JB0qiawTBnlerveAhQri+LW5Z8suhZ1zk6DOevweflZh71BVsDRtK/x
   7J9wQx8KgT8Mgw8i36XbqcSzVGqdYeNkFBVquzENVVoYuvRtn10mtsudf
   w=;
X-IronPort-AV: E=Sophos;i="5.78,476,1599523200"; 
   d="scan'208";a="101273214"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 05 Jan 2021 11:02:30 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 510AEA2111;
        Tue,  5 Jan 2021 11:02:28 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.94) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 Jan 2021 11:02:22 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] xen/xenbus: Count pending messages for each watch
Date:   Tue, 5 Jan 2021 12:01:41 +0100
Message-ID: <20210105110142.1810-5-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105110142.1810-1-sjpark@amazon.com>
References: <20210105110142.1810-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.94]
X-ClientProxiedBy: EX13D45UWA001.ant.amazon.com (10.43.160.91) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
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
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/xenbus/xenbus_xs.c | 31 +++++++++++++++++++------------
 include/xen/xenbus.h           |  2 ++
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index d200aa707988..88b443637106 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -699,6 +699,8 @@ int register_xenbus_watch(struct xenbus_watch *watch)
 
 	sprintf(token, "%lX", (long)watch);
 
+	watch->nr_pending = 0;
+
 	down_read(&xs_state.watch_mutex);
 
 	spin_lock(&watches_lock);
@@ -748,12 +750,15 @@ void unregister_xenbus_watch(struct xenbus_watch *watch)
 
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

