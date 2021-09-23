Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540E84156CB
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbhIWDnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239668AbhIWDmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4866C61352;
        Thu, 23 Sep 2021 03:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368408;
        bh=NjkHYdGgcJtKZqqP8p3faKlWuYHCx+dY/lDsikHdxyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqRO3rCbEdHcbH7A5/hVyApwvdVb+Fg+HfRTQQLuMoR6Zf+bAU1IP2a0pIrUk0R3c
         +l9VbIGizWv+9uhewVUD+pLPq7IMtwILeFOUaQ3u+qyRByfmT8AQJFN4xGCrRhdj+b
         abEowyets32PuGXSqYznfJr0PY2NlpP/Wx54TTkEC0v9vKy4s+dibkzP33BCd+J9EJ
         W9QFMpRpRbzdLHOsmeEnhEWFgGKgEwyf7QTav8184j73Ro+Gxy1EsP14QonKRzgrMJ
         s/z2Gh2DPX4c4jEbukMzocN+2Z2CYGO1xKHz6IoOxhka0EV2aWWbjM619RJy8xyJ5z
         oKge8yskk+hAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, luc.vanoostenryck@gmail.com,
        linux-sparse@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/13] compiler.h: Introduce absolute_pointer macro
Date:   Wed, 22 Sep 2021 23:39:51 -0400
Message-Id: <20210923033959.1421662-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033959.1421662-1-sashal@kernel.org>
References: <20210923033959.1421662-1-sashal@kernel.org>
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
index 3b6e6522e0ec..d29b68379223 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -152,6 +152,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#define absolute_pointer(val)	RELOC_HIDE((void *)(val), 0)
+
 #ifndef OPTIMIZER_HIDE_VAR
 #define OPTIMIZER_HIDE_VAR(var) barrier()
 #endif
-- 
2.30.2

