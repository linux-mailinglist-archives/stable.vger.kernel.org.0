Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E881B39888D
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 13:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhFBLuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 07:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhFBLuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 07:50:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B149B610A8;
        Wed,  2 Jun 2021 11:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622634503;
        bh=lRDvJLbCzhr8ZIh/1K6OOoSk/itsTtf5FuzdVPT/XeY=;
        h=From:To:Cc:Subject:Date:From;
        b=Y5uslJctsJVe9JF8nakoU11NPmeFlMbwtrrERbze2dYUBc7gimJ53t4QrPW2NAP+A
         DH/EA1WEDd+wr/+Xw0NfPE6sFFM/l1mJzpZ/DUB87+XZnbpysz3t1Pnrtw3dce/9Eb
         GEyZ+c+TqeTTHFvf6xD/k44nqlf+TgPmkO5d9u3pwOf8rn+aoIyvSn0XICn73r+BAO
         bYps8jGhM4NvT5X8Nh/IkD2tPen1DCbSBvD0F1U8NXJOfpcjrpK6BpMLBU9YYeParH
         jzgv8DyU7YObjGGUux1sZcsAd+ucHxKaLLUFGQz73gqyy/3Q6ZszmogOBo4N5Lkhc2
         1jm/7D79T4c/w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     stable@vger.kernel.org
Cc:     Michael Weiser <michael.weiser@gmx.de>,
        Martin Vajnar <martin.vajnar@gmail.com>,
        musl@lists.openwall.com, Will Deacon <will.deacon@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [stable v4.4] arm64: Remove unimplemented syscall log message
Date:   Wed,  2 Jun 2021 13:46:51 +0200
Message-Id: <20210602114651.423605-1-arnd@kernel.org>
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
---
 arch/arm64/kernel/traps.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 02710f99c137..a8c0fd0574fa 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -381,14 +381,6 @@ asmlinkage long do_ni_syscall(struct pt_regs *regs)
 	}
 #endif
 
-	if (show_unhandled_signals_ratelimited()) {
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

