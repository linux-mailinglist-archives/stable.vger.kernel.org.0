Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C2C2ED1EF
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbhAGOT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbhAGORR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3B3F233E2;
        Thu,  7 Jan 2021 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029008;
        bh=M8r8CHOnyqls9B7FWyeet+G/8JiA4BwX4eNqgpkXWvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SM1iEgTi2LbYt1Mr9OTjhfqilZSCTA8i2LKq7/HoldgDkkRLIH8/QCTCELvMjr3p2
         lZy1kHS5c1w0lP9GYIs3jrZ0dyhfz7GychYyKt/qcCc+m0D8Wh34jzqQvJKPVQxVWK
         K66oYntPSgzjpDk1HP3y35ud4bBJARYwFwBNuTLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Michael Kurth <mku@amazon.de>,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.9 24/32] xen/xenbus: Allow watches discard events before queueing
Date:   Thu,  7 Jan 2021 15:16:44 +0100
Message-Id: <20210107140829.007519269@linuxfoundation.org>
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

commit fed1755b118147721f2c87b37b9d66e62c39b668 upstream.

If handling logics of watch events are slower than the events enqueue
logic and the events can be created from the guests, the guests could
trigger memory pressure by intensively inducing the events, because it
will create a huge number of pending events that exhausting the memory.

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

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/xen-netback/xenbus.c   |    2 ++
 drivers/xen/xenbus/xenbus_client.c |    1 +
 drivers/xen/xenbus/xenbus_xs.c     |    7 ++++++-
 include/xen/xenbus.h               |    7 +++++++
 4 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -770,12 +770,14 @@ static int xen_register_credit_watch(str
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
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -120,6 +120,7 @@ int xenbus_watch_path(struct xenbus_devi
 	int err;
 
 	watch->node = path;
+	watch->will_handle = NULL;
 	watch->callback = callback;
 
 	err = register_xenbus_watch(watch);
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -901,7 +901,12 @@ static int process_msg(void)
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


