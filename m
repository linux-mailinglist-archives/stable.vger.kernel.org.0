Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5842A15DC
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgJaLiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgJaLf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:35:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 341072074F;
        Sat, 31 Oct 2020 11:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144154;
        bh=Fc5d6HqYu1fwZuvx7GQkTaMz4kjMw5wdzWjqvAXE6nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ba9nYFkBlb8zxeHUYowgqInlfaDMRZQrSMVyTAKUJ/P4ewFvh41RSg51kj/Tl1Xbj
         Pc3xYRke7DhRMfGFWMgU+1EwfUNKaf0bZFgEadM8p9hzRhefIRoApDsh4JzKeaQZoy
         4dDzpQUM/eU+XZ9z66UzX475XXjtfKcxZSH045XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miroslav Benes <mbenes@suse.cz>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.4 03/49] objtool: Support Clang non-section symbols in ORC generation
Date:   Sat, 31 Oct 2020 12:34:59 +0100
Message-Id: <20201031113455.615829187@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit e81e0724432542af8d8c702c31e9d82f57b1ff31 upstream.

When compiling the kernel with AS=clang, objtool produces a lot of
warnings:

  warning: objtool: missing symbol for section .text
  warning: objtool: missing symbol for section .init.text
  warning: objtool: missing symbol for section .ref.text

It then fails to generate the ORC table.

The problem is that objtool assumes text section symbols always exist.
But the Clang assembler is aggressive about removing them.

When generating relocations for the ORC table, objtool always tries to
reference instructions by their section symbol offset.  If the section
symbol doesn't exist, it bails.

Do a fallback: when a section symbol isn't available, reference a
function symbol instead.

Reported-by: Dmitry Golovin <dima@golovin.in>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/669
Link: https://lkml.kernel.org/r/9a9cae7fcf628843aabe5a086b1a3c5bf50f42e8.1585761021.git.jpoimboe@redhat.com
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/objtool/orc_gen.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -88,11 +88,6 @@ static int create_orc_entry(struct secti
 	struct orc_entry *orc;
 	struct rela *rela;
 
-	if (!insn_sec->sym) {
-		WARN("missing symbol for section %s", insn_sec->name);
-		return -1;
-	}
-
 	/* populate ORC data */
 	orc = (struct orc_entry *)u_sec->data->d_buf + idx;
 	memcpy(orc, o, sizeof(*orc));
@@ -105,8 +100,32 @@ static int create_orc_entry(struct secti
 	}
 	memset(rela, 0, sizeof(*rela));
 
-	rela->sym = insn_sec->sym;
-	rela->addend = insn_off;
+	if (insn_sec->sym) {
+		rela->sym = insn_sec->sym;
+		rela->addend = insn_off;
+	} else {
+		/*
+		 * The Clang assembler doesn't produce section symbols, so we
+		 * have to reference the function symbol instead:
+		 */
+		rela->sym = find_symbol_containing(insn_sec, insn_off);
+		if (!rela->sym) {
+			/*
+			 * Hack alert.  This happens when we need to reference
+			 * the NOP pad insn immediately after the function.
+			 */
+			rela->sym = find_symbol_containing(insn_sec,
+							   insn_off - 1);
+		}
+		if (!rela->sym) {
+			WARN("missing symbol for insn at offset 0x%lx\n",
+			     insn_off);
+			return -1;
+		}
+
+		rela->addend = insn_off - rela->sym->offset;
+	}
+
 	rela->type = R_X86_64_PC32;
 	rela->offset = idx * sizeof(int);
 


