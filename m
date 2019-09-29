Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B98C1877
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbfI2RnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729204AbfI2Rbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:31:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9251218AC;
        Sun, 29 Sep 2019 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778295;
        bh=C8GGBJVGuQevLu0Z6ggEvyEinRf5njOQ0297fhKdxTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sV1Ain1i8/g+AuQE09KWd5T4r3HA87Xfksss3I+uKJKePRZkSxJiB2fybwfG7ahGu
         vabpU2qcqzdEIhFrNlDEJYkVk29kc4tqsjWV6XbV5UUsKdYM7mJlQrHmHp+iTGnLK4
         kZpGbkO0Jao4mEOYEYTI3wmt/KU3n+ys7rSdxANY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.3 18/49] ARM: 8875/1: Kconfig: default to AEABI w/ Clang
Date:   Sun, 29 Sep 2019 13:30:18 -0400
Message-Id: <20190929173053.8400-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 24360211534ab..5e2c68e9dd6e2 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1572,8 +1572,9 @@ config ARM_PATCH_IDIV
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

