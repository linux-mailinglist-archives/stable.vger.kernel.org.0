Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41CBFF2A8
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbfKPQUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:20:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728957AbfKPPoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:44:38 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7FA520729;
        Sat, 16 Nov 2019 15:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919078;
        bh=nJ49gYhEL/vKBChnulon0sgeTedMmKmQ57sKJFu4eRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rE991r6ZteMSV1ziuzuek/rKGlmCvpbAOGMJVOfdoAOJpU2FzMhQurjUKCBB0YCaD
         cc+CfconVlqqYlw+7T9ynFl3vjy3vFVkhWLLYUt+HOutZ7x2N0ekmPPb6Cwgn1fC6N
         7j6KwxH8cdG5knaBjrMqEzFQbr2SEv7uRLS4bwy0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 145/237] selftests/powerpc/signal: Fix out-of-tree build
Date:   Sat, 16 Nov 2019 10:39:40 -0500
Message-Id: <20191116154113.7417-145-sashal@kernel.org>
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

[ Upstream commit 27825349d7b238533a47e3d98b8bb0efd886b752 ]

We should use TEST_GEN_PROGS, not TEST_PROGS. That tells the selftests
makefile (lib.mk) that those tests are generated (built), and so it
adds the $(OUTPUT) prefix for us, making the out-of-tree build work
correctly.

It also means we don't need our own clean rule, lib.mk does it.

We also have to update the signal_tm rule to use $(OUTPUT).

Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/signal/Makefile | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/powerpc/signal/Makefile b/tools/testing/selftests/powerpc/signal/Makefile
index 1fca25c6ace06..209a958dca127 100644
--- a/tools/testing/selftests/powerpc/signal/Makefile
+++ b/tools/testing/selftests/powerpc/signal/Makefile
@@ -1,15 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
-TEST_PROGS := signal signal_tm
-
-all: $(TEST_PROGS)
-
-$(TEST_PROGS): ../harness.c ../utils.c signal.S
+TEST_GEN_PROGS := signal signal_tm
 
 CFLAGS += -maltivec
-signal_tm: CFLAGS += -mhtm
+$(OUTPUT)/signal_tm: CFLAGS += -mhtm
 
 top_srcdir = ../../../../..
 include ../../lib.mk
 
-clean:
-	rm -f $(TEST_PROGS) *.o
+$(TEST_GEN_PROGS): ../harness.c ../utils.c signal.S
-- 
2.20.1

