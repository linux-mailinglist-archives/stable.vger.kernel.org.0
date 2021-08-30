Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A303FBC74
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 20:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhH3Sdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 14:33:31 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:35886
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238572AbhH3Sdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 14:33:31 -0400
Received: from mussarela.. (201-69-234-220.dial-up.telesp.net.br [201.69.234.220])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 6BDF040178;
        Mon, 30 Aug 2021 18:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630348356;
        bh=YOEuV5J/RPEj6pgEhF8fmNriL/1isGdpZkkd9u+eMt0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ZJ78aQe/EVIqfsnCcLGmg1aqNgxwnLMtRQmZ2X/lbJkR+77cAiLRl6CxOX3d4Bpf1
         ICa6jG6xXIArLqt3LhszZW7Je5069Ih45kr0R6X4Q1VVYNHCkARuAwccTvS//Hd8gr
         STdJ94tLzL5itm5aRa7bmaIsHftcDZq/Mp2MLZhPgaQba7vjctJ3KVswpTGyWP54D6
         IGchXS0pUs7NMJrCmqGKN8dIYoGxyiB+/isCZFBpZrkXbGu0LBcVu0SodtQg/tnKOF
         fUu8Yx68D3GF2eUWCHUuQDB1nAUpJkPHNSq46CFlW9/ZoK4VR2ORkoR/xJF3/I+zXR
         u5S2pWUjcSVng==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Pavel Machek <pavel@denx.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 1/4] bpf: Do not use ax register in interpreter on div/mod
Date:   Mon, 30 Aug 2021 15:32:08 -0300
Message-Id: <20210830183211.339054-2-cascardo@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830183211.339054-1-cascardo@canonical.com>
References: <20210830183211.339054-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Partially undo old commit 144cd91c4c2b ("bpf: move tmp variable into ax
register in interpreter"). The reason we need this here is because ax
register will be used for holding temporary state for div/mod instruction
which otherwise interpreter would corrupt. This will cause a small +8 byte
stack increase for interpreter, but with the gain that we can use it from
verifier rewrites as scratch register.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
[cascardo: This partial revert is needed in order to support using AX for
the following two commits, as there is no JMP32 on 4.19.y]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 kernel/bpf/core.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index e7211b0fa27c..30d871be9974 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -616,9 +616,6 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	 * below.
 	 *
 	 * Constant blinding is only used by JITs, not in the interpreter.
-	 * The interpreter uses AX in some occasions as a local temporary
-	 * register e.g. in DIV or MOD instructions.
-	 *
 	 * In restricted circumstances, the verifier can also use the AX
 	 * register for rewrites as long as they do not interfere with
 	 * the above cases!
@@ -951,6 +948,7 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
 	u32 tail_call_cnt = 0;
 	void *ptr;
 	int off;
+	u64 tmp;
 
 #define CONT	 ({ insn++; goto select_insn; })
 #define CONT_JMP ({ insn++; goto select_insn; })
@@ -1013,22 +1011,22 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
 	ALU64_MOD_X:
 		if (unlikely(SRC == 0))
 			return 0;
-		div64_u64_rem(DST, SRC, &AX);
-		DST = AX;
+		div64_u64_rem(DST, SRC, &tmp);
+		DST = tmp;
 		CONT;
 	ALU_MOD_X:
 		if (unlikely((u32)SRC == 0))
 			return 0;
-		AX = (u32) DST;
-		DST = do_div(AX, (u32) SRC);
+		tmp = (u32) DST;
+		DST = do_div(tmp, (u32) SRC);
 		CONT;
 	ALU64_MOD_K:
-		div64_u64_rem(DST, IMM, &AX);
-		DST = AX;
+		div64_u64_rem(DST, IMM, &tmp);
+		DST = tmp;
 		CONT;
 	ALU_MOD_K:
-		AX = (u32) DST;
-		DST = do_div(AX, (u32) IMM);
+		tmp = (u32) DST;
+		DST = do_div(tmp, (u32) IMM);
 		CONT;
 	ALU64_DIV_X:
 		if (unlikely(SRC == 0))
@@ -1038,17 +1036,17 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
 	ALU_DIV_X:
 		if (unlikely((u32)SRC == 0))
 			return 0;
-		AX = (u32) DST;
-		do_div(AX, (u32) SRC);
-		DST = (u32) AX;
+		tmp = (u32) DST;
+		do_div(tmp, (u32) SRC);
+		DST = (u32) tmp;
 		CONT;
 	ALU64_DIV_K:
 		DST = div64_u64(DST, IMM);
 		CONT;
 	ALU_DIV_K:
-		AX = (u32) DST;
-		do_div(AX, (u32) IMM);
-		DST = (u32) AX;
+		tmp = (u32) DST;
+		do_div(tmp, (u32) IMM);
+		DST = (u32) tmp;
 		CONT;
 	ALU_END_TO_BE:
 		switch (IMM) {
-- 
2.30.2

