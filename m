Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0909D39FFD7
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhFHShL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234639AbhFHSfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:35:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B3E2613CB;
        Tue,  8 Jun 2021 18:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177128;
        bh=DinYSjk+XniPqbHEC1wDQ/sUB7X9GxsBfF6ozuUjLbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xw3W+8ajaSTAdX8yxSlO4K963y4eZlM3bpZYZoFzXpEnlXwMhtKgbHU2ctPL038zC
         wMuP+HRpVgLXSn52E+Jd8imlrPYL+uHL+kgCOsoJD7t8ofVfLiSfvhBtbps43szIZS
         tlIJX3XJm4NlHZfCkLmyhOyJ5r+mWDilX5iCmlz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.14 42/47] bpf: Fix mask direction swap upon off reg sign change
Date:   Tue,  8 Jun 2021 20:27:25 +0200
Message-Id: <20210608175931.863713046@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit bb01a1bba579b4b1c5566af24d95f1767859771e upstream.

Masking direction as indicated via mask_to_left is considered to be
calculated once and then used to derive pointer limits. Thus, this
needs to be placed into bpf_sanitize_info instead so we can pass it
to sanitize_ptr_alu() call after the pointer move. Piotr noticed a
corner case where the off reg causes masking direction change which
then results in an incorrect final aux->alu_limit.

Fixes: 7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic mask")
Reported-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2033,18 +2033,10 @@ enum {
 };
 
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
-			      const struct bpf_reg_state *off_reg,
-			      u32 *alu_limit, u8 opcode)
+			      u32 *alu_limit, bool mask_to_left)
 {
-	bool off_is_neg = off_reg->smin_value < 0;
-	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
-			    (opcode == BPF_SUB && !off_is_neg);
 	u32 max = 0, ptr_limit = 0;
 
-	if (!tnum_is_const(off_reg->var_off) &&
-	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
-		return REASON_BOUNDS;
-
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
 		/* Offset 0 is out-of-bounds, but acceptable start for the
@@ -2112,6 +2104,7 @@ static bool sanitize_needed(u8 opcode)
 
 struct bpf_sanitize_info {
 	struct bpf_insn_aux_data aux;
+	bool mask_to_left;
 };
 
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
@@ -2143,7 +2136,16 @@ static int sanitize_ptr_alu(struct bpf_v
 	if (vstate->speculative)
 		goto do_sim;
 
-	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
+	if (!commit_window) {
+		if (!tnum_is_const(off_reg->var_off) &&
+		    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
+			return REASON_BOUNDS;
+
+		info->mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
+				     (opcode == BPF_SUB && !off_is_neg);
+	}
+
+	err = retrieve_ptr_limit(ptr_reg, &alu_limit, info->mask_to_left);
 	if (err < 0)
 		return err;
 


