Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D5240E67E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346911AbhIPRV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351938AbhIPRUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F344360EE5;
        Thu, 16 Sep 2021 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810507;
        bh=4hE52cXqdxjES0qafaKTL/fZ6kRAsV34oJ66ygiGwJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doAqHOfQzwJNSVtAujX+kZ65fimAsPSpuMHto0/GKn/DtrTsw2LgbltzWP/SI5l9y
         2j6Mbss4vCotUy9PM5ErnJtDs+6UtauhwdWoCDCma61+vWq6uz3gdEDkBkjGBbcXFL
         9RBU0q+B9uATI/746O1I1ZVdkc0eU2NUZypx5NMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kajol Jain <kjain@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 134/432] powerpc/perf: Fix the check for SIAR value
Date:   Thu, 16 Sep 2021 17:58:03 +0200
Message-Id: <20210916155815.300420072@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 3c69a5f22223fa3e312689ec218b5059784d49d7 ]

Incase of random sampling, there can be scenarios where
Sample Instruction Address Register(SIAR) may not latch
to the sampled instruction and could result in
the value of 0. In these scenarios it is preferred to
return regs->nip. These corner cases are seen in the
previous generation (p9) also.

Patch adds the check for SIAR value along with regs_use_siar
and siar_valid checks so that the function will return
regs->nip incase SIAR is zero.

Patch drops the code under PPMU_P10_DD1 flag check
which handles SIAR 0 case only for Power10 DD1.

Fixes: 2ca13a4cc56c9 ("powerpc/perf: Use regs->nip when SIAR is zero")
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210818171556.36912-3-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/core-book3s.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index bb0ee716de91..b0a589409039 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2251,18 +2251,10 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
  */
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	bool use_siar = regs_use_siar(regs);
 	unsigned long siar = mfspr(SPRN_SIAR);
 
-	if (ppmu && (ppmu->flags & PPMU_P10_DD1)) {
-		if (siar)
-			return siar;
-		else
-			return regs->nip;
-	} else if (use_siar && siar_valid(regs))
-		return mfspr(SPRN_SIAR) + perf_ip_adjust(regs);
-	else if (use_siar)
-		return 0;		// no valid instruction pointer
+	if (regs_use_siar(regs) && siar_valid(regs) && siar)
+		return siar + perf_ip_adjust(regs);
 	else
 		return regs->nip;
 }
-- 
2.30.2



