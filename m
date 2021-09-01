Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA3D3FDAFB
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343944AbhIAMgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244650AbhIAMes (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:34:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB5E46112F;
        Wed,  1 Sep 2021 12:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499584;
        bh=9p7LkImhnAzDClEtLCIzquWHaLG7XFORAFOc0wLVfcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rpagyu72YK19MKGZ23EF/x4kI70GqlQxf+I5/AlzK+oRk7kiAxGUQm1khFkFm0Fcz
         5GbND3mQZRQIRYTEN0WU0O4H0QzGgLBFXbydMt6z7YXohg1Hy/3D1YZ1M6zP+3XYy4
         LCw//CjC0/idmZpx53KBC+XLmzpq7F65ndLvL/70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>
Subject: [PATCH 5.4 39/48] bpf: Track contents of read-only maps as scalars
Date:   Wed,  1 Sep 2021 14:28:29 +0200
Message-Id: <20210901122254.681668285@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit a23740ec43ba022dbfd139d0fe3eff193216272b upstream.

Maps that are read-only both from BPF program side and user space side
have their contents constant, so verifier can track referenced values
precisely and use that knowledge for dead code elimination, branch
pruning, etc. This patch teaches BPF verifier how to do this.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191009201458.2679171-2-andriin@fb.com
Signed-off-by: Rafael David Tinoco <rafaeldtinoco@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2778,6 +2778,41 @@ static void coerce_reg_to_size(struct bp
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
+	ptr = (void *)addr + off;
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
@@ -2815,9 +2850,27 @@ static int check_mem_access(struct bpf_v
 		if (err)
 			return err;
 		err = check_map_access(env, regno, off, size, false);
-		if (!err && t == BPF_READ && value_regno >= 0)
-			mark_reg_unknown(env, regs, value_regno);
+		if (!err && t == BPF_READ && value_regno >= 0) {
+			struct bpf_map *map = reg->map_ptr;
 
+			/* if map is read-only, track its contents as scalars */
+			if (tnum_is_const(reg->var_off) &&
+			    bpf_map_is_rdonly(map) &&
+			    map->ops->map_direct_value_addr) {
+				int map_off = off + reg->var_off.value;
+				u64 val = 0;
+
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
 


