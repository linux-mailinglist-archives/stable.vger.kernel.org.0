Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FB5201708
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389308AbgFSOu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389301AbgFSOuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:50:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27ACA20DD4;
        Fri, 19 Jun 2020 14:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578222;
        bh=REYmcY8cxaI9Sz3+PaxzgBVhHq/qpIHIa00Ix67ORNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOVjpNgKKwxxarverJJXvTHgLgF7dOX/cdG7tr/E7lEi4pzmpKmtZ21cyW3YXEGZe
         QKObfRkLNKcd80krbT9U245JpYv/feupIzCOt/rJTWqwuR66c6RtxpmsWlMc+dPtE9
         t8HduK2ls/zF+0IZh96UHOFWm8wMoloUzD+Y08U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, teroincn@gmail.com,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 100/190] audit: fix a net reference leak in audit_send_reply()
Date:   Fri, 19 Jun 2020 16:32:25 +0200
Message-Id: <20200619141638.582021944@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit a48b284b403a4a073d8beb72d2bb33e54df67fb6 ]

If audit_send_reply() fails when trying to create a new thread to
send the reply it also fails to cleanup properly, leaking a reference
to a net structure.  This patch fixes the error path and makes a
handful of other cleanups that came up while fixing the code.

Reported-by: teroincn@gmail.com
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/audit.c | 50 +++++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index aa6d5e39526b..53224f399038 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -897,19 +897,30 @@ out_kfree_skb:
 	return NULL;
 }
 
+static void audit_free_reply(struct audit_reply *reply)
+{
+	if (!reply)
+		return;
+
+	if (reply->skb)
+		kfree_skb(reply->skb);
+	if (reply->net)
+		put_net(reply->net);
+	kfree(reply);
+}
+
 static int audit_send_reply_thread(void *arg)
 {
 	struct audit_reply *reply = (struct audit_reply *)arg;
-	struct sock *sk = audit_get_sk(reply->net);
 
 	mutex_lock(&audit_cmd_mutex);
 	mutex_unlock(&audit_cmd_mutex);
 
 	/* Ignore failure. It'll only happen if the sender goes away,
 	   because our timeout is set to infinite. */
-	netlink_unicast(sk, reply->skb, reply->portid, 0);
-	put_net(reply->net);
-	kfree(reply);
+	netlink_unicast(audit_get_sk(reply->net), reply->skb, reply->portid, 0);
+	reply->skb = NULL;
+	audit_free_reply(reply);
 	return 0;
 }
 
@@ -923,35 +934,32 @@ static int audit_send_reply_thread(void *arg)
  * @payload: payload data
  * @size: payload size
  *
- * Allocates an skb, builds the netlink message, and sends it to the port id.
- * No failure notifications.
+ * Allocates a skb, builds the netlink message, and sends it to the port id.
  */
 static void audit_send_reply(struct sk_buff *request_skb, int seq, int type, int done,
 			     int multi, const void *payload, int size)
 {
-	struct net *net = sock_net(NETLINK_CB(request_skb).sk);
-	struct sk_buff *skb;
 	struct task_struct *tsk;
-	struct audit_reply *reply = kmalloc(sizeof(struct audit_reply),
-					    GFP_KERNEL);
+	struct audit_reply *reply;
 
+	reply = kzalloc(sizeof(*reply), GFP_KERNEL);
 	if (!reply)
 		return;
 
-	skb = audit_make_reply(seq, type, done, multi, payload, size);
-	if (!skb)
-		goto out;
-
-	reply->net = get_net(net);
+	reply->skb = audit_make_reply(seq, type, done, multi, payload, size);
+	if (!reply->skb)
+		goto err;
+	reply->net = get_net(sock_net(NETLINK_CB(request_skb).sk));
 	reply->portid = NETLINK_CB(request_skb).portid;
-	reply->skb = skb;
 
 	tsk = kthread_run(audit_send_reply_thread, reply, "audit_send_reply");
-	if (!IS_ERR(tsk))
-		return;
-	kfree_skb(skb);
-out:
-	kfree(reply);
+	if (IS_ERR(tsk))
+		goto err;
+
+	return;
+
+err:
+	audit_free_reply(reply);
 }
 
 /*
-- 
2.25.1



