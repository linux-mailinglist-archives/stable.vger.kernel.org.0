Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB0F572310
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiGLSnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbiGLSmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:42:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99273C4451;
        Tue, 12 Jul 2022 11:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8BBFCE1D85;
        Tue, 12 Jul 2022 18:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3414C3411C;
        Tue, 12 Jul 2022 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651304;
        bh=yEjzjL/duoq1Md+YLkmgI3lo63MssRrpZ/IVKlR4NWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEKpbAUsnODy7sKiJBmT2xEnB774nukLK9qWm93rxuD5XA9/ulx5mBGphV/tzTzhN
         VcEfKdDDsH4TgQzf7CySq48iuIJPinwj9NPqbRBzBOhy1UZZCG05ikAkBZFIa/3+g2
         jGz3DUfIPoW3sEPOHXAvgOGdUrub9LJ9YyKBvv8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 035/130] objtool: Support asm jump tables
Date:   Tue, 12 Jul 2022 20:38:01 +0200
Message-Id: <20220712183248.018073095@linuxfoundation.org>
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


