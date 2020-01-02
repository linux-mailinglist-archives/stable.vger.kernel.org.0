Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6B12EBB1
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgABWLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgABWLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:11:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9713222C3;
        Thu,  2 Jan 2020 22:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003083;
        bh=IeJ6x5BZrVJtQg3SHJegVlPO8lhZFQ7CoeSf1gsbnCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+uRkcIhMISvDtTC1G6yornfUk0GZXwGApY2erP1jZONiUVyHgrc9euJ5BHYOYXIU
         riO14Jfprrs0qETjfKa0oKpoSBwQyZq9kaVjuZqKL8ne0smnV7Y4saGy7mffVaHsFa
         oCBiJbbA52olcQbdZTMcM24D/WwVqjT8q15n8ox4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/191] tools/power/x86/intel-speed-select: Remove warning for unused result
Date:   Thu,  2 Jan 2020 23:04:55 +0100
Message-Id: <20200102215831.136234211@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2a9890c8395a..21fcfe621d3a 100644
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



