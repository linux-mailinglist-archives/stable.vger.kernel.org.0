Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2AF47AEEA
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239308AbhLTPGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240498AbhLTPEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:04:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3D1C09B109;
        Mon, 20 Dec 2021 06:52:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 953E9611A4;
        Mon, 20 Dec 2021 14:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F1AC36AE7;
        Mon, 20 Dec 2021 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011958;
        bh=R5ZjyaG3tKZrPockUV4bc0IBB3IS8HpD1SwtksQByQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6A4VsOf72xu/nQlHj9MxuX3dSYTnpyJf9egFFso7LeXtoe3xGrXIgJvb5NBVywSI
         eIk3aP9wAez0ifoaRLpwCaLXLM0UchXPjW4NHBaVkB8QRbfDzJiJfbSByxp+F5/qAN
         G5CLYwfIhClYZKh08jU8bLBhIN92Fn56/F+y2Ii4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 029/177] audit: improve robustness of the audit queue handling
Date:   Mon, 20 Dec 2021 15:32:59 +0100
Message-Id: <20211220143041.061828599@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit f4b3ee3c85551d2d343a3ba159304066523f730f upstream.

If the audit daemon were ever to get stuck in a stopped state the
kernel's kauditd_thread() could get blocked attempting to send audit
records to the userspace audit daemon.  With the kernel thread
blocked it is possible that the audit queue could grow unbounded as
certain audit record generating events must be exempt from the queue
limits else the system enter a deadlock state.

This patch resolves this problem by lowering the kernel thread's
socket sending timeout from MAX_SCHEDULE_TIMEOUT to HZ/10 and tweaks
the kauditd_send_queue() function to better manage the various audit
queues when connection problems occur between the kernel and the
audit daemon.  With this patch, the backlog may temporarily grow
beyond the defined limits when the audit daemon is stopped and the
system is under heavy audit pressure, but kauditd_thread() will
continue to make progress and drain the queues as it would for other
connection problems.  For example, with the audit daemon put into a
stopped state and the system configured to audit every syscall it
was still possible to shutdown the system without a kernel panic,
deadlock, etc.; granted, the system was slow to shutdown but that is
to be expected given the extreme pressure of recording every syscall.

The timeout value of HZ/10 was chosen primarily through
experimentation and this developer's "gut feeling".  There is likely
no one perfect value, but as this scenario is limited in scope (root
privileges would be needed to send SIGSTOP to the audit daemon), it
is likely not worth exposing this as a tunable at present.  This can
always be done at a later date if it proves necessary.

Cc: stable@vger.kernel.org
Fixes: 5b52330bbfe63 ("audit: fix auditd/kernel connection state tracking")
Reported-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Tested-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -718,7 +718,7 @@ static int kauditd_send_queue(struct soc
 {
 	int rc = 0;
 	struct sk_buff *skb;
-	static unsigned int failed = 0;
+	unsigned int failed = 0;
 
 	/* NOTE: kauditd_thread takes care of all our locking, we just use
 	 *       the netlink info passed to us (e.g. sk and portid) */
@@ -735,32 +735,30 @@ static int kauditd_send_queue(struct soc
 			continue;
 		}
 
+retry:
 		/* grab an extra skb reference in case of error */
 		skb_get(skb);
 		rc = netlink_unicast(sk, skb, portid, 0);
 		if (rc < 0) {
-			/* fatal failure for our queue flush attempt? */
+			/* send failed - try a few times unless fatal error */
 			if (++failed >= retry_limit ||
 			    rc == -ECONNREFUSED || rc == -EPERM) {
-				/* yes - error processing for the queue */
 				sk = NULL;
 				if (err_hook)
 					(*err_hook)(skb);
-				if (!skb_hook)
-					goto out;
-				/* keep processing with the skb_hook */
+				if (rc == -EAGAIN)
+					rc = 0;
+				/* continue to drain the queue */
 				continue;
 			} else
-				/* no - requeue to preserve ordering */
-				skb_queue_head(queue, skb);
+				goto retry;
 		} else {
-			/* it worked - drop the extra reference and continue */
+			/* skb sent - drop the extra reference and continue */
 			consume_skb(skb);
 			failed = 0;
 		}
 	}
 
-out:
 	return (rc >= 0 ? 0 : rc);
 }
 
@@ -1609,7 +1607,8 @@ static int __net_init audit_net_init(str
 		audit_panic("cannot initialize netlink socket in namespace");
 		return -ENOMEM;
 	}
-	aunet->sk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
+	/* limit the timeout in case auditd is blocked/stopped */
+	aunet->sk->sk_sndtimeo = HZ / 10;
 
 	return 0;
 }


