Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73E547ADE7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbhLTO4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58432 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235672AbhLTOwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A176BB80EEB;
        Mon, 20 Dec 2021 14:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BFBC36AE8;
        Mon, 20 Dec 2021 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011924;
        bh=hGdh300jJjG7I8tK+x2X40dh/OlUgdx9kf4QRPpOn/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bl/+FPI2JRbeN8I8pOOdnp/17ASXH1M2dLSQ1kgYbrASUlhhxluK83bPZG68lsf/T
         4brkToJb/C7TP4Dnt/mPGVhG2/57uCKhXqtaSyNny6r3AbLSh8Qk/1tL1qPTl1azsN
         63pXAN6DQy1s9I5K5DhbHt8C2k7P2X8+217Uz8qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Jackman <jackmanb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 018/177] bpf: Fix kernel address leakage in atomic cmpxchgs r0 aux reg
Date:   Mon, 20 Dec 2021 15:32:48 +0100
Message-Id: <20211220143040.691107716@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit a82fe085f344ef20b452cd5f481010ff96b5c4cd upstream.

The implementation of BPF_CMPXCHG on a high level has the following parameters:

  .-[old-val]                                          .-[new-val]
  BPF_R0 = cmpxchg{32,64}(DST_REG + insn->off, BPF_R0, SRC_REG)
                          `-[mem-loc]          `-[old-val]

Given a BPF insn can only have two registers (dst, src), the R0 is fixed and
used as an auxilliary register for input (old value) as well as output (returning
old value from memory location). While the verifier performs a number of safety
checks, it misses to reject unprivileged programs where R0 contains a pointer as
old value.

Through brute-forcing it takes about ~16sec on my machine to leak a kernel pointer
with BPF_CMPXCHG. The PoC is basically probing for kernel addresses by storing the
guessed address into the map slot as a scalar, and using the map value pointer as
R0 while SRC_REG has a canary value to detect a matching address.

Fix it by checking R0 for pointers, and reject if that's the case for unprivileged
programs.

Fixes: 5ffa25502b5a ("bpf: Add instructions for atomic_[cmp]xchg")
Reported-by: Ryota Shiga (Flatt Security)
Acked-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4386,9 +4386,16 @@ static int check_atomic(struct bpf_verif
 
 	if (insn->imm == BPF_CMPXCHG) {
 		/* Check comparison of R0 with memory location */
-		err = check_reg_arg(env, BPF_REG_0, SRC_OP);
+		const u32 aux_reg = BPF_REG_0;
+
+		err = check_reg_arg(env, aux_reg, SRC_OP);
 		if (err)
 			return err;
+
+		if (is_pointer_value(env, aux_reg)) {
+			verbose(env, "R%d leaks addr into mem\n", aux_reg);
+			return -EACCES;
+		}
 	}
 
 	if (is_pointer_value(env, insn->src_reg)) {


