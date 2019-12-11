Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD1B11B7C1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbfLKQJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:09:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731038AbfLKPMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0906B222C4;
        Wed, 11 Dec 2019 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077122;
        bh=5C/O1Y703mdhztcjxnZWuVL7WWvHetvvVRi+sDBEqzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bleo0jiUuV0BqDC9nLBQbczrKREJJMl+OAML+hKAC6hTq1kCXFYkdY5fBXLn1105o
         XpW/d8fgMDQuVv2cZfYLXgV6LOYP2SXnA7PcQPu4cci1E2h7m6jI7Sg6q9mSvMWlCk
         YG91ZaZIWYTOJMmw6SrlkUDm7Bl0HMZM40CUsZQY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 011/134] tools/power/x86/intel-speed-select: Remove warning for unused result
Date:   Wed, 11 Dec 2019 10:09:47 -0500
Message-Id: <20191211151150.19073-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit abd120e3bdf3dd72ba1ed9ac077a861e0e3dc43a ]

Fix warning for:
isst-config.c: In function ‘set_cpu_online_offline’:
isst-config.c:221:3: warning: ignoring return value of ‘write’,
declared with attribute warn_unused_result [-Wunused-result]
   write(fd, "1\n", 2);

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index 2a9890c8395a4..21fcfe621d3aa 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -169,7 +169,7 @@ int get_topo_max_cpus(void)
 static void set_cpu_online_offline(int cpu, int state)
 {
 	char buffer[128];
-	int fd;
+	int fd, ret;
 
 	snprintf(buffer, sizeof(buffer),
 		 "/sys/devices/system/cpu/cpu%d/online", cpu);
@@ -179,9 +179,12 @@ static void set_cpu_online_offline(int cpu, int state)
 		err(-1, "%s open failed", buffer);
 
 	if (state)
-		write(fd, "1\n", 2);
+		ret = write(fd, "1\n", 2);
 	else
-		write(fd, "0\n", 2);
+		ret = write(fd, "0\n", 2);
+
+	if (ret == -1)
+		perror("Online/Offline: Operation failed\n");
 
 	close(fd);
 }
-- 
2.20.1

