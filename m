Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51DC71566F3
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBHSiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:38:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33700 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727684AbgBHS3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:36 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-0003dA-CX; Sat, 08 Feb 2020 18:29:34 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrF-000CLC-Qf; Sat, 08 Feb 2020 18:29:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Zhenzhong Duan" <zhenzhong.duan@oracle.com>
Date:   Sat, 08 Feb 2020 18:19:34 +0000
Message-ID: <lsq.1581185940.116498658@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 035/148] cpuidle: Do not unset the driver if it is
 there already
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit 918c1fe9fbbe46fcf56837ff21f0ef96424e8b29 upstream.

Fix __cpuidle_set_driver() to check if any of the CPUs in the mask has
a driver different from drv already and, if so, return -EBUSY before
updating any cpuidle_drivers per-CPU pointers.

Fixes: 82467a5a885d ("cpuidle: simplify multiple driver support")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
[ rjw: Subject & changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/cpuidle/driver.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -60,24 +60,23 @@ static inline void __cpuidle_unset_drive
  * __cpuidle_set_driver - set per CPU driver variables for the given driver.
  * @drv: a valid pointer to a struct cpuidle_driver
  *
- * For each CPU in the driver's cpumask, unset the registered driver per CPU
- * to @drv.
- *
- * Returns 0 on success, -EBUSY if the CPUs have driver(s) already.
+ * Returns 0 on success, -EBUSY if any CPU in the cpumask have a driver
+ * different from drv already.
  */
 static inline int __cpuidle_set_driver(struct cpuidle_driver *drv)
 {
 	int cpu;
 
 	for_each_cpu(cpu, drv->cpumask) {
+		struct cpuidle_driver *old_drv;
 
-		if (__cpuidle_get_cpu_driver(cpu)) {
-			__cpuidle_unset_driver(drv);
+		old_drv = __cpuidle_get_cpu_driver(cpu);
+		if (old_drv && old_drv != drv)
 			return -EBUSY;
-		}
+	}
 
+	for_each_cpu(cpu, drv->cpumask)
 		per_cpu(cpuidle_drivers, cpu) = drv;
-	}
 
 	return 0;
 }

