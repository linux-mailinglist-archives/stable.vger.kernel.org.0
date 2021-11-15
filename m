Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF50450D88
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbhKOR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239145AbhKORyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:54:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E306F632BC;
        Mon, 15 Nov 2021 17:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997590;
        bh=rlwGY74GnDEID8pp7q2XayTP5DUvMxuhhnOMg7+CKhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLe2rrypOYJ/JwMM5Swv+fwztkoP41dbN1Q88SF4xWcMYzC9Z7zoA21zJlUsiDITG
         qnQKxzr9gdKWCTo1+Uko3kyN7Yi4ludwFUe9rSEnlMREvakRR+NK1C+Cb4hKl0Tep4
         UnCU5ZJBp3yt+0siaS+51XK8VkXc1sVt1boc5wyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/575] ipmi: Disable some operations during a panic
Date:   Mon, 15 Nov 2021 17:58:48 +0100
Message-Id: <20211115165350.727150895@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit b36eb5e7b75a756baa64909a176dd4269ee05a8b ]

Don't do kfree or other risky things when oops_in_progress is set.
It's easy enough to avoid doing them

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 10 +++++++---
 drivers/char/ipmi/ipmi_watchdog.c   | 17 ++++++++++++-----
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 8774a3b8ff959..abb865b1dff29 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4802,7 +4802,9 @@ static atomic_t recv_msg_inuse_count = ATOMIC_INIT(0);
 static void free_smi_msg(struct ipmi_smi_msg *msg)
 {
 	atomic_dec(&smi_msg_inuse_count);
-	kfree(msg);
+	/* Try to keep as much stuff out of the panic path as possible. */
+	if (!oops_in_progress)
+		kfree(msg);
 }
 
 struct ipmi_smi_msg *ipmi_alloc_smi_msg(void)
@@ -4821,7 +4823,9 @@ EXPORT_SYMBOL(ipmi_alloc_smi_msg);
 static void free_recv_msg(struct ipmi_recv_msg *msg)
 {
 	atomic_dec(&recv_msg_inuse_count);
-	kfree(msg);
+	/* Try to keep as much stuff out of the panic path as possible. */
+	if (!oops_in_progress)
+		kfree(msg);
 }
 
 static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void)
@@ -4839,7 +4843,7 @@ static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void)
 
 void ipmi_free_recv_msg(struct ipmi_recv_msg *msg)
 {
-	if (msg->user)
+	if (msg->user && !oops_in_progress)
 		kref_put(&msg->user->refcount, free_user);
 	msg->done(msg);
 }
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 6384510c48d6b..92eda5b2f1341 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -342,13 +342,17 @@ static atomic_t msg_tofree = ATOMIC_INIT(0);
 static DECLARE_COMPLETION(msg_wait);
 static void msg_free_smi(struct ipmi_smi_msg *msg)
 {
-	if (atomic_dec_and_test(&msg_tofree))
-		complete(&msg_wait);
+	if (atomic_dec_and_test(&msg_tofree)) {
+		if (!oops_in_progress)
+			complete(&msg_wait);
+	}
 }
 static void msg_free_recv(struct ipmi_recv_msg *msg)
 {
-	if (atomic_dec_and_test(&msg_tofree))
-		complete(&msg_wait);
+	if (atomic_dec_and_test(&msg_tofree)) {
+		if (!oops_in_progress)
+			complete(&msg_wait);
+	}
 }
 static struct ipmi_smi_msg smi_msg = {
 	.done = msg_free_smi
@@ -434,8 +438,10 @@ static int _ipmi_set_timeout(int do_heartbeat)
 	rv = __ipmi_set_timeout(&smi_msg,
 				&recv_msg,
 				&send_heartbeat_now);
-	if (rv)
+	if (rv) {
+		atomic_set(&msg_tofree, 0);
 		return rv;
+	}
 
 	wait_for_completion(&msg_wait);
 
@@ -580,6 +586,7 @@ restart:
 				      &recv_msg,
 				      1);
 	if (rv) {
+		atomic_set(&msg_tofree, 0);
 		pr_warn("heartbeat send failure: %d\n", rv);
 		return rv;
 	}
-- 
2.33.0



