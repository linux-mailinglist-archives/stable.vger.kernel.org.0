Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FE0491DB7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347140AbiARDlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353842AbiARDEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:04:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E23C021987;
        Mon, 17 Jan 2022 18:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A964612E8;
        Tue, 18 Jan 2022 02:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB61C36AF2;
        Tue, 18 Jan 2022 02:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474093;
        bh=BiDawCDCR9XnHyP+jduSugMt5j1biVVhOqB9aUPbh90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpbc3MlOMtPU1yqEaK5S3n43dd6xmakvVcNn8Pj1DzJxQScWuvfIPSApy/DRAZBs4
         8A8lV2SDmVYgzpocDbXra6BTScMC2weQdIQ/DN8n8Hiit/TnFE3tlP4AOa3Selg9lk
         yMuuJpxL13AdJ54UzLNzHLyzRVi5RYofNRupNKoyTtYvGcyoQOe2Ntw4bPDOBvvFHo
         MTrsl1KdeiDzKkylqKvzIqzNRNvLL0QODmogVCSKsmBcX2UpcUW61UPsVAAY9HXwsh
         rnBelCdjoQC3ChJnOtiblliyJjCV6KM2htXtFr5dBef0DzrWUp8vcVVJnhK8OXzgyl
         Dt7nJqdMUzKTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Sasha Levin <sashal@kernel.org>, eparis@redhat.com,
        linux-audit@redhat.com
Subject: [PATCH AUTOSEL 4.19 33/59] audit: ensure userspace is penalized the same as the kernel when under pressure
Date:   Mon, 17 Jan 2022 21:46:34 -0500
Message-Id: <20220118024701.1952911-33-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

