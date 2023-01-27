Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB6367E764
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbjA0N6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbjA0N61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:27 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DA14C12;
        Fri, 27 Jan 2023 05:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827886;
        bh=HcMLUBBv5kU4oCgrunC1HBRLqGB7X6SZPTbL0RLGdhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPocWLFppRhrVBUSadXnjW2PbcveTEJ7ayd6zhoYYAyKgqxdHmbNIlGoyuzrYbc6h
         769NEIIXvDTIIleuCI4lBCSYvHpx4gf4mriFlQtEB25c0x6RL0gYOeUgyOnFeaOxsR
         G/MytwvSyx2y8TRsbeXW38EUz806W1n8lC0w6OhbLhoc62oeiU/tDqrNohyC0bBoGn
         aP8I+nPsisY66F0LWrx7A7jI+FDT8azjGDV4g1SfxSqBEqf0h666RybVtN+nkfvs94
         9Bi8VMZ8PLUM9qgsXpPMFo45hcbGUfZoAH+4HKIzQW4AUzIEjQN3MEG9BE/9Po6XSq
         He0jMM5YKQVaQ==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0Z64fszhTB;
        Fri, 27 Jan 2023 08:58:06 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 27/34] selftests: user_events: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:48 -0500
Message-Id: <20230127135755.79929-28-mathieu.desnoyers@efficios.com>
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
 tools/testing/selftests/user_events/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/user_events/Makefile b/tools/testing/selftests/user_events/Makefile
index c765d8635d9a..87d54c640068 100644
--- a/tools/testing/selftests/user_events/Makefile
+++ b/tools/testing/selftests/user_events/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall -I../../../../usr/include
+CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDLIBS += -lrt -lpthread -lm
 
 TEST_GEN_PROGS = ftrace_test dyn_test perf_test
-- 
2.25.1

