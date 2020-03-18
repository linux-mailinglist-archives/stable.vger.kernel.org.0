Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647A118A688
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgCRVI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 17:08:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgCRUxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D3D0208FE;
        Wed, 18 Mar 2020 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564834;
        bh=aajlEBPgsF9TWsTs1qzScjchYnUPHpC5ectjpFA3GQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5sn7sqvsYzIG/3jGfI/8O77ri3oIF0uD4j39Js3c+nKQkLN6MqOO7BRjKcIIqGmo
         gFbLdteqLnOHdCDLTBlyBFpwZttSgiJb6/wwuIUeo+ad2YbeLPNUDT3UjyLKtcXW5S
         psT19leKhpME/33XG8FgfakN9PqI+Iz7SoBXSuwg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Gilbert <floppym@gentoo.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/73] cpupower: avoid multiple definition with gcc -fno-common
Date:   Wed, 18 Mar 2020 16:52:38 -0400
Message-Id: <20200318205337.16279-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Gilbert <floppym@gentoo.org>

[ Upstream commit 2de7fb60a4740135e03cf55c1982e393ccb87b6b ]

Building cpupower with -fno-common in CFLAGS results in errors due to
multiple definitions of the 'cpu_count' and 'start_time' variables.

./utils/idle_monitor/snb_idle.o:./utils/idle_monitor/cpupower-monitor.h:28:
multiple definition of `cpu_count';
./utils/idle_monitor/nhm_idle.o:./utils/idle_monitor/cpupower-monitor.h:28:
first defined here
...
./utils/idle_monitor/cpuidle_sysfs.o:./utils/idle_monitor/cpuidle_sysfs.c:22:
multiple definition of `start_time';
./utils/idle_monitor/amd_fam14h_idle.o:./utils/idle_monitor/amd_fam14h_idle.c:85:
first defined here

The -fno-common option will be enabled by default in GCC 10.

Bug: https://bugs.gentoo.org/707462
Signed-off-by: Mike Gilbert <floppym@gentoo.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c  | 2 +-
 tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c    | 2 +-
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c | 2 ++
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h | 2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c b/tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c
index 3f893b99b337c..555cb338a71a4 100644
--- a/tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c
+++ b/tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c
@@ -82,7 +82,7 @@ static struct pci_access *pci_acc;
 static struct pci_dev *amd_fam14h_pci_dev;
 static int nbp1_entered;
 
-struct timespec start_time;
+static struct timespec start_time;
 static unsigned long long timediff;
 
 #ifdef DEBUG
diff --git a/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c b/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
index f634aeb65c5f6..7fb4f7a291ad5 100644
--- a/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
+++ b/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
@@ -19,7 +19,7 @@ struct cpuidle_monitor cpuidle_sysfs_monitor;
 
 static unsigned long long **previous_count;
 static unsigned long long **current_count;
-struct timespec start_time;
+static struct timespec start_time;
 static unsigned long long timediff;
 
 static int cpuidle_get_count_percent(unsigned int id, double *percent,
diff --git a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
index d3c3e6e7aa26c..3d54fd4336261 100644
--- a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
@@ -27,6 +27,8 @@ struct cpuidle_monitor *all_monitors[] = {
 0
 };
 
+int cpu_count;
+
 static struct cpuidle_monitor *monitors[MONITORS_MAX];
 static unsigned int avail_monitors;
 
diff --git a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h
index a2d901d3bfaf9..eafef38f1982e 100644
--- a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h
+++ b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h
@@ -25,7 +25,7 @@
 #endif
 #define CSTATE_DESC_LEN 60
 
-int cpu_count;
+extern int cpu_count;
 
 /* Hard to define the right names ...: */
 enum power_range_e {
-- 
2.20.1

