Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2C2421065
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbhJDNnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237975AbhJDNlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:41:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD68163252;
        Mon,  4 Oct 2021 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353541;
        bh=B25abumW32O7lTrmIpy34XjvqDoCNMTEvWZxvNv9EUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gflZZlTB46VRQx2Z29y4DS1tZ6BQ4cWstaiIV+1FuedYCCi1janK7wwMgPzlh5oUc
         d/otdJfpNvim0k/JpqDvaiSKAGE12m9mhxSkts6LQ2S0Jb8U+xxMl8bifetAfQLbac
         Z6gOTNPK0YOToYtvt/YfxI/BbUJn+1ibwD7CkqfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Borislav Petkov <bp@alien8.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 137/172] objtool: Teach get_alt_entry() about more relocation types
Date:   Mon,  4 Oct 2021 14:53:07 +0200
Message-Id: <20211004125049.395677748@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 24ff652573754fe4c03213ebd26b17e86842feb3 ]

Occasionally objtool encounters symbol (as opposed to section)
relocations in .altinstructions. Typically they are the alternatives
written by elf_add_alternative() as encountered on a noinstr
validation run on vmlinux after having already ran objtool on the
individual .o files.

Basically this is the counterpart of commit 44f6a7c0755d ("objtool:
Fix seg fault with Clang non-section symbols"), because when these new
assemblers (binutils now also does this) strip the section symbols,
elf_add_reloc_to_insn() is forced to emit symbol based relocations.

As such, teach get_alt_entry() about different relocation types.

Fixes: 9bc0bb50727c ("objtool/x86: Rewrite retpoline thunk calls")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/YVWUvknIEVNkPvnP@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/special.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index bc925cf19e2d..f58ecc50fb10 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -58,6 +58,24 @@ void __weak arch_handle_alternative(unsigned short feature, struct special_alt *
 {
 }
 
+static bool reloc2sec_off(struct reloc *reloc, struct section **sec, unsigned long *off)
+{
+	switch (reloc->sym->type) {
+	case STT_FUNC:
+		*sec = reloc->sym->sec;
+		*off = reloc->sym->offset + reloc->addend;
+		return true;
+
+	case STT_SECTION:
+		*sec = reloc->sym->sec;
+		*off = reloc->addend;
+		return true;
+
+	default:
+		return false;
+	}
+}
+
 static int get_alt_entry(struct elf *elf, struct special_entry *entry,
 			 struct section *sec, int idx,
 			 struct special_alt *alt)
@@ -91,15 +109,12 @@ static int get_alt_entry(struct elf *elf, struct special_entry *entry,
 		WARN_FUNC("can't find orig reloc", sec, offset + entry->orig);
 		return -1;
 	}
-	if (orig_reloc->sym->type != STT_SECTION) {
-		WARN_FUNC("don't know how to handle non-section reloc symbol %s",
+	if (!reloc2sec_off(orig_reloc, &alt->orig_sec, &alt->orig_off)) {
+		WARN_FUNC("don't know how to handle reloc symbol type: %s",
 			   sec, offset + entry->orig, orig_reloc->sym->name);
 		return -1;
 	}
 
-	alt->orig_sec = orig_reloc->sym->sec;
-	alt->orig_off = orig_reloc->addend;
-
 	if (!entry->group || alt->new_len) {
 		new_reloc = find_reloc_by_dest(elf, sec, offset + entry->new);
 		if (!new_reloc) {
@@ -116,8 +131,11 @@ static int get_alt_entry(struct elf *elf, struct special_entry *entry,
 		if (arch_is_retpoline(new_reloc->sym))
 			return 1;
 
-		alt->new_sec = new_reloc->sym->sec;
-		alt->new_off = (unsigned int)new_reloc->addend;
+		if (!reloc2sec_off(new_reloc, &alt->new_sec, &alt->new_off)) {
+			WARN_FUNC("don't know how to handle reloc symbol type: %s",
+				  sec, offset + entry->new, new_reloc->sym->name);
+			return -1;
+		}
 
 		/* _ASM_EXTABLE_EX hack */
 		if (alt->new_off >= 0x7ffffff0)
-- 
2.33.0



