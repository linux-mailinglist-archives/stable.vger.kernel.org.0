Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F84557AB71
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbiGTBLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240477AbiGTBLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:11:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36AD655AD;
        Tue, 19 Jul 2022 18:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE0E7B81DE0;
        Wed, 20 Jul 2022 01:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70C3C36AE2;
        Wed, 20 Jul 2022 01:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279472;
        bh=64ye752KjtJKz8pAKHODdp82tyr6OxIyyuEdjn1QRsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQME5PZ4Sc/JZbNBNVd9oNJ+/K/QRTluQCE+oF4K/LlD2SzG4FxqqZII3M2wf6MEq
         Z8bZXQjBoPD7yu1Tfk/DBjoiSmtT/zV72Wj+bc+aiE+F3GTKXm6GSqehiS5S36HZJ9
         fSdIzz8M2dODbci5ghvCcENbHNfewjPAWiw2qumtT4l8A908IMvVqAdygTqtZu8Phk
         epMwpOPf1ZsHtOjU1dKdG2xBagZyDHd5YaZ7v+eXQwGp50a4HvQ4KqPBxVyIxywCuV
         PVJwFJmnqe3shcm0VD1c4wU0eOhQka9v7OKslT2d+I7PEJUjzVpTLEIrihW9D3c8BN
         Znm4g7TFgJlRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.18 12/54] objtool: Treat .text.__x86.* as noinstr
Date:   Tue, 19 Jul 2022 21:09:49 -0400
Message-Id: <20220720011031.1023305-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 951ddecf435659553ed15a9214e153a3af43a9a1 ]

Needed because zen_untrain_ret() will be called from noinstr code.

Also makes sense since the thunks MUST NOT contain instrumentation nor
be poked with dynamic instrumentation.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3b3bfe94537a..204519704f3b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -374,7 +374,8 @@ static int decode_instructions(struct objtool_file *file)
 			sec->text = true;
 
 		if (!strcmp(sec->name, ".noinstr.text") ||
-		    !strcmp(sec->name, ".entry.text"))
+		    !strcmp(sec->name, ".entry.text") ||
+		    !strncmp(sec->name, ".text.__x86.", 12))
 			sec->noinstr = true;
 
 		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
-- 
2.35.1

