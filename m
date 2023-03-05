Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37846AB0AC
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjCEN6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCEN5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:57:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9EA1B30A;
        Sun,  5 Mar 2023 05:56:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F97560AE2;
        Sun,  5 Mar 2023 13:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4740C433D2;
        Sun,  5 Mar 2023 13:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024533;
        bh=mnn5RPSXMS1FgIfdFe4OFtnjWbWjKO6WKfdlV5IqC2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yl+yyh8QkYeEKwv1vyc3/JjVD/9cnW/t+zvjKXca8gW+FoMa6rOAjmQVhh/4oWa/Q
         YncqkLBs6mvpPrA5P/0pzUSb+3nykrGEhmddfEuv64pp28guOcYWKO0DEFCngXIZZX
         +tllSd6zT42L82GY74pLaLuYmi0XLdlPr4tQnVqZhswhVcA8UkK9CYOQmXzY5CRTyx
         349wfoovUF3fFvZjTBEzdX5fTcnhDCUbV8pS7kd/VkiM6gjaiENiNaFFKGCmez8zSg
         1QCgVbQ43KkIXUa0rDFjWJri7m1xWWFqLidEb2/2W+s2vwiow7lniHkpf7ymUSm2Pa
         6jH7U2u57Sezw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Edward Humes <aurxenon@lunos.org>,
        Matt Turner <mattst88@gmail.com>,
        Sasha Levin <sashal@kernel.org>, richard.henderson@linaro.org,
        ink@jurassic.park.msu.ru, linux-alpha@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/6] alpha: fix R_ALPHA_LITERAL reloc for large modules
Date:   Sun,  5 Mar 2023 08:55:22 -0500
Message-Id: <20230305135525.1794277-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135525.1794277-1-sashal@kernel.org>
References: <20230305135525.1794277-1-sashal@kernel.org>
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
index 47632fa8c24e0..b169dc9a9ac17 100644
--- a/arch/alpha/kernel/module.c
+++ b/arch/alpha/kernel/module.c
@@ -158,10 +158,8 @@ apply_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
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

