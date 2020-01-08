Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF16E134C0C
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgAHTtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:49:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43484 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730423AbgAHTqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:02 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006oN-Cl; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dm8-OE; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Qiao Zhou" <qiaozhou@asrmicro.com>,
        "Will Deacon" <will.deacon@arm.com>
Date:   Wed, 08 Jan 2020 19:43:19 +0000
Message-ID: <lsq.1578512578.778123725@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 21/63] arm64: traps: disable irq in die()
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Qiao Zhou <qiaozhou@asrmicro.com>

commit 6f44a0bacb79a03972c83759711832b382b1b8ac upstream.

In current die(), the irq is disabled for __die() handle, not
including the possible panic() handling. Since the log in __die()
can take several hundreds ms, new irq might come and interrupt
current die().

If the process calling die() holds some critical resource, and some
other process scheduled later also needs it, then it would deadlock.
The first panic will not be executed.

So here disable irq for the whole flow of die().

Signed-off-by: Qiao Zhou <qiaozhou@asrmicro.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm64/kernel/traps.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -178,10 +178,12 @@ void die(const char *str, struct pt_regs
 {
 	struct thread_info *thread = current_thread_info();
 	int ret;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&die_lock, flags);
 
 	oops_enter();
 
-	raw_spin_lock_irq(&die_lock);
 	console_verbose();
 	bust_spinlocks(1);
 	ret = __die(str, err, thread, regs);
@@ -191,13 +193,15 @@ void die(const char *str, struct pt_regs
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	raw_spin_unlock_irq(&die_lock);
 	oops_exit();
 
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
 		panic("Fatal exception");
+
+	raw_spin_unlock_irqrestore(&die_lock, flags);
+
 	if (ret != NOTIFY_STOP)
 		do_exit(SIGSEGV);
 }

