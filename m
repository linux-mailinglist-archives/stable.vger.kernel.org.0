Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C37642910E
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244134AbhJKOPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239084AbhJKOLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9407A6126A;
        Mon, 11 Oct 2021 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960994;
        bh=vHuI72IqEoknOhtdRhBCZAVIpNrXyT+CCVWDDJ8dn5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6TM/3nybvb3xNm7DnbMVVN3thR4bIMX69ShjKy/Q7KAG1qxgVOj40S7uIXSDy/Ar
         f1j6yZSmd7A3srZE7/Ao8husm6Ovf5poZLUX6/4+fkgQkuxOXRi2NutbrQX/ziolvA
         tuuzou7omEe0F7/jv0+2gdFUkcrvW3vFYsgCGbOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 135/151] powerpc/bpf ppc32: Fix ALU32 BPF_ARSH operation
Date:   Mon, 11 Oct 2021 15:46:47 +0200
Message-Id: <20211011134522.165522140@linuxfoundation.org>
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

[ Upstream commit c9b8da77f22d28348d1f89a6c4d3fec102e9b1c4 ]

Correct the destination register used for ALU32 BPF_ARSH operation.

Fixes: 51c66ad849a703 ("powerpc/bpf: Implement extended BPF on PPC32")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/6d24c1f9e79b6f61f5135eaf2ea1e8bcd4dac87b.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index beb12cbc8c29..faef4a1598fd 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -623,7 +623,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 			EMIT(PPC_RAW_LI(dst_reg_h, 0));
 			break;
 		case BPF_ALU | BPF_ARSH | BPF_X: /* (s32) dst >>= src */
-			EMIT(PPC_RAW_SRAW(dst_reg_h, dst_reg, src_reg));
+			EMIT(PPC_RAW_SRAW(dst_reg, dst_reg, src_reg));
 			break;
 		case BPF_ALU64 | BPF_ARSH | BPF_X: /* (s64) dst >>= src */
 			bpf_set_seen_register(ctx, tmp_reg);
-- 
2.33.0



