Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD9B27CC51
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732782AbgI2MfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729586AbgI2LVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:21:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5F31239EE;
        Tue, 29 Sep 2020 11:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378338;
        bh=jhXXHiBwabz0eO6Y6MDYyI2GS5Y/LweyJRvHgKRcuMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5OzaB51TwdtQyqqRArh9+Tkfz30O1pOKPZjbYNQrKdYZ9aHjWHPN4YPlpy373DCc
         tFaBVW8GbudG0CFI8LH0jNbUwqGnDqW8FNUI+zs2dnlTVtxid2oCLoUWKFYdnHCSeQ
         O9P/9TIyyAW30XJxDfcnWtwXpKtA9FyBFT4fSCqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 145/166] objtool: Fix noreturn detection for ignored functions
Date:   Tue, 29 Sep 2020 13:00:57 +0200
Message-Id: <20200929105942.438280216@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit db6c6a0df840e3f52c84cc302cc1a08ba11a4416 ]

When a function is annotated with STACK_FRAME_NON_STANDARD, objtool
doesn't validate its code paths.  It also skips sibling call detection
within the function.

But sibling call detection is actually needed for the case where the
ignored function doesn't have any return instructions.  Otherwise
objtool naively marks the function as implicit static noreturn, which
affects the reachability of its callers, resulting in "unreachable
instruction" warnings.

Fix it by just enabling sibling call detection for ignored functions.
The 'insn->ignore' check in add_jump_destinations() is no longer needed
after

  e6da9567959e ("objtool: Don't use ignore flag for fake jumps").

Fixes the following warning:

  arch/x86/kvm/vmx/vmx.o: warning: objtool: vmx_handle_exit_irqoff()+0x142: unreachable instruction

which triggers on an allmodconfig with CONFIG_GCOV_KERNEL unset.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lkml.kernel.org/r/5b1e2536cdbaa5246b60d7791b76130a74082c62.1599751464.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 247fbb5f6a389..2c8e2dae17016 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -502,7 +502,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		    insn->type != INSN_JUMP_UNCONDITIONAL)
 			continue;
 
-		if (insn->ignore || insn->offset == FAKE_JUMP_OFFSET)
+		if (insn->offset == FAKE_JUMP_OFFSET)
 			continue;
 
 		rela = find_rela_by_dest_range(insn->sec, insn->offset,
-- 
2.25.1



