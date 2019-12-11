Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C537911B155
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbfLKP3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:29:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387898AbfLKP3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:29:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BE1B2467A;
        Wed, 11 Dec 2019 15:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078170;
        bh=Hw7bD5PbrKVmf62VIKhLrG1Vqni+JW0i4fW7uGy5yyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACcEPvsBjZJftPJ0cvNVrgEBWQo6HTz9RSPkYYyMU4Q8ZLQ3omoIHO8BnXF8Zbx+R
         IBn8hZBj2tryBoEZOZMjZrpy8LGX8rfgNNlV35eAHEYcCR3W7RXFhzZyWPnl11Jf8Z
         fBL6OcLp06+hhmM0XCttlgl/kwGXsIhHLGEDlNak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 54/58] libfdt: define INT32_MAX and UINT32_MAX in libfdt_env.h
Date:   Wed, 11 Dec 2019 10:28:27 -0500
Message-Id: <20191211152831.23507-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit a8de1304b7df30e3a14f2a8b9709bb4ff31a0385 ]

The DTC v1.5.1 added references to (U)INT32_MAX.

This is no problem for user-space programs since <stdint.h> defines
(U)INT32_MAX along with (u)int32_t.

For the kernel space, libfdt_env.h needs to be adjusted before we
pull in the changes.

In the kernel, we usually use s/u32 instead of (u)int32_t for the
fixed-width types.

Accordingly, we already have S/U32_MAX for their max values.
So, we should not add (U)INT32_MAX to <linux/limits.h> any more.

Instead, add them to the in-kernel libfdt_env.h to compile the
latest libfdt.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/libfdt_env.h | 4 +++-
 arch/powerpc/boot/libfdt_env.h        | 2 ++
 include/linux/libfdt_env.h            | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/libfdt_env.h b/arch/arm/boot/compressed/libfdt_env.h
index b36c0289a308e..6a0f1f524466e 100644
--- a/arch/arm/boot/compressed/libfdt_env.h
+++ b/arch/arm/boot/compressed/libfdt_env.h
@@ -2,11 +2,13 @@
 #ifndef _ARM_LIBFDT_ENV_H
 #define _ARM_LIBFDT_ENV_H
 
+#include <linux/limits.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <asm/byteorder.h>
 
-#define INT_MAX			((int)(~0U>>1))
+#define INT32_MAX	S32_MAX
+#define UINT32_MAX	U32_MAX
 
 typedef __be16 fdt16_t;
 typedef __be32 fdt32_t;
diff --git a/arch/powerpc/boot/libfdt_env.h b/arch/powerpc/boot/libfdt_env.h
index 39155d3b2cefa..ac5d3c947e04e 100644
--- a/arch/powerpc/boot/libfdt_env.h
+++ b/arch/powerpc/boot/libfdt_env.h
@@ -6,6 +6,8 @@
 #include <string.h>
 
 #define INT_MAX			((int)(~0U>>1))
+#define UINT32_MAX		((u32)~0U)
+#define INT32_MAX		((s32)(UINT32_MAX >> 1))
 
 #include "of.h"
 
diff --git a/include/linux/libfdt_env.h b/include/linux/libfdt_env.h
index 1aa707ab19bbf..8b54c591678e1 100644
--- a/include/linux/libfdt_env.h
+++ b/include/linux/libfdt_env.h
@@ -7,6 +7,9 @@
 
 #include <asm/byteorder.h>
 
+#define INT32_MAX	S32_MAX
+#define UINT32_MAX	U32_MAX
+
 typedef __be16 fdt16_t;
 typedef __be32 fdt32_t;
 typedef __be64 fdt64_t;
-- 
2.20.1

