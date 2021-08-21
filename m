Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8D03F3C6C
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 22:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhHUUcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Aug 2021 16:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhHUUcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Aug 2021 16:32:05 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B94EC061575
        for <stable@vger.kernel.org>; Sat, 21 Aug 2021 13:31:26 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d9so10453706qty.12
        for <stable@vger.kernel.org>; Sat, 21 Aug 2021 13:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vu6oIyeEogrUxt6GxhQ6bXdAke30vXAjbchW39inJ7g=;
        b=lqeQGP9QmTmDSVXvpAa9PgqZfQjGaD+TO/y8RKzhgRoWf3+ZlgLmXdTMje/V+wTsin
         DzWW/zkjDOUhWHK08CD2drrCQqBVHRKM9yTIntJEpeeMm+kZI1GdmEGswruZ7XupQwnb
         xVFMYFp6AztGLgubXE6LLRwkATv6Bl+zlcnSaFGM7ilrkwiZQyQ4LIRjkazaqQUNYTlC
         tSWFsMiSy4KHPcOHfNRvQexRAjX6t14+Pr//xmn3NSnbzFRONipE2a8heoE6wHrmNvDj
         YW0zot3nrwN+of6ChoenqHMH59/oOvxz073RbYB1aB7I619qspAuEjbcj58i+2o6lYci
         ybJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vu6oIyeEogrUxt6GxhQ6bXdAke30vXAjbchW39inJ7g=;
        b=heIR4Z4hb9rlWNOFg3EvpGSF1Ndh96xNk5drMWJkk3ImcCULsSLaxxwFRaTrkUc8+m
         IAT1occko5XIOYeAjuJ6m77vLsO+GRfQ+X4e/z145PVjzX/wYxJyHF3H2xHcQ6Kv60dp
         q59Bxtjfjvh/yJfaEGJi8N+ekx/rsF/s2pIKXWqfsDB2pcmErnt6ojVJXofCts+uw1xF
         wcYFatJx7xsnR//pQpAt+bL5SRkYErU1c0odPsBqKOtDYS6IcLUu0GyJEDdwXVC9UEQ+
         f2VZfFWeed70jPHZ+353K5dm3xfWe6G08CaX9P4P6hYgTL4LGayc3mLIpeda6474pwCW
         NmjQ==
X-Gm-Message-State: AOAM530TvUso1hgtjhpg+yNfTMJ55n93W1H4aRxCxRjEegvVenLie/c3
        RURv6yajV/3XNFyhnHNlXgf8IXih5jkJ1bI=
X-Google-Smtp-Source: ABdhPJwQw2TOq5ezixHNzoH4OBPkgeyihB8N4i+cE3VxnN64G0zGVcBwTiURiycHBUQccI9maZ+Sgw==
X-Received: by 2002:a05:622a:394:: with SMTP id j20mr19385663qtx.196.1629577884999;
        Sat, 21 Aug 2021 13:31:24 -0700 (PDT)
Received: from fujitsu.celeiro.cu ([191.177.175.120])
        by smtp.gmail.com with ESMTPSA id u189sm5348996qkh.14.2021.08.21.13.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 13:31:24 -0700 (PDT)
From:   Rafael David Tinoco <rafaeldtinoco@gmail.com>
To:     stable@vger.kernel.org
Cc:     rafaeldtinoco@gmail.com, andriin@fb.com, daniel@iogearbox.net,
        yanivagman@gmail.com
Subject: [PATCH] bpf: Track contents of read-only maps as scalars
Date:   Sat, 21 Aug 2021 17:31:08 -0300
Message-Id: <20210821203108.215937-2-rafaeldtinoco@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210821203108.215937-1-rafaeldtinoco@gmail.com>
References: <20210821203108.215937-1-rafaeldtinoco@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a23740ec43ba022dbfd139d0fe3eff193216272b upstream.

Maps that are read-only both from BPF program side and user space side
have their contents constant, so verifier can track referenced values
precisely and use that knowledge for dead code elimination, branch
pruning, etc. This patch teaches BPF verifier how to do this.

  [Backport]
  Already includes further build fix made at commit 2dedd7d21655 ("bpf:
  Fix cast to pointer from integer of different size warning").

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191009201458.2679171-2-andriin@fb.com
Signed-off-by: Rafael David Tinoco <rafaeldtinoco@gmail.com>
Cc: stable@vger.kernel.org # 5.4.x
Link: https://github.com/aquasecurity/tracee/issues/851#issuecomment-903074596
---
 kernel/bpf/verifier.c | 57 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 52c2b11a0b47..ffb33bde92b8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2778,6 +2778,41 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
 	reg->smax_value = reg->umax_value;
 }
 
+static bool bpf_map_is_rdonly(const struct bpf_map *map)
+{
+	return (map->map_flags & BPF_F_RDONLY_PROG) && map->frozen;
+}
+
+static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
+{
+	void *ptr;
+	u64 addr;
+	int err;
+
+	err = map->ops->map_direct_value_addr(map, &addr, off);
+	if (err)
+		return err;
+	ptr = (void *)(long)addr + off;
+
+	switch (size) {
+	case sizeof(u8):
+		*val = (u64)*(u8 *)ptr;
+		break;
+	case sizeof(u16):
+		*val = (u64)*(u16 *)ptr;
+		break;
+	case sizeof(u32):
+		*val = (u64)*(u32 *)ptr;
+		break;
+	case sizeof(u64):
+		*val = *(u64 *)ptr;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /* check whether memory at (regno + off) is accessible for t = (read | write)
  * if t==write, value_regno is a register which value is stored into memory
  * if t==read, value_regno is a register which will receive the value from memory
@@ -2815,9 +2850,27 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		if (err)
 			return err;
 		err = check_map_access(env, regno, off, size, false);
-		if (!err && t == BPF_READ && value_regno >= 0)
-			mark_reg_unknown(env, regs, value_regno);
+		if (!err && t == BPF_READ && value_regno >= 0) {
+			struct bpf_map *map = reg->map_ptr;
+
+			/* if map is read-only, track its contents as scalars */
+			if (tnum_is_const(reg->var_off) &&
+			    bpf_map_is_rdonly(map) &&
+			    map->ops->map_direct_value_addr) {
+				int map_off = off + reg->var_off.value;
+				u64 val = 0;
 
+				err = bpf_map_direct_read(map, map_off, size,
+							  &val);
+				if (err)
+					return err;
+
+				regs[value_regno].type = SCALAR_VALUE;
+				__mark_reg_known(&regs[value_regno], val);
+			} else {
+				mark_reg_unknown(env, regs, value_regno);
+			}
+		}
 	} else if (reg->type == PTR_TO_CTX) {
 		enum bpf_reg_type reg_type = SCALAR_VALUE;
 
-- 
2.30.2

