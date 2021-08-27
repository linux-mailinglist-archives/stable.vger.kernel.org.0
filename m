Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2342C3F9A7E
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbhH0N4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 09:56:47 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:41306
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232884AbhH0N4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 09:56:46 -0400
Received: from mussarela.. (201-69-234-220.dial-up.telesp.net.br [201.69.234.220])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id A4A1A40C89;
        Fri, 27 Aug 2021 13:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630072557;
        bh=guWARIj4adJdQEToFj/scMwAX7JAu+HnyntuansAEOM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=EUSFjdAo2hnPVRX0ldYoN4FQHM0fqpwbLAwF0eVpR5fBBw2sXoWKDBn0RMZqEmhwF
         Qd+kQzK7t2I5M2PrzY4AOzrbRou5KtttJa+zU8zMsG4GOZMiQVRuVoaZJJ04PpM28h
         YenUemy0txtQWSQ0d2taorTpXRC5auL3d/uvhgR9uKQwOhjAK5/LvKQA/s6ejWGFZO
         Gpa4dx0p3xS9qy1KSYPtSFwMCpYL9L/0lh5hlVBrRLXtJ6BHeL7Q98mP0rVLm5/RW3
         Z8E3Vl1sFJahEgL9Aq3Nz0hUXK08X7qJoRMtufGldcqrSF0yYtMbqn89WN+pcUrXGi
         zmWzuX6CFeb/w==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Salvatore Bonaccorso <carnil@debian.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Pavel Machek <pavel@denx.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.19 1/3] bpf: Do not use ax register in interpreter on div/mod
Date:   Fri, 27 Aug 2021 10:55:31 -0300
Message-Id: <20210827135533.146070-2-cascardo@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210827135533.146070-1-cascardo@canonical.com>
References: <20210827135533.146070-1-cascardo@canonical.com>
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
index 36be400c3e65..d2b6d2459aad 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -705,9 +705,6 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	 * below.
 	 *
 	 * Constant blinding is only used by JITs, not in the interpreter.
-	 * The interpreter uses AX in some occasions as a local temporary
-	 * register e.g. in DIV or MOD instructions.
-	 *
 	 * In restricted circumstances, the verifier can also use the AX
 	 * register for rewrites as long as they do not interfere with
 	 * the above cases!
@@ -1057,6 +1054,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 #undef BPF_INSN_3_LBL
 #undef BPF_INSN_2_LBL
 	u32 tail_call_cnt = 0;
+	u64 tmp;
 
 #define CONT	 ({ insn++; goto select_insn; })
 #define CONT_JMP ({ insn++; goto select_insn; })
@@ -1117,36 +1115,36 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		(*(s64 *) &DST) >>= IMM;
 		CONT;
 	ALU64_MOD_X:
-		div64_u64_rem(DST, SRC, &AX);
-		DST = AX;
+		div64_u64_rem(DST, SRC, &tmp);
+		DST = tmp;
 		CONT;
 	ALU_MOD_X:
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
 		DST = div64_u64(DST, SRC);
 		CONT;
 	ALU_DIV_X:
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

