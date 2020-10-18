Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C462291CAD
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733020AbgJRTjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730856AbgJRTYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:24:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3000E20791;
        Sun, 18 Oct 2020 19:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049078;
        bh=kb5U8htsM0ITTcyfBXkn9rMhEia7n8W85AjYcybqbQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTRkW9PKFBHNcs0XuFLW/N87mxIaB89BrV0fJfVgy4uQBGCx7x8gU9fZcAIYTeUdq
         +9rBILL2PaxzOqScNZXCsPWd5mzJy9VHpxlndcpTBHBfQcJeXjjSgvDEz5VSFB3OsP
         PYLG1E5DjskWdHfGJG0IvR1Dw4pHElFWwxX8XT/w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rich Felker <dalias@libc.org>, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 16/56] seccomp: kill process instead of thread for unknown actions
Date:   Sun, 18 Oct 2020 15:23:37 -0400
Message-Id: <20201018192417.4055228-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192417.4055228-1-sashal@kernel.org>
References: <20201018192417.4055228-1-sashal@kernel.org>
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
index 56e69203b6588..4b56c83eb3da9 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -745,7 +745,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	default:
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
-		if (action == SECCOMP_RET_KILL_PROCESS ||
+		if (action != SECCOMP_RET_KILL_THREAD ||
 		    get_nr_threads(current) == 1) {
 			siginfo_t info;
 
@@ -755,10 +755,10 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
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

