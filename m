Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E860D4290C1
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241845AbhJKOMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238598AbhJKOKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D9B6115C;
        Mon, 11 Oct 2021 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960948;
        bh=CPxWgP9a5q/4Ip6Nzx4G6n/3ul9tIw6KZbcbEi/iPYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbaUL8GDbH8byjIljQMfwuevo3qovTRt1tCa0GfeMZ4kFrI67z6VT46AFOVVgUdgW
         nYpBQ8S9M5bzQamZ25usmUSCpOdn3IABfLKoe4HrOYCv46MNoffCpyiJER/tkkbAzl
         y5gZj7wbxcoyagUiExnajptYUMPRTiueDba89/JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 122/151] RISC-V: Fix VDSO build for !MMU
Date:   Mon, 11 Oct 2021 15:46:34 +0200
Message-Id: <20211011134521.758548651@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmerdabbelt@google.com>

[ Upstream commit a290f510a178830a01bfc06e66a54bbe4ece5d2a ]

We don't have a VDSO for the !MMU configurations, so don't try to build
one.

Fixes: fde9c59aebaf ("riscv: explicitly use symbol offsets for VDSO")
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Makefile           | 2 ++
 arch/riscv/include/asm/vdso.h | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index e026b2d0a5a4..83ee0e71204c 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -108,9 +108,11 @@ PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/riscv/kernel/vdso $@
 
+ifeq ($(CONFIG_MMU),y)
 prepare: vdso_prepare
 vdso_prepare: prepare0
 	$(Q)$(MAKE) $(build)=arch/riscv/kernel/vdso include/generated/vdso-offsets.h
+endif
 
 ifneq ($(CONFIG_XIP_KERNEL),y)
 ifeq ($(CONFIG_RISCV_M_MODE)$(CONFIG_SOC_CANAAN),yy)
diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
index d8d003c2b5a3..893e47195e30 100644
--- a/arch/riscv/include/asm/vdso.h
+++ b/arch/riscv/include/asm/vdso.h
@@ -8,6 +8,13 @@
 #ifndef _ASM_RISCV_VDSO_H
 #define _ASM_RISCV_VDSO_H
 
+
+/*
+ * All systems with an MMU have a VDSO, but systems without an MMU don't
+ * support shared libraries and therefor don't have one.
+ */
+#ifdef CONFIG_MMU
+
 #include <linux/types.h>
 #include <generated/vdso-offsets.h>
 
@@ -19,6 +26,8 @@ struct vdso_data {
 #define VDSO_SYMBOL(base, name)							\
 	(void __user *)((unsigned long)(base) + __vdso_##name##_offset)
 
+#endif /* CONFIG_MMU */
+
 asmlinkage long sys_riscv_flush_icache(uintptr_t, uintptr_t, uintptr_t);
 
 #endif /* _ASM_RISCV_VDSO_H */
-- 
2.33.0



