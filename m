Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC3657235C
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbiGLSpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbiGLSpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:45:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68A9DB2C2;
        Tue, 12 Jul 2022 11:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73EFDB81B96;
        Tue, 12 Jul 2022 18:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF5DC3411C;
        Tue, 12 Jul 2022 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651346;
        bh=XZe6mZDywRYuCTJTB4/Kt7NN12giWZC5dpHCMsUZakg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpsp3vEoFY6p3C7/Bx/o3sZVMacTkxc/99brFav3Kx62Z4eKfDPuqs249b6FAwHZa
         vUzAL1sRII2Bm9OwY78mEDDIYTEZoaZoxXkH/x2NXNNf0eExjte1yXCIHAguJ146wO
         LPeEvKSsEo6AWP0Rkyf1GOUVyjkOExD7gJqOv/jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Borislav Petkov <bp@alien8.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 041/130] objtool: Teach get_alt_entry() about more relocation types
Date:   Tue, 12 Jul 2022 20:38:07 +0200
Message-Id: <20220712183248.303544818@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 24ff652573754fe4c03213ebd26b17e86842feb3 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/special.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -55,6 +55,24 @@ void __weak arch_handle_alternative(unsi
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
@@ -87,15 +105,12 @@ static int get_alt_entry(struct elf *elf
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
@@ -112,8 +127,11 @@ static int get_alt_entry(struct elf *elf
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


