Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466C1F4724
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391694AbfKHLr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:47:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391689AbfKHLrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A65222C5;
        Fri,  8 Nov 2019 11:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213675;
        bh=zrACi/zrpE++6Yp8Y3AqZM16ao3eA7zrnaBCivxJV+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2ACvtfMnC+v9xyIx5+8MHxWw8CnJKvNkypZkOMeYg9Vg4tkeOl/cXEHnoMHy+Zx7
         BuDWNTUnT3NT72JJvgsZxSYDmea90xYPSsCCu606/WWY4vDpa/T8+oeW7MUaNq1Umm
         02f8PHPmwhzt8La3u7M+XZysJTkf3EKBZTZw7Heo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 26/44] signal: Properly deliver SIGILL from uprobes
Date:   Fri,  8 Nov 2019 06:47:02 -0500
Message-Id: <20191108114721.15944-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
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
index aad43c88a6685..8cad3cd92e23e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1836,7 +1836,7 @@ static void handle_trampoline(struct pt_regs *regs)
 
  sigill:
 	uprobe_warn(current, "handle uretprobe, sending SIGILL.");
-	force_sig_info(SIGILL, SEND_SIG_FORCED, current);
+	force_sig(SIGILL, current);
 
 }
 
@@ -1952,7 +1952,7 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 
 	if (unlikely(err)) {
 		uprobe_warn(current, "execute the probed insn, sending SIGILL.");
-		force_sig_info(SIGILL, SEND_SIG_FORCED, current);
+		force_sig(SIGILL, current);
 	}
 }
 
-- 
2.20.1

