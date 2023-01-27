Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAF467E775
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbjA0N6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbjA0N61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:27 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D432330D;
        Fri, 27 Jan 2023 05:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827887;
        bh=j0/J2jgcMN5hRuwHVS3PfRhowqmRAWi4T67r4xbEwTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5Zga5tdO5JSw6QnfEUZ26+JP3uOhBoA3BuGJ3CVbx9vWS26fhhaC+yo8NxIn+I3J
         WeeVZPQvl5aYTI7jz0B2VUikDtBkdR/IhBhPbR9uKbfcCL0PNTIIVtdMekDcFWV5NI
         m05d40See0UrY0VcbHo0B3+ItVQJ1VRc1Hr6yGeqhPI6f4KnEmyejIwFf+IfpL8Gml
         H3DuYDsxZ3Y0gy1WmwChq9tXUyJBfAmibJLoIVY8munkTuoVV+IpnMJmegaOw+Bm9V
         kAhPIqQ4j1w1bASt8es6XM7omVPSljOnDM2OT6p+uHeNA0FqeoVPZdHJ6Bng0W+qc5
         zbn41+l3sc5zA==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0b1wn8zhcy;
        Fri, 27 Jan 2023 08:58:07 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 29/34] selftests: x86: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:50 -0500
Message-Id: <20230127135755.79929-30-mathieu.desnoyers@efficios.com>
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
 tools/testing/selftests/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index 0388c4d60af0..ca9374b56ead 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -34,7 +34,7 @@ BINARIES_64 := $(TARGETS_C_64BIT_ALL:%=%_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
 BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
 
-CFLAGS := -O2 -g -std=gnu99 -pthread -Wall
+CFLAGS := -O2 -g -std=gnu99 -pthread -Wall $(KHDR_INCLUDES)
 
 # call32_from_64 in thunks.S uses absolute addresses.
 ifeq ($(CAN_BUILD_WITH_NOPIE),1)
-- 
2.25.1

