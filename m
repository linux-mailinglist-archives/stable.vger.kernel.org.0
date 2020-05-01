Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99651C14E4
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbgEANnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731680AbgEANnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06BF22051A;
        Fri,  1 May 2020 13:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340632;
        bh=xQhIbqv9qqbGbztx1QNd5fp99mJetbAhMqDs+wPVU+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0UuihE8G+GjHEDpz1fuhv3EMFWKBzR4Jb0UMR+loav+6r2cNLjr6j7Pb2NBbxjRpG
         KM1SF02nK0qeymr8/MbyQIhVzuMEph0R5q1CrcUi0NUZtB5oZSNY+6cbKEE2B5P9YV
         9srgI8r4AQavU2f19lK9zvpajNROsbtDFpVeueQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "H. Peter Anvin (Intel)" <hpa@zytor.com>,
        Wang YanQing <udknight@gmail.com>
Subject: [PATCH 5.6 061/106] bpf, x86_32: Fix incorrect encoding in BPF_LDX zero-extension
Date:   Fri,  1 May 2020 15:23:34 +0200
Message-Id: <20200501131550.891106146@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

commit 5fa9a98fb10380e48a398998cd36a85e4ef711d6 upstream.

The current JIT uses the following sequence to zero-extend into the
upper 32 bits of the destination register for BPF_LDX BPF_{B,H,W},
when the destination register is not on the stack:

  EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);

The problem is that C7 /0 encodes a MOV instruction that requires a 4-byte
immediate; the current code emits only 1 byte of the immediate. This
means that the first 3 bytes of the next instruction will be treated as
the rest of the immediate, breaking the stream of instructions.

This patch fixes the problem by instead emitting "xor dst_hi,dst_hi"
to clear the upper 32 bits. This fixes the problem and is more efficient
than using MOV to load a zero immediate.

This bug may not be currently triggerable as BPF_REG_AX is the only
register not stored on the stack and the verifier uses it in a limited
way, and the verifier implements a zero-extension optimization. But the
JIT should avoid emitting incorrect encodings regardless.

Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Acked-by: Wang YanQing <udknight@gmail.com>
Link: https://lore.kernel.org/bpf/20200422173630.8351-1-luke.r.nels@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/net/bpf_jit_comp32.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1854,7 +1854,9 @@ static int do_jit(struct bpf_prog *bpf_p
 					      STACK_VAR(dst_hi));
 					EMIT(0x0, 4);
 				} else {
-					EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);
+					/* xor dst_hi,dst_hi */
+					EMIT2(0x33,
+					      add_2reg(0xC0, dst_hi, dst_hi));
 				}
 				break;
 			case BPF_DW:


