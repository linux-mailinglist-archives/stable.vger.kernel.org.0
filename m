Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD74290E5
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbhJKOOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243357AbhJKOLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:11:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64C9F6108F;
        Mon, 11 Oct 2021 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960982;
        bh=vmB9cTWWIwuK4nCLY9E66RHiGvgHjoJwABq4pRAy71A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osyEqvPMfHrD4O/qUyyfNimhqb27GioIW3gUSnl50dFwd7KNiw+bqGzvqo7gUwfRD
         N8gEIEbTNsDAYxWkDifWmz0Cp7ar7l2HraB0cfvEeA3gDvl+g84lMTS2nWV9ZXPCZp
         0p0t87S8xsTbPzdVuwIAM4gp9CuKdZ+y2nnOL5IU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 131/151] objtool: Remove reloc symbol type checks in get_alt_entry()
Date:   Mon, 11 Oct 2021 15:46:43 +0200
Message-Id: <20211011134522.038399207@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 4d8b35968bbf9e42b6b202eedb510e2c82ad8b38 ]

Converting a special section's relocation reference to a symbol is
straightforward.  No need for objtool to complain that it doesn't know
how to handle it.  Just handle it.

This fixes the following warning:

  arch/x86/kvm/emulate.o: warning: objtool: __ex_table+0x4: don't know how to handle reloc symbol type: kvm_fastop_exception

Fixes: 24ff65257375 ("objtool: Teach get_alt_entry() about more relocation types")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/feadbc3dfb3440d973580fad8d3db873cbfe1694.1633367242.git.jpoimboe@redhat.com
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/special.c | 36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index f1428e32a505..83d5f969bcb0 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -58,22 +58,11 @@ void __weak arch_handle_alternative(unsigned short feature, struct special_alt *
 {
 }
 
-static bool reloc2sec_off(struct reloc *reloc, struct section **sec, unsigned long *off)
+static void reloc_to_sec_off(struct reloc *reloc, struct section **sec,
+			     unsigned long *off)
 {
-	switch (reloc->sym->type) {
-	case STT_FUNC:
-		*sec = reloc->sym->sec;
-		*off = reloc->sym->offset + reloc->addend;
-		return true;
-
-	case STT_SECTION:
-		*sec = reloc->sym->sec;
-		*off = reloc->addend;
-		return true;
-
-	default:
-		return false;
-	}
+	*sec = reloc->sym->sec;
+	*off = reloc->sym->offset + reloc->addend;
 }
 
 static int get_alt_entry(struct elf *elf, struct special_entry *entry,
@@ -109,13 +98,8 @@ static int get_alt_entry(struct elf *elf, struct special_entry *entry,
 		WARN_FUNC("can't find orig reloc", sec, offset + entry->orig);
 		return -1;
 	}
-	if (!reloc2sec_off(orig_reloc, &alt->orig_sec, &alt->orig_off)) {
-		WARN_FUNC("don't know how to handle reloc symbol type %d: %s",
-			   sec, offset + entry->orig,
-			   orig_reloc->sym->type,
-			   orig_reloc->sym->name);
-		return -1;
-	}
+
+	reloc_to_sec_off(orig_reloc, &alt->orig_sec, &alt->orig_off);
 
 	if (!entry->group || alt->new_len) {
 		new_reloc = find_reloc_by_dest(elf, sec, offset + entry->new);
@@ -133,13 +117,7 @@ static int get_alt_entry(struct elf *elf, struct special_entry *entry,
 		if (arch_is_retpoline(new_reloc->sym))
 			return 1;
 
-		if (!reloc2sec_off(new_reloc, &alt->new_sec, &alt->new_off)) {
-			WARN_FUNC("don't know how to handle reloc symbol type %d: %s",
-				  sec, offset + entry->new,
-				  new_reloc->sym->type,
-				  new_reloc->sym->name);
-			return -1;
-		}
+		reloc_to_sec_off(new_reloc, &alt->new_sec, &alt->new_off);
 
 		/* _ASM_EXTABLE_EX hack */
 		if (alt->new_off >= 0x7ffffff0)
-- 
2.33.0



