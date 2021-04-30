Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514B736FC17
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhD3OVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhD3OVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C316461450;
        Fri, 30 Apr 2021 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792442;
        bh=MDwoeJvrh1Z7R2xreywmuPkQRKdfc4Dty9ben5vEXJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liAIUpPFf9QTLpP9tnIHvWCm6jdQo2JCugFiFG2CEI3iQHbbu5nWkscuG79OV9/eS
         CAucLqOw4afzLn0YDD/c+xua5ayZDfyex4bmFPLnEijyfILkqSw9MImolW1ggGyTWB
         LteitPFptzSsVTSakAZMLRF7xHFi4bJO7mmi34BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 5.4 6/8] bpf: Move sanitize_val_alu out of op switch
Date:   Fri, 30 Apr 2021 16:20:20 +0200
Message-Id: <20210430141911.368109936@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141911.137473863@linuxfoundation.org>
References: <20210430141911.137473863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit f528819334881fd622fdadeddb3f7edaed8b7c9b upstream.

Add a small sanitize_needed() helper function and move sanitize_val_alu()
out of the main opcode switch. In upcoming work, we'll move sanitize_ptr_alu()
as well out of its opcode switch so this helps to streamline both.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backported to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4352,6 +4352,11 @@ static int sanitize_val_alu(struct bpf_v
 	return update_alu_sanitation_state(aux, BPF_ALU_NON_POINTER, 0);
 }
 
+static bool sanitize_needed(u8 opcode)
+{
+	return opcode == BPF_ADD || opcode == BPF_SUB;
+}
+
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
@@ -4753,11 +4758,14 @@ static int adjust_scalar_min_max_vals(st
 		return 0;
 	}
 
-	switch (opcode) {
-	case BPF_ADD:
+	if (sanitize_needed(opcode)) {
 		ret = sanitize_val_alu(env, insn);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, NULL, NULL);
+	}
+
+	switch (opcode) {
+	case BPF_ADD:
 		if (signed_add_overflows(dst_reg->smin_value, smin_val) ||
 		    signed_add_overflows(dst_reg->smax_value, smax_val)) {
 			dst_reg->smin_value = S64_MIN;
@@ -4777,9 +4785,6 @@ static int adjust_scalar_min_max_vals(st
 		dst_reg->var_off = tnum_add(dst_reg->var_off, src_reg.var_off);
 		break;
 	case BPF_SUB:
-		ret = sanitize_val_alu(env, insn);
-		if (ret < 0)
-			return sanitize_err(env, insn, ret, NULL, NULL);
 		if (signed_sub_overflows(dst_reg->smin_value, smax_val) ||
 		    signed_sub_overflows(dst_reg->smax_value, smin_val)) {
 			/* Overflow possible, we know nothing */


