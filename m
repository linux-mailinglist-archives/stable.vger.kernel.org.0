Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96063441664
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhKAJYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232075AbhKAJX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:23:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12834610EA;
        Mon,  1 Nov 2021 09:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758443;
        bh=Hd29uUIdD4UJUhWfzEmkEa3ciDeI5+MBQPtX0pNDv68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+f6bN89yKZ8oWUFYaeFdCgVoMWqnNeZS5NxcMAHfIgiWUYoljo5yEIHPeMdmia/B
         +GE//70NZoyS7ehv2xGGhlH+EWFEcLPaUR+JkbcHlkmP55cRWS9dieFM7redrSvvoK
         gX08Xsuy3zkBERRl8KyV+fleGQoD3fF/2gqrOhJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 04/25] powerpc/bpf: Fix BPF_MOD when imm == 1
Date:   Mon,  1 Nov 2021 10:17:16 +0100
Message-Id: <20211101082448.033647002@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082447.070493993@linuxfoundation.org>
References: <20211101082447.070493993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit 8bbc9d822421d9ac8ff9ed26a3713c9afc69d6c8 upstream.

Only ignore the operation if dividing by 1.

Fixes: 156d0e290e969c ("powerpc/ebpf/jit: Implement JIT compiler for extended BPF")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Tested-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c674ca18c3046885602caebb326213731c675d06.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
[cascardo: use PPC_LI instead of EMIT(PPC_RAW_LI)]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit_comp64.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -426,8 +426,14 @@ static int bpf_jit_build_body(struct bpf
 		case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /= imm */
 			if (imm == 0)
 				return -EINVAL;
-			else if (imm == 1)
-				goto bpf_alu32_trunc;
+			if (imm == 1) {
+				if (BPF_OP(code) == BPF_DIV) {
+					goto bpf_alu32_trunc;
+				} else {
+					PPC_LI(dst_reg, 0);
+					break;
+				}
+			}
 
 			PPC_LI32(b2p[TMP_REG_1], imm);
 			switch (BPF_CLASS(code)) {


