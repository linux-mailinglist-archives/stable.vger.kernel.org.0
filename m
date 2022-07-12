Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925D257236C
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbiGLStw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiGLStX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:49:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C553139D;
        Tue, 12 Jul 2022 11:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 092C461AC9;
        Tue, 12 Jul 2022 18:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE39C3411E;
        Tue, 12 Jul 2022 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651427;
        bh=v2jQRb/cwYZnNJNo6P3W1xJ1OpzzWBGK68XPPMII0hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUrsly+J265bbTu6V59u9lBmuL5VefTyjVzkIfkYQQTB2zxzlG7XS9qaBpoVBgT9A
         9SAdYZvQiwGTRGJ0SEFy6vGswerljc+HZ+tFZ5L/VXZDBmFJBXBSQIKqhFwWfJ1W8U
         n0WR3tG9paQ5bfcARlUI6gMLdxyLINsnOs2EXyBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 071/130] objtool: Fix SLS validation for kcov tail-call replacement
Date:   Tue, 12 Jul 2022 20:38:37 +0200
Message-Id: <20220712183249.741563131@linuxfoundation.org>
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

commit 7a53f408902d913cd541b4f8ad7dbcd4961f5b82 upstream.

Since not all compilers have a function attribute to disable KCOV
instrumentation, objtool can rewrite KCOV instrumentation in noinstr
functions as per commit:

  f56dae88a81f ("objtool: Handle __sanitize_cov*() tail calls")

However, this has subtle interaction with the SLS validation from
commit:

  1cc1e4c8aab4 ("objtool: Add straight-line-speculation validation")

In that when a tail-call instrucion is replaced with a RET an
additional INT3 instruction is also written, but is not represented in
the decoded instruction stream.

This then leads to false positive missing INT3 objtool warnings in
noinstr code.

Instead of adding additional struct instruction objects, mark the RET
instruction with retpoline_safe to suppress the warning (since we know
there really is an INT3).

Fixes: 1cc1e4c8aab4 ("objtool: Add straight-line-speculation validation")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220323230712.GA8939@worktop.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -961,6 +961,17 @@ static void annotate_call_site(struct ob
 			               : arch_nop_insn(insn->len));
 
 		insn->type = sibling ? INSN_RETURN : INSN_NOP;
+
+		if (sibling) {
+			/*
+			 * We've replaced the tail-call JMP insn by two new
+			 * insn: RET; INT3, except we only have a single struct
+			 * insn here. Mark it retpoline_safe to avoid the SLS
+			 * warning, instead of adding another insn.
+			 */
+			insn->retpoline_safe = true;
+		}
+
 		return;
 	}
 }


