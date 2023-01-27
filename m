Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5167E770
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbjA0N6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbjA0N61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:27 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6011CDE7;
        Fri, 27 Jan 2023 05:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827886;
        bh=G+eF3FqXFX/xd2Tp8up6FJ8ZvO4HTETfOik4EAwTn4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyoTFkvbD5J97DBzlWDHV5OUvfm/2PieEl5l0yUvk2X3hYYbS6H06c2FPDvK58U9u
         L3mztiHjst/3fx1yJsY7cvvGIIrURB/ygxWC0kt5Spx4a08uQsGEj/ayMHSDTRC12c
         8N6fbPSK/RAacHHz+CEcSjMmVGvLdtnmgMvZ7Gr4A+YMSd4kywfPVBytdwDLBexw7n
         jeOe6HS84KogvuZwE8e3P4Sdr3wRiepMvwwZQ524Dd9at02202n9aDSV4KkcrgRl/D
         +Ygj0D1OFyWUCahXWVhrvTjXgLbJKxkkT0Udk3SR4N3vRrXD6mXkbMysT0YyhfvvRK
         6L8ms5SmbNA5w==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0Z363bzhT9;
        Fri, 27 Jan 2023 08:58:06 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 25/34] selftests: seccomp: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:46 -0500
Message-Id: <20230127135755.79929-26-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 tools/testing/selftests/seccomp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
index f017c382c036..584fba487037 100644
--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall -isystem ../../../../usr/include/
+CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDFLAGS += -lpthread
 LDLIBS += -lcap
 
-- 
2.25.1

