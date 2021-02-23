Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532B432306F
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 19:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbhBWSP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 13:15:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233888AbhBWSPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 13:15:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2169764E24;
        Tue, 23 Feb 2021 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614104115;
        bh=YTPW0+A1gFd+PueT0UIv5DVxtreZ1h/YnUkjM+KgzGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDKXFP1vNC35x0DrH3lKYg4zDu2VeEBfjl88YHGpGcFsgE6YW96X5NLG5nrfAE71f
         OeIhv4BoT9Vika0PjFBBcP1B65XndCzNU19RJR8MhW9rLmhADGvz6n4TG95DwdZmn5
         u0fjf2AusQhNqLipQXaxUAMJ/l4Vv6CUVtj3Na4AYn86V02/0YSyUFB5a9Gq2D19WF
         i8ZN7y3iqx3+UNE6l18a24sRueAiQPEZ+AaIXurntL3y4DXpIc/zm0HtShJK0Ne/TF
         suZ80ARhZEzxWGFOYW20HP59e0WfeoS+u7lHV5zjc54fwvGbgcFuyieJGvcn1ZW0mS
         7x/1C4/uBkHmQ==
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/3] x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls
Date:   Tue, 23 Feb 2021 10:15:09 -0800
Message-Id: <04713c6be5ab45357e3406c42d382536f52a64c6.1614104065.git.luto@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614104065.git.luto@kernel.org>
References: <cover.1614104065.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On a 32-bit fast syscall that fails to read its arguments from user
memory, the kernel currently does syscall exit work but not
syscall entry work.  This confuses audit and ptrace.  For example:

    $ ./tools/testing/selftests/x86/syscall_arg_fault_32
    ...
    strace: pid 264258: entering, ptrace_syscall_info.op == 2
    ...

This is a minimal fix intended for ease of backporting.  A more
complete cleanup is coming.

Cc: stable@vger.kernel.org
Fixes: 0b085e68f407 ("x86/entry: Consolidate 32/64 bit syscall entry")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 0904f5676e4d..cf4dcf346ca8 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -128,7 +128,8 @@ static noinstr bool __do_fast_syscall_32(struct pt_regs *regs)
 		regs->ax = -EFAULT;
 
 		instrumentation_end();
-		syscall_exit_to_user_mode(regs);
+		local_irq_disable();
+		exit_to_user_mode();
 		return false;
 	}
 
-- 
2.29.2

