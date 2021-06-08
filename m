Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D8639FF72
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhFHSdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhFHScV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DF86613CC;
        Tue,  8 Jun 2021 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177015;
        bh=MmRXoHVfQm9eZj+KJphfdg8lo9nB1RfG2eYSEECiXdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ex5A948qXJSTqTFNaXkmRlofkSTQw7ak6GzUF6FhFv3u0pMu3GIJfBQNfzZZxzSYI
         vberP4B2HW21eSfLv28Kl71DL8b7UWUm40H1dkp+U5qBlznZ5gDbXJvkbF0FmllIj8
         SNbYSoVbwSwRuWoaoUtI2qHOh9cLFMW6Ci9OW17w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Michael Weiser <michael.weiser@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.9 28/29] arm64: Remove unimplemented syscall log message
Date:   Tue,  8 Jun 2021 20:27:22 +0200
Message-Id: <20210608175928.730163589@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Michael Weiser <michael.weiser@gmx.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/traps.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -543,14 +543,6 @@ asmlinkage long do_ni_syscall(struct pt_
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
 


