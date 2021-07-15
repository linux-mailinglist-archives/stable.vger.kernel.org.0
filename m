Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DA93CAACA
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbhGOTPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244319AbhGOTOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 822EF613DF;
        Thu, 15 Jul 2021 19:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376218;
        bh=Lrpn29ql0xqhMrkZzmDpW6BQgwWK+WinwHTw7COMlJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mN90Sr8PlIawq20olapcDGBwmiOnJfgwiU1sCTtLanNQ/nadQXRklo6WlQmBrkMeu
         jH+B1y1bRshX0LfMoxHRhsE2WV6D0JHvIpBSdEAUoiluKUOEThVYIOBKdSw+f2h/xz
         4dqS1R46nN9K5NDYaZptLAoCrjb9CLH9JW5tupiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.13 178/266] MIPS: MT extensions are not available on MIPS32r1
Date:   Thu, 15 Jul 2021 20:38:53 +0200
Message-Id: <20210715182643.237778036@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit cad065ed8d8831df67b9754cc4437ed55d8b48c0 upstream.

MIPS MT extensions were added with the MIPS 34K processor, which was
based on the MIPS32r2 ISA.

This fixes a build error when building a generic kernel for a MIPS32r1
CPU.

Fixes: c434b9f80b09 ("MIPS: Kconfig: add MIPS_GENERIC_KERNEL symbol")
Cc: stable@vger.kernel.org # v5.9
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/cpu-features.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
@@ -421,7 +423,7 @@
 #endif
 
 #ifndef cpu_has_mipsmt
-#define cpu_has_mipsmt		__isa_lt_and_ase(6, MIPS_ASE_MIPSMT)
+#define cpu_has_mipsmt		__isa_range_and_ase(2, 6, MIPS_ASE_MIPSMT)
 #endif
 
 #ifndef cpu_has_vp


