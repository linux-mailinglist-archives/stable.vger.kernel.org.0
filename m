Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C369610BD2F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfK0VZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbfK0VBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:01:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61532215A5;
        Wed, 27 Nov 2019 21:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888504;
        bh=8NzhWQdmgAYi75Syl7w/F0X2VA0psKoEI0KYAzgnHuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQ8rZ9Z4zFWHNHbmyEe8S4g8m+1Jwfhrl4GDhMgqhpNVjJ6Xw0R41dxSp25Gobpqz
         CMIIEq6lhoEgLyjmLLl39PBf+w5zH1TaKYoSptWfI8fs299ZKls5oOT8tXBdjXEOre
         zJSjAHKeogJlUDWcDA69dcA4xVweLIYJqHcC58b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 161/306] selftests/powerpc/ptrace: Fix out-of-tree build
Date:   Wed, 27 Nov 2019 21:30:11 +0100
Message-Id: <20191127203127.258270925@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



