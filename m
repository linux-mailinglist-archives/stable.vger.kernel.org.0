Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF6B67E748
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbjA0N6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjA0N6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:07 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA155B8D;
        Fri, 27 Jan 2023 05:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827882;
        bh=K+vhjlywHJgIcCErv80HSw4PprVSDZXcXHTvoqMwzts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FS/1CtiD9ZoThxVxcGeu74sgRZzAhb0dHuqe5ynvzTx9QGIiP2xCrnzOYI8em+8Vy
         tWptOoiXdiJzgcRbwrF+OGDiTczOJWYvRIXssRfQyho98bpSlJRyr1cK6s5fNn4p/T
         Xni7F0OmeixP0R1KOSLNKoAK/TAfE7OP84sM9ZGfdLK5PljJMWFm9e8+nd0Vp2MjLC
         fM/Np9UP25KAICDrKt5HFL7IS+t3WFhzNCWpEGHmgPK5lll+Ls4QLah+/M1qqSOd2b
         s0BXyCXv6QIOuPPJDMJHDKOPLJP1lJl+TeG6a0dApov0jzD8SyowRJphQTE+m0MFwp
         ynQOglEmPKl2w==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0T6xF3zhWW;
        Fri, 27 Jan 2023 08:58:01 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 04/34] selftests: core: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:25 -0500
Message-Id: <20230127135755.79929-5-mathieu.desnoyers@efficios.com>
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
 tools/testing/selftests/core/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/core/Makefile b/tools/testing/selftests/core/Makefile
index f6f2d6f473c6..ce262d097269 100644
--- a/tools/testing/selftests/core/Makefile
+++ b/tools/testing/selftests/core/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -g -I../../../../usr/include/
+CFLAGS += -g $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := close_range_test
 
-- 
2.25.1

