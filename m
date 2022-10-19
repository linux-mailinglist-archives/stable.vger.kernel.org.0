Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826D06050FB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 22:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiJSUF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 16:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiJSUF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 16:05:58 -0400
Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FC818BE09;
        Wed, 19 Oct 2022 13:05:52 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Mt1v13XXkzMq4cH;
        Wed, 19 Oct 2022 22:05:49 +0200 (CEST)
Received: from localhost (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Mt1v06dk9zxH;
        Wed, 19 Oct 2022 22:05:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1666209949;
        bh=dLhBf8o1kXqp6sscAfSz5LKvdc7yEb7Q8TYdJPkHjFU=;
        h=From:To:Cc:Subject:Date:From;
        b=AoGSdmPF2lFsibBkqhvB5eYH60CouLgJ8QYefj+ta77rUi4JMemlGJVAt8EPpPaCk
         P+tS6NSCCXlNSCOxMpSJa4uhMtesUp5+kVEmXqiUFqIhu0KYl9/3fEoekhY7JwKyEr
         r1uI/wobcxe+Eb9kYM0tZ2vS3YpOOh+RzjhTgB6U=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Anders Roxell <anders.roxell@linaro.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v1] selftests/landlock: Build without static libraries
Date:   Wed, 19 Oct 2022 22:05:36 +0200
Message-Id: <20221019200536.2771316-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The only (forced) static test binary doesn't depend on libcap.  Because
using -lcap on systems that don't have such static library would fail
(e.g. on Arch Linux), let's be more specific and require only dynamic
libcap linking.

Fixes: a52540522c95 ("selftests/landlock: Fix out-of-tree builds")
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Guillaume Tucker <guillaume.tucker@collabora.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20221019200536.2771316-1-mic@digikod.net
---
 tools/testing/selftests/landlock/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index 6632bfff486b..348e2dbdb4e0 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -3,7 +3,6 @@
 # First run: make -C ../../../.. headers_install
 
 CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
-LDLIBS += -lcap
 
 LOCAL_HDRS += common.h
 
@@ -13,10 +12,12 @@ TEST_GEN_PROGS := $(src_test:.c=)
 
 TEST_GEN_PROGS_EXTENDED := true
 
-# Static linking for short targets:
+# Short targets:
+$(TEST_GEN_PROGS): LDLIBS += -lcap
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
 
 include ../lib.mk
 
-# Static linking for targets with $(OUTPUT)/ prefix:
+# Targets with $(OUTPUT)/ prefix:
+$(TEST_GEN_PROGS): LDLIBS += -lcap
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static

base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.37.2

