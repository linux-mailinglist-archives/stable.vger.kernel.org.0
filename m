Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03321DD493
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfJRWE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbfJRWE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968A2222C6;
        Fri, 18 Oct 2019 22:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436265;
        bh=BlP8IYozOevQrxXlH5TJfSbvPd0H39Pymk/5eaQJdRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNmbX7jGq/DrK6kmfx5OlJ1JvGoYUowaeNGDMxoPE57V9eQ1URpZYxBthbY/89Xzi
         t2VR27F/t0FFYeSpFC++qPZeCrZh9BiqiuXH9tDxE4dfHra+lYUrPyuTUN4WMV7TON
         C0GGYrxuKI5IWQ99yv7nnvMYXwPdx7rb+ctRXqzM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 47/89] arm64: vdso32: Don't use KBUILD_CPPFLAGS unconditionally
Date:   Fri, 18 Oct 2019 18:02:42 -0400
Message-Id: <20191018220324.8165-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit c71e88c437962c1ec43d4d23a0ebf4c9cf9bee0d ]

KBUILD_CPPFLAGS is defined differently depending on whether the main
compiler is clang or not. This means that it is not possible to build
the compat vDSO with GCC if the rest of the kernel is built with clang.

Define VDSO_CPPFLAGS directly to break this dependency and allow a clang
kernel to build a compat vDSO with GCC:

  $ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_COMPAT=arm-linux-gnueabihf- CC=clang \
    COMPATCC=arm-linux-gnueabihf-gcc

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/vdso32/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 77aa613403747..aa171b043287b 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -25,11 +25,9 @@ cc32-as-instr = $(call try-run,\
 # arm64 one.
 # As a result we set our own flags here.
 
-# From top-level Makefile
-# NOSTDINC_FLAGS
-VDSO_CPPFLAGS := -nostdinc -isystem $(shell $(COMPATCC) -print-file-name=include)
+# KBUILD_CPPFLAGS and NOSTDINC_FLAGS from top-level Makefile
+VDSO_CPPFLAGS := -D__KERNEL__ -nostdinc -isystem $(shell $(COMPATCC) -print-file-name=include)
 VDSO_CPPFLAGS += $(LINUXINCLUDE)
-VDSO_CPPFLAGS += $(KBUILD_CPPFLAGS)
 
 # Common C and assembly flags
 # From top-level Makefile
-- 
2.20.1

