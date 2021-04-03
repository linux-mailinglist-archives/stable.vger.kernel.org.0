Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA2F3534DB
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 19:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhDCROW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 13:14:22 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:38068 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236364AbhDCROW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 13:14:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UULgAXX_1617470051;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UULgAXX_1617470051)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 04 Apr 2021 01:14:16 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        teroincn@gmail.com, Richard Guy Briggs <rgb@redhat.com>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.9] audit: fix a net reference leak in audit_send_reply()
Date:   Sun,  4 Apr 2021 01:14:10 +0800
Message-Id: <20210403171410.29466-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit a48b284b403a4a073d8beb72d2bb33e54df67fb6 upstream.

If audit_send_reply() fails when trying to create a new thread to
send the reply it also fails to cleanup properly, leaking a reference
to a net structure.  This patch fixes the error path and makes a
handful of other cleanups that came up while fixing the code.

Reported-by: teroincn@gmail.com
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 kernel/audit.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index af1e00f..55ccd842 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -580,6 +580,18 @@ struct sk_buff *audit_make_reply(__u32 portid, int seq, int type, int done,
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
@@ -592,8 +604,8 @@ static int audit_send_reply_thread(void *arg)
 	/* Ignore failure. It'll only happen if the sender goes away,
 	   because our timeout is set to infinite. */
 	netlink_unicast(aunet->nlsk , reply->skb, reply->portid, 0);
-	put_net(net);
-	kfree(reply);
+	reply->skb = NULL;
+	audit_free_reply(reply);
 	return 0;
 }
 /**
@@ -606,36 +618,34 @@ static int audit_send_reply_thread(void *arg)
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
 	u32 portid = NETLINK_CB(request_skb).portid;
-	struct net *net = sock_net(NETLINK_CB(request_skb).sk);
-	struct sk_buff *skb;
 	struct task_struct *tsk;
-	struct audit_reply *reply = kmalloc(sizeof(struct audit_reply),
-					    GFP_KERNEL);
+	struct audit_reply *reply;
 
+	reply = kzalloc(sizeof(*reply), GFP_KERNEL);
 	if (!reply)
 		return;
 
-	skb = audit_make_reply(portid, seq, type, done, multi, payload, size);
-	if (!skb)
-		goto out;
+	reply->skb = audit_make_reply(portid, seq, type, done, multi, payload, size);
+	if (!reply->skb)
+		goto err;
 
-	reply->net = get_net(net);
+	reply->net = get_net(sock_net(NETLINK_CB(request_skb).sk));
 	reply->portid = portid;
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
1.8.3.1

