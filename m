Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4302D4FD074
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244390AbiDLGq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351615AbiDLGpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:45:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECC13B29C;
        Mon, 11 Apr 2022 23:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F7C9B81B43;
        Tue, 12 Apr 2022 06:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6368C385A1;
        Tue, 12 Apr 2022 06:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745522;
        bh=Hayc4OIdfzDXy8V+U992Me+XlWnqNqSxsWEX61pl0QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1dCUcP0iHTx35i+YBs69ZEkxS0Zid/VlLji5YMt6U7Wu69MF6L/6y+pMedz9J9wX
         JiCde+VVHuA+qoBuX74NWSMZceBXQC25MCpkFZPpwx7Gu/6BXwzgE4LZspMZQMWHZm
         JtA3MDBGrlisp0+I2T8PbmbEdeJZiFI/WAOc803U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/171] drbd: Fix five use after free bugs in get_initial_state
Date:   Tue, 12 Apr 2022 08:30:16 +0200
Message-Id: <20220412062931.501493672@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit aadb22ba2f656581b2f733deb3a467c48cc618f6 ]

In get_initial_state, it calls notify_initial_state_done(skb,..) if
cb->args[5]==1. If genlmsg_put() failed in notify_initial_state_done(),
the skb will be freed by nlmsg_free(skb).
Then get_initial_state will goto out and the freed skb will be used by
return value skb->len, which is a uaf bug.

What's worse, the same problem goes even further: skb can also be
freed in the notify_*_state_change -> notify_*_state calls below.
Thus 4 additional uaf bugs happened.

My patch lets the problem callee functions: notify_initial_state_done
and notify_*_state_change return an error code if errors happen.
So that the error codes could be propagated and the uaf bugs can be avoid.

v2 reports a compilation warning. This v3 fixed this warning and built
successfully in my local environment with no additional warnings.
v2: https://lore.kernel.org/patchwork/patch/1435218/

Fixes: a29728463b254 ("drbd: Backport the "events2" command")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_int.h          |  8 ++---
 drivers/block/drbd/drbd_nl.c           | 41 ++++++++++++++++----------
 drivers/block/drbd/drbd_state.c        | 18 +++++------
 drivers/block/drbd/drbd_state_change.h |  8 ++---
 4 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8f879e5c2f67..60b9ca53c0a3 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1644,22 +1644,22 @@ struct sib_info {
 };
 void drbd_bcast_event(struct drbd_device *device, const struct sib_info *sib);
 
