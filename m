Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6643BB056
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhGDXIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230312AbhGDXIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D56E36193E;
        Sun,  4 Jul 2021 23:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439926;
        bh=YeSgRczbmbSxo4Z5IzaKSbrJnSZG/xkyc9myQMoVzPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTBd2Kb8Jgnep9VP2kNCLtAfK2wJQauTMX3l2pDD7C06HKyCM7qrpqh6GsGcvI6tz
         s1Ai27YY2ZYEbTMVAans/Uq/we/yVhkU3xdm8lYLJfRNmDxxSWZAIfKD9F72dGIFf9
         RKpDN7fr7AvvjbbFWCuan3QHWLBVRYKK62msGfgkHXkihcUMidRv1fubUCU1lcukTx
         6KQ7nVXAnt4AkVfm1OKl5b7KQ5ESe63qQKqdDyldnOifd1ylbZKrUrA/7UMBxfSWXb
         qxWWV3kp99ZAg8/bxdQZt9kiHaA7mhIKZO7otrLEaoYnOFh5YmiQv5tCJgroVXKg5p
         34Oy1K9rcJ5rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 48/85] arm64: entry: don't instrument entry code with KCOV
Date:   Sun,  4 Jul 2021 19:03:43 -0400
Message-Id: <20210704230420.1488358-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit bf6fa2c0dda751863c3446aa64d733013bec4a19 ]

The code in entry-common.c runs at exception entry and return
boundaries, where portions of the kernel environment aren't available.
For example, RCU may not be watching, and lockdep state may be
out-of-sync with the hardware. Due to this, it is not sound to
instrument this code.

We generally avoid instrumentation by marking the entry functions as
`noinstr`, but currently this doesn't inhibit KCOV instrumentation.
Prevent this by disabling KCOV for the entire compilation unit.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210607094624.34689-20-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 6cc97730790e..787c3c83edd7 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -14,6 +14,11 @@ CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_syscall.o	 = -fstack-protector -fstack-protector-strong
 CFLAGS_syscall.o	+= -fno-stack-protector
 
+# It's not safe to invoke KCOV when portions of the kernel environment aren't
+# available or are out-of-sync with HW state. Since `noinstr` doesn't always
+# inhibit KCOV instrumentation, disable it for the entire compilation unit.
+KCOV_INSTRUMENT_entry.o := n
+
 # Object file lists.
 obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   entry-common.o entry-fpsimd.o process.o ptrace.o	\
-- 
2.30.2

