Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECC957245D
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiGLTAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiGLS7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:59:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCEEEFF85;
        Tue, 12 Jul 2022 11:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1474DB81BBB;
        Tue, 12 Jul 2022 18:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6324AC3411C;
        Tue, 12 Jul 2022 18:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651675;
        bh=kSgwTRsllFILj+qKMFsmLtIGbXkCDdd8/3UJkSJqtAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5xmQIFykJ9jVkFNjBUoq2rrJZPSJlyRi6l63wy8PpCIOjXHtIilroBKG/gcwaXOx
         uqldTRHDq4HgN/1MeHR1xaI0rD4SmpFVrxAwSI3KXJppBB6aoYny7AOLn5hVJMHiIn
         7EXlXIfZuJBvk8PQSQxXNtAKBFRpN1FggGXH4oLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 21/78] objtool: Default ignore INT3 for unreachable
Date:   Tue, 12 Jul 2022 20:38:51 +0200
Message-Id: <20220712183239.696980857@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
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

commit 1ffbe4e935f9b7308615c75be990aec07464d1e7 upstream.

Ignore all INT3 instructions for unreachable code warnings, similar to NOP.
This allows using INT3 for various paddings instead of NOPs.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154317.343312938@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2965,9 +2965,8 @@ static int validate_branch(struct objtoo
 		switch (insn->type) {
 
 		case INSN_RETURN:
-			if (next_insn && next_insn->type == INSN_TRAP) {
-				next_insn->ignore = true;
-			} else if (sls && !insn->retpoline_safe) {
+			if (sls && !insn->retpoline_safe &&
+			    next_insn && next_insn->type != INSN_TRAP) {
 				WARN_FUNC("missing int3 after ret",
 					  insn->sec, insn->offset);
 			}
@@ -3014,9 +3013,8 @@ static int validate_branch(struct objtoo
 			break;
 
 		case INSN_JUMP_DYNAMIC:
-			if (next_insn && next_insn->type == INSN_TRAP) {
-				next_insn->ignore = true;
-			} else if (sls && !insn->retpoline_safe) {
+			if (sls && !insn->retpoline_safe &&
+			    next_insn && next_insn->type != INSN_TRAP) {
 				WARN_FUNC("missing int3 after indirect jump",
 					  insn->sec, insn->offset);
 			}
@@ -3187,7 +3185,7 @@ static bool ignore_unreachable_insn(stru
 	int i;
 	struct instruction *prev_insn;
 
-	if (insn->ignore || insn->type == INSN_NOP)
+	if (insn->ignore || insn->type == INSN_NOP || insn->type == INSN_TRAP)
 		return true;
 
 	/*


