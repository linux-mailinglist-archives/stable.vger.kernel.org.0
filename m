Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A4B67E758
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbjA0N63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbjA0N6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:11 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6858F20D3D;
        Fri, 27 Jan 2023 05:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827884;
        bh=X6gVbqQlq737cstg892yXIS/G1E/XkRwPcbdp0ROAbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjF8+kmJVrJNh1BuPF8a7WG26h8d0kqr13MoaFIKAQxS+OKmGP2p5Q2Z18JdIYP/S
         d4wZYVM6AiQCAxCNOmh2AAnZ1WKr+Ev5VF6FYZkklNBnoTWrlW+DIDy0+P0lo2mTpL
         KuixJarRjopu+5bsZr0viXpK1cZaOsR61fziFIq2aYXq5Jwa1dDEvRUCfIQUuiFWrA
         7B3uoSO2lUc5qx1xdqbstzrBTc+/A0hrvo9YHGPyYjaOBOaIr1ED5l0p8PitV9s6ay
         YcKByRqda2r1VH9ZEletCr4YSCL9fdCv4tdfUgiK+t/8LCv72a2SaL/IndmdJmHDCw
         LHNZfQDYhgzXA==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0X2LMSzhWb;
        Fri, 27 Jan 2023 08:58:04 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 15/34] selftests: mount_setattr: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:36 -0500
Message-Id: <20230127135755.79929-16-mathieu.desnoyers@efficios.com>
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
 tools/testing/selftests/mount_setattr/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mount_setattr/Makefile b/tools/testing/selftests/mount_setattr/Makefile
index 2250f7dcb81e..fde72df01b11 100644
--- a/tools/testing/selftests/mount_setattr/Makefile
+++ b/tools/testing/selftests/mount_setattr/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for mount selftests.
-CFLAGS = -g -I../../../../usr/include/ -Wall -O2 -pthread
+CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2 -pthread
 
 TEST_GEN_FILES += mount_setattr_test
 
-- 
2.25.1

