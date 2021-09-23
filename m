Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A942F415711
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhIWDp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239078AbhIWDoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44EDC61038;
        Thu, 23 Sep 2021 03:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368458;
        bh=wshpeas/bLecEKGrLbRMPe2/oI9FuLRhGmWfRKrEC1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZR5AeLNRkKbazBJBfOshRbvPOGfogCjDCgvpLWXWQ+jZxu/D7iL0bUQ5NQg4Zo02f
         HmXHwLUU0OlVK4jRuR2mlA3acZ3Br94cUTB9ZPk5Dfu5QrEKouH/D68JdSidJUZZPn
         678WcBgGxpDWs9N8cOseVoO5LXbYQb/kWtGj3aguMSuVS2M0jm0Q4DumByCLYhulxb
         EfRmE1bcpUQMVl4OvNYCRqmVRVrvkgOf73jQXiVSqLEU7XHYCTXZ8LL0J08YpZAnTA
         mT47M6cfDSai7igD66VImsGygkInHl6oWtS9tqa3VwlNna73mrR2drfYaJRA4VovXo
         /DZ+6GjJZcFBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, luc.vanoostenryck@gmail.com,
        linux-sparse@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/10] compiler.h: Introduce absolute_pointer macro
Date:   Wed, 22 Sep 2021 23:40:45 -0400
Message-Id: <20210923034055.1422059-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923034055.1422059-1-sashal@kernel.org>
References: <20210923034055.1422059-1-sashal@kernel.org>
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
index 7cabe0cc8665..bc8077e5e688 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -208,6 +208,8 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#define absolute_pointer(val)	RELOC_HIDE((void *)(val), 0)
+
 #ifndef OPTIMIZER_HIDE_VAR
 #define OPTIMIZER_HIDE_VAR(var) barrier()
 #endif
-- 
2.30.2

