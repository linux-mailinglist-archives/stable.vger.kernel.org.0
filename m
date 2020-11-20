Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC862BA865
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgKTLH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:07:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727757AbgKTLH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB5522264;
        Fri, 20 Nov 2020 11:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870446;
        bh=miRzaqvneAnB3APqiUeOQwDQeHSheeVnH82k7rytGxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uxBzRmUUtieZpwl5OCpK1PxPF5+CJsUv5mec6x44VeCdn9D1xzywzKe1TulA/IuG
         smGjOnyQjz/LlvyXHHiNGSHozNc2l10xuxR41Mg8ZIafCYz4hzpWZjn7vmTAF9ualB
         E0eVw5gLiW1L9yKWosxcUFF6zyLSTBh980yaB0+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        Spoorthy S <spoorts2@in.ibm.com>,
        Russell Currey <ruscur@russell.cc>
Subject: [PATCH 5.9 01/14] selftests/powerpc: rfi_flush: disable entry flush if present
Date:   Fri, 20 Nov 2020 12:03:39 +0100
Message-Id: <20201120104541.238114576@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/powerpc/security/rfi_flush.c |   35 +++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

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
 


