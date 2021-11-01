Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B22244184E
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhKAJpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234116AbhKAJoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EBA8613A8;
        Mon,  1 Nov 2021 09:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758970;
        bh=js6PGcD2sqCtv9u3aattD7TJxF1BWSw49LaHNk+d62c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=de1mmMqqohQadGug1GlMQTxHnAaCRyqn3BKTfEO/BeV7tUEUjQkpje0rqmGqF3i3r
         DCT9oEA6wrA2AkP6aEXja79gqlsL0FKHe1V+dNtvrPO/mswBgDfEKnQxCQhCyqHAZt
         PHMud1Hs1ky96QB5Romsa6sr74msvdHTwbjYUjFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 059/125] riscv, bpf: Fix potential NULL dereference
Date:   Mon,  1 Nov 2021 10:17:12 +0100
Message-Id: <20211101082544.363747884@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn@kernel.org>

commit 27de809a3d83a6199664479ebb19712533d6fd9b upstream.

The bpf_jit_binary_free() function requires a non-NULL argument. When
the RISC-V BPF JIT fails to converge in NR_JIT_ITERATIONS steps,
jit_data->header will be NULL, which triggers a NULL
dereference. Avoid this by checking the argument, prior calling the
function.

Fixes: ca6cb5447cec ("riscv, bpf: Factor common RISC-V JIT code")
Signed-off-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20211028125115.514587-1-bjorn@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/net/bpf_jit_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -125,7 +125,8 @@ struct bpf_prog *bpf_int_jit_compile(str
 
 	if (i == NR_JIT_ITERATIONS) {
 		pr_err("bpf-jit: image did not converge in <%d passes!\n", i);
-		bpf_jit_binary_free(jit_data->header);
+		if (jit_data->header)
+			bpf_jit_binary_free(jit_data->header);
 		prog = orig_prog;
 		goto out_offset;
 	}


