Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376C967E747
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbjA0N6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbjA0N6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:10 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBAE76B1;
        Fri, 27 Jan 2023 05:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827884;
        bh=Hovg2rLgtOn0+9QtiG9zIieTKyUfb4MTHQUMXrteeb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUs6hHu6zSApBdm2LEHPcGuHogc7yhJt0t3IHrhVa78nTEkJSTZAh3uNXr6U8BevY
         /4uN6/LAdnTsYXhnuwz7gqeD8+Sqa5KLyXohzV/Aj6zotBqRMAtE+WtTW3hmaPyyxz
         C+UOSSAhLqdHKX9OX0cKSmezJFpHv6VhGqVWdEv65+3Yq8b9Bk3Kq6+6N/lRoulSz+
         yB0mIGQ/tgRS327T/SUMVNDwCtI3kD4Y8MhDQnF/hxwREpYPfOTm9guCL8hKLNY+E5
         rgKXQf0J/h/NgMd9lW3iH1ukG5NdwIXOwvVhTkWwN7ZxsWqvFfooIjZdi2hIsOzN1s
         9tJB+V/Bd0iGA==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0W6NG1zhWZ;
        Fri, 27 Jan 2023 08:58:03 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 13/34] selftests: media_tests: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:34 -0500
Message-Id: <20230127135755.79929-14-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>    [5.18+]
---
 tools/testing/selftests/media_tests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/media_tests/Makefile b/tools/testing/selftests/media_tests/Makefile
index 60826d7d37d4..471d83e61d95 100644
--- a/tools/testing/selftests/media_tests/Makefile
+++ b/tools/testing/selftests/media_tests/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-CFLAGS += -I../ -I../../../../usr/include/
+CFLAGS += -I../ $(KHDR_INCLUDES)
 TEST_GEN_PROGS := media_device_test media_device_open video_device_test
 
 include ../lib.mk
-- 
2.25.1

