Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E7D1C8FEB
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgEGOgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbgEGO2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE88924959;
        Thu,  7 May 2020 14:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861703;
        bh=vvdSzbEpBcmS5iWnBqJ8Fdmt3xvKYr6xWdUdjkVYuFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTaPbQ2esZeZ03s0hxjNpTWqFu3VjjOck5+xb8HmulnMSOG4voI3Vn3x6rStl2Laf
         TMviOW3k3OD3itDIUgjH9/o+Q+cIm7J18jvjX9LpvwWs8Fp/HPZ6+V0T6NE0uT2eMg
         HOSv1ak5JdQhF5bE0/qVfspJkC54nmMH8cy53PAY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 44/50] arm64: vdso: Add -fasynchronous-unwind-tables to cflags
Date:   Thu,  7 May 2020 10:27:20 -0400
Message-Id: <20200507142726.25751-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit 1578e5d03112e3e9d37e1c4d95b6dfb734c73955 ]

On arm64 linux gcc uses -fasynchronous-unwind-tables -funwind-tables
by default since gcc-8, so now the de facto platform ABI is to allow
unwinding from async signal handlers.

However on bare metal targets (aarch64-none-elf), and on old gcc,
async and sync unwind tables are not enabled by default to avoid
runtime memory costs.

This means if linux is built with a baremetal toolchain the vdso.so
may not have unwind tables which breaks the gcc platform ABI guarantee
in userspace.

Add -fasynchronous-unwind-tables explicitly to the vgettimeofday.o
cflags to address the ABI change.

Fixes: 28b1a824a4f4 ("arm64: vdso: Substitute gettimeofday() with C implementation")
Cc: Will Deacon <will@kernel.org>
Reported-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index dd2514bb1511f..3862cad2410cf 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -32,7 +32,7 @@ UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 KCOV_INSTRUMENT			:= n
 
-CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny
+CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny -fasynchronous-unwind-tables
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -include $(c-gettimeofday-y)
-- 
2.20.1

