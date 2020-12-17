Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1BE2DD1D8
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 14:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgLQNGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 08:06:32 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:6252 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgLQNGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 08:06:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608210391; x=1639746391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=2YmxoZfq/FJgaUjFNGuK4Ht5NlZny6+5b/Pu3VGDsno=;
  b=Gyecd/yJqJrsZ7ygYJKivueeUszSBp8WfhI9McRV5u/2/plBp/s7K7hE
   geBD6gnDEHy8XQxcfwB+PxhW92weVHpmLikMjbsOfDwDFSij1+HuCIFSV
   +wlODgScFbcoAafaiAJAc6uAZ/OaFih+JJj7GWQyK3p8DBBvltRF9wCvf
   M=;
X-IronPort-AV: E=Sophos;i="5.78,428,1599523200"; 
   d="scan'208";a="69971866"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 17 Dec 2020 13:05:27 +0000
Received: from EX13D31EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id C819AA1FB4;
        Thu, 17 Dec 2020 13:05:25 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.160.66) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 13:05:21 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/5] xen/xenbus: Allow watches discard events before queueing
Date:   Thu, 17 Dec 2020 14:04:57 +0100
Message-ID: <20201217130501.12702-2-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201217130501.12702-1-sjpark@amazon.com>
References: <20201217130501.12702-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D39UWA002.ant.amazon.com (10.43.160.20) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

If handling logics of watch events are slower than the events enqueue
logic and the events can be created from the guests, the guests could
trigger memory pressure by intensively inducing the events, because it
will create a huge number of pending events that exhausting the memory.
This is known as XSA-349.

Fortunately, some watch events could be ignored, depending on its
handler callback.  For example, if the callback has interest in only one
single path, the watch wouldn't want multiple pending events.  Or, some
watches could ignore events to same path.

To let such watches to volutarily help avoiding the memory pressure
situation, this commit introduces new watch callback, 'will_handle'.  If
it is not NULL, it will be called for each new event just before
enqueuing it.  Then, if the callback returns false, the event will be
discarded.  No watch is using the callback for now, though.

This is part of XSA-349

This is upstream commit fed1755b118147721f2c87b37b9d66e62c39b668

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/net/xen-netback/xenbus.c   | 2 ++
 drivers/xen/xenbus/xenbus_client.c | 1 +
 drivers/xen/xenbus/xenbus_xs.c     | 7 ++++++-
 include/xen/xenbus.h               | 7 +++++++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 56ebd8267386..23f03af0a2d4 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -697,12 +697,14 @@ static int xen_register_watchers(struct xenbus_device *dev, struct xenvif *vif)
 		return -ENOMEM;
 	snprintf(node, maxlen, "%s/rate", dev->nodename);
 	vif->credit_watch.node = node;
+	vif->credit_watch.will_handle = NULL;
 	vif->credit_watch.callback = xen_net_rate_changed;
 	err = register_xenbus_watch(&vif->credit_watch);
 	if (err) {
 		pr_err("Failed to set watcher %s\n", vif->credit_watch.node);
 		kfree(node);
 		vif->credit_watch.node = NULL;
+		vif->credit_watch.will_handle = NULL;
 		vif->credit_watch.callback = NULL;
 	}
 	return err;
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 266f446ba331..d02d25f784c9 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -120,6 +120,7 @@ int xenbus_watch_path(struct xenbus_device *dev, const char *path,
 	int err;
 
 	watch->node = path;
+	watch->will_handle = NULL;
 	watch->callback = callback;
 
 	err = register_xenbus_watch(watch);
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index ce65591b4168..0ea1c259f2f1 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -903,7 +903,12 @@ static int process_msg(void)
 		spin_lock(&watches_lock);
 		msg->u.watch.handle = find_watch(
 			msg->u.watch.vec[XS_WATCH_TOKEN]);
-		if (msg->u.watch.handle != NULL) {
+		if (msg->u.watch.handle != NULL &&
+				(!msg->u.watch.handle->will_handle ||
+				 msg->u.watch.handle->will_handle(
+					 msg->u.watch.handle,
+					 (const char **)msg->u.watch.vec,
+					 msg->u.watch.vec_size))) {
 			spin_lock(&watch_events_lock);
 			list_add_tail(&msg->list, &watch_events);
 			wake_up(&watch_events_waitq);
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 32b944b7cebd..11697aa023b5 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -58,6 +58,13 @@ struct xenbus_watch
 	/* Path being watched. */
 	const char *node;
 
+	/*
+	 * Called just before enqueing new event while a spinlock is held.
+	 * The event will be discarded if this callback returns false.
+	 */
+	bool (*will_handle)(struct xenbus_watch *,
+			    const char **vec, unsigned int len);
+
 	/* Callback (executed in a process context with no locks held). */
 	void (*callback)(struct xenbus_watch *,
 			 const char **vec, unsigned int len);
-- 
2.17.1

