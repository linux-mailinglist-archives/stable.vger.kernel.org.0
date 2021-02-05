Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940F831143F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhBEWC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:02:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232837AbhBEOye (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC31465028;
        Fri,  5 Feb 2021 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534296;
        bh=Vc+XaFPpPgaKd/O8Zcj/k/f9jRzHIKNPTFM6D9De5Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4bGe+HiPIrSHCiruTncsok8iYuOQ12E8M2bl0pc3sRlthIaShtubZw4Ct41K+vP+
         B9i8vpMpzJN5a3uGHRDl10MBkF0vSLEF+Hs7aTFJ9phDhUhnpJvanqTgTQ/hRfA/DW
         bPhZtgKtqw2ALdQBremAacIp1g/UAnl8TibPJhIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/57] objtool: Dont add empty symbols to the rbtree
Date:   Fri,  5 Feb 2021 15:06:57 +0100
Message-Id: <20210205140657.300782881@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit a2e38dffcd93541914aba52b30c6a52acca35201 ]

Building with the Clang assembler shows the following warning:

  arch/x86/kernel/ftrace_64.o: warning: objtool: missing symbol for insn at offset 0x16

The Clang assembler strips section symbols.  That ends up giving
objtool's find_func_containing() much more test coverage than normal.
Turns out, find_func_containing() doesn't work so well for overlapping
symbols:

     2: 000000000000000e     0 NOTYPE  LOCAL  DEFAULT    2 fgraph_trace
     3: 000000000000000f     0 NOTYPE  LOCAL  DEFAULT    2 trace
     4: 0000000000000000   165 FUNC    GLOBAL DEFAULT    2 __fentry__
     5: 000000000000000e     0 NOTYPE  GLOBAL DEFAULT    2 ftrace_stub

The zero-length NOTYPE symbols are inside __fentry__(), confusing the
rbtree search for any __fentry__() offset coming after a NOTYPE.

Try to avoid this problem by not adding zero-length symbols to the
rbtree.  They're rare and aren't needed in the rbtree anyway.

One caveat, this actually might not end up being the right fix.
Non-empty overlapping symbols, if they exist, could have the same
problem.  But that would need bigger changes, let's see if we can get
away with the easy fix for now.

Reported-by: Arnd Bergmann <arnd@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 9452cfb01ef19..f4f3e8d995930 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -425,6 +425,13 @@ static int read_symbols(struct elf *elf)
 		list_add(&sym->list, entry);
 		elf_hash_add(elf->symbol_hash, &sym->hash, sym->idx);
 		elf_hash_add(elf->symbol_name_hash, &sym->name_hash, str_hash(sym->name));
+
+		/*
+		 * Don't store empty STT_NOTYPE symbols in the rbtree.  They
+		 * can exist within a function, confusing the sorting.
+		 */
+		if (!sym->len)
+			rb_erase(&sym->node, &sym->sec->symbol_tree);
 	}
 
 	if (stats)
-- 
2.27.0



