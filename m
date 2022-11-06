Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF54C61E3CB
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiKFRFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiKFREf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:04:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F445FCFC;
        Sun,  6 Nov 2022 09:04:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4844B80C69;
        Sun,  6 Nov 2022 17:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182A5C433C1;
        Sun,  6 Nov 2022 17:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754262;
        bh=GdteqiEM8KhePySDa5CMNW0mw5EsYx6q1uaviAFStn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANwWSzuIQlVm4URp98abOuVuotVyJrzp1x/6iKVYtgfawfPxf67mBcxYIXnTtZa++
         GcpET7MRR6YRyIpWsruhmkOYaKZ+q7QFWkPMre6ULq1tyeJQUMlB9wvPE6t4e8Cpei
         2Xqgh4pg1Y+8FN8rCcsCSysZ3cEOVbqBlwD2yotA2QsX6y7tMQi76jPN1q7kxyn/qt
         YTPyNkCGXQ1MkSazhvGsyzY0+ywji7T1EmzrEmzKOvYKByInxTE/rWP6y4h4y6HNPN
         E/fYyassSkXrLLgaa+edj6kbF8tIDg8AXXzruq7s9Ypvp3wx7IQw2EjGSwpVDD1Sge
         1KlK5MovJChqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, shuah@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, usama.anjum@collabora.com,
        guillaume.tucker@collabora.com, linux-kselftest@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 16/30] selftests/futex: fix build for clang
Date:   Sun,  6 Nov 2022 12:03:28 -0500
Message-Id: <20221106170345.1579893-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Cañuelo <ricardo.canuelo@collabora.com>

[ Upstream commit 03cab65a07e083b6c1010fbc8f9b817e9aca75d9 ]

Don't use the test-specific header files as source files to force a
target dependency, as clang will complain if more than one source file
is used for a compile command with a single '-o' flag.

Use the proper Makefile variables instead as defined in
tools/testing/selftests/lib.mk.

Signed-off-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/futex/functional/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 732149011692..5a0e0df8de9b 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -3,11 +3,11 @@ INCLUDES := -I../include -I../../ -I../../../../../usr/include/
 CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt
 
-HEADERS := \
+LOCAL_HDRS := \
 	../include/futextest.h \
 	../include/atomic.h \
 	../include/logging.h
-TEST_GEN_FILES := \
+TEST_GEN_PROGS := \
 	futex_wait_timeout \
 	futex_wait_wouldblock \
 	futex_requeue_pi \
@@ -24,5 +24,3 @@ TEST_PROGS := run.sh
 top_srcdir = ../../../../..
 DEFAULT_INSTALL_HDR_PATH := 1
 include ../../lib.mk
-
-$(TEST_GEN_FILES): $(HEADERS)
-- 
2.35.1

