Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 607C4F48A8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390881AbfKHLoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:44:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390877AbfKHLoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0473A222D1;
        Fri,  8 Nov 2019 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213483;
        bh=TbNX3dN2mRRR9GX73JiJ7PChGNt7lFxgYfJmfZAb+A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1vh878hdL1hkOkXKCbadKlU9aeCeRD2M1ZIfqlb8zVXPqi+vaaSrqvRCuvQGeVMX
         DaplhibDNFOT6Ul8klUIFDCzSifOrFd/hbwb7n+mMxZVfj/MgDmtNZl3JqdknJn2bd
         YQ8T/YOMiOf9VAQe0J+Vw44d1klY3oNWSOYAjbU4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 064/103] signal: Always ignore SIGKILL and SIGSTOP sent to the global init
Date:   Fri,  8 Nov 2019 06:42:29 -0500
Message-Id: <20191108114310.14363-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 86989c41b5ea08776c450cb759592532314a4ed6 ]

If the first process started (aka /sbin/init) receives a SIGKILL it
will panic the system if it is delivered.  Making the system unusable
and undebugable.  It isn't much better if the first process started
receives SIGSTOP.

So always ignore SIGSTOP and SIGKILL sent to init.

This is done in a separate clause in sig_task_ignored as force_sig_info
can clear SIG_UNKILLABLE and this protection should work even then.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index bb801156628ee..c9b203875001e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -77,6 +77,10 @@ static int sig_task_ignored(struct task_struct *t, int sig, bool force)
 
 	handler = sig_handler(t, sig);
 
+	/* SIGKILL and SIGSTOP may not be sent to the global init */
+	if (unlikely(is_global_init(t) && sig_kernel_only(sig)))
+		return true;
+
 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
 	    handler == SIG_DFL && !(force && sig_kernel_only(sig)))
 		return 1;
-- 
2.20.1

