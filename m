Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E82111F6B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbfLCXIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729106AbfLCWpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 843432084B;
        Tue,  3 Dec 2019 22:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413149;
        bh=2gy4TInhbQX++Sx+cyKimzTAGXbO8qqAErtJUsX9N+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hzf2MFFgnqtCBUn5baEdyVYYzgJG77EyHwbmV5Ml2IV3BPk9TbKkvKuMOngn6BtoG
         S9zBGjIelC0gFCnNSyX722zMQNF9l0C8KEhNpDxcAMNlMvyoHSwr0HXDI8ujj60d+c
         qRcXReOB7HqfAgTUgFexT2ZlQGabqRJgXbK1enL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/321] powerpc/bpf: Fix tail call implementation
Date:   Tue,  3 Dec 2019 23:31:24 +0100
Message-Id: <20191203223428.068100947@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7de086909365cd60a5619a45af3f4152516fd75c ]

We have seen many crashes on powerpc hosts while loading bpf programs.

The problem here is that bpf_int_jit_compile() does a first pass
to compute the program length.

Then it allocates memory to store the generated program and
calls bpf_jit_build_body() a second time (and a third time
later)

What I have observed is that the second bpf_jit_build_body()
could end up using few more words than expected.

If bpf_jit_binary_alloc() put the space for the program
at the end of the allocated page, we then write on
a non mapped memory.

It appears that bpf_jit_emit_tail_call() calls
bpf_jit_emit_common_epilogue() while ctx->seen might not
be stable.

Only after the second pass we can be sure ctx->seen wont be changed.

Trying to avoid a second pass seems quite complex and probably
not worth it.

Fixes: ce0761419faef ("powerpc/bpf: Implement support for tail calls")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20191101033444.143741-1-edumazet@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp64.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 279a51bf94d05..7e3ab477f67fe 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -949,6 +949,19 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		goto out_addrs;
 	}
 
+	/*
+	 * If we have seen a tail call, we need a second pass.
+	 * This is because bpf_jit_emit_common_epilogue() is called
+	 * from bpf_jit_emit_tail_call() with a not yet stable ctx->seen.
+	 */
+	if (cgctx.seen & SEEN_TAILCALL) {
+		cgctx.idx = 0;
+		if (bpf_jit_build_body(fp, 0, &cgctx, addrs, false)) {
+			fp = org_fp;
+			goto out_addrs;
+		}
+	}
+
 	/*
 	 * Pretend to build prologue, given the features we've seen.  This will
 	 * update ctgtx.idx as it pretends to output instructions, then we can
-- 
2.20.1



