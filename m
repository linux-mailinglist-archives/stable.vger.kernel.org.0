Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D19D490DBC
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241890AbiAQRFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:05:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51244 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241909AbiAQRCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC94260EDB;
        Mon, 17 Jan 2022 17:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26315C36AE3;
        Mon, 17 Jan 2022 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438973;
        bh=7Tyt6TC2ggJRw3fF++QSOCLW9HU6iOd4lCmrV9XE4Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RF9M1hYMf/6EY/j1uuSJCBu2+ufApLiAho+/5foupXbKQle3DfKoEU4Xd+vbBdlzm
         FM/lzdzxZDR33DXX7odjqu14CvoUjQWvslpUET4DygFXhjGaSaLgPN6SHA9GfKcn/D
         Yo6dcFLuCSvD3IAFRNimmbaERG5V6TvRaBaJNtbn+jRyJmoaOhjoZzGCaKV4p6xCfN
         lpiV9qe9iPuBKaiYpSQ5nG/Gom9iqq0b3aQ2SxIMb+utqk97/ndiLW2WeDhQ4z1YFa
         /xouxCaw6s0wwCCahDzhqQKtDivzvExwMVzl3r4luxm/ez8k7S9oLFd5QOyDhwv/z3
         dVsrjAPiKfq+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, ndesaulniers@google.com,
        freifunk@adrianschmutzler.de, linux-mips@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 34/44] MIPS: Octeon: Fix build errors using clang
Date:   Mon, 17 Jan 2022 12:01:17 -0500
Message-Id: <20220117170127.1471115-34-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
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
index 0e6bf220db618..6c61e0a639249 100644
--- a/arch/mips/include/asm/octeon/cvmx-bootinfo.h
+++ b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
@@ -318,7 +318,7 @@ enum cvmx_chip_types_enum {
 
 /* Functions to return string based on type */
 #define ENUM_BRD_TYPE_CASE(x) \
-	case x: return(#x + 16);	/* Skip CVMX_BOARD_TYPE_ */
+	case x: return (&#x[16]);	/* Skip CVMX_BOARD_TYPE_ */
 static inline const char *cvmx_board_type_to_string(enum
 						    cvmx_board_types_enum type)
 {
@@ -410,7 +410,7 @@ static inline const char *cvmx_board_type_to_string(enum
 }
 
 #define ENUM_CHIP_TYPE_CASE(x) \
-	case x: return(#x + 15);	/* Skip CVMX_CHIP_TYPE */
+	case x: return (&#x[15]);	/* Skip CVMX_CHIP_TYPE */
 static inline const char *cvmx_chip_type_to_string(enum
 						   cvmx_chip_types_enum type)
 {
-- 
2.34.1

