Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5BA67E745
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbjA0N6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbjA0N6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:10 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A313C2B;
        Fri, 27 Jan 2023 05:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827883;
        bh=7etrW8iE023GQxiA3Q3KlSxXSNyXYwYwDLENTzRvr34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSk4/jSkUPe0tq1mFNG1JdvtfPkyBFssFtI+OjcZs0M0yPOeor8aInfgmMElEW7NK
         D9Zi6yfX1MykyPhi3dxnOM038eaKPCL5qgr4KxKEs8lwVqvdw3YaSjnDg8ZhjNTd5P
         Wgq3UPtJFTyJVMDrwS3yCRkBerX1SXMJCt9GmnB0yibcL4bRzC/h8fhz+wdYRpfU65
         VOyq2qwhIUn2QuePv3F6n4ocFvHtiPsSImBEKsRr5LGZ6DM9oBs0PjKQ5D2fEHF3QV
         IqtiKFM6/UdDvjkD4kLxfJpRK0WLpTiCOpGDY2R7/COv/cFt3KAoI6XUEUjxqmjBjd
         +ZJL3QKTPSRKA==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0W3LfTzhxR;
        Fri, 27 Jan 2023 08:58:03 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 11/34] selftests: ipc: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:32 -0500
Message-Id: <20230127135755.79929-12-mathieu.desnoyers@efficios.com>
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
 tools/testing/selftests/ipc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 1c4448a843a4..50e9c299fc4a 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -10,7 +10,7 @@ ifeq ($(ARCH),x86_64)
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := msgque
 
-- 
2.25.1

