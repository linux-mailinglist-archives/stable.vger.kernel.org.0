Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE18F3C378B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhGJXw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232340AbhGJXwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A53F610A2;
        Sat, 10 Jul 2021 23:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960972;
        bh=NVlw8FdD1InjhL9vfc52dDxWF+C4FWMDMsiClR8WO7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZxNB26vEWWQIxOSKfzkMtdT0ITbfD2S4i0cybFtS02O1ViHWpT8Tl/5QwHfPoeqG
         igEjNbbuxv8Ooc+2C1nyo4wPl5HQ+gZv36AAXTbmbdSjWLK9D/Y6TKxAeuHtgzCDhk
         Z7db8SmcCTQe+0KJfY2TGaw6jXD/VZbR2A71bHjaLMRIydUqgrKyqKFdiJ3JznZegI
         gpDJ+U9oWZDACToiRQuK6vbxP3zEddr8kdXCDyaoqSDkY/kTcyPnsz0tw2ZImCFIz3
         3nmpPctfacFaFLCOh+C8TX7P4H6mv5Sn+boqH+yRGWXRvvyRkwgUQBWd2PVAwBwD9C
         Xyb3oWDDe1Tbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <jiancai@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.12 10/43] ARM: 9087/1: kprobes: test-thumb: fix for LLVM_IAS=1
Date:   Sat, 10 Jul 2021 19:48:42 -0400
Message-Id: <20210710234915.3220342-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 8b95a7d90ce8160ac5cffd5bace6e2eba01a871e ]

There's a few instructions that GAS infers operands but Clang doesn't;
from what I can tell the Arm ARM doesn't say these are optional.

F5.1.257 TBB, TBH T1 Halfword variant
F5.1.238 STREXD T1 variant
F5.1.84 LDREXD T1 variant

Link: https://github.com/ClangBuiltLinux/linux/issues/1309

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Jian Cai <jiancai@google.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/probes/kprobes/test-thumb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/probes/kprobes/test-thumb.c b/arch/arm/probes/kprobes/test-thumb.c
index 456c181a7bfe..4e11f0b760f8 100644
--- a/arch/arm/probes/kprobes/test-thumb.c
+++ b/arch/arm/probes/kprobes/test-thumb.c
@@ -441,21 +441,21 @@ void kprobe_thumb32_test_cases(void)
 		"3:	mvn	r0, r0	\n\t"
 		"2:	nop		\n\t")
 
-	TEST_RX("tbh	[pc, r",7, (9f-(1f+4))>>1,"]",
+	TEST_RX("tbh	[pc, r",7, (9f-(1f+4))>>1,", lsl #1]",
 		"9:			\n\t"
 		".short	(2f-1b-4)>>1	\n\t"
 		".short	(3f-1b-4)>>1	\n\t"
 		"3:	mvn	r0, r0	\n\t"
 		"2:	nop		\n\t")
 
-	TEST_RX("tbh	[pc, r",12, ((9f-(1f+4))>>1)+1,"]",
+	TEST_RX("tbh	[pc, r",12, ((9f-(1f+4))>>1)+1,", lsl #1]",
 		"9:			\n\t"
 		".short	(2f-1b-4)>>1	\n\t"
 		".short	(3f-1b-4)>>1	\n\t"
 		"3:	mvn	r0, r0	\n\t"
 		"2:	nop		\n\t")
 
-	TEST_RRX("tbh	[r",1,9f, ", r",14,1,"]",
+	TEST_RRX("tbh	[r",1,9f, ", r",14,1,", lsl #1]",
 		"9:			\n\t"
 		".short	(2f-1b-4)>>1	\n\t"
 		".short	(3f-1b-4)>>1	\n\t"
@@ -468,10 +468,10 @@ void kprobe_thumb32_test_cases(void)
 
 	TEST_UNSUPPORTED("strexb	r0, r1, [r2]")
 	TEST_UNSUPPORTED("strexh	r0, r1, [r2]")
-	TEST_UNSUPPORTED("strexd	r0, r1, [r2]")
+	TEST_UNSUPPORTED("strexd	r0, r1, r2, [r2]")
 	TEST_UNSUPPORTED("ldrexb	r0, [r1]")
 	TEST_UNSUPPORTED("ldrexh	r0, [r1]")
-	TEST_UNSUPPORTED("ldrexd	r0, [r1]")
+	TEST_UNSUPPORTED("ldrexd	r0, r1, [r1]")
 
 	TEST_GROUP("Data-processing (shifted register) and (modified immediate)")
 
-- 
2.30.2

