Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0E749186C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348891AbiARCqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344481AbiARCnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EB9C061361;
        Mon, 17 Jan 2022 18:37:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF52BB81232;
        Tue, 18 Jan 2022 02:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE302C36AEF;
        Tue, 18 Jan 2022 02:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473451;
        bh=vNMezxssj6VcvR7r/jjQIM53BOA5+j+5fVwfrXZIJ98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVsGGuy3+8EB8NkX3DWBCZl7A0/aJW70Ph0q/0l92eCyRYyVK7IGr3QdvOwDfEbuf
         Q5o+WN3xeOnISTxb3ywDiPY3ZfZoFkRxt5E0Zea053Zvacx/28cegKS2cqw3bgGOK7
         WWhsx1cwKYAgNphVwsRvJLChdx0OZ1AOM2cKd9itrygWDIRy9trpUoM74p7SDtOilb
         zt8DAx60OhXa9YuRSq9bCi6fRtkivIAT3zHHiNHZbj03SbecG5w3RY413Yd/3LYUcQ
         5E3M3DRAfvfemq+QBLDE/Lyi9acsDACBXrvl547uUHQ5EkHcFgDTSMaChQ313eT0Ii
         if2mCG+kxCRfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Sasha Levin <sashal@kernel.org>, eparis@redhat.com,
        linux-audit@redhat.com
Subject: [PATCH AUTOSEL 5.15 121/188] audit: ensure userspace is penalized the same as the kernel when under pressure
Date:   Mon, 17 Jan 2022 21:30:45 -0500
Message-Id: <20220118023152.1948105-121-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index 4cebadb5f30db..eab7282668ab9 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1540,6 +1540,20 @@ static void audit_receive(struct sk_buff  *skb)
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
 
 /* Log information about who is connecting to the audit multicast socket */
@@ -1824,7 +1838,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
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

