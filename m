Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9821F2A78
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732831AbgFIAIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730991AbgFHXUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:20:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2BDC20842;
        Mon,  8 Jun 2020 23:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658435;
        bh=lIYatyaky7rSKOXjSGtd40LsxoDaedv+mNGO2ITQ/Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiAly3wZUKX6xPn4HCt+XOEGqvQw/Z/89MfyHI57N03a4Wv38tNuOFnonB9+etzgF
         ITMb2abrRL60iYpCxB+aLUF9E4oxaBAbCPX4eRhMKza5OhLgi6348EJQtFp5bwcJ/h
         7hyGq1EbuGFL7BDsVIrapi3/tFPzhr9WjA6v7J1k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, teroincn@gmail.com,
        Richard Guy Briggs <rgb@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-audit@redhat.com
Subject: [PATCH AUTOSEL 5.4 079/175] audit: fix a net reference leak in audit_list_rules_send()
Date:   Mon,  8 Jun 2020 19:17:12 -0400
Message-Id: <20200608231848.3366970-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit 3054d06719079388a543de6adb812638675ad8f5 ]

If audit_list_rules_send() fails when trying to create a new thread
to send the rules it also fails to cleanup properly, leaking a
reference to a net structure.  This patch fixes the error patch and
renames audit_send_list() to audit_send_list_thread() to better
match its cousin, audit_send_reply_thread().

Reported-by: teroincn@gmail.com
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/audit.c       |  2 +-
 kernel/audit.h       |  2 +-
 kernel/auditfilter.c | 16 +++++++---------
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index a4eeece2eecd..05ae208ad442 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -879,7 +879,7 @@ static int kauditd_thread(void *dummy)
 	return 0;
 }
 
-int audit_send_list(void *_dest)
+int audit_send_list_thread(void *_dest)
 {
 	struct audit_netlink_list *dest = _dest;
 	struct sk_buff *skb;
diff --git a/kernel/audit.h b/kernel/audit.h
index 6fb7160412d4..ddc22878433d 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -229,7 +229,7 @@ struct audit_netlink_list {
 	struct sk_buff_head q;
 };
 
-int audit_send_list(void *_dest);
+int audit_send_list_thread(void *_dest);
 
 extern int selinux_audit_rule_update(void);
 
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 026e34da4ace..a10e2997aa6c 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1161,11 +1161,8 @@ int audit_rule_change(int type, int seq, void *data, size_t datasz)
  */
 int audit_list_rules_send(struct sk_buff *request_skb, int seq)
 {
-	u32 portid = NETLINK_CB(request_skb).portid;
-	struct net *net = sock_net(NETLINK_CB(request_skb).sk);
 	struct task_struct *tsk;
 	struct audit_netlink_list *dest;
-	int err = 0;
 
 	/* We can't just spew out the rules here because we might fill
 	 * the available socket buffer space and deadlock waiting for
@@ -1173,25 +1170,26 @@ int audit_list_rules_send(struct sk_buff *request_skb, int seq)
 	 * happen if we're actually running in the context of auditctl
 	 * trying to _send_ the stuff */
 
-	dest = kmalloc(sizeof(struct audit_netlink_list), GFP_KERNEL);
+	dest = kmalloc(sizeof(*dest), GFP_KERNEL);
 	if (!dest)
 		return -ENOMEM;
-	dest->net = get_net(net);
-	dest->portid = portid;
+	dest->net = get_net(sock_net(NETLINK_CB(request_skb).sk));
+	dest->portid = NETLINK_CB(request_skb).portid;
 	skb_queue_head_init(&dest->q);
 
 	mutex_lock(&audit_filter_mutex);
 	audit_list_rules(seq, &dest->q);
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
2.25.1

