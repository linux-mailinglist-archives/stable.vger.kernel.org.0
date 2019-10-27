Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74104E6933
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbfJ0Ve7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729526AbfJ0VJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:42 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D8EB20873;
        Sun, 27 Oct 2019 21:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210581;
        bh=Kdkl6MjKw9XcZ+JW5R1/iavV97KIaMZNlGVouRBiJCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BL2Z1cYch2LkgJcuuEQxDxhPsdS4+uRY3cnqn/T3D8aYuZ06Hl8sAExZD+kQa/Mp1
         EHjU9Yk4HHXSVB89xxE40U0zC5smK7YRWhnD8ugKZFX+HBmG3ZI9VpdT02qkfakmjq
         CxnR+ZjXcedq5BfpVL2m2GjQjEjrMAX+pCEwKsHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 066/119] arm64: dont zero DIT on signal return
Date:   Sun, 27 Oct 2019 22:00:43 +0100
Message-Id: <20191027203332.526906764@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 1265132127b63502d34e0f58c8bdef3a4dc927c2 ]

Currently valid_user_regs() treats SPSR_ELx.DIT as a RES0 bit, causing
it to be zeroed upon exception return, rather than preserved. Thus, code
relying on DIT will not function as expected, and may expose an
unexpected timing sidechannel.

Let's remove DIT from the set of RES0 bits, such that it is preserved.
At the same time, the related comment is updated to better describe the
situation, and to take into account the most recent documentation of
SPSR_ELx, in ARM DDI 0487C.a.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Fixes: 7206dc93a58fb764 ("arm64: Expose Arm v8.4 features")
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1402,15 +1402,19 @@ asmlinkage void syscall_trace_exit(struc
 }
 
 /*
- * Bits which are always architecturally RES0 per ARM DDI 0487A.h
+ * SPSR_ELx bits which are always architecturally RES0 per ARM DDI 0487C.a
+ * We also take into account DIT (bit 24), which is not yet documented, and
+ * treat PAN and UAO as RES0 bits, as they are meaningless at EL0, and may be
+ * allocated an EL0 meaning in future.
  * Userspace cannot use these until they have an architectural meaning.
+ * Note that this follows the SPSR_ELx format, not the AArch32 PSR format.
  * We also reserve IL for the kernel; SS is handled dynamically.
  */
 #define SPSR_EL1_AARCH64_RES0_BITS \
-	(GENMASK_ULL(63,32) | GENMASK_ULL(27, 22) | GENMASK_ULL(20, 10) | \
-	 GENMASK_ULL(5, 5))
+	(GENMASK_ULL(63,32) | GENMASK_ULL(27, 25) | GENMASK_ULL(23, 22) | \
+	 GENMASK_ULL(20, 10) | GENMASK_ULL(5, 5))
 #define SPSR_EL1_AARCH32_RES0_BITS \
-	(GENMASK_ULL(63,32) | GENMASK_ULL(24, 22) | GENMASK_ULL(20,20))
+	(GENMASK_ULL(63,32) | GENMASK_ULL(23, 22) | GENMASK_ULL(20,20))
 
 static int valid_compat_regs(struct user_pt_regs *regs)
 {


