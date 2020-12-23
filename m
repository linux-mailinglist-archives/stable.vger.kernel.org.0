Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB332E13A6
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgLWCcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728868AbgLWCZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56D922333D;
        Wed, 23 Dec 2020 02:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690301;
        bh=q486Ccf37EISGzSH2d4Tt5pJpsZ9Y1IrmDAlGJlUEaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atIL0AdnFa/2z8ewEG0zPBwZGVqtGPC6YJYpMPDAvVXTU/Pb5PGaAbDApaC/fLeno
         H3CXbg2eofBEWS9ILnpZI9d/RB4NNeDbwf5PRaPQkbBbbiI5YRTJoa4diLh5yE6hw9
         mRihWJqbCEEz7YOVUwTXGu0ZenG2PhSxZbDby+6L6CQUBNxiVljWDjzrO6NqkyS6I6
         zYv5ysf2efgnNwa1bBeE7rJRtrxziduGDc5qVCbCtGioaNdmwPfM80u4i+NC9bEVcD
         oWgkxSpcMPukiz6Dhhw/pb960/BC6hfMJ1T1d/cx1VaPpn6rbEaDK82Viy/5Urunuy
         BX6kTyzgjHppg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jinyang He <hejinyang@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 36/48] MIPS: KASLR: Avoid endless loop in sync_icache if synci_step is zero
Date:   Tue, 22 Dec 2020 21:24:04 -0500
Message-Id: <20201223022417.2794032-36-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinyang He <hejinyang@loongson.cn>

[ Upstream commit c0aac3a51cb6364bed367ee3e1a96ed414f386b4 ]

Most platforms do not need to do synci instruction operations when
synci_step is 0. But for example, the synci implementation on Loongson64
platform has some changes. On the one hand, it ensures that the memory
access instructions have been completed. On the other hand, it guarantees
that all prefetch instructions need to be fetched again. And its address
information is useless. Thus, only one synci operation is required when
synci_step is 0 on Loongson64 platform. I guess that some other platforms
have similar implementations on synci, so add judgment conditions in
`while` to ensure that at least all platforms perform synci operations
once. For those platforms that do not need synci, they just do one more
operation similar to nop.

Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/relocate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index 1958910b75c07..f759aae1e1f3d 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -52,7 +52,7 @@ static void __init sync_icache(void *kbase, unsigned long kernel_length)
 			: "r" (kbase));
 
 		kbase += step;
-	} while (kbase < kend);
+	} while (step && kbase < kend);
 
 	/* Completion barrier */
 	__sync();
-- 
2.27.0

