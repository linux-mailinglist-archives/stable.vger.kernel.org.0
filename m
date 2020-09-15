Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182ED26B628
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgIOX6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgIOOaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:30:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D38E422B2A;
        Tue, 15 Sep 2020 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179735;
        bh=RLnm2/WdwBdljCPhwPl14tRBTo7Xc6Y33lXFr1ACZyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/DcXJddikTz0wIhlETEZwzagNOHAIfXug6E4toGUOWeLlb5Rfao2im70Wicp8IrZ
         BU3VeVokioX47uXjDUVl5TFx1T5hMADTuDlAwTLJvXc/Ar8FyzsfNiCQbF3+BHj8I3
         wdordw7Z0dHEVaaBw9LK2U04HFv9KJFBLoKu79Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/132] arm64/module: set trampoline section flags regardless of CONFIG_DYNAMIC_FTRACE
Date:   Tue, 15 Sep 2020 16:12:50 +0200
Message-Id: <20200915140647.512952460@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Yu <jeyu@kernel.org>

[ Upstream commit e0328feda79d9681b3e3245e6e180295550c8ee9 ]

In the arm64 module linker script, the section .text.ftrace_trampoline
is specified unconditionally regardless of whether CONFIG_DYNAMIC_FTRACE
is enabled (this is simply due to the limitation that module linker
scripts are not preprocessed like the vmlinux one).

Normally, for .plt and .text.ftrace_trampoline, the section flags
present in the module binary wouldn't matter since module_frob_arch_sections()
would assign them manually anyway. However, the arm64 module loader only
sets the section flags for .text.ftrace_trampoline when CONFIG_DYNAMIC_FTRACE=y.
That's only become problematic recently due to a recent change in
binutils-2.35, where the .text.ftrace_trampoline section (along with the
.plt section) is now marked writable and executable (WAX).

We no longer allow writable and executable sections to be loaded due to
commit 5c3a7db0c7ec ("module: Harden STRICT_MODULE_RWX"), so this is
causing all modules linked with binutils-2.35 to be rejected under arm64.
Drop the IS_ENABLED(CONFIG_DYNAMIC_FTRACE) check in module_frob_arch_sections()
so that the section flags for .text.ftrace_trampoline get properly set to
SHF_EXECINSTR|SHF_ALLOC, without SHF_WRITE.

Signed-off-by: Jessica Yu <jeyu@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: http://lore.kernel.org/r/20200831094651.GA16385@linux-8ccs
Link: https://lore.kernel.org/r/20200901160016.3646-1-jeyu@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/module-plts.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/module-plts.c b/arch/arm64/kernel/module-plts.c
index b182442b87a32..426018ebb7007 100644
--- a/arch/arm64/kernel/module-plts.c
+++ b/arch/arm64/kernel/module-plts.c
@@ -270,8 +270,7 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 			mod->arch.core.plt_shndx = i;
 		else if (!strcmp(secstrings + sechdrs[i].sh_name, ".init.plt"))
 			mod->arch.init.plt_shndx = i;
-		else if (IS_ENABLED(CONFIG_DYNAMIC_FTRACE) &&
-			 !strcmp(secstrings + sechdrs[i].sh_name,
+		else if (!strcmp(secstrings + sechdrs[i].sh_name,
 				 ".text.ftrace_trampoline"))
 			tramp = sechdrs + i;
 		else if (sechdrs[i].sh_type == SHT_SYMTAB)
-- 
2.25.1



