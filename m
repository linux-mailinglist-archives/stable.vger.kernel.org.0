Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BEA43C88E
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 13:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbhJ0LbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 07:31:04 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33744
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234849AbhJ0LbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 07:31:00 -0400
Received: from mussarela.. (201-43-198-173.dsl.telesp.net.br [201.43.198.173])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id A70CD3F1AF;
        Wed, 27 Oct 2021 11:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635334111;
        bh=XlqBZiePGXEvvtZfAwrf4ktAoKjm6h9SruUXSwAjfGQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=k8nrRUMWdkzpaM464az8K6jmf7WNvGyL+nPPaUiZbTaOeDFDTfTdRjs4gnK7jU3EC
         g9G8am4PA6KX/fpvkokkToY3XGh8IGIketS8BotVolR9r6cn/94Dmn4Smb7IJt9NIf
         ZvtkHJTGTdNwzYJ+7RHgDmHLVErJsHOyJsMtgIwXyeDI3woNF9Y2OYYkZHhocnkU0b
         ZW7Oe3rabrFmK/Y7DDfBcbYc8igTdkdDj+gcrkoTEXYYUqehmCGV0/c4lAWmrVXq16
         FI87PfRimUedURwlMvUTeKqWgh4gaAYdzqAtwJCI1/rKgpOLQi66LOn9Nr6X84bZs9
         zdxd4AwiiqQOQ==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.9/4.14/4.19/5.4] powerpc/bpf: Fix BPF_MOD when imm == 1
Date:   Wed, 27 Oct 2021 08:28:04 -0300
Message-Id: <20211027112804.1273985-2-cascardo@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211027112804.1273985-1-cascardo@canonical.com>
References: <20211027112804.1273985-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

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
---
 arch/powerpc/net/bpf_jit_comp64.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 20bfd753bcba..81e6279c9874 100644
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
+					PPC_LI(dst_reg, 0);
+					break;
+				}
+			}
 
 			PPC_LI32(b2p[TMP_REG_1], imm);
 			switch (BPF_CLASS(code)) {
-- 
2.32.0

