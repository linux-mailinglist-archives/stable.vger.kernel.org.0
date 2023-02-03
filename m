Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9CD68969A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbjBCKZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbjBCKZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146EC29155
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:24:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B2B0B82A6F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1F5C4339B;
        Fri,  3 Feb 2023 10:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419864;
        bh=QVWL9Ryh5/fAmRZzxLER3tGYMSZKgPr7dmH+SGZuT/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=druKFEM50F9US6up1HpBTFmGT9Ag2BPa+uMZ7MDlL9FWlzafv/WRonJV0khp/mVKc
         1HmO8l2nN8tUDjmRHNMCaaAHNINPWf6LIqr1rTxubq3P6N0gei65uEnNS4L/cCoN8N
         WFblvk4QCHqWLVY4CM5n3y7tVNanUH4faYlwMdA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.15 16/20] tools: fix ARRAY_SIZE defines in tools and selftests hdrs
Date:   Fri,  3 Feb 2023 11:13:43 +0100
Message-Id: <20230203101008.677359238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 066b34aa5461f6072dbbecb690f4fe446b736ebf upstream.

tools/include/linux/kernel.h and kselftest_harness.h are missing
ifndef guard around ARRAY_SIZE define. Fix them to avoid duplicate
define errors during compile when another file defines it. This
problem was found when compiling selftests that include a header
with ARRAY_SIZE define.

ARRAY_SIZE is defined in several selftests. There are about 25+
duplicate defines in various selftests source and header files.
Add ARRAY_SIZE to kselftest.h in preparation for removing duplicate
ARRAY_SIZE defines from individual test files.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Kyle Huey <me@kylehuey.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/kernel.h                |    2 ++
 tools/testing/selftests/kselftest.h         |    4 ++++
 tools/testing/selftests/kselftest_harness.h |    2 ++
 3 files changed, 8 insertions(+)

--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -108,7 +108,9 @@ int vscnprintf(char *buf, size_t size, c
 int scnprintf(char * buf, size_t size, const char * fmt, ...);
 int scnprintf_pad(char * buf, size_t size, const char * fmt, ...);
 
+#ifndef ARRAY_SIZE
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#endif
 
 /*
  * This looks more complex than it should be. But we need to
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -48,6 +48,10 @@
 #include <stdarg.h>
 #include <stdio.h>
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#endif
+
 /* define kselftest exit codes */
 #define KSFT_PASS  0
 #define KSFT_FAIL  1
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -671,7 +671,9 @@
 #define EXPECT_STRNE(expected, seen) \
 	__EXPECT_STR(expected, seen, !=, 0)
 
+#ifndef ARRAY_SIZE
 #define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))
+#endif
 
 /* Support an optional handler after and ASSERT_* or EXPECT_*.  The approach is
  * not thread-safe, but it should be fine in most sane test scenarios.


