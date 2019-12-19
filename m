Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DD5126A69
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbfLSSrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729406AbfLSSrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:47:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF161222C2;
        Thu, 19 Dec 2019 18:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781221;
        bh=thMYs7Pso3z3nCP5kKe2+F7DwqxhPwkfJ29Py85+nNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+2rFN3j0fppUI7HKime6c7p6JXR5w+upInWM38A//xWK2mSYbdMVoNf+Bxw76odA
         7ejoKwHbkHCAbFi9BGdKOOfuesiAcTReP8XO2iT7J34uF6GqDfDWCrJD61dEePF0Vy
         CzQ6ixA/DJn8kWxFP2nEGCwrgu70JT1AWUe51vtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 133/199] cpuidle: Do not unset the driver if it is there already
Date:   Thu, 19 Dec 2019 19:33:35 +0100
Message-Id: <20191219183222.434745018@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit 918c1fe9fbbe46fcf56837ff21f0ef96424e8b29 upstream.

Fix __cpuidle_set_driver() to check if any of the CPUs in the mask has
a driver different from drv already and, if so, return -EBUSY before
updating any cpuidle_drivers per-CPU pointers.

Fixes: 82467a5a885d ("cpuidle: simplify multiple driver support")
Cc: 3.11+ <stable@vger.kernel.org> # 3.11+
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
[ rjw: Subject & changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpuidle/driver.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -61,24 +61,23 @@ static inline void __cpuidle_unset_drive
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


