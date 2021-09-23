Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDEC41567A
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbhIWDld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239379AbhIWDkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B7B6124D;
        Thu, 23 Sep 2021 03:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368351;
        bh=0dxi+POJ2iYwd8maKH6Ogr4If9FX45mzsIKZJumt1Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1cLj8yfeRW9mC03J0nkZG3q2QBY539YG2p+hzUkZlEvbEqxDTnp8HEGC6jqlD8iz
         Dnt+39mTNVJneYM7WG+B69t9blQFUfmc73I62rG0M256qbUY89HjoH3nbiQp5uHMRb
         i62xTtJ151RW2YflwXeSx9a+esnyGm8QnrdXJVIAoVsAEDYjkFOllLT7BS5Y6qzP9d
         IzSBzKr3ErflYHFcO+AukVDKUy1kPatcZ8tcpWA+NSUNCW/dVfJDfp4/ST+58dn8Vt
         NwSFekiTYtnqtzGTMday2FK4VWptFsqm1ZIcDtgDfqLx8X1O5H81GvWNFSy/UR2dR4
         8weBZbMuMhiXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, luc.vanoostenryck@gmail.com,
        linux-sparse@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/19] compiler.h: Introduce absolute_pointer macro
Date:   Wed, 22 Sep 2021 23:38:45 -0400
Message-Id: <20210923033853.1421193-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
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
index 9446e8fbe55c..bce983406aaf 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -233,6 +233,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#define absolute_pointer(val)	RELOC_HIDE((void *)(val), 0)
+
 #ifndef OPTIMIZER_HIDE_VAR
 /* Make the optimizer believe the variable can be manipulated arbitrarily. */
 #define OPTIMIZER_HIDE_VAR(var)						\
-- 
2.30.2

