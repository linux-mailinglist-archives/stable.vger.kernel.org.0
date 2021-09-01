Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D633FDA44
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244771AbhIAMbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244766AbhIAMa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:30:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EB0F610CA;
        Wed,  1 Sep 2021 12:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499402;
        bh=ZUJPf2+s2Td46vVyzMf06L9O9cB5NWGnWArPt+i2/Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fd+LCIBRH8oo7uuDE0mPT5/qGtRKq5+LvIjgAkeP5cX3As1l9YGLwaetjbsD40dVJ
         Pd799X36ohJP1N0TJaPS9KcZCUr+ykqW4JpC3gijcWWUipD0A6P0HQqC64ZppXy1cv
         RDY8In3ngwuqV+lLJl6/jXGZKUnxfNOJEOf6A440=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.19 02/33] bpf: Do not use ax register in interpreter on div/mod
Date:   Wed,  1 Sep 2021 14:27:51 +0200
Message-Id: <20210901122250.827589904@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/core.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -705,9 +705,6 @@ static int bpf_jit_blind_insn(const stru
 	 * below.
 	 *
 	 * Constant blinding is only used by JITs, not in the interpreter.
-	 * The interpreter uses AX in some occasions as a local temporary
-	 * register e.g. in DIV or MOD instructions.
-	 *
 	 * In restricted circumstances, the verifier can also use the AX
 	 * register for rewrites as long as they do not interfere with
 	 * the above cases!
@@ -1057,6 +1054,7 @@ static u64 ___bpf_prog_run(u64 *regs, co
 #undef BPF_INSN_3_LBL
 #undef BPF_INSN_2_LBL
 	u32 tail_call_cnt = 0;
+	u64 tmp;
 
 #define CONT	 ({ insn++; goto select_insn; })
 #define CONT_JMP ({ insn++; goto select_insn; })
@@ -1117,36 +1115,36 @@ select_insn:
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


