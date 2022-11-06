Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6495661E488
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiKFRMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiKFRLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:11:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2371140AF;
        Sun,  6 Nov 2022 09:07:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF05560C55;
        Sun,  6 Nov 2022 17:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CBDC433D6;
        Sun,  6 Nov 2022 17:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754448;
        bh=Tq6UTvV/U2fHils2tZDK+ExsX83NX/T6fR7K3h6E4wM=;
        h=From:To:Cc:Subject:Date:From;
        b=TS4cPYEPMMqb0hI4kNiZNsQ/wDHMrRX/rMkJBUzF30usFzJRzucUMiIgekMIDa4J1
         PQSO6EXETdTtzSZcRQP0nfyAeEkZc812iWC6rzmnZSz8qtRPvRVB4kAk56dNYuslsE
         RJJiYcSIDT5Gne3XS2z5Wy7/+/2rsK2S+qQ/H4Ss5tk/zYfgMLd6Tnlf6Vk9H8x+7+
         LkybTKAh6F7dyh13dBVyr1RpQfIeKiY5p6hDJm3S/LazsuEI5DJIG9lMJAEKANdUQf
         nXVBJvJsWEQCkKG75z2FFEF77/oZDu6ZeBnI+6jUAG88fJ1Q+yTxduMXiKYUmToRBT
         e31OWwlQmSszA==
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
Subject: [PATCH AUTOSEL 4.14 1/2] selftests/futex: fix build for clang
Date:   Sun,  6 Nov 2022 12:07:22 -0500
Message-Id: <20221106170724.1581086-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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
index ff8feca49746..ad175add3f1d 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -3,11 +3,11 @@ INCLUDES := -I../include -I../../
 CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
 LDFLAGS := $(LDFLAGS) -pthread -lrt
 
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
@@ -19,5 +19,3 @@ TEST_GEN_FILES := \
 TEST_PROGS := run.sh
 
 include ../../lib.mk
-
-$(TEST_GEN_FILES): $(HEADERS)
-- 
2.35.1

