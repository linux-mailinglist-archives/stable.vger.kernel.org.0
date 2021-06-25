Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5183B41EF
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhFYKwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:52:02 -0400
Received: from aposti.net ([89.234.176.197]:36628 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhFYKwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 06:52:01 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     list@opendingux.net, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: MT extensions are not available on MIPS32r1
Date:   Fri, 25 Jun 2021 11:49:29 +0100
Message-Id: <20210625104929.42689-1-paul@crapouillou.net>
In-Reply-To: <202106192349.LlB9JRTC-lkp@intel.com>
References: <202106192349.LlB9JRTC-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

MIPS MT extensions were added with the MIPS 34K processor, which was
based on the MIPS32r2 ISA.

This fixes a build error when building a generic kernel for a MIPS32r1
CPU.

Fixes: c434b9f80b09 ("MIPS: Kconfig: add MIPS_GENERIC_KERNEL symbol")
Cc: stable@vger.kernel.org # v5.9
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 arch/mips/include/asm/cpu-features.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index 78cf7e300f12..f98892fd8f1d 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -64,6 +64,8 @@
 	((MIPS_ISA_REV >= (ge)) && (MIPS_ISA_REV < (lt)))
 #define __isa_range_or_flag(ge, lt, flag) \
 	(__isa_range(ge, lt) || ((MIPS_ISA_REV < (lt)) && __isa(flag)))
+#define __isa_range_and_ase(ge, lt, ase) \
+	(__isa_range(ge, lt) && __ase(ase))
 
 /*
  * SMP assumption: Options of CPU 0 are a superset of all processors.
@@ -426,7 +428,7 @@
 #endif
 
 #ifndef cpu_has_mipsmt
-#define cpu_has_mipsmt		__isa_lt_and_ase(6, MIPS_ASE_MIPSMT)
+#define cpu_has_mipsmt		__isa_range_and_ase(2, 6, MIPS_ASE_MIPSMT)
 #endif
 
 #ifndef cpu_has_vp
-- 
2.30.2

