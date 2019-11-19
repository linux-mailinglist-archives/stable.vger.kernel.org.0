Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7C81015D7
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbfKSFrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731276AbfKSFrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:47:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1135521783;
        Tue, 19 Nov 2019 05:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142467;
        bh=6MASBMvSjedbUBKnlD71QlaSd44QwcHpO8AQ3LfEVJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=af5zeFcAfQjDT4rmEV80mCpsX9pPLwo/KN+JFbi90YWmQgdk5988NAsxBJP48qQ/F
         kWjTBCsUbaHFmtnZi6sNMyDyCexF5sYl8hELFiuPrVEaKbWnSVAGeMn+4iEIGIPcmV
         gQWrmekzcmSKKpuVfcFj6JVoDVCSVcwet51suR2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 092/239] signal: Properly deliver SIGILL from uprobes
Date:   Tue, 19 Nov 2019 06:18:12 +0100
Message-Id: <20191119051320.368558389@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

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



