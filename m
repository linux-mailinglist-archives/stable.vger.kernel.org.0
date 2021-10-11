Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594EE428F1F
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbhJKNzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237582AbhJKNwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15D8561076;
        Mon, 11 Oct 2021 13:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960202;
        bh=FBk/GQbLGbKSsw3T8V70nbKvNWPZz98C+9m0gZvZrPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQzmdmWwkYYdrXREjHNwqw5UAkYCtyRlOecT6maTGLzLIn3rjQUQ80w1cA8seOqHK
         6+lRCtTZE4qGiI9jkgZuGIv8sC6cTTNi3MPjvpXbR2XcaalltCeR8XuI9VBkPjT92B
         P8b903BFD4w1rvtOm4QSsVvApJAW3A25hvBvWgJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/52] powerpc/bpf: Fix BPF_MOD when imm == 1
Date:   Mon, 11 Oct 2021 15:46:18 +0200
Message-Id: <20211011134505.420785540@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 8bbc9d822421d9ac8ff9ed26a3713c9afc69d6c8 ]

Only ignore the operation if dividing by 1.

Fixes: 156d0e290e969c ("powerpc/ebpf/jit: Implement JIT compiler for extended BPF")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Tested-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c674ca18c3046885602caebb326213731c675d06.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp64.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 20bfd753bcba..a05386318f70 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -408,8 +408,14 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /= imm */
 			if (imm == 0)
 				return -EINVAL;
-			else if (imm == 1)
-				goto bpf_alu32_trunc;
+			if (imm == 1) {
+				if (BPF_OP(code) == BPF_DIV) {
+					goto bpf_alu32_trunc;
+				} else {
+					EMIT(PPC_RAW_LI(dst_reg, 0));
+					break;
+				}
+			}
 
 			PPC_LI32(b2p[TMP_REG_1], imm);
 			switch (BPF_CLASS(code)) {
-- 
2.33.0



