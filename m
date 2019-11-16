Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553C3FED7A
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbfKPPoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbfKPPog (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:44:36 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D69572072D;
        Sat, 16 Nov 2019 15:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919076;
        bh=8NzhWQdmgAYi75Syl7w/F0X2VA0psKoEI0KYAzgnHuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wP1CN14DuR/OInosbLHgXDP39KEfTauAt26bPWm5p+LR3kI7VE2jbOO/fO/zun0du
         Hp56NamJRhF3sDFplqkEaBq8L1Y0hcWc77t6KrFHhR6DUts2rb7Vn9wuI6qb3YUdwJ
         ErLnNV0fGc8tzgeuM/rxqDKuRauK7c1GPvNEgcec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 144/237] selftests/powerpc/ptrace: Fix out-of-tree build
Date:   Sat, 16 Nov 2019 10:39:39 -0500
Message-Id: <20191116154113.7417-144-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit c39b79082a38a4f8c801790edecbbb4d62ed2992 ]

We should use TEST_GEN_PROGS, not TEST_PROGS. That tells the selftests
makefile (lib.mk) that those tests are generated (built), and so it
adds the $(OUTPUT) prefix for us, making the out-of-tree build work
correctly.

It also means we don't need our own clean rule, lib.mk does it.

We also have to update the ptrace-pkey and core-pkey rules to use
$(OUTPUT).

Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/ptrace/Makefile | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/powerpc/ptrace/Makefile b/tools/testing/selftests/powerpc/ptrace/Makefile
index 923d531265f8c..9f9423430059e 100644
--- a/tools/testing/selftests/powerpc/ptrace/Makefile
+++ b/tools/testing/selftests/powerpc/ptrace/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-TEST_PROGS := ptrace-gpr ptrace-tm-gpr ptrace-tm-spd-gpr \
+TEST_GEN_PROGS := ptrace-gpr ptrace-tm-gpr ptrace-tm-spd-gpr \
               ptrace-tar ptrace-tm-tar ptrace-tm-spd-tar ptrace-vsx ptrace-tm-vsx \
               ptrace-tm-spd-vsx ptrace-tm-spr ptrace-hwbreak ptrace-pkey core-pkey \
               perf-hwbreak
@@ -7,14 +7,9 @@ TEST_PROGS := ptrace-gpr ptrace-tm-gpr ptrace-tm-spd-gpr \
 top_srcdir = ../../../../..
 include ../../lib.mk
 
-all: $(TEST_PROGS)
-
 CFLAGS += -m64 -I../../../../../usr/include -I../tm -mhtm -fno-pie
 
-ptrace-pkey core-pkey: child.h
-ptrace-pkey core-pkey: LDLIBS += -pthread
-
-$(TEST_PROGS): ../harness.c ../utils.c ../lib/reg.S ptrace.h
+$(OUTPUT)/ptrace-pkey $(OUTPUT)/core-pkey: child.h
+$(OUTPUT)/ptrace-pkey $(OUTPUT)/core-pkey: LDLIBS += -pthread
 
-clean:
-	rm -f $(TEST_PROGS) *.o
+$(TEST_GEN_PROGS): ../harness.c ../utils.c ../lib/reg.S ptrace.h
-- 
2.20.1

