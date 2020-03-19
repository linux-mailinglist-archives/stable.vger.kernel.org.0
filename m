Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9550118B8E3
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 15:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgCSOLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 10:11:53 -0400
Received: from foss.arm.com ([217.140.110.172]:36724 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbgCSOLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 10:11:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0647B30E;
        Thu, 19 Mar 2020 07:11:53 -0700 (PDT)
Received: from e119884-lin.cambridge.arm.com (e119884-lin.cambridge.arm.com [10.1.196.72])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05C843F52E;
        Thu, 19 Mar 2020 07:11:51 -0700 (PDT)
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
To:     linux-arm-kernel@lists.infradead.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org
Subject: [PATCH] arm64: compat: Fix syscall number of compat_clock_getres
Date:   Thu, 19 Mar 2020 14:11:38 +0000
Message-Id: <20200319141138.19343-1-vincenzo.frascino@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The syscall number of compat_clock_getres was erroneously set to 247
instead of 264. This causes the vDSO fallback of clock_getres to land
on the wrong syscall.

Address the issue fixing the syscall number of compat_clock_getres.

Fixes: 53c489e1dfeb6 ("arm64: compat: Add missing syscall numbers")
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
---
 arch/arm64/include/asm/unistd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 1dd22da1c3a9..803039d504de 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -25,8 +25,8 @@
 #define __NR_compat_gettimeofday	78
 #define __NR_compat_sigreturn		119
 #define __NR_compat_rt_sigreturn	173
-#define __NR_compat_clock_getres	247
 #define __NR_compat_clock_gettime	263
+#define __NR_compat_clock_getres	264
 #define __NR_compat_clock_gettime64	403
 #define __NR_compat_clock_getres_time64	406
 
-- 
2.25.1

