Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23BE1ABF12
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 13:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632937AbgDPLZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 07:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633052AbgDPLZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 07:25:42 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6D5F21D7F;
        Thu, 16 Apr 2020 11:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587036342;
        bh=wCkxcDbz5xirgIfchefcfaOqkTclgC7v7IQAWBE+wHA=;
        h=From:To:Cc:Subject:Date:From;
        b=a3qrk9JHogGqtwuY+xnShuARonqZlEi1RWr6VSTITPvJSd0TOTKyZPg/+mWutHW22
         Qad9z+CS/uYO0ptdC+XUF2jbyp48zfQw6zLeoBDlXDY25EkVggcV3XZX2Ta+FfGI7U
         VCP2sWVMgIczYJcMxZo7IZfYelZ3r0J5kNt1tQZ8=
From:   Mark Brown <broonie@kernel.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.6] arm64: Always force a branch protection mode when the compiler has one
Date:   Thu, 16 Apr 2020 12:24:30 +0100
Message-Id: <20200416112430.1256-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Compilers with branch protection support can be configured to enable it by
default, it is likely that distributions will do this as part of deploying
branch protection system wide. As well as the slight overhead from having
some extra NOPs for unused branch protection features this can cause more
serious problems when the kernel is providing pointer authentication to
userspace but not built for pointer authentication itself. In that case our
switching of keys for userspace can affect the kernel unexpectedly, causing
pointer authentication instructions in the kernel to corrupt addresses.

To ensure that we get consistent and reliable behaviour always explicitly
initialise the branch protection mode, ensuring that the kernel is built
the same way regardless of the compiler defaults.

[This is a reworked version of b8fdef311a0bd9223f1075 ("arm64: Always
force a branch protection mode when the compiler has one") for backport.
Kernels prior to 74afda4016a7 ("arm64: compile the kernel with ptrauth
return address signing") don't have any Makefile machinery for forcing
on pointer auth but still have issues if the compiler defaults it on so
need this reworked version. -- broonie]

Fixes: 7503197562567 (arm64: add basic pointer authentication support)
Reported-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
[catalin.marinas@arm.com: remove Kconfig option in favour of Makefile check]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index dca1a97751ab..4e6ce2d9196e 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -65,6 +65,10 @@ stack_protector_prepare: prepare0
 					include/generated/asm-offsets.h))
 endif
 
+# Ensure that if the compiler supports branch protection we default it
+# off.
+KBUILD_CFLAGS += $(call cc-option,-mbranch-protection=none)
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
-- 
2.20.1

