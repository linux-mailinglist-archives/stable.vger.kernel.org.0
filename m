Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE85310BE3D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbfK0UuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:50:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbfK0UuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:50:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A265721843;
        Wed, 27 Nov 2019 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887810;
        bh=+jRBefN1uwEbzARKvRxsl294CfyeOzMo4klRHllFCY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFH2UYN7fkXj1Jo8Zy0vWgFIRnF9knI1hMsY5raImIynlnC5Hg+IduICbHJLtb2LU
         me9r3TdYrNo3F5z7rncunaqGIUAQ6YLXkoElJ/SYmuciJKzlytCYkBwMH6oBVDVhoT
         zF9p7jlpBuRFunpU7cx5Yg1mZ0h7HLGl5Xkzji2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 104/211] selftests/powerpc/signal: Fix out-of-tree build
Date:   Wed, 27 Nov 2019 21:30:37 +0100
Message-Id: <20191127203103.526628802@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a7cbd5082e271..4213978f3ee2c 100644
--- a/tools/testing/selftests/powerpc/signal/Makefile
+++ b/tools/testing/selftests/powerpc/signal/Makefile
@@ -1,14 +1,9 @@
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
 
 include ../../lib.mk
 
-clean:
-	rm -f $(TEST_PROGS) *.o
+$(TEST_GEN_PROGS): ../harness.c ../utils.c signal.S
-- 
2.20.1



