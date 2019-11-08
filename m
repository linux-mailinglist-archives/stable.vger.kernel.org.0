Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1189F46BC
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390890AbfKHLoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:44:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390882AbfKHLop (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDFDC22459;
        Fri,  8 Nov 2019 11:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213484;
        bh=Z/wQeacsCU/UcVT0yywx6nIU0Pj0AZJRVkjGg3WJL0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jxqp4HTebTlEs4fI8ZYNfDoRu1l2sByTwS17pCnq2TAYy/rWwK4Y+pdw5aJgXSRjb
         xl/68S09QZtfRXr4TE9OdgYtmPEHioGIjDsPfcr+ZAEu7QC1/Ums+2bgTCJZDkf+go
         VyZborXRq7EDZ4VGyahqcP/a8lEC5MhbW6Ya3ryE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 065/103] signal: Properly deliver SIGILL from uprobes
Date:   Fri,  8 Nov 2019 06:42:30 -0500
Message-Id: <20191108114310.14363-65-sashal@kernel.org>
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

[ Upstream commit 55a3235fc71bf34303e34a95eeee235b2d2a35dd ]

For userspace to tell the difference between a random signal and an
exception, the exception must include siginfo information.

Using SEND_SIG_FORCED for SIGILL is thus wrong, and it will result
in userspace seeing si_code == SI_USER (like a random signal) instead
of si_code == SI_KERNEL or a more specific si_code as all exceptions
deliver.

Therefore replace force_sig_info(SIGILL, SEND_SIG_FORCE, current)
with force_sig(SIG_ILL, current) which gets this right and is
shorter and easier to type.

Fixes: 014940bad8e4 ("uprobes/x86: Send SIGILL if arch_uprobe_post_xol() fails")
Fixes: 0b5256c7f173 ("uprobes: Send SIGILL if handle_trampoline() fails")
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 01941cffa9c2f..c74fc98262508 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1854,7 +1854,7 @@ static void handle_trampoline(struct pt_regs *regs)
 
  sigill:
 	uprobe_warn(current, "handle uretprobe, sending SIGILL.");
-	force_sig_info(SIGILL, SEND_SIG_FORCED, current);
+	force_sig(SIGILL, current);
 
 }
 
@@ -1970,7 +1970,7 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 
 	if (unlikely(err)) {
 		uprobe_warn(current, "execute the probed insn, sending SIGILL.");
-		force_sig_info(SIGILL, SEND_SIG_FORCED, current);
+		force_sig(SIGILL, current);
 	}
 }
 
-- 
2.20.1

