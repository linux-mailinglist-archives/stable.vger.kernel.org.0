Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECBE57EDB2
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbiGWKBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237777AbiGWKAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BAC77A75;
        Sat, 23 Jul 2022 02:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B2D5B82C1A;
        Sat, 23 Jul 2022 09:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A3DC341C0;
        Sat, 23 Jul 2022 09:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570301;
        bh=AAi8L56AzRyySQ+Kplk53X8AoGVDe7CwzbFO9ViCi28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfhNoVtt1BBjBuiWhgvB/L6lzVZ2Kz7OR2KT9efPT58vsC5KS4rmBj6Q2M+L5N5Od
         Yq8PiZvYMjxCEtc+mGZL8BgihBEaHDyMqKvqL8rjiPbIEZd9Znh0ELuB0l2qYhqvm9
         9i68vozD8knXZp5Vpf7pu+oDKaEjzz8Nu7Su//QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Majczak <lma@semihalf.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 038/148] objtool: Only rewrite unconditional retpoline thunk calls
Date:   Sat, 23 Jul 2022 11:54:10 +0200
Message-Id: <20220723095235.007621512@linuxfoundation.org>
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

commit 2d49b721dc18c113d5221f4cf5a6104eb66cb7f2 upstream.

It turns out that the compilers generate conditional branches to the
retpoline thunks like:

  5d5:   0f 85 00 00 00 00       jne    5db <cpuidle_reflect+0x22>
	5d7: R_X86_64_PLT32     __x86_indirect_thunk_r11-0x4

while the rewrite can only handle JMP/CALL to the thunks. The result
is the alternative wrecking the code. Make sure to skip writing the
alternatives for conditional branches.

Fixes: 9bc0bb50727c ("objtool/x86: Rewrite retpoline thunk calls")
Reported-by: Lukasz Majczak <lma@semihalf.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch/x86/decode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -674,6 +674,10 @@ int arch_rewrite_retpolines(struct objto
 
 	list_for_each_entry(insn, &file->retpoline_call_list, call_node) {
 
+		if (insn->type != INSN_JUMP_DYNAMIC &&
+		    insn->type != INSN_CALL_DYNAMIC)
+			continue;
+
 		if (!strcmp(insn->sec->name, ".text.__x86.indirect_thunk"))
 			continue;
 


