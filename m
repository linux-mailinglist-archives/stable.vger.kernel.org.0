Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A3A4156A3
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbhIWDmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239500AbhIWDlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:41:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D0336124F;
        Thu, 23 Sep 2021 03:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368381;
        bh=rhV09odn3N6lzn4H/XhQcSW3wW6sHFdFsL9736YOl2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQtfCtoAnCig0wZfaxBdlkG+b925kwhNU7u4kyjUU8fGIWLMgyFHL6wdx8RWOrY8L
         7ah7v9PAcZcBfsXrjW4GwM9X/NqFC1y8yvqQdrOfsryeIF0Ijs9LP8bA8dIhr+WHhf
         mdMTJXyU51r3Aol6n/DOXuiHsmOJ5wQQ0H+uDp+6CZq1vOveNC+iigKawQmzbbWMzN
         RwB101b4zfEpvyTR3UASdU05F6YlYM1+2neCMBb6i8KsHmRgOKi0q3TltVzbeY97WC
         W5w6caZe1a5PTAPJTPfU5e6tc85w0GH3GqJc1utNYBfPbYeT7Yr9uyUDGI7G9MpC9v
         LHrmN7+QC6fKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, luc.vanoostenryck@gmail.com,
        linux-sparse@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/15] compiler.h: Introduce absolute_pointer macro
Date:   Wed, 22 Sep 2021 23:39:21 -0400
Message-Id: <20210923033929.1421446-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033929.1421446-1-sashal@kernel.org>
References: <20210923033929.1421446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f6b5f1a56987de837f8e25cd560847106b8632a8 ]

absolute_pointer() disassociates a pointer from its originating symbol
type and context. Use it to prevent compiler warnings/errors such as

  drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
  arch/m68k/include/asm/string.h:72:25: error:
	'__builtin_memcpy' reading 6 bytes from a region of size 0 [-Werror=stringop-overread]

Such warnings may be reported by gcc 11.x for string and memory
operations on fixed addresses.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 6a53300cbd1e..ab9dfb14f486 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -228,6 +228,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#define absolute_pointer(val)	RELOC_HIDE((void *)(val), 0)
+
 #ifndef OPTIMIZER_HIDE_VAR
 /* Make the optimizer believe the variable can be manipulated arbitrarily. */
 #define OPTIMIZER_HIDE_VAR(var)						\
-- 
2.30.2

