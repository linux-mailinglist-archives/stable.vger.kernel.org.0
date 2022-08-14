Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB490592505
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242726AbiHNQif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242918AbiHNQgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:36:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51FC1BEA9;
        Sun, 14 Aug 2022 09:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 635E760FC3;
        Sun, 14 Aug 2022 16:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D237C433D7;
        Sun, 14 Aug 2022 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494537;
        bh=oxPVV2m77GTW/SkQcS6bwbMb6sbrxTJSZLBOV8s6PN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+tGTAUO30TwvWrJKOFRiwoQPXkg1njSJCU9mZK2BAXTwuhFLwAIUsaYnPlitltPr
         VFdQk5VadGvKf/ALS50go5Yq/Qheki/qSJ6CzluAtmJPM30XWBBA8e0CB4CDvTWxPw
         1coJ2B1MLdpNLV+GG4InQkcoPYBsMmYvdwy7Pp9gGASlrZ1vMMKsRY7RZDWyqk3l7C
         wGNa69BgDgxJF82akYVVpoelCiyPgAdYmSiJGXeFa6i80zxKKcAjJq/nKebu8kiIpY
         0GdH6usD/KcoY0jcy5p+u2FITKIQH0+AKTMyAvcI8B5FfTw85Kuie/LBZh0G5QcKxp
         6YLWFGvQ6imWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Dufour <ldufour@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, pmladek@suse.com,
        akpm@linux-foundation.org, juri.lelli@redhat.com,
        peterz@infradead.org, mcgrof@kernel.org, nixiaoming@huawei.com,
        frederic@kernel.org, john.ogness@linutronix.de,
        linux@rasmusvillemoes.dk
Subject: [PATCH AUTOSEL 5.4 08/16] watchdog: export lockup_detector_reconfigure
Date:   Sun, 14 Aug 2022 12:28:23 -0400
Message-Id: <20220814162833.2398478-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162833.2398478-1-sashal@kernel.org>
References: <20220814162833.2398478-1-sashal@kernel.org>
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
index 9003e29cde46..e972d1ae1ee6 100644
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
index cbd3cf503c90..a3d0e928305c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -568,7 +568,7 @@ int lockup_detector_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
-static void lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(void)
 {
 	cpus_read_lock();
 	watchdog_nmi_stop();
@@ -588,6 +588,13 @@ static void lockup_detector_reconfigure(void)
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
  * Create the watchdog thread infrastructure and configure the detector(s).
  *
@@ -608,13 +615,13 @@ static __init void lockup_detector_setup(void)
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
@@ -622,9 +629,13 @@ static void lockup_detector_reconfigure(void)
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
 
@@ -664,7 +675,7 @@ static void proc_watchdog_update(void)
 {
 	/* Remove impossible cpus to keep sysctl output clean. */
 	cpumask_and(&watchdog_cpumask, &watchdog_cpumask, cpu_possible_mask);
-	lockup_detector_reconfigure();
+	__lockup_detector_reconfigure();
 }
 
 /*
-- 
2.35.1

