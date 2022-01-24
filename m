Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12568498C73
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbiAXTWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:22:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40686 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348839AbiAXTTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:19:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6C3FB8121B;
        Mon, 24 Jan 2022 19:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D03C340E8;
        Mon, 24 Jan 2022 19:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051985;
        bh=BiDawCDCR9XnHyP+jduSugMt5j1biVVhOqB9aUPbh90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Xd9bBSJUhV6/nhZpBZKeD6y3PidL9tqTGDXlQDse8ATHomPVfG3gnQbKGx3uxXnk
         aBBvQDuxnXk73pyRXYRhl1BismM+xH4s0mZc+f7qfJta4bLaxnmZamp/IrMvbykEaS
         OkYW9I3WUFZ8FPY8LhruRfHWjPzAhbzca8LDIT3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/239] audit: ensure userspace is penalized the same as the kernel when under pressure
Date:   Mon, 24 Jan 2022 19:43:09 +0100
Message-Id: <20220124183947.896612524@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit 8f110f530635af44fff1f4ee100ecef0bac62510 ]

Due to the audit control mutex necessary for serializing audit
userspace messages we haven't been able to block/penalize userspace
processes that attempt to send audit records while the system is
under audit pressure.  The result is that privileged userspace
applications have a priority boost with respect to audit as they are
not bound by the same audit queue throttling as the other tasks on
the system.

This patch attempts to restore some balance to the system when under
audit pressure by blocking these privileged userspace tasks after
they have finished their audit processing, and dropped the audit
control mutex, but before they return to userspace.

Reported-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Tested-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/audit.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 968921d376b98..c5e034fe14bbb 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1528,6 +1528,20 @@ static void audit_receive(struct sk_buff  *skb)
 		nlh = nlmsg_next(nlh, &len);
 	}
 	audit_ctl_unlock();
+
+	/* can't block with the ctrl lock, so penalize the sender now */
+	if (audit_backlog_limit &&
+	    (skb_queue_len(&audit_queue) > audit_backlog_limit)) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		/* wake kauditd to try and flush the queue */
+		wake_up_interruptible(&kauditd_wait);
+
+		add_wait_queue_exclusive(&audit_backlog_wait, &wait);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(audit_backlog_wait_time);
+		remove_wait_queue(&audit_backlog_wait, &wait);
+	}
 }
 
 /* Run custom bind function on netlink socket group connect or bind requests. */
@@ -1772,7 +1786,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	 *    task_tgid_vnr() since auditd_pid is set in audit_receive_msg()
 	 *    using a PID anchored in the caller's namespace
 	 * 2. generator holding the audit_cmd_mutex - we don't want to block
-	 *    while holding the mutex */
+	 *    while holding the mutex, although we do penalize the sender
+	 *    later in audit_receive() when it is safe to block
+	 */
 	if (!(auditd_test_task(current) || audit_ctl_owner_current())) {
 		long stime = audit_backlog_wait_time;
 
-- 
2.34.1



