Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74D757EDBF
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbiGWKCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiGWKBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:01:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781E661101;
        Sat, 23 Jul 2022 02:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B95D2CE0DC2;
        Sat, 23 Jul 2022 09:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD22C341C0;
        Sat, 23 Jul 2022 09:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570321;
        bh=yEjzjL/duoq1Md+YLkmgI3lo63MssRrpZ/IVKlR4NWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0qp9kZV7RsdyzWlN2drKT7LT3LJ3KpbLIcJyPSvoo5bdKydsWGqddBavLKSBG8A5
         6oClmzZqISaADhaUfoKeMkFC5KyuvqXqlR6rJCfG6ttQpuMZ4ETL/1m9yOC2pkEct3
         KthF0dJgAVcLMYOnO2NBUfgCILZWwJRmeK9OrCag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 035/148] objtool: Support asm jump tables
Date:   Sat, 23 Jul 2022 11:54:07 +0200
Message-Id: <20220723095234.140361076@linuxfoundation.org>
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

commit 99033461e685b48549ec77608b4bda75ddf772ce upstream.

Objtool detection of asm jump tables would normally just work, except
for the fact that asm retpolines use alternatives.  Objtool thinks the
alternative code path (a jump to the retpoline) is a sibling call.

Don't treat alternative indirect branches as sibling calls when the
original instruction has a jump table.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Link: https://lore.kernel.org/r/460cf4dc675d64e1124146562cabd2c05aa322e8.1614182415.git.jpoimboe@redhat.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -107,6 +107,18 @@ static struct instruction *prev_insn_sam
 	for (insn = next_insn_same_sec(file, insn); insn;		\
 	     insn = next_insn_same_sec(file, insn))
 
+static bool is_jump_table_jump(struct instruction *insn)
+{
+	struct alt_group *alt_group = insn->alt_group;
+
+	if (insn->jump_table)
+		return true;
+
+	/* Retpoline alternative for a jump table? */
+	return alt_group && alt_group->orig_group &&
+	       alt_group->orig_group->first_insn->jump_table;
+}
+
 static bool is_sibling_call(struct instruction *insn)
 {
 	/*
@@ -119,7 +131,7 @@ static bool is_sibling_call(struct instr
 
 	/* An indirect jump is either a sibling call or a jump to a table. */
 	if (insn->type == INSN_JUMP_DYNAMIC)
-		return list_empty(&insn->alts);
+		return !is_jump_table_jump(insn);
 
 	/* add_jump_destinations() sets insn->call_dest for sibling calls. */
 	return (is_static_jump(insn) && insn->call_dest);


