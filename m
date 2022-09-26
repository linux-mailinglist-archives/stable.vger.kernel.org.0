Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0FE5EA4EC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbiIZL4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbiIZLyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B12778585;
        Mon, 26 Sep 2022 03:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9408260A4D;
        Mon, 26 Sep 2022 10:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5C3C433C1;
        Mon, 26 Sep 2022 10:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189318;
        bh=pnveg2+UrGnBn4IrjP5QIeOLOVOzaErr8xzbOiDup+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7MyoS64vhlBkF4oonqI33saQ0aFqOygXynMeMxBj02+XajUBvfqzLpFcsUIwWKAY
         p5EaRBraxXAdR7K4ZsFplMqb4iUPpgVa1h51UDR+GiZs3A8l6RAn0pzK03rUXvBMNy
         cfGWtD7Y3+QZ7DJwZ5F3uSNdiiS68c40WrovZWgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Lieven Hey <lieven.hey@kdab.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 147/207] perf jit: Include program header in ELF files
Date:   Mon, 26 Sep 2022 12:12:16 +0200
Message-Id: <20220926100813.228665782@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lieven Hey <lieven.hey@kdab.com>

[ Upstream commit babd04386b1df8c364cdaa39ac0e54349502e1e5 ]

The missing header makes it hard for programs like elfutils to open
these files.

Fixes: 2d86612aacb7805f ("perf symbol: Correct address for bss symbols")
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Lieven Hey <lieven.hey@kdab.com>
Tested-by: Leo Yan <leo.yan@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Link: https://lore.kernel.org/r/20220915092910.711036-1-lieven.hey@kdab.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/genelf.c | 14 ++++++++++++++
 tools/perf/util/genelf.h |  4 ++++
 2 files changed, 18 insertions(+)

diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
index 953338b9e887..02cd9f75e3d2 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -251,6 +251,7 @@ jit_write_elf(int fd, uint64_t load_addr, const char *sym,
 	Elf_Data *d;
 	Elf_Scn *scn;
 	Elf_Ehdr *ehdr;
+	Elf_Phdr *phdr;
 	Elf_Shdr *shdr;
 	uint64_t eh_frame_base_offset;
 	char *strsym = NULL;
@@ -285,6 +286,19 @@ jit_write_elf(int fd, uint64_t load_addr, const char *sym,
 	ehdr->e_version = EV_CURRENT;
 	ehdr->e_shstrndx= unwinding ? 4 : 2; /* shdr index for section name */
 
+	/*
+	 * setup program header
+	 */
+	phdr = elf_newphdr(e, 1);
+	phdr[0].p_type = PT_LOAD;
+	phdr[0].p_offset = 0;
+	phdr[0].p_vaddr = 0;
+	phdr[0].p_paddr = 0;
+	phdr[0].p_filesz = csize;
+	phdr[0].p_memsz = csize;
+	phdr[0].p_flags = PF_X | PF_R;
+	phdr[0].p_align = 8;
+
 	/*
 	 * setup text section
 	 */
diff --git a/tools/perf/util/genelf.h b/tools/perf/util/genelf.h
index ae138afe6c56..b5c909546e3f 100644
--- a/tools/perf/util/genelf.h
+++ b/tools/perf/util/genelf.h
@@ -53,8 +53,10 @@ int jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_ent
 
 #if GEN_ELF_CLASS == ELFCLASS64
 #define elf_newehdr	elf64_newehdr
+#define elf_newphdr	elf64_newphdr
 #define elf_getshdr	elf64_getshdr
 #define Elf_Ehdr	Elf64_Ehdr
+#define Elf_Phdr	Elf64_Phdr
 #define Elf_Shdr	Elf64_Shdr
 #define Elf_Sym		Elf64_Sym
 #define ELF_ST_TYPE(a)	ELF64_ST_TYPE(a)
@@ -62,8 +64,10 @@ int jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_ent
 #define ELF_ST_VIS(a)	ELF64_ST_VISIBILITY(a)
 #else
 #define elf_newehdr	elf32_newehdr
+#define elf_newphdr	elf32_newphdr
 #define elf_getshdr	elf32_getshdr
 #define Elf_Ehdr	Elf32_Ehdr
+#define Elf_Phdr	Elf32_Phdr
 #define Elf_Shdr	Elf32_Shdr
 #define Elf_Sym		Elf32_Sym
 #define ELF_ST_TYPE(a)	ELF32_ST_TYPE(a)
-- 
2.35.1



