Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E534FD7EB
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377559AbiDLHuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359416AbiDLHnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEFB2CE1A;
        Tue, 12 Apr 2022 00:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0845B81B33;
        Tue, 12 Apr 2022 07:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D29C385A1;
        Tue, 12 Apr 2022 07:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748185;
        bh=puVvcVR9URWdyntTsSnOVTEqo3uaLGnngVEYbR821qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypCvaqY1qsWsMqIQo4I+11L2K9UtNB0RenZSz4m+f86gDIPmmlI+3QhP8zrcEFP5w
         Bi56pyKdXFjIzeaiXL4ht5gSgfTtLXektvN57ADh/SrQGHY3C+Cl8wgsH517/Uc9PO
         muxqzinrJ1PpZlhbWCiGqtT2jc0Zya1zvsDIeDnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.17 330/343] objtool: Fix SLS validation for kcov tail-call replacement
Date:   Tue, 12 Apr 2022 08:32:28 +0200
Message-Id: <20220412063000.843902940@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1090,6 +1090,17 @@ static void annotate_call_site(struct ob
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
 


