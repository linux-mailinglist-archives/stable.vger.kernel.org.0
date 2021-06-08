Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C14139FF3F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbhFHSbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234106AbhFHSbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:31:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1203613BD;
        Tue,  8 Jun 2021 18:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623176962;
        bh=GjZLYadtShdseGMv6xryN9ZrYJlOObDaAjWxe9xYudU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhlzSwzQR/0U6vakIR4nSlvZTKniZ1uVdsU5Zq/ZeXiuo26mtnUK6DcnFHf3W47mr
         usmMMkQeIiJr5JJfv44GsVLhAj0Z3rrgT0HXE7iYppyVBZttvu/REVFzpeZhJQaZ2c
         0uM81NRtm5/zCH5JB8mgmmbKbTefBPiAu00atPg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Michael Weiser <michael.weiser@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.4 22/23] arm64: Remove unimplemented syscall log message
Date:   Tue,  8 Jun 2021 20:27:14 +0200
Message-Id: <20210608175927.252349365@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175926.524658689@linuxfoundation.org>
References: <20210608175926.524658689@linuxfoundation.org>
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
@@ -381,14 +381,6 @@ asmlinkage long do_ni_syscall(struct pt_
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
 


