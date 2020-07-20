Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF8D2269F9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbgGTP5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731627AbgGTP5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:57:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14BB72065E;
        Mon, 20 Jul 2020 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260649;
        bh=egxt+OqgdvW57MofFR/h1DolS9Q1TbBM33DDluq4gHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yugVC8FI/y9+Jvc+wMxY01RADixhc+Z5RfBkLZluvwy9QG+QoR3hPV0EW1ERCy3+F
         K+RSuV/eCO5nBKCtDyUr2n17dZLKN+aj4wXRHhBnl1pMwm3P+ry0W9i8bDgMxHbKC+
         VsguS6vaqtelVw4lZx81kknopWR9sahkwkR2iNGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/215] arm64/alternatives: dont patch up internal branches
Date:   Mon, 20 Jul 2020 17:35:27 +0200
Message-Id: <20200720152822.340606082@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 5679b28142193a62f6af93249c0477be9f0c669b ]

Commit f7b93d42945c ("arm64/alternatives: use subsections for replacement
sequences") moved the alternatives replacement sequences into subsections,
in order to keep the as close as possible to the code that they replace.

Unfortunately, this broke the logic in branch_insn_requires_update,
which assumed that any branch into kernel executable code was a branch
that required updating, which is no longer the case now that the code
sequences that are patched in are in the same section as the patch site
itself.

So the only way to discriminate branches that require updating and ones
that don't is to check whether the branch targets the replacement sequence
itself, and so we can drop the call to kernel_text_address() entirely.

Fixes: f7b93d42945c ("arm64/alternatives: use subsections for replacement sequences")
Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/20200709125953.30918-1-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/alternative.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index d1757ef1b1e74..73039949b5ce2 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -43,20 +43,8 @@ bool alternative_is_applied(u16 cpufeature)
  */
 static bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
 {
-	unsigned long replptr;
-
-	if (kernel_text_address(pc))
-		return true;
-
-	replptr = (unsigned long)ALT_REPL_PTR(alt);
-	if (pc >= replptr && pc <= (replptr + alt->alt_len))
-		return false;
-
-	/*
-	 * Branching into *another* alternate sequence is doomed, and
-	 * we're not even trying to fix it up.
-	 */
-	BUG();
+	unsigned long replptr = (unsigned long)ALT_REPL_PTR(alt);
+	return !(pc >= replptr && pc <= (replptr + alt->alt_len));
 }
 
 #define align_down(x, a)	((unsigned long)(x) & ~(((unsigned long)(a)) - 1))
-- 
2.25.1



