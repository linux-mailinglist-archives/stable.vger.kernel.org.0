Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F81A4290F3
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241428AbhJKOOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241822AbhJKOMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:12:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 358F86127B;
        Mon, 11 Oct 2021 14:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961005;
        bh=smZgp0YAeFcL9zbCEr/we141EXz/cpjyMdwcUiBdi14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcBSDVxooVM2ydT7rLVKmjZBKMWlrMyQLbT7MkGPT44Aw+iJqC9b4qqw1t3UAsvUR
         m+m1QS4RKR6sL5ZE7M3JLsgQxCz+x7MXvAGyv18M6tSWEHnEN3+sTkefo3BQ9koLtw
         /01rk/JP1y/+goPtl5ysBRoqOy9o9K6io5gzKwQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 138/151] powerpc/bpf ppc32: Fix BPF_SUB when imm == 0x80000000
Date:   Mon, 11 Oct 2021 15:46:50 +0200
Message-Id: <20211011134522.263427461@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 548b762763b885b81850db676258df47c55dd5f9 ]

Special case handling of the smallest 32-bit negative number for BPF_SUB.

Fixes: 51c66ad849a703 ("powerpc/bpf: Implement extended BPF on PPC32")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/7135360a0cdf70adedbccf9863128b8daef18764.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index c48de048c8ce..a7759aa8043d 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -355,7 +355,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 				PPC_LI32(_R0, imm);
 				EMIT(PPC_RAW_ADDC(dst_reg, dst_reg, _R0));
 			}
-			if (imm >= 0)
+			if (imm >= 0 || (BPF_OP(code) == BPF_SUB && imm == 0x80000000))
 				EMIT(PPC_RAW_ADDZE(dst_reg_h, dst_reg_h));
 			else
 				EMIT(PPC_RAW_ADDME(dst_reg_h, dst_reg_h));
-- 
2.33.0



