Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58E1313C53
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhBHSFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhBHSAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C67B64ECD;
        Mon,  8 Feb 2021 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807127;
        bh=ft4G97VhIjJwaES8UFkwK1Ab7kaT0oqcang245BltCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOkVzrCQhj4GUHh7tPRK90Gp0bzA07PDFzoqV7AyMTEzO2JdAGkKASkRX8cYv6Pe/
         97gwCYe+o/Wo9ljzW9uhO1SZemp7y/gdN6z4sWK9OCg/64F58OpeEMnqBMc5dtCdwV
         QE6VO4Kc8k5pIlPsGP/qLOuKSG9MXVKtHyIWRpd9lFnI4SEZ9n935klmEnsojqrAr8
         Z0lA7Bdi4JHNLju8ipu+PeEuM14WZhAA2DHFI3eEIz8Nvk/UAYZly66v2He5iDoE+S
         IM+IedzLgySbw5a/AuVoWMIX4Idx0TlcuvW+eon9O+mjIV4ItzR/WB8Vm9A3R1PlUl
         g/eTHobU3Y5nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 30/36] ARM: ensure the signal page contains defined contents
Date:   Mon,  8 Feb 2021 12:58:00 -0500
Message-Id: <20210208175806.2091668-30-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
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
index 585edbfccf6df..2f81d3af5f9af 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -693,18 +693,20 @@ struct page *get_signal_page(void)
 
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

