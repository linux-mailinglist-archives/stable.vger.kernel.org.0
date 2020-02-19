Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0130A164265
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 11:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgBSKlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 05:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgBSKlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 05:41:36 -0500
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A1CE2465D;
        Wed, 19 Feb 2020 10:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582108896;
        bh=U6to4otLXJGLB13o6RzYw7pCZ5asKRv2pkOtt9vkGms=;
        h=From:To:Cc:Subject:Date:From;
        b=xl4Cp7xBchKZx9ZkeBPRExGYG3NrRV2PCihn+lHV5zD4r84NXFh3jeHZKCrz6r2IB
         GbtBQXOvH1G2/XsA22xsoXbh810x0EcpVZ4wvS7EWnE9NZwBWG5MKcrp5YAFMJWs5B
         jBjWek1zesELJmvQUDOSwpAsGZAHZLBL2AUA/rQo=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] arm64: memory: Add missing brackets to untagged_addr() macro
Date:   Wed, 19 Feb 2020 10:41:31 +0000
Message-Id: <20200219104131.18960-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add brackets around the evaluation of the 'addr' parameter to the
untagged_addr() macro so that the case to 'u64' applies to the result
of the expression.

Cc: <stable@vger.kernel.org>
Fixes: 597399d0cb91 ("arm64: tags: Preserve tags for addresses translated via TTBR1")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/memory.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index a4f9ca5479b0..4d94676e5a8b 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -213,7 +213,7 @@ static inline unsigned long kaslr_offset(void)
 	((__force __typeof__(addr))sign_extend64((__force u64)(addr), 55))
 
 #define untagged_addr(addr)	({					\
-	u64 __addr = (__force u64)addr;					\
+	u64 __addr = (__force u64)(addr);					\
 	__addr &= __untagged_addr(__addr);				\
 	(__force __typeof__(addr))__addr;				\
 })
-- 
2.25.0.265.gbab2e86ba0-goog

