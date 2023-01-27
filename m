Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF52B67E768
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbjA0N6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbjA0N6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:12 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5204222D6;
        Fri, 27 Jan 2023 05:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827885;
        bh=Xbp5KzcrorO+aTVy5ft5VjJu1byFBs5Sa3jbbZp1vXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVHmXurzNmglu93HtwBBBAsCOSaianGAd+AzEWyrbKeRnf6jH0Kt3vFsk6Y9Zg5Bv
         cw81yKik2bvZHb3qBwcTtv/s0nZPmn1GUJIWynbu86vmNxq54pJV4ECjVEGo1AomAG
         bMZExrBryqrRRk96dF7VpC3Xvo8ctbak8bVDpqZeEDhbUQ6ovNuQTzoiBZJJJpoGYa
         kF7AB7PzQB7AShOQpOqVm6EoAUjyQeDdwzxxeqBXLPLCJMq3xLIImb8tTi2vU7OktB
         PHGrZQH/BMWKbDYhsksIIkkTV5PyzpzCCs+IGk2Gr6wBTcB+LZjBlmF1j2szkVTSoX
         vCbZI+fIJj//g==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0Y1McdzhWd;
        Fri, 27 Jan 2023 08:58:05 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 19/34] selftests: pid_namespace: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:40 -0500
Message-Id: <20230127135755.79929-20-mathieu.desnoyers@efficios.com>
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
 tools/testing/selftests/pid_namespace/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/pid_namespace/Makefile b/tools/testing/selftests/pid_namespace/Makefile
index edafaca1aeb3..9286a1d22cd3 100644
--- a/tools/testing/selftests/pid_namespace/Makefile
+++ b/tools/testing/selftests/pid_namespace/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -g -I../../../../usr/include/
+CFLAGS += -g $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS = regression_enomem
 
-- 
2.25.1

