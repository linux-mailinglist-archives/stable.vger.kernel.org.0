Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B784290EC
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241003AbhJKOOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238697AbhJKOLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:11:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D86611CB;
        Mon, 11 Oct 2021 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960997;
        bh=hRg2QCYRsHOa1NWe5FH4IXbq6lsS7XC8uW8yuWmLmiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIbaqLIHa2PIo4rjQeeZKHnd5S1PEy9xtF0JUajM1DlooChOn57agW/cGRqFl4wlY
         FkaliWcuawyMs32AnNMqJhcvF+OY+RFnnb696pe6Wt+wZ3DlftKBGXZUJjBCULPgeN
         PMN/H+FqQzbgK9eFT6HwX3W1eKZ1yIXDj1coa67Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 136/151] powerpc/bpf ppc32: Fix JMP32_JSET_K
Date:   Mon, 11 Oct 2021 15:46:48 +0200
Message-Id: <20211011134522.203541562@linuxfoundation.org>
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

[ Upstream commit e8278d44443207bb6609c7b064073f353e6f4978 ]

'andi' only takes an unsigned 16-bit value. Correct the imm range used
when emitting andi.

Fixes: 51c66ad849a703 ("powerpc/bpf: Implement extended BPF on PPC32")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b94489f52831305ec15aca4dd04a3527236be7e8.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index faef4a1598fd..ae3a31cb7b7e 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -1073,7 +1073,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 				break;
 			case BPF_JMP32 | BPF_JSET | BPF_K:
 				/* andi does not sign-extend the immediate */
-				if (imm >= -32768 && imm < 32768) {
+				if (imm >= 0 && imm < 32768) {
 					/* PPC_ANDI is _only/always_ dot-form */
 					EMIT(PPC_RAW_ANDI(_R0, dst_reg, imm));
 				} else {
-- 
2.33.0



