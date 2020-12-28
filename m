Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5122E6657
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388248AbgL1NW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388235AbgL1NWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9A59207C9;
        Mon, 28 Dec 2020 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161702;
        bh=SEF2i0iPA5d6UNnZnlZX4c/P+nQpD0ufL6j88hVYMu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHH7UBbO6UxsBMgFS25CkxjVytHhg1oHhoBBQd9DNLsNX+R9oGpW2aETIZkQMcU7S
         +9hdUigT9cqdf09GPTWue7uHLVT+r17k6tdtAdvfGw6fLQZceC0Uh1meQIYrYi1yKY
         JpLshJHwobUC2GFZIlnzZB5DISYVGaA69tFLcAZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Amit Kachhap <Amit.Kachhap@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 051/346] arm64: lse: Fix LSE atomics with LLVM
Date:   Mon, 28 Dec 2020 13:46:10 +0100
Message-Id: <20201228124922.260235014@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

commit dd1f6308b28edf0452dd5dc7877992903ec61e69 upstream.

Commit e0d5896bd356 ("arm64: lse: fix LSE atomics with LLVM's integrated
assembler") broke the build when clang is used in connjunction with the
binutils assembler ("-no-integrated-as"). This happens because
__LSE_PREAMBLE is defined as ".arch armv8-a+lse", which overrides the
version of the CPU architecture passed via the "-march" paramter to gas:

$ aarch64-none-linux-gnu-as -EL -I ./arch/arm64/include
                                -I ./arch/arm64/include/generated
                                -I ./include -I ./include
                                -I ./arch/arm64/include/uapi
                                -I ./arch/arm64/include/generated/uapi
                                -I ./include/uapi -I ./include/generated/uapi
                                -I ./init -I ./init
                                -march=armv8.3-a -o init/do_mounts.o
                                /tmp/do_mounts-d7992a.s
/tmp/do_mounts-d7992a.s: Assembler messages:
/tmp/do_mounts-d7992a.s:1959: Error: selected processor does not support `autiasp'
/tmp/do_mounts-d7992a.s:2021: Error: selected processor does not support `paciasp'
/tmp/do_mounts-d7992a.s:2157: Error: selected processor does not support `autiasp'
/tmp/do_mounts-d7992a.s:2175: Error: selected processor does not support `paciasp'
/tmp/do_mounts-d7992a.s:2494: Error: selected processor does not support `autiasp'

Fix the issue by replacing ".arch armv8-a+lse" with ".arch_extension lse".
Sami confirms that the clang integrated assembler does now support the
'.arch_extension' directive, so this change will be fine even for LTO
builds in future.

Fixes: e0d5896bd356cd ("arm64: lse: fix LSE atomics with LLVM's integrated assembler")
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Reported-by: Amit Kachhap <Amit.Kachhap@arm.com>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/lse.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/lse.h
+++ b/arch/arm64/include/asm/lse.h
@@ -4,7 +4,7 @@
 
 #if defined(CONFIG_AS_LSE) && defined(CONFIG_ARM64_LSE_ATOMICS)
 
-#define __LSE_PREAMBLE	".arch armv8-a+lse\n"
+#define __LSE_PREAMBLE	".arch_extension lse\n"
 
 #include <linux/compiler_types.h>
 #include <linux/export.h>


