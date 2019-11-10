Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9CD2F6547
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfKJCqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:46:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbfKJCqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5809F2085B;
        Sun, 10 Nov 2019 02:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353968;
        bh=yd/2s7NgD5N/H4tCXDGVVAgmUhkj7AtVXMSL9P/ctck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLo+7FU5KSHjF2/4vfa2EImOP+gR3NUxgn6KkezdbSMoVkUzpykfZ42y090ObMvBp
         7F46CbwP2upAvhF46h6pdbAuiSwWK4HHTK8mI+4ZmQK72vLzFiiZjjAsmOdHMMAChG
         N7W0iBcZihpoDdLBiVqVyyPCi8qzuvAcS2Q/FA0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 016/109] libfdt: Ensure INT_MAX is defined in libfdt_env.h
Date:   Sat,  9 Nov 2019 21:44:08 -0500
Message-Id: <20191110024541.31567-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 53dd9dce6979bc54d64a3a09a2fb20187a025be7 ]

The next update of libfdt has a new dependency on INT_MAX. Update the
instances of libfdt_env.h in the kernel to either include the necessary
header with the definition or define it locally.

Cc: Russell King <linux@armlinux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/libfdt_env.h | 2 ++
 arch/powerpc/boot/libfdt_env.h        | 2 ++
 include/linux/libfdt_env.h            | 1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/arm/boot/compressed/libfdt_env.h b/arch/arm/boot/compressed/libfdt_env.h
index 07437816e0986..b36c0289a308e 100644
--- a/arch/arm/boot/compressed/libfdt_env.h
+++ b/arch/arm/boot/compressed/libfdt_env.h
@@ -6,6 +6,8 @@
 #include <linux/string.h>
 #include <asm/byteorder.h>
 
+#define INT_MAX			((int)(~0U>>1))
+
 typedef __be16 fdt16_t;
 typedef __be32 fdt32_t;
 typedef __be64 fdt64_t;
diff --git a/arch/powerpc/boot/libfdt_env.h b/arch/powerpc/boot/libfdt_env.h
index f52c31b1f48fa..39155d3b2cefa 100644
--- a/arch/powerpc/boot/libfdt_env.h
+++ b/arch/powerpc/boot/libfdt_env.h
@@ -5,6 +5,8 @@
 #include <types.h>
 #include <string.h>
 
+#define INT_MAX			((int)(~0U>>1))
+
 #include "of.h"
 
 typedef u32 uint32_t;
diff --git a/include/linux/libfdt_env.h b/include/linux/libfdt_env.h
index 14997285e53d3..1aa707ab19bbf 100644
--- a/include/linux/libfdt_env.h
+++ b/include/linux/libfdt_env.h
@@ -2,6 +2,7 @@
 #ifndef _LIBFDT_ENV_H
 #define _LIBFDT_ENV_H
 
+#include <linux/kernel.h>	/* For INT_MAX */
 #include <linux/string.h>
 
 #include <asm/byteorder.h>
-- 
2.20.1

