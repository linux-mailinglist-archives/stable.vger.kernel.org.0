Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06FF32AF13
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhCCAO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244617AbhCBMBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC5764F0E;
        Tue,  2 Mar 2021 11:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686160;
        bh=pyvkKG6xNO25r+4NNTsksYyuERDmsedBHxXCzBO9PFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iv4cCGaWqWZoPq3INuBTIf7aDQqupQWv77lowlhEslG4iatiMa5s1h4ErP9hI3YRN
         jk2ggcvgYINkDhDWbf5oMXWlNjbv3SMs3FqqINsDtGVJXg7ZpZpqU/sy//yIRSvlJn
         PJ04T3N4fIzLMJmPRuOQDc0GnGDjZRD+GlBy0OOt9N3hdQ+mT9pmc95g69iDKzLccJ
         AeMxsvTtPL/WVsZ0VtTNhvBPtaHWvdn0EFpxjaQGVzfO/Dxb9IbcWpBCfTyPUle8ib
         /OG1Rwi0tcz3GWw7wZEYJ8KAtrwkF+yXKyasTZTYsy4heYEEQRGB9r873aLxMH+fxX
         KQLU+4314uf4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.11 19/52] powerpc: improve handling of unrecoverable system reset
Date:   Tue,  2 Mar 2021 06:55:00 -0500
Message-Id: <20210302115534.61800-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 11cb0a25f71818ca7ab4856548ecfd83c169aa4d ]

If an unrecoverable system reset hits in process context, the system
does not have to panic. Similar to machine check, call nmi_exit()
before die().

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210130130852.2952424-26-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 3ec7b443fe6b..4be05517f2db 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -503,8 +503,11 @@ out:
 		die("Unrecoverable nested System Reset", regs, SIGABRT);
 #endif
 	/* Must die if the interrupt is not recoverable */
-	if (!(regs->msr & MSR_RI))
+	if (!(regs->msr & MSR_RI)) {
+		/* For the reason explained in die_mce, nmi_exit before die */
+		nmi_exit();
 		die("Unrecoverable System Reset", regs, SIGABRT);
+	}
 
 	if (saved_hsrrs) {
 		mtspr(SPRN_HSRR0, hsrr0);
-- 
2.30.1

