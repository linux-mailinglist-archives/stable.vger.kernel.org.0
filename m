Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C589B353D04
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhDEI5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233373AbhDEI5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C928E61393;
        Mon,  5 Apr 2021 08:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613068;
        bh=EHu03ADcVSThp0tnW4DpPUjxbQbEo0qZve+4tBck6wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGh0vKIerXmADj6JydH4a2WPxgUm1weuOIHbqJ+ONp1dEw5IlYiONrt6K9jhPkJ9x
         kgOx21mTAqxMPeCfDLCcvFlCuR2KbCtOInjA5vAgH56QmWuuLL9f9baut77yF0FIjz
         1NYkQhBOU/eT/bFqC/bJL5JRUw8vVLIXEl/cokAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, teroincn@gmail.com,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.9 35/35] audit: fix a net reference leak in audit_list_rules_send()
Date:   Mon,  5 Apr 2021 10:54:10 +0200
Message-Id: <20210405085019.983552878@linuxfoundation.org>
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

commit 3054d06719079388a543de6adb812638675ad8f5 upstream.

If audit_list_rules_send() fails when trying to create a new thread
to send the rules it also fails to cleanup properly, leaking a
reference to a net structure.  This patch fixes the error patch and
renames audit_send_list() to audit_send_list_thread() to better
match its cousin, audit_send_reply_thread().

Reported-by: teroincn@gmail.com
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c       |    2 +-
 kernel/audit.h       |    2 +-
 kernel/auditfilter.c |   13 ++++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -535,7 +535,7 @@ static int kauditd_thread(void *dummy)
 	return 0;
 }
 
-int audit_send_list(void *_dest)
+int audit_send_list_thread(void *_dest)
 {
 	struct audit_netlink_list *dest = _dest;
 	struct sk_buff *skb;
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -245,7 +245,7 @@ struct audit_netlink_list {
 	struct sk_buff_head q;
 };
 
-int audit_send_list(void *);
+int audit_send_list_thread(void *);
 
 struct audit_net {
 	struct sock *nlsk;
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1139,10 +1139,8 @@ int audit_rule_change(int type, __u32 po
 int audit_list_rules_send(struct sk_buff *request_skb, int seq)
 {
 	u32 portid = NETLINK_CB(request_skb).portid;
-	struct net *net = sock_net(NETLINK_CB(request_skb).sk);
 	struct task_struct *tsk;
 	struct audit_netlink_list *dest;
-	int err = 0;
 
 	/* We can't just spew out the rules here because we might fill
 	 * the available socket buffer space and deadlock waiting for
@@ -1150,10 +1148,10 @@ int audit_list_rules_send(struct sk_buff
 	 * happen if we're actually running in the context of auditctl
 	 * trying to _send_ the stuff */
 
-	dest = kmalloc(sizeof(struct audit_netlink_list), GFP_KERNEL);
+	dest = kmalloc(sizeof(*dest), GFP_KERNEL);
 	if (!dest)
 		return -ENOMEM;
-	dest->net = get_net(net);
+	dest->net = get_net(sock_net(NETLINK_CB(request_skb).sk));
 	dest->portid = portid;
 	skb_queue_head_init(&dest->q);
 
@@ -1161,14 +1159,15 @@ int audit_list_rules_send(struct sk_buff
 	audit_list_rules(portid, seq, &dest->q);
 	mutex_unlock(&audit_filter_mutex);
 
-	tsk = kthread_run(audit_send_list, dest, "audit_send_list");
+	tsk = kthread_run(audit_send_list_thread, dest, "audit_send_list");
 	if (IS_ERR(tsk)) {
 		skb_queue_purge(&dest->q);
+		put_net(dest->net);
 		kfree(dest);
-		err = PTR_ERR(tsk);
+		return PTR_ERR(tsk);
 	}
 
-	return err;
+	return 0;
 }
 
 int audit_comparator(u32 left, u32 op, u32 right)


