Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDEE34DA54
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhC2WW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbhC2WWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC2816198E;
        Mon, 29 Mar 2021 22:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056522;
        bh=I031ln3e6P3zRucWbFb24kWFba2wJs6WaG1az7OuX5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYCjqp2ObjNBUoCL+lH0VKQhFRbVTuZBxnR4KO4jxp1EFuEB+/FY7qO3T1mDJWG05
         EDYJEkrmIjWAXL8Nz3vYrt2ln0Gbge7GrscEH2WicPDabY3AtyNZxQK+FYIJkvkXGs
         saqL/AL6bKKJcvJg9Oe/RZiROJeH35T8YSdjMT9kvtXIPfX+Bxjdy7ZBtFxm00b8J+
         XJHy62PpIR8E+DPiTFvg+thLeBNDInw9nIKceg8OZj7ikmfqIK+CJftZZSSJtw2XZN
         012LYBr1pp11XiI42r4+LHVMo1aiuW2q9NvbwNPoh22/S946Bt5ROK+N/jyZKsX9e4
         cx12rkhiVL3MQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 23/38] kselftest/arm64: sve: Do not use non-canonical FFR register value
Date:   Mon, 29 Mar 2021 18:21:18 -0400
Message-Id: <20210329222133.2382393-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 7011d72588d16a9e5f5d85acbc8b10019809599c ]

The "First Fault Register" (FFR) is an SVE register that mimics a
predicate register, but clears bits when a load or store fails to handle
an element of a vector. The supposed usage scenario is to initialise
this register (using SETFFR), then *read* it later on to learn about
elements that failed to load or store. Explicit writes to this register
using the WRFFR instruction are only supposed to *restore* values
previously read from the register (for context-switching only).
As the manual describes, this register holds only certain values, it:
"... contains a monotonic predicate value, in which starting from bit 0
there are zero or more 1 bits, followed only by 0 bits in any remaining
bit positions."
Any other value is UNPREDICTABLE and is not supposed to be "restored"
into the register.

The SVE test currently tries to write a signature pattern into the
register, which is *not* a canonical FFR value. Apparently the existing
setups treat UNPREDICTABLE as "read-as-written", but a new
implementation actually only stores canonical values. As a consequence,
the sve-test fails immediately when comparing the FFR value:
-----------
 # ./sve-test
Vector length:  128 bits
PID:    207
Mismatch: PID=207, iteration=0, reg=48
        Expected [cf00]
        Got      [0f00]
Aborted
-----------

Fix this by only populating the FFR with proper canonical values.
Effectively the requirement described above limits us to 17 unique
values over 16 bits worth of FFR, so we condense our signature down to 4
bits (2 bits from the PID, 2 bits from the generation) and generate the
canonical pattern from it. Any bits describing elements above the
minimum 128 bit are set to 0.

This aligns the FFR usage to the architecture and fixes the test on
microarchitectures implementing FFR in a more restricted way.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviwed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210319120128.29452-1-andre.przywara@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/fp/sve-test.S | 22 ++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/arm64/fp/sve-test.S b/tools/testing/selftests/arm64/fp/sve-test.S
index 9210691aa998..e3e08d9c7020 100644
--- a/tools/testing/selftests/arm64/fp/sve-test.S
+++ b/tools/testing/selftests/arm64/fp/sve-test.S
@@ -284,16 +284,28 @@ endfunction
 // Set up test pattern in the FFR
 // x0: pid
 // x2: generation
+//
+// We need to generate a canonical FFR value, which consists of a number of
+// low "1" bits, followed by a number of zeros. This gives us 17 unique values
+// per 16 bits of FFR, so we create a 4 bit signature out of the PID and
+// generation, and use that as the initial number of ones in the pattern.
+// We fill the upper lanes of FFR with zeros.
 // Beware: corrupts P0.
 function setup_ffr
 	mov	x4, x30
 
-	bl	pattern
+	and	w0, w0, #0x3
+	bfi	w0, w2, #2, #2
+	mov	w1, #1
+	lsl	w1, w1, w0
+	sub	w1, w1, #1
+
 	ldr	x0, =ffrref
-	ldr	x1, =scratch
-	rdvl	x2, #1
-	lsr	x2, x2, #3
-	bl	memcpy
+	strh	w1, [x0], 2
+	rdvl	x1, #1
+	lsr	x1, x1, #3
+	sub	x1, x1, #2
+	bl	memclr
 
 	mov	x0, #0
 	ldr	x1, =ffrref
-- 
2.30.1

