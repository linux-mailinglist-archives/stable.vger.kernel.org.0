Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B95D57236D
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiGLSrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbiGLSrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:47:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFA1DD236;
        Tue, 12 Jul 2022 11:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 120F4B81BB9;
        Tue, 12 Jul 2022 18:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E67C3411C;
        Tue, 12 Jul 2022 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651382;
        bh=p69Pkhj7FSTSQGKzGUI/7ybWeLAgcbtPAlo52bDLKgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWI5SDZ0qTT9/exp53pXM+ZyAwTWn4OCrUazT04A0BxpMcbJNgfGafKhzr+TZ/vlb
         DjCzRNoTuEaAa4KgZkOWlfp3EED5j5VQ9z7tsYTrKKbCuH19uEG4AtEUKVgb/XUEHU
         FEXCVJspPFMUX+eIOS+0TZGhhVc5xmmYaG79rdO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 042/130] objtool: print out the symbol type when complaining about it
Date:   Tue, 12 Jul 2022 20:38:08 +0200
Message-Id: <20220712183248.351269760@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 7fab1c12bde926c5a8c7d5984c551d0854d7e0b3 upstream.

The objtool warning that the kvm instruction emulation code triggered
wasn't very useful:

    arch/x86/kvm/emulate.o: warning: objtool: __ex_table+0x4: don't know how to handle reloc symbol type: kvm_fastop_exception

in that it helpfully tells you which symbol name it had trouble figuring
out the relocation for, but it doesn't actually say what the unknown
symbol type was that triggered it all.

In this case it was because of missing type information (type 0, aka
STT_NOTYPE), but on the whole it really should just have printed that
out as part of the message.

Because if this warning triggers, that's very much the first thing you
want to know - why did reloc2sec_off() return failure for that symbol?

So rather than just saying you can't handle some type of symbol without
saying what the type _was_, just print out the type number too.

Fixes: 24ff65257375 ("objtool: Teach get_alt_entry() about more relocation types")
Link: https://lore.kernel.org/lkml/CAHk-=wiZwq-0LknKhXN4M+T8jbxn_2i9mcKpO+OaBSSq_Eh7tg@mail.gmail.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/special.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -106,8 +106,10 @@ static int get_alt_entry(struct elf *elf
 		return -1;
 	}
 	if (!reloc2sec_off(orig_reloc, &alt->orig_sec, &alt->orig_off)) {
-		WARN_FUNC("don't know how to handle reloc symbol type: %s",
-			   sec, offset + entry->orig, orig_reloc->sym->name);
+		WARN_FUNC("don't know how to handle reloc symbol type %d: %s",
+			   sec, offset + entry->orig,
+			   orig_reloc->sym->type,
+			   orig_reloc->sym->name);
 		return -1;
 	}
 
@@ -128,8 +130,10 @@ static int get_alt_entry(struct elf *elf
 			return 1;
 
 		if (!reloc2sec_off(new_reloc, &alt->new_sec, &alt->new_off)) {
-			WARN_FUNC("don't know how to handle reloc symbol type: %s",
-				  sec, offset + entry->new, new_reloc->sym->name);
+			WARN_FUNC("don't know how to handle reloc symbol type %d: %s",
+				  sec, offset + entry->new,
+				  new_reloc->sym->type,
+				  new_reloc->sym->name);
 			return -1;
 		}
 


