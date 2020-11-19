Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B190E2B9E16
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgKSXW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgKSXW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:22:59 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E0DC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:22:58 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id v5so1976067pff.10
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9VGRteVLeEm3H5CSBy5azxCAdQM5D8pVFtpbJvUoRsQ=;
        b=Nhm6+n9EaKUEDmL+41tDoBji+MU/OtUo2DWtp+kjypDXbstT+3oe3NYEITkJ/uPPxl
         G/XShAocY1vMHDYEnX4IX+EBmLqx1N5MfkT1zYeeyn94u3rObUeb6cDQZXkpSYwqsPon
         +Fwh0ZwKihG7HwIdP1gIoEm9N7EKGPKdKaSbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9VGRteVLeEm3H5CSBy5azxCAdQM5D8pVFtpbJvUoRsQ=;
        b=DYehGK/0514MpD9c9S94S063Mr96yMgvdoBSXivl+8Tf4sF0AAdc1DKDv12MYafsPD
         AZnhw2IUHVtjJpc0pF1ezbvclYEr1+PQ0dfvGhtculePaXSs2KLM7UOjSNd0xZ3BFmyM
         K1ivA6xBchPcF07FYk9IGsRyllpEToi/amhT7AvU6VZODnh2An7Vdq2Tzt3FxwaPe0ob
         SoeLV4nDo/aig4Eg/f/sBCvjf9I6g6GyyaNtfa5F/P7l2W8AGaxIZ6M9wBeDLfxjSa+V
         kSkUPTBIzM1/d0nx8A2GFg+KzZXRzng6K6mxnDo6yRBT7sdPqfs9TblfqFihTufBld/m
         3n+g==
X-Gm-Message-State: AOAM532TdyEbXxL2rR7lApZZUDF8oYbruwdY6MBKwbyia0kIbGSvoNR3
        vfcSPjogfYdtE8sWRoqQLjpr/vsc1aN/LA==
X-Google-Smtp-Source: ABdhPJz3BfHje3QNuyhVRI7SH9chtSfOLzdAkkAbDti/VOf6vWWUnBE/2axInrgQW9wyVb0lTQGlLQ==
X-Received: by 2002:a17:90a:1b84:: with SMTP id w4mr6709026pjc.15.1605828178303;
        Thu, 19 Nov 2020 15:22:58 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id o1sm777242pgk.60.2020.11.19.15.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:22:57 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.9 1/5] selftests/powerpc: rfi_flush: disable entry flush if present
Date:   Fri, 20 Nov 2020 10:22:46 +1100
Message-Id: <20201119232250.365304-2-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119232250.365304-1-dja@axtens.net>
References: <20201119232250.365304-1-dja@axtens.net>
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
@@ -109,8 +124,8 @@ again:
 		       repetitions * l1d_misses_expected / 2,
 		       passes, repetitions);
 
-	if (rfi_flush == rfi_flush_org) {
-		rfi_flush = !rfi_flush_org;
+	if (rfi_flush == rfi_flush_orig) {
+		rfi_flush = !rfi_flush_orig;
 		if (write_debugfs_file("powerpc/rfi_flush", rfi_flush) < 0) {
 			perror("error writing to powerpc/rfi_flush debugfs file");
 			return 1;
@@ -126,11 +141,19 @@ again:
 
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

