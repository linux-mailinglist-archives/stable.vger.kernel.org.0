Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8A853D032
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346024AbiFCSBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346264AbiFCSAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:00:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA02053716;
        Fri,  3 Jun 2022 10:55:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37BB2B8241D;
        Fri,  3 Jun 2022 17:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8CDC385A9;
        Fri,  3 Jun 2022 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278953;
        bh=iD1LTKLrroJIGGWbrPOT5G7rn4yVI1cE+hIePOwluT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4kOEeuC2YPf8adyd7pLtTuZxI4npRXQWyDHv9a0WtK4Ufc1S5cpLOTTZRuCJj9k7
         xaT1vjcKoPAvP9A3EGDuj22uqRxa/l81j9KEzbTq63XVeBcW3UxN/U53cTPcoST89X
         WtXymwK1gIuD27BITOEkV2rDUPeFQzXtEyy4c3wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 5.17 70/75] bpf: Fix combination of jit blinding and pointers to bpf subprogs.
Date:   Fri,  3 Jun 2022 19:43:54 +0200
Message-Id: <20220603173823.714252183@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alexei Starovoitov <ast@kernel.org>

commit 4b6313cf99b0d51b49aeaea98ec76ca8161ecb80 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1157,6 +1157,16 @@ struct bpf_prog *bpf_jit_blind_constants
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


