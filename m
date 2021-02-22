Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAF832164C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhBVMUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhBVMRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:17:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17EC064F12;
        Mon, 22 Feb 2021 12:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996194;
        bh=PYrS36eLoHwCchuEv3GtasPtYiowxhUsjoGUmCqlgto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSvn2U2ZbO5wLsR8sYWnwRPr5pIXnlPPyNRgGVv+CYOOgPccXzX4MDq5B5/+6xBZM
         Epj8cdSStqUiP28exxu69KqV+T5aEN4X5Kc6zvDBhnasvQyD6mTnSpCYYAKNuogqar
         vFVEhFW+SIZSIGPCe+lw7lhtxzZWVp6xftyVe6fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fangrui Song <maskray@google.com>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/50] firmware_loader: align .builtin_fw to 8
Date:   Mon, 22 Feb 2021 13:13:15 +0100
Message-Id: <20210222121024.622972918@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

[ Upstream commit 793f49a87aae24e5bcf92ad98d764153fc936570 ]

arm64 references the start address of .builtin_fw (__start_builtin_fw)
with a pair of R_AARCH64_ADR_PREL_PG_HI21/R_AARCH64_LDST64_ABS_LO12_NC
relocations.  The compiler is allowed to emit the
R_AARCH64_LDST64_ABS_LO12_NC relocation because struct builtin_fw in
include/linux/firmware.h is 8-byte aligned.

The R_AARCH64_LDST64_ABS_LO12_NC relocation requires the address to be a
multiple of 8, which may not be the case if .builtin_fw is empty.
Unconditionally align .builtin_fw to fix the linker error.  32-bit
architectures could use ALIGN(4) but that would add unnecessary
complexity, so just use ALIGN(8).

Link: https://lkml.kernel.org/r/20201208054646.2913063-1-maskray@google.com
Link: https://github.com/ClangBuiltLinux/linux/issues/1204
Fixes: 5658c76 ("firmware: allow firmware files to be built into kernel image")
Signed-off-by: Fangrui Song <maskray@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f65a924a75abd..e71c97c3c25ef 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -363,7 +363,7 @@
 	}								\
 									\
 	/* Built-in firmware blobs */					\
-	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
+	.builtin_fw : AT(ADDR(.builtin_fw) - LOAD_OFFSET) ALIGN(8) {	\
 		__start_builtin_fw = .;					\
 		KEEP(*(.builtin_fw))					\
 		__end_builtin_fw = .;					\
-- 
2.27.0



