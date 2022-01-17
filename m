Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89FA490EBE
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241495AbiAQRLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243434AbiAQRJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:09:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BC7C0613A7;
        Mon, 17 Jan 2022 09:05:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB5F86126B;
        Mon, 17 Jan 2022 17:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ED0C36AE7;
        Mon, 17 Jan 2022 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439142;
        bh=Qf6XnIzeElSZlaTPE0+w9iFReX52uTDmquC2axMPOMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuCJ0SOcfP+v3FQviXSl9z/GVwRQIUir1AZqWR6l3tVt3VIysIala/WoLEJk1BWF3
         jRHpYmiosjMNFDiedODr1uEEdZnYgCxVcW3J+pdU+4BzrRO4rHD4QXS/9DosHiHa01
         r2DKYO055Wu1vvc5ZlSqrj+c2Y+N0VbmckhUCCg2u0xviJsdiG/EgRGwOQt0g+Ms+z
         0uG8jZN8XA8a9gtLVP4cfm/UgtjAs2oIZVsJPy2lQBDMIBv2XseNWu2hZFTs3z6xUt
         ARxFAt7XpjrRyNqbv8y8HSil0om1lVmgAfGJY72Y/uIzHaMaMWIqle9JzlnZyNw2QJ
         36PonuXPJf/4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, ndesaulniers@google.com,
        freifunk@adrianschmutzler.de, linux-mips@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.4 19/21] MIPS: Octeon: Fix build errors using clang
Date:   Mon, 17 Jan 2022 12:04:51 -0500
Message-Id: <20220117170454.1472347-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170454.1472347-1-sashal@kernel.org>
References: <20220117170454.1472347-1-sashal@kernel.org>
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
index 62787765575ef..ce6e5fddce0bf 100644
--- a/arch/mips/include/asm/octeon/cvmx-bootinfo.h
+++ b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
@@ -315,7 +315,7 @@ enum cvmx_chip_types_enum {
 
 /* Functions to return string based on type */
 #define ENUM_BRD_TYPE_CASE(x) \
-	case x: return(#x + 16);	/* Skip CVMX_BOARD_TYPE_ */
+	case x: return (&#x[16]);	/* Skip CVMX_BOARD_TYPE_ */
 static inline const char *cvmx_board_type_to_string(enum
 						    cvmx_board_types_enum type)
 {
@@ -404,7 +404,7 @@ static inline const char *cvmx_board_type_to_string(enum
 }
 
 #define ENUM_CHIP_TYPE_CASE(x) \
-	case x: return(#x + 15);	/* Skip CVMX_CHIP_TYPE */
+	case x: return (&#x[15]);	/* Skip CVMX_CHIP_TYPE */
 static inline const char *cvmx_chip_type_to_string(enum
 						   cvmx_chip_types_enum type)
 {
-- 
2.34.1

