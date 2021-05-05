Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D375F3739F5
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhEEMGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233297AbhEEMG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAF3261222;
        Wed,  5 May 2021 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216330;
        bh=IB6vIYypWQb4OzWkItWsEkYq8FQ4fbMULXjMce9s+V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVHqFUEBZGe/ERl4DUXhIBFdHHmpgbnLgj+bcc1DAwTSj8MYrbsOCkGUgalhkhBfu
         tG5UstZEuVrtMp6TO3z6tXeaZxDGTd7sqJaFGquiVcRLWZcP0rxH8yf9eCHK40dA+e
         5jyTTqTXpROm7y0llT7EHRSTSGT9oQkHBwBTpqyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Piotr Krysiuk <piotras@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 07/21] bpf: Fix masking negation logic upon negative dst register
Date:   Wed,  5 May 2021 14:04:21 +0200
Message-Id: <20210505112324.966282033@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit b9b34ddbe2076ade359cd5ce7537d5ed019e9807 upstream.

The negation logic for the case where the off_reg is sitting in the
dst register is not correct given then we cannot just invert the add
to a sub or vice versa. As a fix, perform the final bitwise and-op
unconditionally into AX from the off_reg, then move the pointer from
the src to dst and finally use AX as the source for the original
pointer arithmetic operation such that the inversion yields a correct
result. The single non-AX mov in between is possible given constant
blinding is retaining it as it's not an immediate based operation.

Fixes: 979d63d50c0c ("bpf: prevent out of bounds speculation on pointer arithmetic")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Piotr Krysiuk <piotras@gmail.com>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9176,14 +9176,10 @@ static int fixup_bpf_calls(struct bpf_ve
 			*patch++ = BPF_ALU64_REG(BPF_OR, BPF_REG_AX, off_reg);
 			*patch++ = BPF_ALU64_IMM(BPF_NEG, BPF_REG_AX, 0);
 			*patch++ = BPF_ALU64_IMM(BPF_ARSH, BPF_REG_AX, 63);
-			if (issrc) {
-				*patch++ = BPF_ALU64_REG(BPF_AND, BPF_REG_AX,
-							 off_reg);
-				insn->src_reg = BPF_REG_AX;
-			} else {
-				*patch++ = BPF_ALU64_REG(BPF_AND, off_reg,
-							 BPF_REG_AX);
-			}
+			*patch++ = BPF_ALU64_REG(BPF_AND, BPF_REG_AX, off_reg);
+			if (!issrc)
+				*patch++ = BPF_MOV64_REG(insn->dst_reg, insn->src_reg);
+			insn->src_reg = BPF_REG_AX;
 			if (isneg)
 				insn->code = insn->code == code_add ?
 					     code_sub : code_add;


