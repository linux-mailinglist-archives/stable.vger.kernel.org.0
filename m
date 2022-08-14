Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8015923C6
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239867AbiHNQYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242361AbiHNQXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:23:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2F421C;
        Sun, 14 Aug 2022 09:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06EF960F40;
        Sun, 14 Aug 2022 16:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EA1C433D6;
        Sun, 14 Aug 2022 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494123;
        bh=mVBmaehpQ/O+zrjmiuuFeI+9dN+eLesTdAlf4Fd5+Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoF+yi5obspE8OHhC70vaUvUZR0AcZk71lSEMfdfbCP9G9n3EOBY+bQzskadIkv+0
         ECIrho+SFZJ5HC15fs+wYOUhKGsXQt7otfYDcd0QDs/7KXC5TnFdBukJkgdB+hFx9S
         KUXIa0Z+AcTPo7fYhwRW6ZAmcAZOallRmBo/Y2guHb0bnYKthIF2KwAyGVE5nPLWC5
         XIyx4A58vADAjN7TvmfrwPjcWMDCQVOjw2oG9xL2i2Ar3fO+j/NXN6aWQHlCkNJkFv
         s0cHPKAjZL1LWvkw7JjpUuOWjtrdeuV0PwsrakT6jW199GLunyOanmCGCRThKMd+54
         bibiT7NVrVZzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Dufour <ldufour@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, pmladek@suse.com,
        akpm@linux-foundation.org, juri.lelli@redhat.com,
        john.ogness@linutronix.de, frederic@kernel.org,
        nixiaoming@huawei.com, linux@rasmusvillemoes.dk
Subject: [PATCH AUTOSEL 5.19 28/48] watchdog: export lockup_detector_reconfigure
Date:   Sun, 14 Aug 2022 12:19:21 -0400
Message-Id: <20220814161943.2394452-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit 7c56a8733d0a2a4be2438a7512566e5ce552fccf ]

In some circumstances it may be interesting to reconfigure the watchdog
from inside the kernel.

On PowerPC, this may helpful before and after a LPAR migration (LPM) is
initiated, because it implies some latencies, watchdog, and especially NMI
watchdog is expected to be triggered during this operation. Reconfiguring
the watchdog with a factor, would prevent it to happen too frequently
during LPM.

Rename lockup_detector_reconfigure() as __lockup_detector_reconfigure() and
create a new function lockup_detector_reconfigure() calling
__lockup_detector_reconfigure() under the protection of watchdog_mutex.

Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
[mpe: Squash in build fix from Laurent, reported by Sachin]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220713154729.80789-3-ldufour@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nmi.h |  2 ++
 kernel/watchdog.c   | 21 ++++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 750c7f395ca9..f700ff2df074 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -122,6 +122,8 @@ int watchdog_nmi_probe(void);
 int watchdog_nmi_enable(unsigned int cpu);
 void watchdog_nmi_disable(unsigned int cpu);
 
+void lockup_detector_reconfigure(void);
+
 /**
  * touch_nmi_watchdog - restart NMI watchdog timeout.
  *
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index ecb0e8346e65..8e61f21e7e33 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -537,7 +537,7 @@ int lockup_detector_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
-static void lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(void)
 {
 	cpus_read_lock();
 	watchdog_nmi_stop();
@@ -557,6 +557,13 @@ static void lockup_detector_reconfigure(void)
 	__lockup_detector_cleanup();
 }
 
+void lockup_detector_reconfigure(void)
+{
+	mutex_lock(&watchdog_mutex);
+	__lockup_detector_reconfigure();
+	mutex_unlock(&watchdog_mutex);
+}
+
 /*
  * Create the watchdog infrastructure and configure the detector(s).
  */
@@ -573,13 +580,13 @@ static __init void lockup_detector_setup(void)
 		return;
 
 	mutex_lock(&watchdog_mutex);
-	lockup_detector_reconfigure();
+	__lockup_detector_reconfigure();
 	softlockup_initialized = true;
 	mutex_unlock(&watchdog_mutex);
 }
 
 #else /* CONFIG_SOFTLOCKUP_DETECTOR */
-static void lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(void)
 {
 	cpus_read_lock();
 	watchdog_nmi_stop();
@@ -587,9 +594,13 @@ static void lockup_detector_reconfigure(void)
 	watchdog_nmi_start();
 	cpus_read_unlock();
 }
+void lockup_detector_reconfigure(void)
+{
+	__lockup_detector_reconfigure();
+}
 static inline void lockup_detector_setup(void)
 {
-	lockup_detector_reconfigure();
+	__lockup_detector_reconfigure();
 }
 #endif /* !CONFIG_SOFTLOCKUP_DETECTOR */
 
@@ -629,7 +640,7 @@ static void proc_watchdog_update(void)
 {
 	/* Remove impossible cpus to keep sysctl output clean. */
 	cpumask_and(&watchdog_cpumask, &watchdog_cpumask, cpu_possible_mask);
-	lockup_detector_reconfigure();
+	__lockup_detector_reconfigure();
 }
 
 /*
-- 
2.35.1

