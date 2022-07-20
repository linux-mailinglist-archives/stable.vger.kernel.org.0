Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501C257ABE6
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241262AbiGTBRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241274AbiGTBRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:17:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D2965546;
        Tue, 19 Jul 2022 18:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41CA46176A;
        Wed, 20 Jul 2022 01:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35E2C341CA;
        Wed, 20 Jul 2022 01:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279649;
        bh=fjlWKDNRFQ32bHV3uG8bQ7pYj+M5ALfv21vd27AQdRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpBUfG+TwXTd6DbDaX2s6gtUPgeeAsC1jHvHOhdObfERhVkMAW7e6EOts5BF+YrLf
         x1qN6jygp4dOMtF5E0QAKppdS/fUQjQhYu5VfmUP0SzLzlvRqNWjrpf9nYDZLXYP1g
         +e7KtnC/z0ptZYKv1Jh+WXdl83KF6tLyzK0X4731hSpyiQpL7XB6boixuJ4cboei9i
         7TWv17EWFG5/NvcGCceg2OoBarJKMI3A/vhQ9sMAniP/aYxFB3AUpWiZdP5HqGxyjv
         f6Alh07UsX98h7QuENPJWS1A54lIby3TqBz6zdChlB5vZr+YJRicsiFoeOQEUFxwF+
         TtX777pJv1BnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 08/42] objtool: Treat .text.__x86.* as noinstr
Date:   Tue, 19 Jul 2022 21:13:16 -0400
Message-Id: <20220720011350.1024134-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
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
index 8b3435af989a..d87b493544e1 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -291,7 +291,8 @@ static int decode_instructions(struct objtool_file *file)
 			sec->text = true;
 
 		if (!strcmp(sec->name, ".noinstr.text") ||
-		    !strcmp(sec->name, ".entry.text"))
+		    !strcmp(sec->name, ".entry.text") ||
+		    !strncmp(sec->name, ".text.__x86.", 12))
 			sec->noinstr = true;
 
 		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
-- 
2.35.1

