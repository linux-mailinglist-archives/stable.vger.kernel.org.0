Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FAE27C751
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgI2LxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729752AbgI2LrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53FE12075F;
        Tue, 29 Sep 2020 11:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380024;
        bh=PjuISOa82blkMWfP52o6yU3VYHCNd9RDj3ZnzSlk5H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tf5pU0w5//Bt/5EUQSqgHXN/GaY3Il4JLHBEu8ntxYHqIyF+HwuNecek9EuhH89q6
         hRaTihmuXG3UbooCbTYBqjoNVkgpHZC6N0RXWfqDzbeWtR/IsEvphIr6oKsL9aNYKB
         Q5ga7XHF4mD201PU/exQtxa7Uoc4CZApSCXDBhoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bryce Kahle <bryce.kahle@datadoghq.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 34/99] bpf: Fix clobbering of r2 in bpf_gen_ld_abs
Date:   Tue, 29 Sep 2020 13:01:17 +0200
Message-Id: <20200929105931.408544866@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e6a18d36118bea3bf497c9df4d9988b6df120689 ]

Bryce reported that he saw the following with:

  0:  r6 = r1
  1:  r1 = 12
  2:  r0 = *(u16 *)skb[r1]

The xlated sequence was incorrectly clobbering r2 with pointer
value of r6 ...

  0: (bf) r6 = r1
  1: (b7) r1 = 12
  2: (bf) r1 = r6
  3: (bf) r2 = r1
  4: (85) call bpf_skb_load_helper_16_no_cache#7692160

... and hence call to the load helper never succeeded given the
offset was too high. Fix it by reordering the load of r6 to r1.

Other than that the insn has similar calling convention than BPF
helpers, that is, r0 - r5 are scratch regs, so nothing else
affected after the insn.

Fixes: e0cea7ce988c ("bpf: implement ld_abs/ld_ind in native bpf")
Reported-by: Bryce Kahle <bryce.kahle@datadoghq.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/cace836e4d07bb63b1a53e49c5dfb238a040c298.1599512096.git.daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d13ea1642b974..0261531d4fda6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6998,8 +6998,6 @@ static int bpf_gen_ld_abs(const struct bpf_insn *orig,
 	bool indirect = BPF_MODE(orig->code) == BPF_IND;
 	struct bpf_insn *insn = insn_buf;
 
-	/* We're guaranteed here that CTX is in R6. */
-	*insn++ = BPF_MOV64_REG(BPF_REG_1, BPF_REG_CTX);
 	if (!indirect) {
 		*insn++ = BPF_MOV64_IMM(BPF_REG_2, orig->imm);
 	} else {
@@ -7007,6 +7005,8 @@ static int bpf_gen_ld_abs(const struct bpf_insn *orig,
 		if (orig->imm)
 			*insn++ = BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, orig->imm);
 	}
+	/* We're guaranteed here that CTX is in R6. */
+	*insn++ = BPF_MOV64_REG(BPF_REG_1, BPF_REG_CTX);
 
 	switch (BPF_SIZE(orig->code)) {
 	case BPF_B:
-- 
2.25.1



