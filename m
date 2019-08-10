Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD96488E32
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfHJUnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:43:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53954 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726530AbfHJUnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-00053P-Kb; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003Z7-1I; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kohji Okuno" <okuno.kohji@jp.panasonic.com>,
        "Shawn Guo" <shawnguo@kernel.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.702416996@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 021/157] ARM: imx6q: cpuidle: fix bug that CPU might
 not wake up at expected time
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

From: Kohji Okuno <okuno.kohji@jp.panasonic.com>

commit 91740fc8242b4f260cfa4d4536d8551804777fae upstream.

In the current cpuidle implementation for i.MX6q, the CPU that sets
'WAIT_UNCLOCKED' and the CPU that returns to 'WAIT_CLOCKED' are always
the same. While the CPU that sets 'WAIT_UNCLOCKED' is in IDLE state of
"WAIT", if the other CPU wakes up and enters IDLE state of "WFI"
istead of "WAIT", this CPU can not wake up at expired time.
 Because, in the case of "WFI", the CPU must be waked up by the local
timer interrupt. But, while 'WAIT_UNCLOCKED' is set, the local timer
is stopped, when all CPUs execute "wfi" instruction. As a result, the
local timer interrupt is not fired.
 In this situation, this CPU will wake up by IRQ different from local
timer. (e.g. broacast timer)

So, this fix changes CPU to return to 'WAIT_CLOCKED'.

Signed-off-by: Kohji Okuno <okuno.kohji@jp.panasonic.com>
Fixes: e5f9dec8ff5f ("ARM: imx6q: support WAIT mode using cpuidle")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
[bwh: Backported to 3.16: use imx6q_set_lpm() instead of imx6_set_lpm()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-imx/cpuidle-imx6q.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- a/arch/arm/mach-imx/cpuidle-imx6q.c
+++ b/arch/arm/mach-imx/cpuidle-imx6q.c
@@ -14,30 +14,23 @@
 #include "common.h"
 #include "cpuidle.h"
 
-static atomic_t master = ATOMIC_INIT(0);
-static DEFINE_SPINLOCK(master_lock);
+static int num_idle_cpus = 0;
+static DEFINE_SPINLOCK(cpuidle_lock);
 
 static int imx6q_enter_wait(struct cpuidle_device *dev,
 			    struct cpuidle_driver *drv, int index)
 {
-	if (atomic_inc_return(&master) == num_online_cpus()) {
-		/*
-		 * With this lock, we prevent other cpu to exit and enter
-		 * this function again and become the master.
-		 */
-		if (!spin_trylock(&master_lock))
-			goto idle;
+	spin_lock(&cpuidle_lock);
+	if (++num_idle_cpus == num_online_cpus())
 		imx6q_set_lpm(WAIT_UNCLOCKED);
-		cpu_do_idle();
-		imx6q_set_lpm(WAIT_CLOCKED);
-		spin_unlock(&master_lock);
-		goto done;
-	}
+	spin_unlock(&cpuidle_lock);
 
-idle:
 	cpu_do_idle();
-done:
-	atomic_dec(&master);
+
+	spin_lock(&cpuidle_lock);
+	if (num_idle_cpus-- == num_online_cpus())
+		imx6q_set_lpm(WAIT_CLOCKED);
+	spin_unlock(&cpuidle_lock);
 
 	return index;
 }

