Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928F515EFEB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgBNRv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:51:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388711AbgBNP6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A98D2082F;
        Fri, 14 Feb 2020 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695931;
        bh=erFRMLR9IzhmKMg/3FdZYPI3TuSoYfb9KD3j/IgNGgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LaIayJLdB15ZysijlG3u3FiWHmA0wnbQJHfIno9GWxIs1kua1Ys4GbcsCQyoz0dbH
         eQXRRGJwLJ6XWS86hwbaNvstb9ptIcxyHfghpahpix5ajNVd7NR2fUt5X809djDLug
         QK81CPZ6iFGSGxtQK7PZYrSag++wTsj8jJFAZ7Ms=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 467/542] ARM: 8949/1: mm: mark free_memmap as __init
Date:   Fri, 14 Feb 2020 10:47:39 -0500
Message-Id: <20200214154854.6746-467-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

[ Upstream commit 31f3010e60522ede237fb145a63b4af5a41718c2 ]

As of commit ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING
forcibly"), free_memmap() might not always be inlined, and thus is
triggering a section warning:

WARNING: vmlinux.o(.text.unlikely+0x904): Section mismatch in reference from the function free_memmap() to the function .meminit.text:memblock_free()

Mark it as __init, since the faller (free_unused_memmap) already is.

Fixes: ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING forcibly")
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 3ef204137e732..054be44d1cdb4 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -324,7 +324,7 @@ static inline void poison_init_mem(void *s, size_t count)
 		*p++ = 0xe7fddef0;
 }
 
-static inline void
+static inline void __init
 free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct page *start_pg, *end_pg;
-- 
2.20.1

