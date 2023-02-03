Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B536D68960A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjBCK0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbjBCKZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D009D585
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:24:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC75561EC9
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBF1C433EF;
        Fri,  3 Feb 2023 10:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419870;
        bh=dPN+EQaYp+aYd2XWlihDeKFNLSXLqGOubMUwWGUkCTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhrPHLZeRUWtGIjT998bppJA5W0bk+e1+gbuspx6zPu98ofAEr1CvwSuOukI6JDJ+
         wynW9lR2eaVitdC3ULJtiLBWJYhzxEiqDUiIN8D2Jp3JKuscBdwg2MYOoeP2mB1A6G
         RIT9nlmI9FlJy63ual0ZMBkHFoSznEm7Kpf2dIVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.15 18/20] selftests: Provide local define of __cpuid_count()
Date:   Fri,  3 Feb 2023 11:13:45 +0100
Message-Id: <20230203101008.753709022@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

commit a23039c7306f53416ba35d230201398ea34f4640 upstream.

Some selftests depend on information provided by the CPUID instruction.
To support this dependency the selftests implement private wrappers for
CPUID.

Duplication of the CPUID wrappers should be avoided.

Both gcc and clang/LLVM provide __cpuid_count() macros but neither
the macro nor its header file are available in all the compiler
versions that need to be supported by the selftests. __cpuid_count()
as provided by gcc is available starting with gcc v4.4, so it is
not available if the latest tests need to be run in all the
environments required to support kernels v4.9 and v4.14 that
have the minimal required gcc v3.2.

Duplicate gcc's __cpuid_count() macro to provide a centrally defined
macro for __cpuid_count() to help eliminate the duplicate CPUID wrappers
while continuing to compile in older environments.

Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Kyle Huey <me@kylehuey.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kselftest.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -52,6 +52,21 @@
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 #endif
 
+/*
+ * gcc cpuid.h provides __cpuid_count() since v4.4.
+ * Clang/LLVM cpuid.h provides  __cpuid_count() since v3.4.0.
+ *
+ * Provide local define for tests needing __cpuid_count() because
+ * selftests need to work in older environments that do not yet
+ * have __cpuid_count().
+ */
+#ifndef __cpuid_count
+#define __cpuid_count(level, count, a, b, c, d)				\
+	__asm__ __volatile__ ("cpuid\n\t"				\
+			      : "=a" (a), "=b" (b), "=c" (c), "=d" (d)	\
+			      : "0" (level), "2" (count))
+#endif
+
 /* define kselftest exit codes */
 #define KSFT_PASS  0
 #define KSFT_FAIL  1


