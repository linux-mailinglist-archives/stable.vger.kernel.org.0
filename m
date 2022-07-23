Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8773D57EDDD
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbiGWKDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiGWKDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:03:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5CC88F0A;
        Sat, 23 Jul 2022 02:59:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 619FDB82C1B;
        Sat, 23 Jul 2022 09:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81151C341C0;
        Sat, 23 Jul 2022 09:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570364;
        bh=v2jQRb/cwYZnNJNo6P3W1xJ1OpzzWBGK68XPPMII0hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2JjE2osv5Vzw8YU+AAwf84S+N/wjxQxQJD7lznZ8SjmQ0kxIJ5mR7GhmFbdp8/vy
         3C52MhcSO25N91GaqUbJdDOz/JDtG4jaSOXRHbcih1md0ga5ggKxfd/1MWxmN0B/41
         NVUNhql//TGL1bCmThYbvckmV80nUpHiJIF5gtqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 071/148] objtool: Fix SLS validation for kcov tail-call replacement
Date:   Sat, 23 Jul 2022 11:54:43 +0200
Message-Id: <20220723095244.084751710@linuxfoundation.org>
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


