Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5853534443B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhCVM7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231494AbhCVM4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9473D619B3;
        Mon, 22 Mar 2021 12:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417307;
        bh=jqJcBmEi+b0x47+Nj2hWl1lgcgvC4/LQapDnsBycC3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dn035BOL1DgzFsfYOSnj4p+497kI47RSzevZwfmGmmEa606ujtyNovN++B2qmNWqT
         S8/j692Gq2mPLbj3UsXaxdssLu4zYYABAEt6EOII5eGQsCfjafJLX+C4XDjN/hSE+v
         9EW6TNhxcml5gPPj24u+5qyr0Qw17sUo5OefHg5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.14 05/43] bpf: Simplify alu_limit masking for pointer arithmetic
Date:   Mon, 22 Mar 2021 13:28:46 +0100
Message-Id: <20210322121920.230234974@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Krysiuk <piotras@gmail.com>

commit b5871dca250cd391885218b99cc015aca1a51aea upstream.

Instead of having the mov32 with aux->alu_limit - 1 immediate, move this
operation to retrieve_ptr_limit() instead to simplify the logic and to
allow for subsequent sanity boundary checks inside retrieve_ptr_limit().
This avoids in future that at the time of the verifier masking rewrite
we'd run into an underflow which would not sign extend due to the nature
of mov32 instruction.

Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2035,16 +2035,16 @@ static int retrieve_ptr_limit(const stru
 	case PTR_TO_STACK:
 		off = ptr_reg->off + ptr_reg->var_off.value;
 		if (mask_to_left)
-			*ptr_limit = MAX_BPF_STACK + off + 1;
+			*ptr_limit = MAX_BPF_STACK + off;
 		else
-			*ptr_limit = -off;
+			*ptr_limit = -off - 1;
 		return 0;
 	case PTR_TO_MAP_VALUE:
 		if (mask_to_left) {
-			*ptr_limit = ptr_reg->umax_value + ptr_reg->off + 1;
+			*ptr_limit = ptr_reg->umax_value + ptr_reg->off;
 		} else {
 			off = ptr_reg->smin_value + ptr_reg->off;
-			*ptr_limit = ptr_reg->map_ptr->value_size - off;
+			*ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
 		}
 		return 0;
 	default:
@@ -4802,7 +4802,7 @@ static int fixup_bpf_calls(struct bpf_ve
 			off_reg = issrc ? insn->src_reg : insn->dst_reg;
 			if (isneg)
 				*patch++ = BPF_ALU64_IMM(BPF_MUL, off_reg, -1);
-			*patch++ = BPF_MOV32_IMM(BPF_REG_AX, aux->alu_limit - 1);
+			*patch++ = BPF_MOV32_IMM(BPF_REG_AX, aux->alu_limit);
 			*patch++ = BPF_ALU64_REG(BPF_SUB, BPF_REG_AX, off_reg);
 			*patch++ = BPF_ALU64_REG(BPF_OR, BPF_REG_AX, off_reg);
 			*patch++ = BPF_ALU64_IMM(BPF_NEG, BPF_REG_AX, 0);


