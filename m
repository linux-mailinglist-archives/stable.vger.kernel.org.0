Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DF95722E6
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiGLSlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiGLSlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E647BFAD8;
        Tue, 12 Jul 2022 11:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29AD961AD1;
        Tue, 12 Jul 2022 18:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EBDC3411C;
        Tue, 12 Jul 2022 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651261;
        bh=lsyuTmXLAidtYPc/lopZFL7NAHk8kmzndFF44qwQcAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLb02ed24DZb0Af9F44ky0xrfiIuA0+UXv2XkLaR1YKjNWK4JuMkEjJVHdLU1Rjfu
         lFt1mthDTiV27q5wd2gFRCmUwkH9XBJkB1SIQ/nzf3FzuEqw1Sun9P7yBJTGhJIzu8
         n5k4ih3OF/vVKJ80Fz8nOja1oZ3HhxV50nZ/reb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 023/130] objtool: Correctly handle retpoline thunk calls
Date:   Tue, 12 Jul 2022 20:37:49 +0200
Message-Id: <20220712183247.461343366@linuxfoundation.org>
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

commit bcb1b6ff39da7e8a6a986eb08126fba2b5e13c32 upstream.

Just like JMP handling, convert a direct CALL to a retpoline thunk
into a retpoline safe indirect CALL.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151259.567568238@infradead.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -953,6 +953,18 @@ static int add_call_destinations(struct
 					  dest_off);
 				return -1;
 			}
+
+		} else if (!strncmp(reloc->sym->name, "__x86_indirect_thunk_", 21)) {
+			/*
+			 * Retpoline calls are really dynamic calls in
+			 * disguise, so convert them accordingly.
+			 */
+			insn->type = INSN_CALL_DYNAMIC;
+			insn->retpoline_safe = true;
+
+			remove_insn_ops(insn);
+			continue;
+
 		} else
 			insn->call_dest = reloc->sym;
 


