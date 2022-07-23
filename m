Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677F357EDBC
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237772AbiGWKCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbiGWKBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:01:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9BC7969C;
        Sat, 23 Jul 2022 02:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F1ADB82B92;
        Sat, 23 Jul 2022 09:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE17DC341C7;
        Sat, 23 Jul 2022 09:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570315;
        bh=Z0Ife+YnzVRgmcIv2ueknAX3OEj7I9mFJI5lNXufmyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKNtpT5iN2pBTr9/NWVfBbwMooEQOs1dpHhE9myPA5GDcgAs4o737JX983j2697pv
         5DMzO5RmONqlil3N8Oi9NL0gxp1RGY2MiVElfhmPIkoJa5lh4bYKYsKcjmOW4q3nSO
         j+f6TGTOxDrUxi0tKM21lWbPO5vqHG/ykYm33QTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 043/148] objtool: Remove reloc symbol type checks in get_alt_entry()
Date:   Sat, 23 Jul 2022 11:54:15 +0200
Message-Id: <20220723095236.390915078@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 4d8b35968bbf9e42b6b202eedb510e2c82ad8b38 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/special.c |   36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -55,22 +55,11 @@ void __weak arch_handle_alternative(unsi
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
@@ -105,13 +94,8 @@ static int get_alt_entry(struct elf *elf
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
@@ -129,13 +113,7 @@ static int get_alt_entry(struct elf *elf
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


