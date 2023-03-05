Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4C46AB062
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCENzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjCENzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:55:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8061040F7;
        Sun,  5 Mar 2023 05:54:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C04DB60B1A;
        Sun,  5 Mar 2023 13:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70068C433D2;
        Sun,  5 Mar 2023 13:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024431;
        bh=bxTptbUVa63UoQCRWI3jLiKQBHLWc7zNuIcPhaE4q9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2zFa1Eo5Zd1oUXAe5qfehASPY7aVap57+hBSrL84YgA/CJ8tlDVoj1mnmZs81pn1
         3uI6ij3F7xuwSomPmRxp1FUEo/CcTjXVgYt7l4iVO4Y/l9CkcgNE1IhrL91x6WSD0s
         lebTbwWk4nf5AT147ZyHEC+LqeDU3oYmeEyb3yrHa0c1IKhqqwtdtAPkl90BBrkF/5
         JnQKGU+fGcjBGRzmGCfd8lh7NMGB49lbf6mhu02nnTNyzAEklbWAHEdOMBSEhhsLTE
         5DMuJQz8T/KLRCbHhEaG0rIlH0fcRRkz91IfZQnfp4aUrV4e6nJRHW19PzxrauZUBo
         XrjnuUVwNqYmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Edward Humes <aurxenon@lunos.org>,
        Matt Turner <mattst88@gmail.com>,
        Sasha Levin <sashal@kernel.org>, richard.henderson@linaro.org,
        ink@jurassic.park.msu.ru, linux-alpha@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 12/15] alpha: fix R_ALPHA_LITERAL reloc for large modules
Date:   Sun,  5 Mar 2023 08:53:03 -0500
Message-Id: <20230305135306.1793564-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135306.1793564-1-sashal@kernel.org>
References: <20230305135306.1793564-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Humes <aurxenon@lunos.org>

[ Upstream commit b6b17a8b3ecd878d98d5472a9023ede9e669ca72 ]

Previously, R_ALPHA_LITERAL relocations would overflow for large kernel
modules.

This was because the Alpha's apply_relocate_add was relying on the kernel's
module loader to have sorted the GOT towards the very end of the module as it
was mapped into memory in order to correctly assign the global pointer. While
this behavior would mostly work fine for small kernel modules, this approach
would overflow on kernel modules with large GOT's since the global pointer
would be very far away from the GOT, and thus, certain entries would be out of
range.

This patch fixes this by instead using the Tru64 behavior of assigning the
global pointer to be 32KB away from the start of the GOT. The change made
in this patch won't work for multi-GOT kernel modules as it makes the
assumption the module only has one GOT located at the beginning of .got,
although for the vast majority kernel modules, this should be fine. Of the
kernel modules that would previously result in a relocation error, none of
them, even modules like nouveau, have even come close to filling up a single
GOT, and they've all worked fine under this patch.

Signed-off-by: Edward Humes <aurxenon@lunos.org>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/module.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/alpha/kernel/module.c b/arch/alpha/kernel/module.c
index 5b60c248de9ea..cbefa5a773846 100644
--- a/arch/alpha/kernel/module.c
+++ b/arch/alpha/kernel/module.c
@@ -146,10 +146,8 @@ apply_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
 	base = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr;
 	symtab = (Elf64_Sym *)sechdrs[symindex].sh_addr;
 
-	/* The small sections were sorted to the end of the segment.
-	   The following should definitely cover them.  */
-	gp = (u64)me->core_layout.base + me->core_layout.size - 0x8000;
 	got = sechdrs[me->arch.gotsecindex].sh_addr;
+	gp = got + 0x8000;
 
 	for (i = 0; i < n; i++) {
 		unsigned long r_sym = ELF64_R_SYM (rela[i].r_info);
-- 
2.39.2

