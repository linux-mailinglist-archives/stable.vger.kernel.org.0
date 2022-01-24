Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6014C499FBE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842103AbiAXXAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836489AbiAXWjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C51BC054871;
        Mon, 24 Jan 2022 13:01:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3434AB81233;
        Mon, 24 Jan 2022 21:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51387C340E5;
        Mon, 24 Jan 2022 21:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058060;
        bh=Ix2i5yklliOEQD/vcWRxVdDk4r7GXMXZENMCJQoSCpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ltuypwTLpxBDaFSCin5BANZZOpkI3H9HFoGL0BoxhJwf3S1QYPRDfcTXerJeJO6/
         ltSCw7ztBP3S6YQ1r/E/Qfs3JzOqPGeLsub/KXRxnUqZOpAKbE7P/IV59FVL2jMaGx
         Oh+94zrK04agrR3FwpEq2C0LNNZSBHYu++ibuw3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0169/1039] libbpf: Load global data maps lazily on legacy kernels
Date:   Mon, 24 Jan 2022 19:32:38 +0100
Message-Id: <20220124184130.907300076@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 16e0c35c6f7a2e90d52f3035ecf942af21417b7b ]

Load global data maps lazily, if kernel is too old to support global
data. Make sure that programs are still correct by detecting if any of
the to-be-loaded programs have relocation against any of such maps.

This allows to solve the issue ([0]) with bpf_printk() and Clang
generating unnecessary and unreferenced .rodata.strX.Y sections, but it
also goes further along the CO-RE lines, allowing to have a BPF object
in which some code can work on very old kernels and relies only on BPF
maps explicitly, while other BPF programs might enjoy global variable
support. If such programs are correctly set to not load at runtime on
old kernels, bpf_object will load and function correctly now.

  [0] https://lore.kernel.org/bpf/CAK-59YFPU3qO+_pXWOH+c1LSA=8WA1yabJZfREjOEXNHAqgXNg@mail.gmail.com/

Fixes: aed659170a31 ("libbpf: Support multiple .rodata.* and .data.* BPF maps")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20211123200105.387855-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 509f3719409bb..4050a0f8dad66 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4988,6 +4988,24 @@ bpf_object__create_maps(struct bpf_object *obj)
 	for (i = 0; i < obj->nr_maps; i++) {
 		map = &obj->maps[i];
 
+		/* To support old kernels, we skip creating global data maps
+		 * (.rodata, .data, .kconfig, etc); later on, during program
+		 * loading, if we detect that at least one of the to-be-loaded
+		 * programs is referencing any global data map, we'll error
+		 * out with program name and relocation index logged.
+		 * This approach allows to accommodate Clang emitting
+		 * unnecessary .rodata.str1.1 sections for string literals,
+		 * but also it allows to have CO-RE applications that use
+		 * global variables in some of BPF programs, but not others.
+		 * If those global variable-using programs are not loaded at
+		 * runtime due to bpf_program__set_autoload(prog, false),
+		 * bpf_object loading will succeed just fine even on old
+		 * kernels.
+		 */
+		if (bpf_map__is_internal(map) &&
+		    !kernel_supports(obj, FEAT_GLOBAL_DATA))
+			continue;
+
 		retried = false;
 retry:
 		if (map->pin_path) {
@@ -5587,6 +5605,14 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 				insn[0].src_reg = BPF_PSEUDO_MAP_IDX_VALUE;
 				insn[0].imm = relo->map_idx;
 			} else {
+				const struct bpf_map *map = &obj->maps[relo->map_idx];
+
+				if (bpf_map__is_internal(map) &&
+				    !kernel_supports(obj, FEAT_GLOBAL_DATA)) {
+					pr_warn("prog '%s': relo #%d: kernel doesn't support global data\n",
+						prog->name, i);
+					return -ENOTSUP;
+				}
 				insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
 				insn[0].imm = obj->maps[relo->map_idx].fd;
 			}
@@ -6121,6 +6147,8 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
 		 */
 		if (prog_is_subprog(obj, prog))
 			continue;
+		if (!prog->load)
+			continue;
 
 		err = bpf_object__relocate_calls(obj, prog);
 		if (err) {
@@ -6134,6 +6162,8 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
 		prog = &obj->programs[i];
 		if (prog_is_subprog(obj, prog))
 			continue;
+		if (!prog->load)
+			continue;
 		err = bpf_object__relocate_data(obj, prog);
 		if (err) {
 			pr_warn("prog '%s': failed to relocate data references: %d\n",
@@ -6915,10 +6945,6 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
 	bpf_object__for_each_map(m, obj) {
 		if (!bpf_map__is_internal(m))
 			continue;
-		if (!kernel_supports(obj, FEAT_GLOBAL_DATA)) {
-			pr_warn("kernel doesn't support global data\n");
-			return -ENOTSUP;
-		}
 		if (!kernel_supports(obj, FEAT_ARRAY_MMAP))
 			m->def.map_flags ^= BPF_F_MMAPABLE;
 	}
-- 
2.34.1



