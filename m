Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84C04290F0
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbhJKOOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239797AbhJKOL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F8F61284;
        Mon, 11 Oct 2021 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961002;
        bh=jjsZq5VgWIZzqUYZOWyoWCPbH8wRM0z+PvXIQlnLlLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBwYpeCaNZxayXKDhZpKQZ/KajDyp5BJtT5Aa/3tqNCCIKDAGM0yc+S+KJSdSvofX
         sjF7jQ8XUbRykYs4jpJj5kCMmF2e3dVujcQ8effp+Ml+9om6l24PHwwQdXPMnn34C4
         0vOYEw3/gXTNkkkrJsVVa/cUGpPa+/rVFR4VltKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 137/151] powerpc/bpf ppc32: Do not emit zero extend instruction for 64-bit BPF_END
Date:   Mon, 11 Oct 2021 15:46:49 +0200
Message-Id: <20211011134522.233481711@linuxfoundation.org>
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

[ Upstream commit 48164fccdff6d5cc11308126c050bd25a329df25 ]

Suppress emitting zero extend instruction for 64-bit BPF_END_FROM_[L|B]E
operation.

Fixes: 51c66ad849a703 ("powerpc/bpf: Implement extended BPF on PPC32")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b4e3c3546121315a8e2059b19a1bda84971816e4.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index ae3a31cb7b7e..c48de048c8ce 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -1103,7 +1103,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 			return -EOPNOTSUPP;
 		}
 		if (BPF_CLASS(code) == BPF_ALU && !fp->aux->verifier_zext &&
-		    !insn_is_zext(&insn[i + 1]))
+		    !insn_is_zext(&insn[i + 1]) && !(BPF_OP(code) == BPF_END && imm == 64))
 			EMIT(PPC_RAW_LI(dst_reg_h, 0));
 	}
 
-- 
2.33.0



