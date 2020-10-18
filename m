Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D11291F6D
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388949AbgJRUAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 16:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbgJRTSk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84932222EB;
        Sun, 18 Oct 2020 19:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048720;
        bh=vopNWSWNwlgzyqkMps1MvPVsl9SsyP7xO3+tSPNb8cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wibFtqfufJyKC/UXFUZgO+8MAU/jEjgt9FN5mXYW9adVIKVC8hTBoS9vAq/2R0aJV
         4Xgfy1ndrrlafT5M9xLCf2Jb4eacMQveydejbMyLHgt+xKVGnm406SPJopxsZ8a7ut
         73J3GlZ/WcRT7s4TUpbrKcPWNnlkiGyDJKi0QNAE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rich Felker <dalias@libc.org>, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 026/111] seccomp: kill process instead of thread for unknown actions
Date:   Sun, 18 Oct 2020 15:16:42 -0400
Message-Id: <20201018191807.4052726-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rich Felker <dalias@libc.org>

[ Upstream commit 4d671d922d51907bc41f1f7f2dc737c928ae78fd ]

Asynchronous termination of a thread outside of the userspace thread
library's knowledge is an unsafe operation that leaves the process in
an inconsistent, corrupt, and possibly unrecoverable state. In order
to make new actions that may be added in the future safe on kernels
not aware of them, change the default action from
SECCOMP_RET_KILL_THREAD to SECCOMP_RET_KILL_PROCESS.

Signed-off-by: Rich Felker <dalias@libc.org>
Link: https://lore.kernel.org/r/20200829015609.GA32566@brightrain.aerifal.cx
[kees: Fixed up coredump selection logic to match]
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/seccomp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 676d4af621038..f754c1087e413 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1020,7 +1020,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	default:
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
-		if (action == SECCOMP_RET_KILL_PROCESS ||
+		if (action != SECCOMP_RET_KILL_THREAD ||
 		    get_nr_threads(current) == 1) {
 			kernel_siginfo_t info;
 
@@ -1030,10 +1030,10 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 			seccomp_init_siginfo(&info, this_syscall, data);
 			do_coredump(&info);
 		}
-		if (action == SECCOMP_RET_KILL_PROCESS)
-			do_group_exit(SIGSYS);
-		else
+		if (action == SECCOMP_RET_KILL_THREAD)
 			do_exit(SIGSYS);
+		else
+			do_group_exit(SIGSYS);
 	}
 
 	unreachable();
-- 
2.25.1

