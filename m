Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BEC26EC6C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgIRCLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbgIRCLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FFEF208E4;
        Fri, 18 Sep 2020 02:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395082;
        bh=FYsT9KfWnWhlZjA8kDJ4p//bZ/GFoFMExTtd/EDIMBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XGR7Gj5nW4t0hToLI8tldy57lcd7bn6dkM2XDvT4rvEsT0xSFHoFF/3YY1MIGL5f
         jzvJ8RmVonjjnY/P7E5JmBz7tq7nvXU4iQvEPhR7fO4zHmantxRTU57L9ekycoXEzx
         Fzo8Hc1l4/wPeajw9W+g4V7BGbzxAYp0IVgOQgTM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 165/206] powerpc/traps: Make unrecoverable NMIs die instead of panic
Date:   Thu, 17 Sep 2020 22:07:21 -0400
Message-Id: <20200918020802.2065198-165-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 265d6e588d87194c2fe2d6c240247f0264e0c19b ]

System Reset and Machine Check interrupts that are not recoverable due
to being nested or interrupting when RI=0 currently panic. This is not
necessary, and can often just kill the current context and recover.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Link: https://lore.kernel.org/r/20200508043408.886394-16-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index d5f351f02c153..7781f0168ce8c 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -430,11 +430,11 @@ out:
 #ifdef CONFIG_PPC_BOOK3S_64
 	BUG_ON(get_paca()->in_nmi == 0);
 	if (get_paca()->in_nmi > 1)
-		nmi_panic(regs, "Unrecoverable nested System Reset");
+		die("Unrecoverable nested System Reset", regs, SIGABRT);
 #endif
 	/* Must die if the interrupt is not recoverable */
 	if (!(regs->msr & MSR_RI))
-		nmi_panic(regs, "Unrecoverable System Reset");
+		die("Unrecoverable System Reset", regs, SIGABRT);
 
 	if (!nested)
 		nmi_exit();
@@ -775,7 +775,7 @@ void machine_check_exception(struct pt_regs *regs)
 
 	/* Must die if the interrupt is not recoverable */
 	if (!(regs->msr & MSR_RI))
-		nmi_panic(regs, "Unrecoverable Machine check");
+		die("Unrecoverable Machine check", regs, SIGBUS);
 
 	return;
 
-- 
2.25.1

