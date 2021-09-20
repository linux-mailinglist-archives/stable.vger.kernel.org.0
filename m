Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A022411FE1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346612AbhITRqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352987AbhITRnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:43:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F8A61B65;
        Mon, 20 Sep 2021 17:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157739;
        bh=yMJmJrRcdl7Uebq5B5u0cvtRcyPEopJjdS3osBzzuE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WT2a0FwxJ9Y7NjkE0fX0lJvKoRa+izb/XMJMgLUqVk3FIVSX5FMzwYi7RIN/P1TkJ
         HS7upr6+2Ly+gVHFyUAf1qP79k4O7V9RVCF/EUV5HZwNwN+ok0DqIQ+iMfSgUhcuyo
         XyNGMElJjMYhiA6Os20HNWyy6gTpyRm11aU3qiFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 129/293] bpf: Support variable offset stack access from helpers
Date:   Mon, 20 Sep 2021 18:41:31 +0200
Message-Id: <20210920163937.680385978@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit 2011fccfb61bbd1d7c8864b2b3ed7012342e9ba3 upstream.

Currently there is a difference in how verifier checks memory access for
helper arguments for PTR_TO_MAP_VALUE and PTR_TO_STACK with regard to
variable part of offset.

check_map_access, that is used for PTR_TO_MAP_VALUE, can handle variable
offsets just fine, so that BPF program can call a helper like this:

  some_helper(map_value_ptr + off, size);

, where offset is unknown at load time, but is checked by program to be
in a safe rage (off >= 0 && off + size < map_value_size).

But it's not the case for check_stack_boundary, that is used for
PTR_TO_STACK, and same code with pointer to stack is rejected by
verifier:

  some_helper(stack_value_ptr + off, size);

For example:
  0: (7a) *(u64 *)(r10 -16) = 0
  1: (7a) *(u64 *)(r10 -8) = 0
  2: (61) r2 = *(u32 *)(r1 +0)
  3: (57) r2 &= 4
  4: (17) r2 -= 16
  5: (0f) r2 += r10
  6: (18) r1 = 0xffff888111343a80
  8: (85) call bpf_map_lookup_elem#1
  invalid variable stack read R2 var_off=(0xfffffffffffffff0; 0x4)

Add support for variable offset access to check_stack_boundary so that
if offset is checked by program to be in a safe range it's accepted by
verifier.

Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[OP: replace reg_state(env, regno) helper with "cur_regs(env) + regno"]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   75 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 21 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1755,6 +1755,29 @@ static int check_xadd(struct bpf_verifie
 				BPF_SIZE(insn->code), BPF_WRITE, -1, true);
 }
 
+static int __check_stack_boundary(struct bpf_verifier_env *env, u32 regno,
+				  int off, int access_size,
+				  bool zero_size_allowed)
+{
+	struct bpf_reg_state *reg = cur_regs(env) + regno;
+
+	if (off >= 0 || off < -MAX_BPF_STACK || off + access_size > 0 ||
+	    access_size < 0 || (access_size == 0 && !zero_size_allowed)) {
+		if (tnum_is_const(reg->var_off)) {
+			verbose(env, "invalid stack type R%d off=%d access_size=%d\n",
+				regno, off, access_size);
+		} else {
+			char tn_buf[48];
+
+			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+			verbose(env, "invalid stack type R%d var_off=%s access_size=%d\n",
+				regno, tn_buf, access_size);
+		}
+		return -EACCES;
+	}
+	return 0;
+}
+
 /* when register 'regno' is passed into function that will read 'access_size'
  * bytes from that pointer, make sure that it's within stack boundary
  * and all elements of stack are initialized.
@@ -1767,7 +1790,7 @@ static int check_stack_boundary(struct b
 {
 	struct bpf_reg_state *reg = cur_regs(env) + regno;
 	struct bpf_func_state *state = func(env, reg);
-	int off, i, slot, spi;
+	int err, min_off, max_off, i, slot, spi;
 
 	if (reg->type != PTR_TO_STACK) {
 		/* Allow zero-byte read from NULL, regardless of pointer type */
@@ -1781,21 +1804,23 @@ static int check_stack_boundary(struct b
 		return -EACCES;
 	}
 
-	/* Only allow fixed-offset stack reads */
-	if (!tnum_is_const(reg->var_off)) {
-		char tn_buf[48];
-
-		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-		verbose(env, "invalid variable stack read R%d var_off=%s\n",
-			regno, tn_buf);
-		return -EACCES;
-	}
-	off = reg->off + reg->var_off.value;
-	if (off >= 0 || off < -MAX_BPF_STACK || off + access_size > 0 ||
-	    access_size < 0 || (access_size == 0 && !zero_size_allowed)) {
-		verbose(env, "invalid stack type R%d off=%d access_size=%d\n",
-			regno, off, access_size);
-		return -EACCES;
+	if (tnum_is_const(reg->var_off)) {
+		min_off = max_off = reg->var_off.value + reg->off;
+		err = __check_stack_boundary(env, regno, min_off, access_size,
+					     zero_size_allowed);
+		if (err)
+			return err;
+	} else {
+		min_off = reg->smin_value + reg->off;
+		max_off = reg->umax_value + reg->off;
+		err = __check_stack_boundary(env, regno, min_off, access_size,
+					     zero_size_allowed);
+		if (err)
+			return err;
+		err = __check_stack_boundary(env, regno, max_off, access_size,
+					     zero_size_allowed);
+		if (err)
+			return err;
 	}
 
 	if (meta && meta->raw_mode) {
@@ -1804,10 +1829,10 @@ static int check_stack_boundary(struct b
 		return 0;
 	}
 
-	for (i = 0; i < access_size; i++) {
+	for (i = min_off; i < max_off + access_size; i++) {
 		u8 *stype;
 
-		slot = -(off + i) - 1;
+		slot = -i - 1;
 		spi = slot / BPF_REG_SIZE;
 		if (state->allocated_stack <= slot)
 			goto err;
@@ -1820,8 +1845,16 @@ static int check_stack_boundary(struct b
 			goto mark;
 		}
 err:
-		verbose(env, "invalid indirect read from stack off %d+%d size %d\n",
-			off, i, access_size);
+		if (tnum_is_const(reg->var_off)) {
+			verbose(env, "invalid indirect read from stack off %d+%d size %d\n",
+				min_off, i - min_off, access_size);
+		} else {
+			char tn_buf[48];
+
+			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+			verbose(env, "invalid indirect read from stack var_off %s+%d size %d\n",
+				tn_buf, i - min_off, access_size);
+		}
 		return -EACCES;
 mark:
 		/* reading any byte out of 8-byte 'spill_slot' will cause
@@ -1830,7 +1863,7 @@ mark:
 		mark_reg_read(env, &state->stack[spi].spilled_ptr,
 			      state->stack[spi].spilled_ptr.parent);
 	}
-	return update_stack_depth(env, state, off);
+	return update_stack_depth(env, state, min_off);
 }
 
 static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,


