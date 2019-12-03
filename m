Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C912C11200C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfLCXLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:11:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbfLCWkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D3420684;
        Tue,  3 Dec 2019 22:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412839;
        bh=YKtNUsduV5isZO5nsHf4mSCvJD88xZ0PmVpG0Onr6VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnOqC0AJovc/gldiqjhvixymM8HP1g1DjZxDyLGfuYoJLCppu4PCTiHN2hvWANLgX
         5KrWSr/a9lGx//ByRt4XextXjkdjtt5LMWPPAmF4MfSklFm/HQk+5AhWfd8Q55UbXl
         s/9NH/CFayiqpCVoxYoHyI7wvgR3vcjBgB45nPt0=
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
Subject: [PATCH 5.3 035/135] powerpc/bpf: Fix tail call implementation
Date:   Tue,  3 Dec 2019 23:34:35 +0100
Message-Id: <20191203213013.128883661@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
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
index 02a59946a78af..be3517ef0574d 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -1141,6 +1141,19 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
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



