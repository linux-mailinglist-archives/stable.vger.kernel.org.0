Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367AC313C9D
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhBHSIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:08:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235209AbhBHSEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:04:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42E4B64EFA;
        Mon,  8 Feb 2021 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807198;
        bh=iyHY/UcIwkzqStaBKjD3/l5RVg2ZyLz1Phcoql7aRQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/D77yx4Fahnr489W7LCqIhu0Cbd66xLl0ZcoTbeeFjjiGQQOSS1BeiaHTk2b1a6Q
         LBgWCGK6vOmTfS5r6rPy8a9vFhB+wAu7MiMfK+wZbCC/xLT9sK+JWNZLhBibQkwkbe
         GP/LI/I9ZJdYlyporOaIf9M3xwVwkzjjom9FqTVtvLhOIAqWtPOEgSBD6/TAtU57nF
         kymJUqjGWv4vy9AA94eT3/GwxyQUmq/r5ftDJZbpF9QaMZP6reDAC/DXz8GpwQ+foY
         lF6e9W9d70//W1U+r1pqy1JzCxjq5BQna8ohnZqHW8o3cdvBrJFKXV7KTL4BfRE4rW
         k2fRJgAGm+VNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 8/9] ARM: ensure the signal page contains defined contents
Date:   Mon,  8 Feb 2021 12:59:45 -0500
Message-Id: <20210208175946.2092374-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175946.2092374-1-sashal@kernel.org>
References: <20210208175946.2092374-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 9c698bff66ab4914bb3d71da7dc6112519bde23e ]

Ensure that the signal page contains our poison instruction to increase
the protection against ROP attacks and also contains well defined
contents.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/signal.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 02e6b6dfffa7e..19e4ff507209b 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -667,18 +667,20 @@ struct page *get_signal_page(void)
 
 	addr = page_address(page);
 
+	/* Poison the entire page */
+	memset32(addr, __opcode_to_mem_arm(0xe7fddef1),
+		 PAGE_SIZE / sizeof(u32));
+
 	/* Give the signal return code some randomness */
 	offset = 0x200 + (get_random_int() & 0x7fc);
 	signal_return_offset = offset;
 
-	/*
-	 * Copy signal return handlers into the vector page, and
-	 * set sigreturn to be a pointer to these.
-	 */
+	/* Copy signal return handlers into the page */
 	memcpy(addr + offset, sigreturn_codes, sizeof(sigreturn_codes));
 
-	ptr = (unsigned long)addr + offset;
-	flush_icache_range(ptr, ptr + sizeof(sigreturn_codes));
+	/* Flush out all instructions in this page */
+	ptr = (unsigned long)addr;
+	flush_icache_range(ptr, ptr + PAGE_SIZE);
 
 	return page;
 }
-- 
2.27.0

