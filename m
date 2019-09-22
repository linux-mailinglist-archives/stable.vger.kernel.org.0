Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D92BAA7E
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbfIVT1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389239AbfIVSvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:51:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 206A82190F;
        Sun, 22 Sep 2019 18:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178292;
        bh=R84mSIxpEX1AcPIuhZJU0uwLWQyn3K4b+Mpvg9kxH0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w828XU5XTSqHDlxHcHTW0AqJRFmC/uqWFpFnl4zlptLMWeztF27u6sBSRpCmoQNEE
         G9ZwQFi9xagDGvuXLkS0Ljc2FIaHVKCWqvs5AQOIpC1wG1BgseAySdn8xYu2qB2h32
         +3leoru6QwDBnEPf5HsU5I6Ck2e8cSORMEikgNUs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 069/185] ARM: xscale: fix multi-cpu compilation
Date:   Sun, 22 Sep 2019 14:47:27 -0400
Message-Id: <20190922184924.32534-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c7b68049943079550d4e6af0f10aa3aabd64131a ]

Building a combined ARMv4+XScale kernel produces these
and other build failures:

/tmp/copypage-xscale-3aa821.s: Assembler messages:
/tmp/copypage-xscale-3aa821.s:167: Error: selected processor does not support `pld [r7,#0]' in ARM mode
/tmp/copypage-xscale-3aa821.s:168: Error: selected processor does not support `pld [r7,#32]' in ARM mode
/tmp/copypage-xscale-3aa821.s:169: Error: selected processor does not support `pld [r1,#0]' in ARM mode
/tmp/copypage-xscale-3aa821.s:170: Error: selected processor does not support `pld [r1,#32]' in ARM mode
/tmp/copypage-xscale-3aa821.s:171: Error: selected processor does not support `pld [r7,#64]' in ARM mode
/tmp/copypage-xscale-3aa821.s:176: Error: selected processor does not support `ldrd r4,r5,[r7],#8' in ARM mode
/tmp/copypage-xscale-3aa821.s:180: Error: selected processor does not support `strd r4,r5,[r1],#8' in ARM mode

Add an explict .arch armv5 in the inline assembly to allow the ARMv5
specific instructions regardless of the compiler -march= target.

Link: https://lore.kernel.org/r/20190809163334.489360-5-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/copypage-xscale.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/copypage-xscale.c b/arch/arm/mm/copypage-xscale.c
index 61d834157bc05..382e1c2855e85 100644
--- a/arch/arm/mm/copypage-xscale.c
+++ b/arch/arm/mm/copypage-xscale.c
@@ -42,6 +42,7 @@ static void mc_copy_user_page(void *from, void *to)
 	 * when prefetching destination as well.  (NP)
 	 */
 	asm volatile ("\
+.arch xscale					\n\
 	pld	[%0, #0]			\n\
 	pld	[%0, #32]			\n\
 	pld	[%1, #0]			\n\
@@ -106,8 +107,9 @@ void
 xscale_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
 	void *ptr, *kaddr = kmap_atomic(page);
-	asm volatile(
-	"mov	r1, %2				\n\
+	asm volatile("\
+.arch xscale					\n\
+	mov	r1, %2				\n\
 	mov	r2, #0				\n\
 	mov	r3, #0				\n\
 1:	mov	ip, %0				\n\
-- 
2.20.1

