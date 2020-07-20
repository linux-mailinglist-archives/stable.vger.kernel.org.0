Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CFB226AFF
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbgGTQiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730482AbgGTPud (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:50:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE97220657;
        Mon, 20 Jul 2020 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260233;
        bh=1tA+2fHiDrinWEOULh5l8EluCQFOE21aDFPmgw/uKDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thevYuAYd3ShNXUfz/yflaeRwl7lWnQQecCv9mNTEZpVwEZX1zaQtAL3Jx+FkFgVW
         ZJpBhfaRL1O0dJHN83r5kxAOwOAV4qhIraNL1HjjnyW1r24fT3vDPq9VNY3AZmlI5B
         5AI41Q7WnN/jn7gLY9h9sx8v2Bre38kFPGct8R3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/133] arm64/alternatives: dont patch up internal branches
Date:   Mon, 20 Jul 2020 17:36:15 +0200
Message-Id: <20200720152805.094092400@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
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
index b5d603992d401..0d345622bbba2 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -44,20 +44,8 @@ struct alt_region {
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



