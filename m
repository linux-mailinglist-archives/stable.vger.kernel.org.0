Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D510B39320C
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbhE0PPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236964AbhE0PO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:14:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89E47613AA;
        Thu, 27 May 2021 15:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128399;
        bh=Fu/ptINs4q6Ju+7/XM7yOBqMxZbUL/wQcCB76Uu8sVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gI9YVehEfek1HhzQw4ZXR0L7PSjpDqx7MOMqPlnST0U6bJV7uVKXDJvEJ7y90CcNc
         p1NVOtJ0TREWryE2CE5iRmW16TtKGD8H4fFL7xQXD3y/xZ6PmHjduDw6SraEPGb2Gg
         FHfJf+tyjYtzR+kl/NdlEPs36NJIRHvWnwvfbOOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 2/9] bpf: Fix mask direction swap upon off reg sign change
Date:   Thu, 27 May 2021 17:12:54 +0200
Message-Id: <20210527151139.321814981@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
References: <20210527151139.242182390@linuxfoundation.org>
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
@@ -5666,18 +5666,10 @@ enum {
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
@@ -5745,6 +5737,7 @@ static bool sanitize_needed(u8 opcode)
 
 struct bpf_sanitize_info {
 	struct bpf_insn_aux_data aux;
+	bool mask_to_left;
 };
 
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
@@ -5776,7 +5769,16 @@ static int sanitize_ptr_alu(struct bpf_v
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
 


