Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8C13E4407
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhHIKmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234061AbhHIKm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 06:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0EE60F9F;
        Mon,  9 Aug 2021 10:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628505727;
        bh=UaQD+AWgJu7VQxTTR2K99tG17JXkAuWCdbaP4nftpd4=;
        h=Subject:To:Cc:From:Date:From;
        b=wac/cTtOWlRBpNlhE5JmmhnrPJOPNnSF4pOjdQi7YEABXneYj97FDnx4UF+u8MUmB
         ZSemyZOEM65f1hUkIPz1XyrWmEaTAajkMq11N2UA/uru0Hxv8F5BOK3mZznQLeYqyF
         FKqDJO+LnWFovz2ZUEn9TLiAPzjgKAJdjx6dS8Xk=
Subject: FAILED: patch "[PATCH] Revert "riscv: Remove CONFIG_PHYS_RAM_BASE_FIXED"" failed to apply to 5.13-stable tree
To:     alex@ghiti.fr, jszhang@kernel.org, kernel@esmil.dk,
        palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Aug 2021 12:42:04 +0200
Message-ID: <16285057241800@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 867432bec1c6e7df21a361d7f12022a8c5f54022 Mon Sep 17 00:00:00 2001
From: Alexandre Ghiti <alex@ghiti.fr>
Date: Wed, 21 Jul 2021 09:59:36 +0200
Subject: [PATCH] Revert "riscv: Remove CONFIG_PHYS_RAM_BASE_FIXED"

This reverts commit 9b79878ced8f7ab85c57623f8b1f6882e484a316.

The removal of this config exposes CONFIG_PHYS_RAM_BASE for all kernel
types: this value being implementation-specific, this breaks the
genericity of the RISC-V kernel so revert it.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Tested-by: Emil Renner Berthing <kernel@esmil.dk>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 31f9e92f1402..4f7b70ae7c31 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -495,8 +495,13 @@ config STACKPROTECTOR_PER_TASK
 	depends on !GCC_PLUGIN_RANDSTRUCT
 	depends on STACKPROTECTOR && CC_HAVE_STACKPROTECTOR_TLS
 
+config PHYS_RAM_BASE_FIXED
+	bool "Explicitly specified physical RAM address"
+	default n
+
 config PHYS_RAM_BASE
 	hex "Platform Physical RAM address"
+	depends on PHYS_RAM_BASE_FIXED
 	default "0x80000000"
 	help
 	  This is the physical address of RAM in the system. It has to be
@@ -509,6 +514,7 @@ config XIP_KERNEL
 	# This prevents XIP from being enabled by all{yes,mod}config, which
 	# fail to build since XIP doesn't support large kernels.
 	depends on !COMPILE_TEST
+	select PHYS_RAM_BASE_FIXED
 	help
 	  Execute-In-Place allows the kernel to run from non-volatile storage
 	  directly addressable by the CPU, such as NOR flash. This saves RAM

