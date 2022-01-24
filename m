Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A646499D81
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351517AbiAXWYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583232AbiAXWR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124DDC06138F;
        Mon, 24 Jan 2022 12:48:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A2D60C19;
        Mon, 24 Jan 2022 20:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8570DC340E5;
        Mon, 24 Jan 2022 20:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057298;
        bh=6i/Lc3WTadO3w1mqFn1HbvI5iuw8Z8mWohFm0Ksrknc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4GWvnvcj2yHScho/Dd7Z4H7qez3SyP2Lx9zY26ayyiCEN/xhYz69ATMxdgpTDKMJ
         Ko8w2ZzV/dS4LrteDklgDFf/cKKAkthl0Mhmox+GolW/1g6PudeWDVSbZ9Mj5tm9NE
         LwALerZMngssTMuziyRqDjj3H+K5fjnAi4KwZh7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 767/846] bpf: Mark PTR_TO_FUNC register initially with zero offset
Date:   Mon, 24 Jan 2022 19:44:44 +0100
Message-Id: <20220124184127.412298584@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit d400a6cf1c8a57cdf10f35220ead3284320d85ff upstream.

Similar as with other pointer types where we use ldimm64, clear the register
content to zero first, and then populate the PTR_TO_FUNC type and subprogno
number. Currently this is not done, and leads to reuse of stale register
tracking data.

Given for special ldimm64 cases we always clear the register offset, make it
common for all cases, so it won't be forgotten in future.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9199,9 +9199,13 @@ static int check_ld_imm(struct bpf_verif
 		return 0;
 	}
 
-	if (insn->src_reg == BPF_PSEUDO_BTF_ID) {
-		mark_reg_known_zero(env, regs, insn->dst_reg);
+	/* All special src_reg cases are listed below. From this point onwards
+	 * we either succeed and assign a corresponding dst_reg->type after
+	 * zeroing the offset, or fail and reject the program.
+	 */
+	mark_reg_known_zero(env, regs, insn->dst_reg);
 
+	if (insn->src_reg == BPF_PSEUDO_BTF_ID) {
 		dst_reg->type = aux->btf_var.reg_type;
 		switch (dst_reg->type) {
 		case PTR_TO_MEM:
@@ -9238,7 +9242,6 @@ static int check_ld_imm(struct bpf_verif
 	}
 
 	map = env->used_maps[aux->map_index];
-	mark_reg_known_zero(env, regs, insn->dst_reg);
 	dst_reg->map_ptr = map;
 
 	if (insn->src_reg == BPF_PSEUDO_MAP_VALUE ||


