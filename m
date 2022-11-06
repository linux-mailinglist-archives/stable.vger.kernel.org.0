Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D4C61E42A
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKFRIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiKFRHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:07:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C293CF033;
        Sun,  6 Nov 2022 09:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AB0360D2C;
        Sun,  6 Nov 2022 17:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A586C433C1;
        Sun,  6 Nov 2022 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754342;
        bh=hcWqM5dE67uuplVflQAGo4eIRyUeZr2rhyv1ReIeg28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrIgxV+vhKScTMsk8WsOz1N/avaOEpw5zrKQ8l56PpGrpYtrIB5TCHublgGdXH+Tx
         5LYmZWLJbwRLZ79OYQctqm1zlBO7FrusOD8PecEBkRmw3UW5WMWjvjiP11zJe7bHxw
         FgyreaRoAdMVXKkmzrHs3Doo8QrhN0nSvoRTi7EXcMIQSkJmsS09HXzf3iCH9Dz7Oo
         N0Ir5/A3YfzFMXQtGIQVvv0LBEqnfczB+CBBD4UU5t5t2ragMIEG09/tWvuXJUiVVO
         HRmpUJVXCZPu33ApYnzzK2zscPn93BLgP0p588XIulbiNH8i+2xMgF5zOm29Qlaiya
         8GwDzZBKozEiQ==
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
Subject: [PATCH AUTOSEL 5.15 13/18] selftests/futex: fix build for clang
Date:   Sun,  6 Nov 2022 12:05:02 -0500
Message-Id: <20221106170509.1580304-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170509.1580304-1-sashal@kernel.org>
References: <20221106170509.1580304-1-sashal@kernel.org>
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
index bd1fec59e010..ece2e38fbb0b 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -4,11 +4,11 @@ INCLUDES := -I../include -I../../ -I../../../../../usr/include/ \
 CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
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
 KSFT_KHDR_INSTALL := 1
 include ../../lib.mk
-
-$(TEST_GEN_FILES): $(HEADERS)
-- 
2.35.1

