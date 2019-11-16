Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72396FF2C2
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfKPPnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbfKPPnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:39 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1955820833;
        Sat, 16 Nov 2019 15:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919018;
        bh=T1fjXJ8Jm32Cke60Jcid/VJwyP6KUMtt2vqjFjO8xeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCyt8RD6YK86xeR85nOUBAEhInc8zUHli0GBR3x25KDXgQ94HLvBlLgsouSGvPl5X
         2dgqtEAXtLftPhucdsNpybc+s579zJP+Kb5i3PAE+sH4ZFPC17N14sU3kEzZz26oeN
         Ql3Du7q4/QPEuJK6XqaLftqF58n/QBISrv0gQRnQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        Shuah Khan <shuah@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 119/237] selftests: kvm: Fix -Wformat warnings
Date:   Sat, 16 Nov 2019 10:39:14 -0500
Message-Id: <20191116154113.7417-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri <andrea.parri@amarulasolutions.com>

[ Upstream commit fb363e2d20351e1d16629df19e7bce1a31b3227a ]

Fixes the following warnings:

dirty_log_test.c: In function ‘help’:
dirty_log_test.c:216:9: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 2 has type ‘int’ [-Wformat=]
  printf(" -i: specify iteration counts (default: %"PRIu64")\n",
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/test_util.h:18:0,
                 from dirty_log_test.c:16:
/usr/include/inttypes.h:105:34: note: format string is defined here
 # define PRIu64  __PRI64_PREFIX "u"
dirty_log_test.c:218:9: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 2 has type ‘int’ [-Wformat=]
  printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/test_util.h:18:0,
                 from dirty_log_test.c:16:
/usr/include/inttypes.h:105:34: note: format string is defined here
 # define PRIu64  __PRI64_PREFIX "u"

Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
Signed-off-by: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 0c2cdc105f968..a9c4b5e21d7e7 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -31,9 +31,9 @@
 /* How many pages to dirty for each guest loop */
 #define  TEST_PAGES_PER_LOOP            1024
 /* How many host loops to run (one KVM_GET_DIRTY_LOG for each loop) */
-#define  TEST_HOST_LOOP_N               32
+#define  TEST_HOST_LOOP_N               32UL
 /* Interval for each host loop (ms) */
-#define  TEST_HOST_LOOP_INTERVAL        10
+#define  TEST_HOST_LOOP_INTERVAL        10UL
 
 /*
  * Guest variables.  We use these variables to share data between host
-- 
2.20.1

