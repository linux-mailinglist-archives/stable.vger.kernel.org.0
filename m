Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC1B57EDED
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbiGWKEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbiGWKEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:04:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBF49B9F1;
        Sat, 23 Jul 2022 03:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B205961204;
        Sat, 23 Jul 2022 09:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0475C341C0;
        Sat, 23 Jul 2022 09:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570390;
        bh=a3uaGNTJRCN1AZgQunj5sehXg5YFviJZKOEKcHUEBxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TygPaWoA+fBLfJ0qPdyl6WYxlRAXM7gLTAp9/Z3fADwWN5X64AXo/ssJWS0h4lSS4
         LG21cS4Zj9Zs9Mgi1PUCcPORvbr6LRaQ4phOHFj1ReaQFNfbS6+aMPb/ItdngaJHks
         mBZfXHQAWLzHjy0wEeAjHujq4dX4iceZEc3df81c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 069/148] objtool: Default ignore INT3 for unreachable
Date:   Sat, 23 Jul 2022 11:54:41 +0200
Message-Id: <20220723095243.581466839@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 1ffbe4e935f9b7308615c75be990aec07464d1e7 upstream.

Ignore all INT3 instructions for unreachable code warnings, similar to NOP.
This allows using INT3 for various paddings instead of NOPs.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154317.343312938@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2775,9 +2775,8 @@ static int validate_branch(struct objtoo
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
@@ -2824,9 +2823,8 @@ static int validate_branch(struct objtoo
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
@@ -2997,7 +2995,7 @@ static bool ignore_unreachable_insn(stru
 	int i;
 	struct instruction *prev_insn;
 
-	if (insn->ignore || insn->type == INSN_NOP)
+	if (insn->ignore || insn->type == INSN_NOP || insn->type == INSN_TRAP)
 		return true;
 
 	/*


