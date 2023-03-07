Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2767E6AEC83
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjCGR4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjCGRzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:55:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DAA9E51D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6475CB819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92235C433D2;
        Tue,  7 Mar 2023 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211418;
        bh=AWoc/4xw+6X0y4pWdVbKPs0tp5lzvCX/NGbUuvJ/rP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6kJ1If++Pc92xpVCQCyNeWl7fgKmDSWbVR3VxhRo09jZp2ca+mNp41WDwztBTABy
         w/0mzfQ1iwbyvVfeWfM83dsPLEFByNi3ZQIGFx/GvhvngtxF+Jh1mbcYhbFcuIFL2E
         YOykh0NUre2Gv3k1Lf4hZhEd7EHVKOz7FF6ODOvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.2 0854/1001] selftests/powerpc: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:00:26 +0100
Message-Id: <20230307170058.888247919@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 4f11410bf6da87defe8fd59b0413f0d9f71744da upstream.

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230127135755.79929-22-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/powerpc/ptrace/Makefile   |    2 +-
 tools/testing/selftests/powerpc/security/Makefile |    2 +-
 tools/testing/selftests/powerpc/syscalls/Makefile |    2 +-
 tools/testing/selftests/powerpc/tm/Makefile       |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/powerpc/ptrace/Makefile
+++ b/tools/testing/selftests/powerpc/ptrace/Makefile
@@ -33,7 +33,7 @@ TESTS_64 := $(patsubst %,$(OUTPUT)/%,$(T
 $(TESTS_64): CFLAGS += -m64
 $(TM_TESTS): CFLAGS += -I../tm -mhtm
 
-CFLAGS += -I../../../../../usr/include -fno-pie
+CFLAGS += $(KHDR_INCLUDES) -fno-pie
 
 $(OUTPUT)/ptrace-gpr: ptrace-gpr.S
 $(OUTPUT)/ptrace-pkey $(OUTPUT)/core-pkey: LDLIBS += -pthread
--- a/tools/testing/selftests/powerpc/security/Makefile
+++ b/tools/testing/selftests/powerpc/security/Makefile
@@ -5,7 +5,7 @@ TEST_PROGS := mitigation-patching.sh
 
 top_srcdir = ../../../../..
 
-CFLAGS += -I../../../../../usr/include
+CFLAGS += $(KHDR_INCLUDES)
 
 include ../../lib.mk
 
--- a/tools/testing/selftests/powerpc/syscalls/Makefile
+++ b/tools/testing/selftests/powerpc/syscalls/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 TEST_GEN_PROGS := ipc_unmuxed rtas_filter
 
-CFLAGS += -I../../../../../usr/include
+CFLAGS += $(KHDR_INCLUDES)
 
 top_srcdir = ../../../../..
 include ../../lib.mk
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -17,7 +17,7 @@ $(TEST_GEN_PROGS): ../harness.c ../utils
 CFLAGS += -mhtm
 
 $(OUTPUT)/tm-syscall: tm-syscall-asm.S
-$(OUTPUT)/tm-syscall: CFLAGS += -I../../../../../usr/include
+$(OUTPUT)/tm-syscall: CFLAGS += $(KHDR_INCLUDES)
 $(OUTPUT)/tm-tmspr: CFLAGS += -pthread
 $(OUTPUT)/tm-vmx-unavail: CFLAGS += -pthread -m64
 $(OUTPUT)/tm-resched-dscr: ../pmu/lib.c


