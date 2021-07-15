Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B933CAACC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243682AbhGOTPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244428AbhGOTOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF6E3613F2;
        Thu, 15 Jul 2021 19:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376227;
        bh=7MPuI7HQIsQRr261hVvk0fPJba0H/8bR2LnvPM9k0u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxaY2Yquj7z3WkY8UMbTLdeEJmck3s44QCfRyTXl/a7jrqDwvUhmQexoch0Ugahyi
         9bBxGoGhT9L+noKq5hnnqqtGQOSBmvqPE3jm+9PSxfpVlzoHZvAwZWBEcra6M3qSKE
         PmDMq92KWIJ0pG6fMxlsh6OXo7zh69Km5D+fyfuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 181/266] powerpc/bpf: Reject atomic ops in ppc32 JIT
Date:   Thu, 15 Jul 2021 20:38:56 +0200
Message-Id: <20210715182643.552266960@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit 307e5042c7bdae15308ef2e9b848833b84122eb0 upstream.

Commit 91c960b0056672 ("bpf: Rename BPF_XADD and prepare to encode other
atomics in .imm") converted BPF_XADD to BPF_ATOMIC and updated all JIT
implementations to reject JIT'ing instructions with an immediate value
different from BPF_ADD. However, ppc32 BPF JIT was implemented around
the same time and didn't include the same change. Update the ppc32 JIT
accordingly.

Fixes: 51c66ad849a7 ("powerpc/bpf: Implement extended BPF on PPC32")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/426699046d89fe50f66ecf74bd31c01eda976ba5.1625145429.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/net/bpf_jit_comp32.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -773,9 +773,17 @@ int bpf_jit_build_body(struct bpf_prog *
 			break;
 
 		/*
-		 * BPF_STX XADD (atomic_add)
+		 * BPF_STX ATOMIC (atomic ops)
 		 */
-		case BPF_STX | BPF_XADD | BPF_W: /* *(u32 *)(dst + off) += src */
+		case BPF_STX | BPF_ATOMIC | BPF_W:
+			if (imm != BPF_ADD) {
+				pr_err_ratelimited("eBPF filter atomic op code %02x (@%d) unsupported\n",
+						   code, i);
+				return -ENOTSUPP;
+			}
+
+			/* *(u32 *)(dst + off) += src */
+
 			bpf_set_seen_register(ctx, tmp_reg);
 			/* Get offset into TMP_REG */
 			EMIT(PPC_RAW_LI(tmp_reg, off));
@@ -789,7 +797,7 @@ int bpf_jit_build_body(struct bpf_prog *
 			PPC_BCC_SHORT(COND_NE, (ctx->idx - 3) * 4);
 			break;
 
-		case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + off) += src */
+		case BPF_STX | BPF_ATOMIC | BPF_DW: /* *(u64 *)(dst + off) += src */
 			return -EOPNOTSUPP;
 
 		/*


