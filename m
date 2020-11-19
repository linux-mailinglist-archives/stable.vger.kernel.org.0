Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F0E2B9E65
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgKSXf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgKSXf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:35:26 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19846C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:25 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t37so5589624pga.7
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+KPuYc/v3ERrytjKiInJ626zQ8PwviyucHMc2bbxUI=;
        b=DeHPRmWD0nbDCdhq4p6l1080MCIDfbPrzDCi7No4CSROvzzUJbfA3Co++pV2SDr7Jh
         GF72wUWENTQd/zTX93IRnukccakfyjwGKXQl4xBmR3Yt7S74NwP3sUfe8fh7d7QaW0qH
         FYMnjwegq05i8ZlBF6ykqjae2UGiP2KLGRklE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+KPuYc/v3ERrytjKiInJ626zQ8PwviyucHMc2bbxUI=;
        b=CFUY7BfM+oM/9KDdazpQFnV7E+E4eETa9Cx0skvvqUG7MjxJCbVW9mZwa8oHfyn1iF
         2xzQcm472BCVD6YeoImRpfqmXNu91wUGZamJW7JxjdWIQNrXPVncvm/Lf8LgxG/Pyya6
         H4pU4LCIpRozNxUX8nISoR/j8w5jnCjZdnC7uCZbT6YI0W659bEpvkq/vBLrlLpvFB3L
         8gAWkMMlo9PHFH5AIMfu7fAGRtXlAAjvhPsQxlPYTcQXyAsC7XrsbVGntT4l9NTq5vCK
         VhSbmg2M/mhhv9ecMc6Z5Iv0qodhVeKxJzP1wH7L3KKhiW46W9kYWntKKPH1weEypEqm
         zPmw==
X-Gm-Message-State: AOAM5302qaJzQbUWHveI8qNaXs7PbUZFGwGK2SgnJxwdCneKr4a/XBJ0
        H9/WCnOtM04BISxAVl/Y2JY9rmMlsqXNOA==
X-Google-Smtp-Source: ABdhPJynN2jCjn0586s8JLP74n5r2Gd2JM7nc+DQIVkdVXZE8lRr77j8xM3XrcdJLk91sK7rWfEQAg==
X-Received: by 2002:a17:90a:62c8:: with SMTP id k8mr6887390pjs.33.1605828924427;
        Thu, 19 Nov 2020 15:35:24 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id u14sm1131426pfc.87.2020.11.19.15.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:35:23 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.4 1/5] selftests/powerpc: rfi_flush: disable entry flush if present
Date:   Fri, 20 Nov 2020 10:35:12 +1100
Message-Id: <20201119233516.368194-2-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119233516.368194-1-dja@axtens.net>
References: <20201119233516.368194-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell Currey <ruscur@russell.cc>

commit fcb48454c23c5679d1a2e252f127642e91b05cbe upstream.

We are about to add an entry flush. The rfi (exit) flush test measures
the number of L1D flushes over a syscall with the RFI flush enabled and
disabled. But if the entry flush is also enabled, the effect of enabling
and disabling the RFI flush is masked.

If there is a debugfs entry for the entry flush, disable it during the RFI
flush and restore it later.

Reported-by: Spoorthy S <spoorts2@in.ibm.com>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 .../selftests/powerpc/security/rfi_flush.c    | 35 +++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/powerpc/security/rfi_flush.c b/tools/testing/selftests/powerpc/security/rfi_flush.c
index 0a7d0afb26b8..533315e68133 100644
--- a/tools/testing/selftests/powerpc/security/rfi_flush.c
+++ b/tools/testing/selftests/powerpc/security/rfi_flush.c
@@ -50,16 +50,30 @@ int rfi_flush_test(void)
 	__u64 l1d_misses_total = 0;
 	unsigned long iterations = 100000, zero_size = 24 * 1024;
 	unsigned long l1d_misses_expected;
-	int rfi_flush_org, rfi_flush;
+	int rfi_flush_orig, rfi_flush;
+	int have_entry_flush, entry_flush_orig;
 
 	SKIP_IF(geteuid() != 0);
 
-	if (read_debugfs_file("powerpc/rfi_flush", &rfi_flush_org)) {
+	if (read_debugfs_file("powerpc/rfi_flush", &rfi_flush_orig) < 0) {
 		perror("Unable to read powerpc/rfi_flush debugfs file");
 		SKIP_IF(1);
 	}
 
-	rfi_flush = rfi_flush_org;
+	if (read_debugfs_file("powerpc/entry_flush", &entry_flush_orig) < 0) {
+		have_entry_flush = 0;
+	} else {
+		have_entry_flush = 1;
+
+		if (entry_flush_orig != 0) {
+			if (write_debugfs_file("powerpc/entry_flush", 0) < 0) {
+				perror("error writing to powerpc/entry_flush debugfs file");
+				return 1;
+			}
+		}
+	}
+
+	rfi_flush = rfi_flush_orig;
 
 	fd = perf_event_open_counter(PERF_TYPE_RAW, /* L1d miss */ 0x400f0, -1);
 	FAIL_IF(fd < 0);
@@ -68,6 +82,7 @@ int rfi_flush_test(void)
 
 	FAIL_IF(perf_event_enable(fd));
 
+	// disable L1 prefetching
 	set_dscr(1);
 
 	iter = repetitions;
@@ -109,8 +124,8 @@ int rfi_flush_test(void)
 		       repetitions * l1d_misses_expected / 2,
 		       passes, repetitions);
 
-	if (rfi_flush == rfi_flush_org) {
-		rfi_flush = !rfi_flush_org;
+	if (rfi_flush == rfi_flush_orig) {
+		rfi_flush = !rfi_flush_orig;
 		if (write_debugfs_file("powerpc/rfi_flush", rfi_flush) < 0) {
 			perror("error writing to powerpc/rfi_flush debugfs file");
 			return 1;
@@ -126,11 +141,19 @@ int rfi_flush_test(void)
 
 	set_dscr(0);
 
-	if (write_debugfs_file("powerpc/rfi_flush", rfi_flush_org) < 0) {
+	if (write_debugfs_file("powerpc/rfi_flush", rfi_flush_orig) < 0) {
 		perror("unable to restore original value of powerpc/rfi_flush debugfs file");
 		return 1;
 	}
 
+	if (have_entry_flush) {
+		if (write_debugfs_file("powerpc/entry_flush", entry_flush_orig) < 0) {
+			perror("unable to restore original value of powerpc/entry_flush "
+			       "debugfs file");
+			return 1;
+		}
+	}
+
 	return rc;
 }
 
-- 
2.25.1

