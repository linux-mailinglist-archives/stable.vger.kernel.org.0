Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00028F6611
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbfKJDLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbfKJCnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7574721D7B;
        Sun, 10 Nov 2019 02:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353826;
        bh=k8d5s75KhVKjgm3jmwxPY/yUWZ6JYWL1KLUdROsgTKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBFCzOlU5Oy0BIs3wHD26wK8HQoHyyOvvo6qzJd31uUimX4dhLXGsjwPBccIoxxwH
         zrLcLBvXw8jFPXY/ap21671StgOzbpC8yJkKy1gpB0IPvjhEiXucHemAhU2/VtnlTd
         LPUkcbdLyG08zhB5L3I6jkPbxB+q8euW7Sgr7Xco=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laura Abbott <labbott@redhat.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 121/191] misc: kgdbts: Fix restrict error
Date:   Sat,  9 Nov 2019 21:39:03 -0500
Message-Id: <20191110024013.29782-121-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@redhat.com>

[ Upstream commit fa0218ef733e6f247a1a3986e3eb12460064ac77 ]

kgdbts current fails when compiled with restrict:

drivers/misc/kgdbts.c: In function ‘configure_kgdbts’:
drivers/misc/kgdbts.c:1070:2: error: ‘strcpy’ source argument is the same as destination [-Werror=restrict]
  strcpy(config, opt);
  ^~~~~~~~~~~~~~~~~~~

As the error says, config is being used in both the source and destination.
Refactor the code to avoid the extra copy and put the parsing closer to
the actual location.

Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/kgdbts.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index eb4d90b7d99e1..8b01257783dd8 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -985,6 +985,12 @@ static void kgdbts_run_tests(void)
 	int nmi_sleep = 0;
 	int i;
 
+	verbose = 0;
+	if (strstr(config, "V1"))
+		verbose = 1;
+	if (strstr(config, "V2"))
+		verbose = 2;
+
 	ptr = strchr(config, 'F');
 	if (ptr)
 		fork_test = simple_strtol(ptr + 1, NULL, 10);
@@ -1068,13 +1074,6 @@ static int kgdbts_option_setup(char *opt)
 		return -ENOSPC;
 	}
 	strcpy(config, opt);
-
-	verbose = 0;
-	if (strstr(config, "V1"))
-		verbose = 1;
-	if (strstr(config, "V2"))
-		verbose = 2;
-
 	return 0;
 }
 
@@ -1086,9 +1085,6 @@ static int configure_kgdbts(void)
 
 	if (!strlen(config) || isspace(config[0]))
 		goto noconfig;
-	err = kgdbts_option_setup(config);
-	if (err)
-		goto noconfig;
 
 	final_ack = 0;
 	run_plant_and_detach_test(1);
-- 
2.20.1

