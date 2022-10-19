Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBCE60419E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiJSKqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiJSKor (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:44:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5908311877D;
        Wed, 19 Oct 2022 03:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D853AB8231D;
        Wed, 19 Oct 2022 08:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE6CC433D6;
        Wed, 19 Oct 2022 08:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169286;
        bh=HFFF37R3oYOiJnZ/OBH3lRHLRux8zKszRban/GNbQAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCPo4k60POx/tyzu3+Rv3Nu0yk/lr8pbD6ewan6Dd+88Z8hALC1LuBMCvkD40e1xk
         79Rmh49pVJfaaetVIKPLzubBmC/l83RsXFG46/p/dI0/Mei408k6uVqLMBmZnSD7Ea
         LjeSoSURGtTq1ApiA75Wv927BWwGqaU9vyp5yKts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 220/862] objtool: Preserve special st_shndx indexes in elf_update_symbol
Date:   Wed, 19 Oct 2022 10:25:07 +0200
Message-Id: <20221019083259.753894368@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit 5141d3a06b2da1731ac82091298b766a1f95d3d8 ]

elf_update_symbol fails to preserve the special st_shndx values
between [SHN_LORESERVE, SHN_HIRESERVE], which results in it
converting SHN_ABS entries into SHN_UNDEF, for example. Explicitly
check for the special indexes and ensure these symbols are not
marked undefined.

Fixes: ead165fa1042 ("objtool: Fix symbol creation")
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220908215504.3686827-17-samitolvanen@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index c25e957c1e52..7e24b09b1163 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -619,6 +619,11 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	Elf64_Xword entsize = symtab->sh.sh_entsize;
 	int max_idx, idx = sym->idx;
 	Elf_Scn *s, *t = NULL;
+	bool is_special_shndx = sym->sym.st_shndx >= SHN_LORESERVE &&
+				sym->sym.st_shndx != SHN_XINDEX;
+
+	if (is_special_shndx)
+		shndx = sym->sym.st_shndx;
 
 	s = elf_getscn(elf->elf, symtab->idx);
 	if (!s) {
@@ -704,7 +709,7 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	}
 
 	/* setup extended section index magic and write the symbol */
-	if (shndx >= SHN_UNDEF && shndx < SHN_LORESERVE) {
+	if ((shndx >= SHN_UNDEF && shndx < SHN_LORESERVE) || is_special_shndx) {
 		sym->sym.st_shndx = shndx;
 		if (!shndx_data)
 			shndx = 0;
-- 
2.35.1



