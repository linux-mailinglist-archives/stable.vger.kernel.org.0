Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281ED353D00
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhDEI5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233340AbhDEI5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 301B8610E8;
        Mon,  5 Apr 2021 08:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613065;
        bh=3SHKbbEXoPErrAsIDb2nUkQQYB67JgIL0oeUYVPoEH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/34lefzYaWzQABKVu5g0Ih0n6EniawWAJbiU2XnYoLqajt8pVNLlDMog5AOCksBV
         uAGRV9L0PYnWkClI8aMpvPoMueyN8qc5FWMPWjQv4YXvhHJHlAlxyMbL37+FfBsfyv
         5gbtiynfBzjvnEew8HpHogx7NTNw4HLcvcA0EX34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, teroincn@gmail.com,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.9 34/35] audit: fix a net reference leak in audit_send_reply()
Date:   Mon,  5 Apr 2021 10:54:09 +0200
Message-Id: <20210405085019.951555935@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |   46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -580,6 +580,18 @@ out_kfree_skb:
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
@@ -592,8 +604,8 @@ static int audit_send_reply_thread(void
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
@@ -606,36 +618,34 @@ static int audit_send_reply_thread(void
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


