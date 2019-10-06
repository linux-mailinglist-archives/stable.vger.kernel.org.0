Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51E9CD782
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfJFRaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbfJFRaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:30:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DB092133F;
        Sun,  6 Oct 2019 17:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383022;
        bh=hfNg8Nm40zRI8TDF/Icp+MSffb6Vg+BWyaWKFeR4cw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRZjk+728IAntQ3/DJQxRUoWlzEafzlLf4ERhTICJUy0wZVMIc9ipb3CppTMF2VXG
         X02GnqX9Y4TQEAXOzVAdBygDc4sh3rj6s7FA/3+HYePTdJlNFswJ90z0HRIEDz97Qj
         dGf/56050kvO3k1f+402S068F37B/alv8WcH9YGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/106] ARM: 8875/1: Kconfig: default to AEABI w/ Clang
Date:   Sun,  6 Oct 2019 19:21:03 +0200
Message-Id: <20191006171147.869327445@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit a05b9608456e0d4464c6f7ca8572324ace57a3f4 ]

Clang produces references to __aeabi_uidivmod and __aeabi_idivmod for
arm-linux-gnueabi and arm-linux-gnueabihf targets incorrectly when AEABI
is not selected (such as when OABI_COMPAT is selected).

While this means that OABI userspaces wont be able to upgraded to
kernels built with Clang, it means that boards that don't enable AEABI
like s3c2410_defconfig will stop failing to link in KernelCI when built
with Clang.

Link: https://github.com/ClangBuiltLinux/linux/issues/482
Link: https://groups.google.com/forum/#!msg/clang-built-linux/yydsAAux5hk/GxjqJSW-AQAJ

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 51794c7fa6d5b..185e552f14610 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1586,8 +1586,9 @@ config ARM_PATCH_IDIV
 	  code to do integer division.
 
 config AEABI
-	bool "Use the ARM EABI to compile the kernel" if !CPU_V7 && !CPU_V7M && !CPU_V6 && !CPU_V6K
-	default CPU_V7 || CPU_V7M || CPU_V6 || CPU_V6K
+	bool "Use the ARM EABI to compile the kernel" if !CPU_V7 && \
+		!CPU_V7M && !CPU_V6 && !CPU_V6K && !CC_IS_CLANG
+	default CPU_V7 || CPU_V7M || CPU_V6 || CPU_V6K || CC_IS_CLANG
 	help
 	  This option allows for the kernel to be compiled using the latest
 	  ARM ABI (aka EABI).  This is only useful if you are using a user
-- 
2.20.1



