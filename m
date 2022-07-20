Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23ECB57AC48
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbiGTBWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241764AbiGTBWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:22:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69E570994;
        Tue, 19 Jul 2022 18:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D65EB81DD6;
        Wed, 20 Jul 2022 01:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B19C341C6;
        Wed, 20 Jul 2022 01:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279784;
        bh=22GcbUcb+LYwfLwd9LNmozcHVw/m9lvvCpiavYD04Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF9Npn+d9smMa7w4KwZBToc1uYTmuhMnsfhI+xh2DbJx2OZELICPmtM5cyZwn5wgU
         uIUpVG6IKZUlVglahqciQbWRhkC3Hb1bkb00pzbqc6wwYiH14nkL6gI5iUxy63JtUA
         ZkGqXmH2JDKQmEBS4619T1hWZ82JheoZfDlZQ9mSnSYscSUOoRhfnrEvohEnYIraeb
         IpcRLuVRNToShbFCi6I+702OTIk8VTa5eTQ+HLZtilMu0NnvDDa9ZybNhddn6tRyBy
         XAscTKyUFQRTe+ok20L3bKxwYGrm4adiuVuJ+iqDeTvUGIIwyzKqqjP3d3oJEvVLV0
         wfWd5IYGs/VGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 04/25] objtool: Treat .text.__x86.* as noinstr
Date:   Tue, 19 Jul 2022 21:15:55 -0400
Message-Id: <20220720011616.1024753-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011616.1024753-1-sashal@kernel.org>
References: <20220720011616.1024753-1-sashal@kernel.org>
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
index 8932f41c387f..0149e0bdf0d8 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -274,7 +274,8 @@ static int decode_instructions(struct objtool_file *file)
 			sec->text = true;
 
 		if (!strcmp(sec->name, ".noinstr.text") ||
-		    !strcmp(sec->name, ".entry.text"))
+		    !strcmp(sec->name, ".entry.text") ||
+		    !strncmp(sec->name, ".text.__x86.", 12))
 			sec->noinstr = true;
 
 		for (offset = 0; offset < sec->len; offset += insn->len) {
-- 
2.35.1

