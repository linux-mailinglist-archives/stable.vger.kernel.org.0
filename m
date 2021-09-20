Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41569411FE0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349343AbhITRqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352980AbhITRm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BF0B61B60;
        Mon, 20 Sep 2021 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157737;
        bh=dz9QHFgpjtF0W5zMIO7A8wdUyXVEFgGTDCA6HPtfahY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/Z1+S4Nb0LbIFD7qakFqOtyTbYJArtCiqC3wIa3sSdbeIYtDL62ktAte7VoYagrA
         kqQZOJVs06HFqy7Ectw1KeR+Tor/DZBSI/FDVJ4DOHHdMMiJ7GWB9ES/LSG/jvOigg
         /LdBlSGzLP1G3L93/ly3l2XJAtK1RUgTt2jv9GRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 128/293] bpf: correct slot_type marking logic to allow more stack slot sharing
Date:   Mon, 20 Sep 2021 18:41:30 +0200
Message-Id: <20210920163937.641914891@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiong Wang <jiong.wang@netronome.com>

commit 0bae2d4d62d523f06ff1a8e88ce38b45400acd28 upstream.

Verifier is supposed to support sharing stack slot allocated to ptr with
SCALAR_VALUE for privileged program. However this doesn't happen for some
cases.

The reason is verifier is not clearing slot_type STACK_SPILL for all bytes,
it only clears part of them, while verifier is using:

  slot_type[0] == STACK_SPILL

as a convention to check one slot is ptr type.

So, the consequence of partial clearing slot_type is verifier could treat a
partially overridden ptr slot, which should now be a SCALAR_VALUE slot,
still as ptr slot, and rejects some valid programs.

Before this patch, test_xdp_noinline.o under bpf selftests, bpf_lxc.o and
bpf_netdev.o under Cilium bpf repo, when built with -mattr=+alu32 are
rejected due to this issue. After this patch, they all accepted.

There is no processed insn number change before and after this patch on
Cilium bpf programs.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[OP: adjusted context for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c                       |    5 ++++
 tools/testing/selftests/bpf/test_verifier.c |   34 ++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1039,6 +1039,10 @@ static int check_stack_write(struct bpf_
 
 		/* regular write of data into stack destroys any spilled ptr */
 		state->stack[spi].spilled_ptr.type = NOT_INIT;
+		/* Mark slots as STACK_MISC if they belonged to spilled ptr. */
+		if (state->stack[spi].slot_type[0] == STACK_SPILL)
+			for (i = 0; i < BPF_REG_SIZE; i++)
+				state->stack[spi].slot_type[i] = STACK_MISC;
 
 		/* only mark the slot as written if all 8 bytes were written
 		 * otherwise read propagation may incorrectly stop too soon
@@ -1056,6 +1060,7 @@ static int check_stack_write(struct bpf_
 		    register_is_null(&cur->regs[value_regno]))
 			type = STACK_ZERO;
 
+		/* Mark slots affected by this stack write. */
 		for (i = 0; i < size; i++)
 			state->stack[spi].slot_type[(slot - i) % BPF_REG_SIZE] =
 				type;
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -956,16 +956,46 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_1, -8),
 			/* mess up with R1 pointer on stack */
 			BPF_ST_MEM(BPF_B, BPF_REG_10, -7, 0x23),
-			/* fill back into R0 should fail */
+			/* fill back into R0 is fine for priv.
+			 * R0 now becomes SCALAR_VALUE.
+			 */
 			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_10, -8),
+			/* Load from R0 should fail. */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 8),
 			BPF_EXIT_INSN(),
 		},
 		.errstr_unpriv = "attempt to corrupt spilled",
-		.errstr = "corrupted spill",
+		.errstr = "R0 invalid mem access 'inv",
 		.result = REJECT,
 		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
+		"check corrupted spill/fill, LSB",
+		.insns = {
+			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_1, -8),
+			BPF_ST_MEM(BPF_H, BPF_REG_10, -8, 0xcafe),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_10, -8),
+			BPF_EXIT_INSN(),
+		},
+		.errstr_unpriv = "attempt to corrupt spilled",
+		.result_unpriv = REJECT,
+		.result = ACCEPT,
+		.retval = POINTER_VALUE,
+	},
+	{
+		"check corrupted spill/fill, MSB",
+		.insns = {
+			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_1, -8),
+			BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0x12345678),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_10, -8),
+			BPF_EXIT_INSN(),
+		},
+		.errstr_unpriv = "attempt to corrupt spilled",
+		.result_unpriv = REJECT,
+		.result = ACCEPT,
+		.retval = POINTER_VALUE,
+	},
+	{
 		"invalid src register in STX",
 		.insns = {
 			BPF_STX_MEM(BPF_B, BPF_REG_10, -1, -1),


