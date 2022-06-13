Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAEF54916C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377888AbiFMNlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379205AbiFMNkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9226B1DE;
        Mon, 13 Jun 2022 04:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4471C61236;
        Mon, 13 Jun 2022 11:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54391C34114;
        Mon, 13 Jun 2022 11:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119796;
        bh=A4QkFLw7RYLtUaQJCr75vqo0MsGdNuKkf+KeCKGIbL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRKFpH+LJrF/dL2/ELzkQGMSHcn/+BpVB484hJ1ZEMJiliQgltfSUZeWoTK61a9En
         aPfAJj/YhcTiXP0+8i4nK7KMrl45uDi+J0oLvNDueWjB0+xZI9R7QKRDcugqla7mtq
         nHjHzSP2efCqOwKdMQcoEPXwk4uf5n1aRGQ70P3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Osterried <thomas@osterried.de>
Subject: [PATCH 5.18 143/339] ax25: Fix ax25 session cleanup problems
Date:   Mon, 13 Jun 2022 12:09:28 +0200
Message-Id: <20220613094931.021278225@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 7d8a3a477b3e25ada8dc71d22048c2ea417209a0 ]

There are session cleanup problems in ax25_release() and
ax25_disconnect(). If we setup a session and then disconnect,
the disconnected session is still in "LISTENING" state that
is shown below.

Active AX.25 sockets
Dest       Source     Device  State        Vr/Vs    Send-Q  Recv-Q
DL9SAU-4   DL9SAU-3   ???     LISTENING    000/000  0       0
DL9SAU-3   DL9SAU-4   ???     LISTENING    000/000  0       0

The first reason is caused by del_timer_sync() in ax25_release().
The timers of ax25 are used for correct session cleanup. If we use
ax25_release() to close ax25 sessions and ax25_dev is not null,
the del_timer_sync() functions in ax25_release() will execute.
As a result, the sessions could not be cleaned up correctly,
because the timers have stopped.

In order to solve this problem, this patch adds a device_up flag
in ax25_dev in order to judge whether the device is up. If there
are sessions to be cleaned up, the del_timer_sync() in
ax25_release() will not execute. What's more, we add ax25_cb_del()
in ax25_kill_by_device(), because the timers have been stopped
and there are no functions that could delete ax25_cb if we do not
call ax25_release(). Finally, we reorder the position of
ax25_list_lock in ax25_cb_del() in order to synchronize among
different functions that call ax25_cb_del().

The second reason is caused by improper check in ax25_disconnect().
The incoming ax25 sessions which ax25->sk is null will close
heartbeat timer, because the check "if(!ax25->sk || ..)" is
satisfied. As a result, the session could not be cleaned up properly.

In order to solve this problem, this patch changes the improper
check to "if(ax25->sk && ..)" in ax25_disconnect().

What`s more, the ax25_disconnect() may be called twice, which is
not necessary. For example, ax25_kill_by_device() calls
ax25_disconnect() and sets ax25->state to AX25_STATE_0, but
ax25_release() calls ax25_disconnect() again.

In order to solve this problem, this patch add a check in
ax25_release(). If the flag of ax25->sk equals to SOCK_DEAD,
the ax25_disconnect() in ax25_release() should not be executed.

Fixes: 82e31755e55f ("ax25: Fix UAF bugs in ax25 timers")
Fixes: 8a367e74c012 ("ax25: Fix segfault after sock connection timeout")
Reported-and-tested-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220530152158.108619-1-duoming@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ax25.h   |  1 +
 net/ax25/af_ax25.c   | 27 +++++++++++++++++----------
 net/ax25/ax25_dev.c  |  1 +
 net/ax25/ax25_subr.c |  2 +-
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 0f9790c455bb..a427a05672e2 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -228,6 +228,7 @@ typedef struct ax25_dev {
 	ax25_dama_info		dama;
 #endif
 	refcount_t		refcount;
+	bool device_up;
 } ax25_dev;
 
 typedef struct ax25_cb {
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 363d47f94532..289f355e1853 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -62,12 +62,12 @@ static void ax25_free_sock(struct sock *sk)
  */
 static void ax25_cb_del(ax25_cb *ax25)
 {
+	spin_lock_bh(&ax25_list_lock);
 	if (!hlist_unhashed(&ax25->ax25_node)) {
-		spin_lock_bh(&ax25_list_lock);
 		hlist_del_init(&ax25->ax25_node);
-		spin_unlock_bh(&ax25_list_lock);
 		ax25_cb_put(ax25);
 	}
+	spin_unlock_bh(&ax25_list_lock);
 }
 
 /*
@@ -81,6 +81,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		return;
+	ax25_dev->device_up = false;
 
 	spin_lock_bh(&ax25_list_lock);
 again:
@@ -91,6 +92,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 				spin_unlock_bh(&ax25_list_lock);
 				ax25_disconnect(s, ENETUNREACH);
 				s->ax25_dev = NULL;
+				ax25_cb_del(s);
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
 			}
@@ -103,6 +105,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 				dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 				ax25_dev_put(ax25_dev);
 			}
+			ax25_cb_del(s);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
@@ -995,9 +998,11 @@ static int ax25_release(struct socket *sock)
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
 		case AX25_STATE_0:
-			release_sock(sk);
-			ax25_disconnect(ax25, 0);
-			lock_sock(sk);
+			if (!sock_flag(ax25->sk, SOCK_DEAD)) {
+				release_sock(sk);
+				ax25_disconnect(ax25, 0);
+				lock_sock(sk);
+			}
 			ax25_destroy_socket(ax25);
 			break;
 
@@ -1053,11 +1058,13 @@ static int ax25_release(struct socket *sock)
 		ax25_destroy_socket(ax25);
 	}
 	if (ax25_dev) {
-		del_timer_sync(&ax25->timer);
-		del_timer_sync(&ax25->t1timer);
-		del_timer_sync(&ax25->t2timer);
-		del_timer_sync(&ax25->t3timer);
-		del_timer_sync(&ax25->idletimer);
+		if (!ax25_dev->device_up) {
+			del_timer_sync(&ax25->timer);
+			del_timer_sync(&ax25->t1timer);
+			del_timer_sync(&ax25->t2timer);
+			del_timer_sync(&ax25->t3timer);
+			del_timer_sync(&ax25->idletimer);
+		}
 		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 		ax25_dev_put(ax25_dev);
 	}
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d2a244e1c260..5451be15e072 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -62,6 +62,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	ax25_dev->dev     = dev;
 	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
 	ax25_dev->forward = NULL;
+	ax25_dev->device_up = true;
 
 	ax25_dev->values[AX25_VALUES_IPDEFMODE] = AX25_DEF_IPDEFMODE;
 	ax25_dev->values[AX25_VALUES_AXDEFMODE] = AX25_DEF_AXDEFMODE;
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index 3a476e4f6cd0..9ff98f46dc6b 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -268,7 +268,7 @@ void ax25_disconnect(ax25_cb *ax25, int reason)
 		del_timer_sync(&ax25->t3timer);
 		del_timer_sync(&ax25->idletimer);
 	} else {
-		if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+		if (ax25->sk && !sock_flag(ax25->sk, SOCK_DESTROY))
 			ax25_stop_heartbeat(ax25);
 		ax25_stop_t1timer(ax25);
 		ax25_stop_t2timer(ax25);
-- 
2.35.1



