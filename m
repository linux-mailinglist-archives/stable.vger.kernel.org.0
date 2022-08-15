Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7301159480B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbiHOXZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241882AbiHOXXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:23:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21267391E;
        Mon, 15 Aug 2022 13:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D547360690;
        Mon, 15 Aug 2022 20:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDED8C433D6;
        Mon, 15 Aug 2022 20:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593932;
        bh=wzUTotmsOvyiM2qWLvIOatO2CoZfg/QgKijFCVNekYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osg9tDbXfB0v5yo4fxYDURkA1P2iTxpxDjkLyUNl5PtD17vALHM1Gcb0pGOIn3IfQ
         1srGY6E75cEnyZO6YTyVm5XdyHqw2KW9S1H/Q7sY1bmWDz60KNOy/GZuyxyymeBMkA
         Nl1Yb2bfOijiLgVrzbNGKvf8HzRDDaVynvIIAI7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Riham Selim <rihams@fb.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0350/1157] libbpf: Fix uprobe symbol file offset calculation logic
Date:   Mon, 15 Aug 2022 19:55:06 +0200
Message-Id: <20220815180453.716772247@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit fe92833524e368e59bba9c57e00f7359f133667f ]

Fix libbpf's bpf_program__attach_uprobe() logic of determining
function's *file offset* (which is what kernel is actually expecting)
when attaching uprobe/uretprobe by function name. Previously calculation
was determining virtual address offset relative to base load address,
which (offset) is not always the same as file offset (though very
frequently it is which is why this went unnoticed for a while).

Fixes: 433966e3ae04 ("libbpf: Support function name-based attach uprobes")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Riham Selim <rihams@fb.com>
Cc: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/20220606220143.3796908-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 63 +++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 41 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 526bd6cd84a0..b9245bf688fa 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10983,43 +10983,6 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
-/* uprobes deal in relative offsets; subtract the base address associated with
- * the mapped binary.  See Documentation/trace/uprobetracer.rst for more
- * details.
- */
-static long elf_find_relative_offset(const char *filename, Elf *elf, long addr)
-{
-	size_t n;
-	int i;
-
-	if (elf_getphdrnum(elf, &n)) {
-		pr_warn("elf: failed to find program headers for '%s': %s\n", filename,
-			elf_errmsg(-1));
-		return -ENOENT;
-	}
-
-	for (i = 0; i < n; i++) {
-		int seg_start, seg_end, seg_offset;
-		GElf_Phdr phdr;
-
-		if (!gelf_getphdr(elf, i, &phdr)) {
-			pr_warn("elf: failed to get program header %d from '%s': %s\n", i, filename,
-				elf_errmsg(-1));
-			return -ENOENT;
-		}
-		if (phdr.p_type != PT_LOAD || !(phdr.p_flags & PF_X))
-			continue;
-
-		seg_start = phdr.p_vaddr;
-		seg_end = seg_start + phdr.p_memsz;
-		seg_offset = phdr.p_offset;
-		if (addr >= seg_start && addr < seg_end)
-			return addr - seg_start + seg_offset;
-	}
-	pr_warn("elf: failed to find prog header containing 0x%lx in '%s'\n", addr, filename);
-	return -ENOENT;
-}
-
 /* Return next ELF section of sh_type after scn, or first of that type if scn is NULL. */
 static Elf_Scn *elf_find_next_scn_by_type(Elf *elf, int sh_type, Elf_Scn *scn)
 {
@@ -11106,6 +11069,8 @@ static long elf_find_func_offset(const char *binary_path, const char *name)
 		for (idx = 0; idx < nr_syms; idx++) {
 			int curr_bind;
 			GElf_Sym sym;
+			Elf_Scn *sym_scn;
+			GElf_Shdr sym_sh;
 
 			if (!gelf_getsym(symbols, idx, &sym))
 				continue;
@@ -11143,12 +11108,28 @@ static long elf_find_func_offset(const char *binary_path, const char *name)
 					continue;
 				}
 			}
-			ret = sym.st_value;
+
+			/* Transform symbol's virtual address (absolute for
+			 * binaries and relative for shared libs) into file
+			 * offset, which is what kernel is expecting for
+			 * uprobe/uretprobe attachment.
+			 * See Documentation/trace/uprobetracer.rst for more
+			 * details.
+			 * This is done by looking up symbol's containing
+			 * section's header and using it's virtual address
+			 * (sh_addr) and corresponding file offset (sh_offset)
+			 * to transform sym.st_value (virtual address) into
+			 * desired final file offset.
+			 */
+			sym_scn = elf_getscn(elf, sym.st_shndx);
+			if (!sym_scn)
+				continue;
+			if (!gelf_getshdr(sym_scn, &sym_sh))
+				continue;
+
+			ret = sym.st_value - sym_sh.sh_addr + sym_sh.sh_offset;
 			last_bind = curr_bind;
 		}
-		/* For binaries that are not shared libraries, we need relative offset */
-		if (ret > 0 && !is_shared_lib)
-			ret = elf_find_relative_offset(binary_path, elf, ret);
 		if (ret > 0)
 			break;
 	}
-- 
2.35.1



