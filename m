Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C826E601E43
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiJRAIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiJRAIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:08:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204827E324;
        Mon, 17 Oct 2022 17:07:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C7B2B81BE1;
        Tue, 18 Oct 2022 00:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D69C433C1;
        Tue, 18 Oct 2022 00:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051673;
        bh=KtSPXtltLaR39nQ58teUKsRR/MN4D9N1XdSowoX1sb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/X0lRNRldbTmi+21bRnx/v6n0YZ39T+nVHI4/tiaoUBCiRcnwr/xLq3cT9bwV02X
         TCIBCEBiL8SgUtjOg7Hq54dYSPWYVVxa678XJE+BhhWTybFq691WAsZ0fuE9qxKfmY
         +wo3sdCWgUl1EwSuqEhARN7odQZBBX9qAaAD14XiKHQZcRky4xcNLXhXsYa2JrDY++
         7SNBmpT/vdlUCjY95HszPDPGBV2oBX+akIcXTMXDol2tQpxhsjc7Jug/iGli/AQaVJ
         tQSo5yvvV38MPx8Io9kKuvrmif7612uBvtxyVTPe+LmrZpKzAW6+Qiyl2hJ+BTYkVU
         hqjsTinrFrwKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jpoimboe@kernel.org,
        bp@suse.de, fenghua.yu@intel.com, tony.luck@intel.com
Subject: [PATCH AUTOSEL 6.0 10/32] objtool,x86: Teach decode about LOOP* instructions
Date:   Mon, 17 Oct 2022 20:07:07 -0400
Message-Id: <20221018000729.2730519-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7a7621dfa417aa3715d2a3bd1bdd6cf5018274d0 ]

When 'discussing' control flow Masami mentioned the LOOP* instructions
and I realized objtool doesn't decode them properly.

As it turns out, these instructions are somewhat inefficient and as
such unlikely to be emitted by the compiler (a few vmlinux.o checks
can't find a single one) so this isn't critical, but still, best to
decode them properly.

Reported-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/Yxhd4EMKyoFoH9y4@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index c260006106be..1c253b4b7ce0 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -635,6 +635,12 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 		*type = INSN_CONTEXT_SWITCH;
 		break;
 
+	case 0xe0: /* loopne */
+	case 0xe1: /* loope */
+	case 0xe2: /* loop */
+		*type = INSN_JUMP_CONDITIONAL;
+		break;
+
 	case 0xe8:
 		*type = INSN_CALL;
 		/*
-- 
2.35.1

