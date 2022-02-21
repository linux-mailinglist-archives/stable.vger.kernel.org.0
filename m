Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28ED54BE678
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347087AbiBUJEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:04:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346961AbiBUJDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:03:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ADE2CC9F;
        Mon, 21 Feb 2022 00:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E81C361207;
        Mon, 21 Feb 2022 08:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A18C340E9;
        Mon, 21 Feb 2022 08:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433904;
        bh=hpxen5vihTO55Q6aW24d9qk3pSPgtuGSQEi6irhJ6ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Soz3arL+gGmMuP4z55Nro/vmjKWRyZ+Xg/ks0545pR+Q4wy7Uts5lW2VZSS6NBBVp
         ZsQoqN/eOOZbr6/1viie3f/YwxmoYInKHjCFxE3vYgZaQq+04M38DG6L4ABcXb3Vt6
         q85Y0mDiPPN9HlOgpHtLtH1IucwaAnkFEt4BDPno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Torsten Duwe <duwe@suse.de>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.4 25/80] arm64: module: rework special section handling
Date:   Mon, 21 Feb 2022 09:49:05 +0100
Message-Id: <20220221084916.411809014@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit bd8b21d3dd661658addc1cd4cc869bab11d28596 upstream.

When we load a module, we have to perform some special work for a couple
of named sections. To do this, we iterate over all of the module's
sections, and perform work for each section we recognize.

To make it easier to handle the unexpected absence of a section, and to
make the section-specific logic easer to read, let's factor the section
search into a helper. Similar is already done in the core module loader,
and other architectures (and ideally we'd unify these in future).

If we expect a module to have an ftrace trampoline section, but it
doesn't have one, we'll now reject loading the module. When
ARM64_MODULE_PLTS is selected, any correctly built module should have
one (and this is assumed by arm64's ftrace PLT code) and the absence of
such a section implies something has gone wrong at build time.

Subsequent patches will make use of the new helper.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Torsten Duwe <duwe@suse.de>
Tested-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Tested-by: Torsten Duwe <duwe@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/module.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -470,22 +470,39 @@ overflow:
 	return -ENOEXEC;
 }
 
-int module_finalize(const Elf_Ehdr *hdr,
-		    const Elf_Shdr *sechdrs,
-		    struct module *me)
+static const Elf_Shdr *find_section(const Elf_Ehdr *hdr,
+				    const Elf_Shdr *sechdrs,
+				    const char *name)
 {
 	const Elf_Shdr *s, *se;
 	const char *secstrs = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
 	for (s = sechdrs, se = sechdrs + hdr->e_shnum; s < se; s++) {
-		if (strcmp(".altinstructions", secstrs + s->sh_name) == 0)
-			apply_alternatives_module((void *)s->sh_addr, s->sh_size);
+		if (strcmp(name, secstrs + s->sh_name) == 0)
+			return s;
+	}
+
+	return NULL;
+}
+
+int module_finalize(const Elf_Ehdr *hdr,
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
+{
+	const Elf_Shdr *s;
+
+	s = find_section(hdr, sechdrs, ".altinstructions");
+	if (s)
+		apply_alternatives_module((void *)s->sh_addr, s->sh_size);
+
 #ifdef CONFIG_ARM64_MODULE_PLTS
-		if (IS_ENABLED(CONFIG_DYNAMIC_FTRACE) &&
-		    !strcmp(".text.ftrace_trampoline", secstrs + s->sh_name))
-			me->arch.ftrace_trampoline = (void *)s->sh_addr;
-#endif
+	if (IS_ENABLED(CONFIG_DYNAMIC_FTRACE)) {
+		s = find_section(hdr, sechdrs, ".text.ftrace_trampoline");
+		if (!s)
+			return -ENOEXEC;
+		me->arch.ftrace_trampoline = (void *)s->sh_addr;
 	}
+#endif
 
 	return 0;
 }


