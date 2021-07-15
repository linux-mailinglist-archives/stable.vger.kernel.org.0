Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C85A3CA91D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242619AbhGOTF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243371AbhGOTEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BAFA61402;
        Thu, 15 Jul 2021 18:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375595;
        bh=gHjxUE6q5q2kLdGweCLT5/Xb1aBBzr5wP0DdDKZxUEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L51JosaaAplxxQbZ0F44V47yGY2yyrBsPWnJxbeaRtJYZqglJv3AtnGqum5giaQTo
         EF23Yn0SvDt9vY3t7CtBtaxmKHph/BRrKLvqpzhNdgRzO835+kwiELXCBqNO5m8zU0
         NObg4f2PAkylgK5fng97StxHV0zeLGUlDrDLvFcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 152/242] MIPS: set mips32r5 for virt extensions
Date:   Thu, 15 Jul 2021 20:38:34 +0200
Message-Id: <20210715182620.017148023@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit c994a3ec7ecc8bd2a837b2061e8a76eb8efc082b ]

Clang's integrated assembler only accepts these instructions when the
cpu is set to mips32r5. With this change, we can assemble
malta_defconfig with Clang via `make LLVM_IAS=1`.

Link: https://github.com/ClangBuiltLinux/linux/issues/763
Reported-by: Dmitry Golovin <dima@golovin.in>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mipsregs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 9c8099a6ffed..acdf8c69220b 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -2077,7 +2077,7 @@ _ASM_MACRO_0(tlbginvf, _ASM_INSN_IF_MIPS(0x4200000c)
 ({ int __res;								\
 	__asm__ __volatile__(						\
 		".set\tpush\n\t"					\
-		".set\tmips32r2\n\t"					\
+		".set\tmips32r5\n\t"					\
 		_ASM_SET_VIRT						\
 		"mfgc0\t%0, " #source ", %1\n\t"			\
 		".set\tpop"						\
@@ -2090,7 +2090,7 @@ _ASM_MACRO_0(tlbginvf, _ASM_INSN_IF_MIPS(0x4200000c)
 ({ unsigned long long __res;						\
 	__asm__ __volatile__(						\
 		".set\tpush\n\t"					\
-		".set\tmips64r2\n\t"					\
+		".set\tmips64r5\n\t"					\
 		_ASM_SET_VIRT						\
 		"dmfgc0\t%0, " #source ", %1\n\t"			\
 		".set\tpop"						\
@@ -2103,7 +2103,7 @@ _ASM_MACRO_0(tlbginvf, _ASM_INSN_IF_MIPS(0x4200000c)
 do {									\
 	__asm__ __volatile__(						\
 		".set\tpush\n\t"					\
-		".set\tmips32r2\n\t"					\
+		".set\tmips32r5\n\t"					\
 		_ASM_SET_VIRT						\
 		"mtgc0\t%z0, " #register ", %1\n\t"			\
 		".set\tpop"						\
@@ -2115,7 +2115,7 @@ do {									\
 do {									\
 	__asm__ __volatile__(						\
 		".set\tpush\n\t"					\
-		".set\tmips64r2\n\t"					\
+		".set\tmips64r5\n\t"					\
 		_ASM_SET_VIRT						\
 		"dmtgc0\t%z0, " #register ", %1\n\t"			\
 		".set\tpop"						\
-- 
2.30.2



