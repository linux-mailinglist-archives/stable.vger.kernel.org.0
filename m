Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AAF36AE83
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhDZHp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233357AbhDZHne (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A77B613B2;
        Mon, 26 Apr 2021 07:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422793;
        bh=fXYI7LkxEUEiQL+M9Fyog+fr9/YAJ+bUjLFnHYnJaIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbixGl6dX++pCqsTeMinf4jYuBHjh9x/xcxb8jEoNLQAUVc+7AjyKsfAvtRhAb0CQ
         7HCowttJrIsLyBio9clE3k18xaBqOsGHxQW/cmPGJF4jDfBZNmeLuRARQgkUH9HDlB
         ZGd4X4s2f+2nXBovFcXyG7iE9FWStOE5NwwDlqM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/36] bpf: Permits pointers on stack for helper calls
Date:   Mon, 26 Apr 2021 09:29:51 +0200
Message-Id: <20210426072819.114779832@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit cd17d38f8b28f808c368121041c0a4fa91757e0d ]

Currently, when checking stack memory accessed by helper calls,
for spills, only PTR_TO_BTF_ID and SCALAR_VALUE are
allowed.

Song discovered an issue where the below bpf program
  int dump_task(struct bpf_iter__task *ctx)
  {
    struct seq_file *seq = ctx->meta->seq;
    static char[] info = "abc";
    BPF_SEQ_PRINTF(seq, "%s\n", info);
    return 0;
  }
may cause a verifier failure.

The verifier output looks like:
  ; struct seq_file *seq = ctx->meta->seq;
  1: (79) r1 = *(u64 *)(r1 +0)
  ; BPF_SEQ_PRINTF(seq, "%s\n", info);
  2: (18) r2 = 0xffff9054400f6000
  4: (7b) *(u64 *)(r10 -8) = r2
  5: (bf) r4 = r10
  ;
  6: (07) r4 += -8
  ; BPF_SEQ_PRINTF(seq, "%s\n", info);
  7: (18) r2 = 0xffff9054400fe000
  9: (b4) w3 = 4
  10: (b4) w5 = 8
  11: (85) call bpf_seq_printf#126
   R1_w=ptr_seq_file(id=0,off=0,imm=0) R2_w=map_value(id=0,off=0,ks=4,vs=4,imm=0)
  R3_w=inv4 R4_w=fp-8 R5_w=inv8 R10=fp0 fp-8_w=map_value
  last_idx 11 first_idx 0
  regs=8 stack=0 before 10: (b4) w5 = 8
  regs=8 stack=0 before 9: (b4) w3 = 4
  invalid indirect read from stack off -8+0 size 8

Basically, the verifier complains the map_value pointer at "fp-8" location.
To fix the issue, if env->allow_ptr_leaks is true, let us also permit
pointers on the stack to be accessible by the helper.

Reported-by: Song Liu <songliubraving@fb.com>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20201210013349.943719-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3370f0d476e9..2e09e691a6be 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3759,7 +3759,8 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 			goto mark;
 
 		if (state->stack[spi].slot_type[0] == STACK_SPILL &&
-		    state->stack[spi].spilled_ptr.type == SCALAR_VALUE) {
+		    (state->stack[spi].spilled_ptr.type == SCALAR_VALUE ||
+		     env->allow_ptr_leaks)) {
 			__mark_reg_unknown(env, &state->stack[spi].spilled_ptr);
 			for (j = 0; j < BPF_REG_SIZE; j++)
 				state->stack[spi].slot_type[j] = STACK_MISC;
-- 
2.30.2