-extern void notify_resource_state(struct sk_buff *,
+extern int notify_resource_state(struct sk_buff *,
 				  unsigned int,
 				  struct drbd_resource *,
 				  struct resource_info *,
 				  enum drbd_notification_type);
-extern void notify_device_state(struct sk_buff *,
+extern int notify_device_state(struct sk_buff *,
 				unsigned int,
 				struct drbd_device *,
 				struct device_info *,
 				enum drbd_notification_type);
-extern void notify_connection_state(struct sk_buff *,
+extern int notify_connection_state(struct sk_buff *,
 				    unsigned int,
 				    struct drbd_connection *,
 				    struct connection_info *,
 				    enum drbd_notification_type);
-extern void notify_peer_device_state(struct sk_buff *,
+extern int notify_peer_device_state(struct sk_buff *,
 				     unsigned int,
 				     struct drbd_peer_device *,
 				     struct peer_device_info *,
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index bf7de4c7b96c..f8d0146bf785 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -4614,7 +4614,7 @@ static int nla_put_notification_header(struct sk_buff *msg,
 	return drbd_notification_header_to_skb(msg, &nh, true);
 }
 
-void notify_resource_state(struct sk_buff *skb,
+int notify_resource_state(struct sk_buff *skb,
 			   unsigned int seq,
 			   struct drbd_resource *resource,
 			   struct resource_info *resource_info,
@@ -4656,16 +4656,17 @@ void notify_resource_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(resource, "Error %d while broadcasting event. Event seq:%u\n",
 			err, seq);
+	return err;
 }
 
-void notify_device_state(struct sk_buff *skb,
+int notify_device_state(struct sk_buff *skb,
 			 unsigned int seq,
 			 struct drbd_device *device,
 			 struct device_info *device_info,
@@ -4705,16 +4706,17 @@ void notify_device_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(device, "Error %d while broadcasting event. Event seq:%u\n",
 		 err, seq);
+	return err;
 }
 
-void notify_connection_state(struct sk_buff *skb,
+int notify_connection_state(struct sk_buff *skb,
 			     unsigned int seq,
 			     struct drbd_connection *connection,
 			     struct connection_info *connection_info,
@@ -4754,16 +4756,17 @@ void notify_connection_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(connection, "Error %d while broadcasting event. Event seq:%u\n",
 		 err, seq);
+	return err;
 }
 
-void notify_peer_device_state(struct sk_buff *skb,
+int notify_peer_device_state(struct sk_buff *skb,
 			      unsigned int seq,
 			      struct drbd_peer_device *peer_device,
 			      struct peer_device_info *peer_device_info,
@@ -4804,13 +4807,14 @@ void notify_peer_device_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(peer_device, "Error %d while broadcasting event. Event seq:%u\n",
 		 err, seq);
+	return err;
 }
 
 void notify_helper(enum drbd_notification_type type,
@@ -4861,7 +4865,7 @@ void notify_helper(enum drbd_notification_type type,
 		 err, seq);
 }
 
-static void notify_initial_state_done(struct sk_buff *skb, unsigned int seq)
+static int notify_initial_state_done(struct sk_buff *skb, unsigned int seq)
 {
 	struct drbd_genlmsghdr *dh;
 	int err;
@@ -4875,11 +4879,12 @@ static void notify_initial_state_done(struct sk_buff *skb, unsigned int seq)
 	if (nla_put_notification_header(skb, NOTIFY_EXISTS))
 		goto nla_put_failure;
 	genlmsg_end(skb, dh);
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 	pr_err("Error %d sending event. Event seq:%u\n", err, seq);
+	return err;
 }
 
 static void free_state_changes(struct list_head *list)
@@ -4906,6 +4911,7 @@ static int get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned int seq = cb->args[2];
 	unsigned int n;
 	enum drbd_notification_type flags = 0;
+	int err = 0;
 
 	/* There is no need for taking notification_mutex here: it doesn't
 	   matter if the initial state events mix with later state chage
@@ -4914,32 +4920,32 @@ static int get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 
 	cb->args[5]--;
 	if (cb->args[5] == 1) {
-		notify_initial_state_done(skb, seq);
+		err = notify_initial_state_done(skb, seq);
 		goto out;
 	}
 	n = cb->args[4]++;
 	if (cb->args[4] < cb->args[3])
 		flags |= NOTIFY_CONTINUES;
 	if (n < 1) {
-		notify_resource_state_change(skb, seq, state_change->resource,
+		err = notify_resource_state_change(skb, seq, state_change->resource,
 					     NOTIFY_EXISTS | flags);
 		goto next;
 	}
 	n--;
 	if (n < state_change->n_connections) {
-		notify_connection_state_change(skb, seq, &state_change->connections[n],
+		err = notify_connection_state_change(skb, seq, &state_change->connections[n],
 					       NOTIFY_EXISTS | flags);
 		goto next;
 	}
 	n -= state_change->n_connections;
 	if (n < state_change->n_devices) {
-		notify_device_state_change(skb, seq, &state_change->devices[n],
+		err = notify_device_state_change(skb, seq, &state_change->devices[n],
 					   NOTIFY_EXISTS | flags);
 		goto next;
 	}
 	n -= state_change->n_devices;
 	if (n < state_change->n_devices * state_change->n_connections) {
-		notify_peer_device_state_change(skb, seq, &state_change->peer_devices[n],
+		err = notify_peer_device_state_change(skb, seq, &state_change->peer_devices[n],
 						NOTIFY_EXISTS | flags);
 		goto next;
 	}
@@ -4954,7 +4960,10 @@ static int get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 		cb->args[4] = 0;
 	}
 out:
-	return skb->len;
+	if (err)
+		return err;
+	else
+		return skb->len;
 }
 
 int drbd_adm_get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 0067d328f0b5..5fbaea6b77b1 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1537,7 +1537,7 @@ int drbd_bitmap_io_from_worker(struct drbd_device *device,
 	return rv;
 }
 
-void notify_resource_state_change(struct sk_buff *skb,
+int notify_resource_state_change(struct sk_buff *skb,
 				  unsigned int seq,
 				  struct drbd_resource_state_change *resource_state_change,
 				  enum drbd_notification_type type)
@@ -1550,10 +1550,10 @@ void notify_resource_state_change(struct sk_buff *skb,
 		.res_susp_fen = resource_state_change->susp_fen[NEW],
 	};
 
-	notify_resource_state(skb, seq, resource, &resource_info, type);
+	return notify_resource_state(skb, seq, resource, &resource_info, type);
 }
 
-void notify_connection_state_change(struct sk_buff *skb,
+int notify_connection_state_change(struct sk_buff *skb,
 				    unsigned int seq,
 				    struct drbd_connection_state_change *connection_state_change,
 				    enum drbd_notification_type type)
@@ -1564,10 +1564,10 @@ void notify_connection_state_change(struct sk_buff *skb,
 		.conn_role = connection_state_change->peer_role[NEW],
 	};
 
-	notify_connection_state(skb, seq, connection, &connection_info, type);
+	return notify_connection_state(skb, seq, connection, &connection_info, type);
 }
 
-void notify_device_state_change(struct sk_buff *skb,
+int notify_device_state_change(struct sk_buff *skb,
 				unsigned int seq,
 				struct drbd_device_state_change *device_state_change,
 				enum drbd_notification_type type)
@@ -1577,10 +1577,10 @@ void notify_device_state_change(struct sk_buff *skb,
 		.dev_disk_state = device_state_change->disk_state[NEW],
 	};
 
-	notify_device_state(skb, seq, device, &device_info, type);
+	return notify_device_state(skb, seq, device, &device_info, type);
 }
 
-void notify_peer_device_state_change(struct sk_buff *skb,
+int notify_peer_device_state_change(struct sk_buff *skb,
 				     unsigned int seq,
 				     struct drbd_peer_device_state_change *p,
 				     enum drbd_notification_type type)
@@ -1594,7 +1594,7 @@ void notify_peer_device_state_change(struct sk_buff *skb,
 		.peer_resync_susp_dependency = p->resync_susp_dependency[NEW],
 	};
 
-	notify_peer_device_state(skb, seq, peer_device, &peer_device_info, type);
+	return notify_peer_device_state(skb, seq, peer_device, &peer_device_info, type);
 }
 
 static void broadcast_state_change(struct drbd_state_change *state_change)
@@ -1602,7 +1602,7 @@ static void broadcast_state_change(struct drbd_state_change *state_change)
 	struct drbd_resource_state_change *resource_state_change = &state_change->resource[0];
 	bool resource_state_has_changed;
 	unsigned int n_device, n_connection, n_peer_device, n_peer_devices;
-	void (*last_func)(struct sk_buff *, unsigned int, void *,
+	int (*last_func)(struct sk_buff *, unsigned int, void *,
 			  enum drbd_notification_type) = NULL;
 	void *last_arg = NULL;
 
diff --git a/drivers/block/drbd/drbd_state_change.h b/drivers/block/drbd/drbd_state_change.h
index ba80f612d6ab..d5b0479bc9a6 100644
--- a/drivers/block/drbd/drbd_state_change.h
+++ b/drivers/block/drbd/drbd_state_change.h
@@ -44,19 +44,19 @@ extern struct drbd_state_change *remember_old_state(struct drbd_resource *, gfp_
 extern void copy_old_to_new_state_change(struct drbd_state_change *);
 extern void forget_state_change(struct drbd_state_change *);
 
-extern void notify_resource_state_change(struct sk_buff *,
+extern int notify_resource_state_change(struct sk_buff *,
 					 unsigned int,
 					 struct drbd_resource_state_change *,
 					 enum drbd_notification_type type);
-extern void notify_connection_state_change(struct sk_buff *,
+extern int notify_connection_state_change(struct sk_buff *,
 					   unsigned int,
 					   struct drbd_connection_state_change *,
 					   enum drbd_notification_type type);
-extern void notify_device_state_change(struct sk_buff *,
+extern int notify_device_state_change(struct sk_buff *,
 				       unsigned int,
 				       struct drbd_device_state_change *,
 				       enum drbd_notification_type type);
-extern void notify_peer_device_state_change(struct sk_buff *,
+extern int notify_peer_device_state_change(struct sk_buff *,
 					    unsigned int,
 					    struct drbd_peer_device_state_change *,
 					    enum drbd_notification_type type);
-- 
2.35.1



