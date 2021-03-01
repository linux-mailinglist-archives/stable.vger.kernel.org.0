Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB27328DBF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241051AbhCATQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241133AbhCATMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:12:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CA2C651D7;
        Mon,  1 Mar 2021 17:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619066;
        bh=ojeTjuDY35/u129zo93H02dlPVWhaoTGm7cCGJ+NniU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cj42+949m6EgssOWuiodftXKGZ8g9Au3XERGzJAFGGnZIe3UP/AsH2SSOp2+uzHj8
         +1CLZY5FCrvXqaXb3WOtmV2RdVh6jP58Eb5BC+3Q9JUDLS/oP44lltq7bnNPUa/w6C
         ZR0u+IpGzihgYQiEpxOiIjZ1kEqPn2ncDLEF7zq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/663] objtool: Fix retpoline detection in asm code
Date:   Mon,  1 Mar 2021 17:09:27 +0100
Message-Id: <20210301161157.636120210@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 1f9a1b74942485a0a29e7c4a9a9f2fe8aea17766 ]

The JMP_NOSPEC macro branches to __x86_retpoline_*() rather than the
__x86_indirect_thunk_*() wrappers used by C code.  Detect jumps to
__x86_retpoline_*() as retpoline dynamic jumps.

Presumably this doesn't trigger a user-visible bug.  I only found it
when testing vmlinux.o validation.

Fixes: 39b735332cb8 ("objtool: Detect jumps to retpoline thunks")
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/31f5833e2e4f01e3d755889ac77e3661e906c09f.1611263461.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/x86/special.c |  2 +-
 tools/objtool/check.c            |  3 ++-
 tools/objtool/check.h            | 11 +++++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/arch/x86/special.c b/tools/objtool/arch/x86/special.c
index fd4af88c0ea52..151b13d0a2676 100644
--- a/tools/objtool/arch/x86/special.c
+++ b/tools/objtool/arch/x86/special.c
@@ -48,7 +48,7 @@ bool arch_support_alt_relocation(struct special_alt *special_alt,
 	 * replacement group.
 	 */
 	return insn->offset == special_alt->new_off &&
-	       (insn->type == INSN_CALL || is_static_jump(insn));
+	       (insn->type == INSN_CALL || is_jump(insn));
 }
 
 /*
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 2e154f00ccec2..48e22e3c6f186 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -789,7 +789,8 @@ static int add_jump_destinations(struct objtool_file *file)
 			dest_sec = reloc->sym->sec;
 			dest_off = reloc->sym->sym.st_value +
 				   arch_dest_reloc_offset(reloc->addend);
-		} else if (strstr(reloc->sym->name, "_indirect_thunk_")) {
+		} else if (!strncmp(reloc->sym->name, "__x86_indirect_thunk_", 21) ||
+			   !strncmp(reloc->sym->name, "__x86_retpoline_", 16)) {
 			/*
 			 * Retpoline jumps are really dynamic jumps in
 			 * disguise, so convert them accordingly.
diff --git a/tools/objtool/check.h b/tools/objtool/check.h
index 5ec00a4b891b6..2804848e628e3 100644
--- a/tools/objtool/check.h
+++ b/tools/objtool/check.h
@@ -54,6 +54,17 @@ static inline bool is_static_jump(struct instruction *insn)
 	       insn->type == INSN_JUMP_UNCONDITIONAL;
 }
 
+static inline bool is_dynamic_jump(struct instruction *insn)
+{
+	return insn->type == INSN_JUMP_DYNAMIC ||
+	       insn->type == INSN_JUMP_DYNAMIC_CONDITIONAL;
+}
+
+static inline bool is_jump(struct instruction *insn)
+{
+	return is_static_jump(insn) || is_dynamic_jump(insn);
+}
+
 struct instruction *find_insn(struct objtool_file *file,
 			      struct section *sec, unsigned long offset);
 
-- 
2.27.0



