Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B37C88D92
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfHJUrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:47:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55094 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726859AbfHJUoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDZ-00053m-TS; Sat, 10 Aug 2019 21:44:02 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDL-0003eJ-SS; Sat, 10 Aug 2019 21:43:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Lendacky" <thomas.lendacky@amd.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Mikhail Gavrilov" <mikhail.v.gavrilov@gmail.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.972476944@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 084/157] x86/speculation: Prevent deadlock on
 ssb_state::lock
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 2f5fb19341883bb6e37da351bc3700489d8506a7 upstream.

Mikhail reported a lockdep splat related to the AMD specific ssb_state
lock:

  CPU0                       CPU1
  lock(&st->lock);
                             local_irq_disable();
                             lock(&(&sighand->siglock)->rlock);
                             lock(&st->lock);
  <Interrupt>
     lock(&(&sighand->siglock)->rlock);

  *** DEADLOCK ***

The connection between sighand->siglock and st->lock comes through seccomp,
which takes st->lock while holding sighand->siglock.

Make sure interrupts are disabled when __speculation_ctrl_update() is
invoked via prctl() -> speculation_ctrl_update(). Add a lockdep assert to
catch future offenders.

Fixes: 1f50ddb4f418 ("x86/speculation: Handle HT correctly on AMD")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1904141948200.4917@nanos.tec.linutronix.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/process.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -351,6 +351,8 @@ static __always_inline void __speculatio
 	u64 msr = x86_spec_ctrl_base;
 	bool updmsr = false;
 
+	lockdep_assert_irqs_disabled();
+
 	/*
 	 * If TIF_SSBD is different, select the proper mitigation
 	 * method. Note that if SSBD mitigation is disabled or permanentely
@@ -402,10 +404,12 @@ static unsigned long speculation_ctrl_up
 
 void speculation_ctrl_update(unsigned long tif)
 {
+	unsigned long flags;
+
 	/* Forced update. Make sure all relevant TIF flags are different */
-	preempt_disable();
+	local_irq_save(flags);
 	__speculation_ctrl_update(~tif, tif);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 /* Called from seccomp/prctl update */

