Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324D2490E00
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242209AbiAQRGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54572 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242493AbiAQREf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:04:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 792FD61245;
        Mon, 17 Jan 2022 17:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9784C36AE3;
        Mon, 17 Jan 2022 17:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439073;
        bh=HTUHJVVdTyLs2HI+l2PKLckftklMLQZY10KtFgY2Q+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+59PHjB2sh1pX3OtYCqkboIRXMAJyj7Vud464x/LvxyeyhyYr6EJk+EzguIGkOMq
         z+xB5UfT6DDKRQpI2mCZsZhz92MUE0wjMMgUH5MfnZamzjYAwgatHga1jI09w44JxY
         NtTsvhBdlIqcQSq4gkvsSpIuVsbfGGmGW9eG4Ii/o/2l11sfPpdzFUktbWgByyDKlY
         WlKK3G/SlqQalTKBF896XuYs7HsMxjr7AsvcmxdQorRYsdLgyj16v4+1a8zChPKGWR
         yxjHNeh5OoMP/AYX06WcQAjji7r00VioM/q+GVIuLBU6IK8U+wNHiG8AGv/OmjxFMl
         zn1IoJcgqj76Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, ndesaulniers@google.com,
        freifunk@adrianschmutzler.de, linux-mips@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 29/34] MIPS: Octeon: Fix build errors using clang
Date:   Mon, 17 Jan 2022 12:03:19 -0500
Message-Id: <20220117170326.1471712-29-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 95339b70677dc6f9a2d669c4716058e71b8dc1c7 ]

A large number of the following errors is reported when compiling
with clang:

  cvmx-bootinfo.h:326:3: error: adding 'int' to a string does not append to the string [-Werror,-Wstring-plus-int]
                  ENUM_BRD_TYPE_CASE(CVMX_BOARD_TYPE_NULL)
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cvmx-bootinfo.h:321:20: note: expanded from macro 'ENUM_BRD_TYPE_CASE'
          case x: return(#x + 16);        /* Skip CVMX_BOARD_TYPE_ */
                         ~~~^~~~
  cvmx-bootinfo.h:326:3: note: use array indexing to silence this warning
  cvmx-bootinfo.h:321:20: note: expanded from macro 'ENUM_BRD_TYPE_CASE'
          case x: return(#x + 16);        /* Skip CVMX_BOARD_TYPE_ */
                          ^

Follow the prompts to use the address operator '&' to fix this error.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/octeon/cvmx-bootinfo.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/octeon/cvmx-bootinfo.h b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
index c114a7ba0badd..e77e8b7c00838 100644
--- a/arch/mips/include/asm/octeon/cvmx-bootinfo.h
+++ b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
@@ -317,7 +317,7 @@ enum cvmx_chip_types_enum {
 
 /* Functions to return string based on type */
 #define ENUM_BRD_TYPE_CASE(x) \
-	case x: return(#x + 16);	/* Skip CVMX_BOARD_TYPE_ */
+	case x: return (&#x[16]);	/* Skip CVMX_BOARD_TYPE_ */
 static inline const char *cvmx_board_type_to_string(enum
 						    cvmx_board_types_enum type)
 {
@@ -408,7 +408,7 @@ static inline const char *cvmx_board_type_to_string(enum
 }
 
 #define ENUM_CHIP_TYPE_CASE(x) \
-	case x: return(#x + 15);	/* Skip CVMX_CHIP_TYPE */
+	case x: return (&#x[15]);	/* Skip CVMX_CHIP_TYPE */
 static inline const char *cvmx_chip_type_to_string(enum
 						   cvmx_chip_types_enum type)
 {
-- 
2.34.1

