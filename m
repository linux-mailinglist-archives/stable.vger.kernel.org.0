Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3B2E68DD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgL1M7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbgL1M7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FB9B208D5;
        Mon, 28 Dec 2020 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160304;
        bh=CVmvmXwBLVzLHTnV7nqcXfaHlf3iWf7sO7N46UH8uRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiv6C6ZHlCn3B98WgsZRLUGnIChIZ6pYazpXK8ChQio48MUXqRnxgw+lqAf9w5ZCG
         qKsqioLU+R6V1MCF8ewYV7WbJOEvwjfWQkRt4cxkAkLyqF3QqSomHUO5bBfrQ48RrP
         As1GyByZEHRPK6/GZLlRUOkcYsT+xZ8e89U8/seI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Michael Kurth <mku@amazon.de>,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.4 127/132] xen/xenbus: Allow watches discard events before queueing
Date:   Mon, 28 Dec 2020 13:50:11 +0100
Message-Id: <20201228124852.551614596@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
@@ -697,12 +697,14 @@ static int xen_register_watchers(struct
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


