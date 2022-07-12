Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81232572333
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiGLSoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiGLSnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:43:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1956ED9160;
        Tue, 12 Jul 2022 11:41:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A22BB61AC9;
        Tue, 12 Jul 2022 18:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87DDC341CD;
        Tue, 12 Jul 2022 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651317;
        bh=AAi8L56AzRyySQ+Kplk53X8AoGVDe7CwzbFO9ViCi28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIvLElVUCwbmCkhjDNFUP4cMNciPZN+5GEVQCZUUdw+Yuvdo/wWkjcEU1IOlG3XbA
         87IkzFkv+hhVe1Qr0B5+xDlni8hEk+Pi8jLt0f2G1UV7ra3XKkaTDJni/mvakgVy7R
         Vihc5ikIL6pirTBKqL8IETGf/4I3BFD0TxYd0GR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Majczak <lma@semihalf.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 038/130] objtool: Only rewrite unconditional retpoline thunk calls
Date:   Tue, 12 Jul 2022 20:38:04 +0200
Message-Id: <20220712183248.155092519@linuxfoundation.org>
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
 


