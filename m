Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE0053CDA1
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344173AbiFCRBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243045AbiFCRBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:01:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A253522D7
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 10:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA55061A3E
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 17:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E122FC385A9;
        Fri,  3 Jun 2022 17:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654275692;
        bh=JDIWSU9rcKW9X2Y+Go3Q9VNv5dFAkla5idRq1Bj5Wfw=;
        h=Subject:To:Cc:From:Date:From;
        b=mlwvvU0Q2ZWn9skePf/IwSVjh+Ay2ggL+hlkAuRpkz2HZVkTXjo1/PnYgF1WnFee2
         G/jbugKrP6SK5hHxMAh9NzStNvM6sezmfI/DfPAPkgJPcuiv8MZ0etH/Mf2rJ9Lt6Y
         fEizv0QXXFscbnzoqhWaj9vYsy6LelTf3rEVr2aQ=
Subject: FAILED: patch "[PATCH] bpf: Fix combination of jit blinding and pointers to bpf" failed to apply to 5.15-stable tree
To:     ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        kafai@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 19:01:29 +0200
Message-ID: <1654275689143236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4b6313cf99b0d51b49aeaea98ec76ca8161ecb80 Mon Sep 17 00:00:00 2001
From: Alexei Starovoitov <ast@kernel.org>
Date: Thu, 12 May 2022 18:10:24 -0700
Subject: [PATCH] bpf: Fix combination of jit blinding and pointers to bpf
 subprogs.

The combination of jit blinding and pointers to bpf subprogs causes:
[   36.989548] BUG: unable to handle page fault for address: 0000000100000001
[   36.990342] #PF: supervisor instruction fetch in kernel mode
[   36.990968] #PF: error_code(0x0010) - not-present page
[   36.994859] RIP: 0010:0x100000001
[   36.995209] Code: Unable to access opcode bytes at RIP 0xffffffd7.
[   37.004091] Call Trace:
[   37.004351]  <TASK>
[   37.004576]  ? bpf_loop+0x4d/0x70
[   37.004932]  ? bpf_prog_3899083f75e4c5de_F+0xe3/0x13b

The jit blinding logic didn't recognize that ld_imm64 with an address
of bpf subprogram is a special instruction and proceeded to randomize it.
By itself it wouldn't have been an issue, but jit_subprogs() logic
relies on two step process to JIT all subprogs and then JIT them
again when addresses of all subprogs are known.
Blinding process in the first JIT phase caused second JIT to miss
adjustment of special ld_imm64.

Fix this issue by ignoring special ld_imm64 instructions that don't have
user controlled constants and shouldn't be blinded.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20220513011025.13344-1-alexei.starovoitov@gmail.com

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 76f68d0a7ae8..9cc91f0f3115 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1434,6 +1434,16 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
 	insn = clone->insnsi;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
+		if (bpf_pseudo_func(insn)) {
+			/* ld_imm64 with an address of bpf subprog is not
+			 * a user controlled constant. Don't randomize it,
+			 * since it will conflict with jit_subprogs() logic.
+			 */
+			insn++;
+			i++;
+			continue;
+		}
+
 		/* We temporarily need to hold the original ld64 insn
 		 * so that we can still access the first part in the
 		 * second blinding run.

