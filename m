Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB71119B113
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388357AbgDAQbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388353AbgDAQbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:31:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E726D214DB;
        Wed,  1 Apr 2020 16:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758708;
        bh=rKlS2ai3j6z/Og3rPCW/YL1QOjxzpZV/wM+ukN/KTlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPNPy6smqjfXmfZQMSqqrz5gGMbX4mtAUMVGS7kcJ3XHuOR8DHTNsOyr8NdpVFiWQ
         dI+zDU3Amce4moNl0s+2keLpdl8gRkJGtgO9nNSfifYeErcETQ7T6YykL//ecTa9xQ
         DktnzGepLlTs9OXlxnJilHOnHFSuXfCvesQ/9V5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Gilbert <floppym@gentoo.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 50/91] cpupower: avoid multiple definition with gcc -fno-common
Date:   Wed,  1 Apr 2020 18:17:46 +0200
Message-Id: <20200401161531.014988368@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2116df9ad8325..c097a3748674f 100644
--- a/tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c
+++ b/tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c
@@ -83,7 +83,7 @@ static struct pci_access *pci_acc;
 static struct pci_dev *amd_fam14h_pci_dev;
 static int nbp1_entered;
 
-struct timespec start_time;
+static struct timespec start_time;
 static unsigned long long timediff;
 
 #ifdef DEBUG
diff --git a/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c b/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
index bcd22a1a39708..86e9647e4e686 100644
--- a/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
+++ b/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
@@ -21,7 +21,7 @@ struct cpuidle_monitor cpuidle_sysfs_monitor;
 
 static unsigned long long **previous_count;
 static unsigned long long **current_count;
-struct timespec start_time;
+static struct timespec start_time;
 static unsigned long long timediff;
 
 static int cpuidle_get_count_percent(unsigned int id, double *percent,
diff --git a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
index 05f953f0f0a0c..80a21cb67d94f 100644
--- a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
@@ -29,6 +29,8 @@ struct cpuidle_monitor *all_monitors[] = {
 0
 };
 
+int cpu_count;
+
 static struct cpuidle_monitor *monitors[MONITORS_MAX];
 static unsigned int avail_monitors;
 
diff --git a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h
index 9e43f3371fbc6..3558bbae2b5dc 100644
--- a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h
+++ b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h
@@ -18,7 +18,7 @@
 #define CSTATE_NAME_LEN 5
 #define CSTATE_DESC_LEN 60
 
-int cpu_count;
+extern int cpu_count;
 
 /* Hard to define the right names ...: */
 enum power_range_e {
-- 
2.20.1



