Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C169339888C
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 13:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhFBLtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 07:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhFBLtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 07:49:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C1A61263;
        Wed,  2 Jun 2021 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622634472;
        bh=q8gKn2Z957mx4u3uYf4BEGqmCtIdVS+1rgXR+HW02+c=;
        h=From:To:Cc:Subject:Date:From;
        b=jyWVxr0z3mXs5pGRAbLsxSRMBsJ9WHdnS5bXy+rf+7X/SvrELYFkRjXoGBJblpZ9o
         lCbcLbGQ30lccIFlv6GtSYacn8ChFHznCmvFYZp+gzT+60qaivaeHvfi4q8S2rUmlL
         TYSCSXnwatjerVOMOrnDaaj5h2N6tvDWXHMLD1r0cvpMjb2GbeUXpU0tmJsVhYrjQF
         mNYtflcBMNXNpm27oNMpyRihtXmJ3t+L6Cl2kkQUN80gHzfgtTgJvUn+4Rfd5i18H1
         6tPoBxTBZkNBoruFk9DNzsKGGoctDua/e2kROyOl4yqWy3PZbBrkBBsdw2Y5XArUoU
         iv7Vx5/w3Uqrw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     stable@vger.kernel.org
Cc:     Michael Weiser <michael.weiser@gmx.de>,
        Martin Vajnar <martin.vajnar@gmail.com>,
        musl@lists.openwall.com, Will Deacon <will.deacon@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [stable v4.1] arm64: Remove unimplemented syscall log message
Date:   Wed,  2 Jun 2021 13:46:17 +0200
Message-Id: <20210602114617.423521-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Weiser <michael.weiser@gmx.de>

commit 1962682d2b2fbe6cfa995a85c53c069fadda473e upstream.

Stop printing a (ratelimited) kernel message for each instance of an
unimplemented syscall being called. Userland making an unimplemented
syscall is not necessarily misbehaviour and to be expected with a
current userland running on an older kernel. Also, the current message
looks scary to users but does not actually indicate a real problem nor
help them narrow down the cause. Just rely on sys_ni_syscall() to return
-ENOSYS.

Cc: <stable@vger.kernel.org>
Cc: Martin Vajnar <martin.vajnar@gmail.com>
Cc: musl@lists.openwall.com
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Michael Weiser <michael.weiser@gmx.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This was backported to v4.14 and later, but is missing in v4.4 and
before, apparently because of a trivial merge conflict. This is
a manual backport I did after I saw a report about the issue
by Martin Vajnar on the musl mailing list.
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kernel/traps.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 9322be69ca09..db4163808c76 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -363,14 +363,6 @@ asmlinkage long do_ni_syscall(struct pt_regs *regs)
 	}
 #endif
 
-	if (show_unhandled_signals && printk_ratelimit()) {
-		pr_info("%s[%d]: syscall %d\n", current->comm,
-			task_pid_nr(current), (int)regs->syscallno);
-		dump_instr("", regs);
-		if (user_mode(regs))
-			__show_regs(regs);
-	}
-
 	return sys_ni_syscall();
 }
 
-- 
2.29.2

