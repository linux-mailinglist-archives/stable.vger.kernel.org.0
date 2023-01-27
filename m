Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA2367E755
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbjA0N61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbjA0N6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:10 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5C2C64E;
        Fri, 27 Jan 2023 05:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827882;
        bh=9bTL5ZQeBBSKQ5ZimARCBa1khFOkkbpLsDUnEgWCuIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcnGZEJoJAKMoQ6YGcaurO9muRAm8BgZzowAuvJgT3OMtpzqufgatyjPu5UBE2RW7
         qV+wYJLZvU3X1szhg3knmG5zbLyPfpNA/mmmF9h0PzzSRzPYeH2gB0+vQ0fImzP7GS
         ljm5JvxzEMRMC6Od0Rq4r2ytF+8ZoBo/waFfQheKFuBDl6o5CA7M5UjK4/53LuqAm+
         ZLiPZATM5ysEd/Tfg50M8rZqtVG7o1jpGPTud2AY0x1ck91GnGl1v1FfaKoe0WoJeE
         C6gArTqQhEGPpesqy0gVYjvLUswdn66ludIz6gO55D3SJgTmWPf3PUyTrOCFoBGbiG
         0Bk/Mh9V+81JA==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0V4PnLzhxN;
        Fri, 27 Jan 2023 08:58:02 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 07/34] selftests: drivers: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:28 -0500
Message-Id: <20230127135755.79929-8-mathieu.desnoyers@efficios.com>
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
 tools/testing/selftests/drivers/dma-buf/Makefile        | 2 +-
 tools/testing/selftests/drivers/s390x/uvdevice/Makefile | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/dma-buf/Makefile b/tools/testing/selftests/drivers/dma-buf/Makefile
index 79cb16b4e01a..441407bb0e80 100644
--- a/tools/testing/selftests/drivers/dma-buf/Makefile
+++ b/tools/testing/selftests/drivers/dma-buf/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -I../../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := udmabuf
 
diff --git a/tools/testing/selftests/drivers/s390x/uvdevice/Makefile b/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
index 891215a7dc8a..755d164384c4 100644
--- a/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
+++ b/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
@@ -11,10 +11,9 @@ else
 TEST_GEN_PROGS := test_uvdevice
 
 top_srcdir ?= ../../../../../..
-khdr_dir = $(top_srcdir)/usr/include
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 
-CFLAGS += -Wall -Werror -static -I$(khdr_dir) -I$(LINUX_TOOL_ARCH_INCLUDE)
+CFLAGS += -Wall -Werror -static $(KHDR_INCLUDES) -I$(LINUX_TOOL_ARCH_INCLUDE)
 
 include ../../../lib.mk
 
-- 
2.25.1

