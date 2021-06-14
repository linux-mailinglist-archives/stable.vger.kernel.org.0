Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25243A630A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhFNLIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233311AbhFNLGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2021361928;
        Mon, 14 Jun 2021 10:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667527;
        bh=ATX+R9iI4RWuortbgaRdIBaCq+Rva6ha+gLJi6HSKGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/ZLo5CXXWk6GD1DihcdBzqHPJm8PIIVwnHTBNbe71d0HbVCIQ8zWxN41ssyJLQbF
         pzpXvxXUJcBBKJVEDqFpBFz8sUG0QfrHS8LIuCdzBJkrjZ8b1zd15YMSNwAkvepHw7
         PcrapkDHiAHq7qSooWYPQt/RT1DDQYTKQX0QFCXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 105/131] ARM: cpuidle: Avoid orphan section warning
Date:   Mon, 14 Jun 2021 12:27:46 +0200
Message-Id: <20210614102656.570135046@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit d94b93a9101573eb75b819dee94b1417acff631b upstream.

Since commit 83109d5d5fba ("x86/build: Warn on orphan section placement"),
we get a warning for objects in orphan sections. The cpuidle implementation
for OMAP causes this when CONFIG_CPU_IDLE is disabled:

arm-linux-gnueabi-ld: warning: orphan section `__cpuidle_method_of_table' from `arch/arm/mach-omap2/pm33xx-core.o' being placed in section `__cpuidle_method_of_table'
arm-linux-gnueabi-ld: warning: orphan section `__cpuidle_method_of_table' from `arch/arm/mach-omap2/pm33xx-core.o' being placed in section `__cpuidle_method_of_table'
arm-linux-gnueabi-ld: warning: orphan section `__cpuidle_method_of_table' from `arch/arm/mach-omap2/pm33xx-core.o' being placed in section `__cpuidle_method_of_table'

Change the definition of CPUIDLE_METHOD_OF_DECLARE() to silently
drop the table and all code referenced from it when CONFIG_CPU_IDLE
is disabled.

Fixes: 06ee7a950b6a ("ARM: OMAP2+: pm33xx-core: Add cpuidle_ops for am335x/am437x")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20201230155506.1085689-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/cpuidle.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/cpuidle.h
+++ b/arch/arm/include/asm/cpuidle.h
@@ -7,9 +7,11 @@
 #ifdef CONFIG_CPU_IDLE
 extern int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index);
+#define __cpuidle_method_section __used __section("__cpuidle_method_of_table")
 #else
 static inline int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index) { return -ENODEV; }
+#define __cpuidle_method_section __maybe_unused /* drop silently */
 #endif
 
 /* Common ARM WFI state */
@@ -42,8 +44,7 @@ struct of_cpuidle_method {
 
 #define CPUIDLE_METHOD_OF_DECLARE(name, _method, _ops)			\
 	static const struct of_cpuidle_method __cpuidle_method_of_table_##name \
-	__used __section("__cpuidle_method_of_table")			\
-	= { .method = _method, .ops = _ops }
+	__cpuidle_method_section = { .method = _method, .ops = _ops }
 
 extern int arm_cpuidle_suspend(int index);
 


