Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F5C4999AD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455952AbiAXVgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34358 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376267AbiAXVNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCD6EB811F3;
        Mon, 24 Jan 2022 21:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8342C340E5;
        Mon, 24 Jan 2022 21:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058797;
        bh=RPNJE7lmv9dsqBv8r2uXE3MZEddVG5SDSzixqBWmW/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgE8WT0K1sanm2oj7HXRNMcdmiXlHf/B6n4ef6+WxzHmXraNMZrmfAU9qBNeTj1p2
         tpJBjUYsXJO9KdYO3qI38QCHQPiqemP+2WUsf1o6M8C43Zv/HIBay89qyogRkzo5m0
         7B7rvWKODuVvvChJN1eSFZOjsGCInLcBv3660RNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0372/1039] bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
Date:   Mon, 24 Jan 2022 19:36:01 +0100
Message-Id: <20220124184137.812097875@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit e4a41c2c1fa916547e63440c73a51a5eb06247af ]

The following error is reported when running "./test_progs -t for_each"
under arm64:

  bpf_jit: multi-func JIT bug 58 != 56
  [...]
  JIT doesn't support bpf-to-bpf calls

The root cause is the size of BPF_PSEUDO_FUNC instruction increases
from 2 to 3 after the address of called bpf-function is settled and
there are two bpf-to-bpf calls in test_pkt_access. The generated
instructions are shown below:

  0x48:  21 00 C0 D2    movz x1, #0x1, lsl #32
  0x4c:  21 00 80 F2    movk x1, #0x1

  0x48:  E1 3F C0 92    movn x1, #0x1ff, lsl #32
  0x4c:  41 FE A2 F2    movk x1, #0x17f2, lsl #16
  0x50:  81 70 9F F2    movk x1, #0xfb84

Fixing it by using emit_addr_mov_i64() for BPF_PSEUDO_FUNC, so
the size of jited image will not change.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211231151018.3781550-1-houtao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 3a8a7140a9bfb..c2d95aa1d294c 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -791,7 +791,10 @@ emit_cond_jmp:
 		u64 imm64;
 
 		imm64 = (u64)insn1.imm << 32 | (u32)imm;
-		emit_a64_mov_i64(dst, imm64, ctx);
+		if (bpf_pseudo_func(insn))
+			emit_addr_mov_i64(dst, imm64, ctx);
+		else
+			emit_a64_mov_i64(dst, imm64, ctx);
 
 		return 1;
 	}
-- 
2.34.1



