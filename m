Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508493534DC
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 19:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhDCROe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 13:14:34 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:60006 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236819AbhDCROd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 13:14:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UULd8cZ_1617470062;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UULd8cZ_1617470062)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 04 Apr 2021 01:14:28 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        teroincn@gmail.com, Richard Guy Briggs <rgb@redhat.com>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.9] audit: fix a net reference leak in audit_list_rules_send()
Date:   Sun,  4 Apr 2021 01:14:21 +0800
Message-Id: <20210403171421.29512-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
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
---
 kernel/audit.c       |  2 +-
 kernel/audit.h       |  2 +-
 kernel/auditfilter.c | 13 ++++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 55ccd842..7fa9020 100644
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
diff --git a/kernel/audit.h b/kernel/audit.h
index 431444c..2eaf450 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -245,7 +245,7 @@ struct audit_netlink_list {
 	struct sk_buff_head q;
 };
 
-int audit_send_list(void *);
+int audit_send_list_thread(void *);
 
 struct audit_net {
 	struct sock *nlsk;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index a71ff996..cd12d79 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1139,10 +1139,8 @@ int audit_rule_change(int type, __u32 portid, int seq, void *data,
 int audit_list_rules_send(struct sk_buff *request_skb, int seq)
 {
 	u32 portid = NETLINK_CB(request_skb).portid;
-	struct net *net = sock_net(NETLINK_CB(request_skb).sk);
 	struct task_struct *tsk;
 	struct audit_netlink_list *dest;
-	int err = 0;
 
 	/* We can't just spew out the rules here because we might fill
 	 * the available socket buffer space and deadlock waiting for
@@ -1150,10 +1148,10 @@ int audit_list_rules_send(struct sk_buff *request_skb, int seq)
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
 
@@ -1161,14 +1159,15 @@ int audit_list_rules_send(struct sk_buff *request_skb, int seq)
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
-- 
1.8.3.1

