Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC93367E74A
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbjA0N6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbjA0N6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:09 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81068F744;
        Fri, 27 Jan 2023 05:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827882;
        bh=DQfwUmfs5iNfdjrcPzg0HaVMYofBtZ0lo/V3C+VzwwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2FtjY5BDlGSDq3Tp9GCd33whMgy0KMIfA0rbcQs7ZIsF5T9IftAhcL5SrNlOPv6Q
         tT6XCJh/7Dmx8xCBqEOLV5HgSqj8BOvTms9i8zhkjwlQAnpr+lBdz2BTjeM9KAQAlG
         GSjzadjtZ6jd28/CP3LIqvgR6rcoDx3ehwKmOFBk2YUqEvHfDmKnT1RgxcuZC34f5R
         q9cxhz7HaXL2Th/1LkRtksF4tZs1c0g+r7qbN0lzQljypuA95dFX/Sjc6ZEqw1nw+3
         ARmRRn5d5qqf8UJqFBIqJ+wuxXUyeV6KvfhRFlz0WTGQfcDwHfef6hsgyEB57vbX6p
         eNUfMINnAvz0w==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0V1MFXzhWX;
        Fri, 27 Jan 2023 08:58:02 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 05/34] selftests: dma: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:26 -0500
Message-Id: <20230127135755.79929-6-mathieu.desnoyers@efficios.com>
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
 tools/testing/selftests/dma/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/dma/Makefile b/tools/testing/selftests/dma/Makefile
index cd8c5ece1cba..dd7f746f3e84 100644
--- a/tools/testing/selftests/dma/Makefile
+++ b/tools/testing/selftests/dma/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 CFLAGS += -I../../../../include/
 
 TEST_GEN_PROGS := dma_map_benchmark
-- 
2.25.1

