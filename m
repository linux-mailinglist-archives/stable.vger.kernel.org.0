Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8CF32162B
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhBVMTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230446AbhBVMQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:16:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3F9364EDB;
        Mon, 22 Feb 2021 12:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996168;
        bh=Qrgn96LrMm5xRqQANseyCsxjhxCwOScm9LAMBr/qeWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pr9kBZfnjJyJRauKu8X3QFrM6hT57VioFAS3kbPCQc/Ok6sdUrKGqza3/9i4MSOHk
         p9oQpAzOxN6CF2Wtqm1DVKAI34gC+yfnK+vrxVhozxC75pBGVuIbnBM66yk3Jm2wpO
         8pE7h/j827rRic4Fw3FCkjUGTPAV91bMPiI3btQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/50] ARM: ensure the signal page contains defined contents
Date:   Mon, 22 Feb 2021 13:13:05 +0100
Message-Id: <20210222121022.364481842@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b908382b69ff5..1c01358b9b6db 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -697,18 +697,20 @@ struct page *get_signal_page(void)
 
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



