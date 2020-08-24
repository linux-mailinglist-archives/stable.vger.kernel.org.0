Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ADE24F961
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgHXInK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbgHXInH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:43:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 038EB2087D;
        Mon, 24 Aug 2020 08:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258586;
        bh=Un0jkfdEzqoS7mtwb6Y8qjOb2BUnF5ehMVkAyDM176I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6SBXQiehh/5WvpAg1V/JgHgid6NABk85JdtLaGJwkoQt0dGfwhVNKYOwoqf/iuwf
         rfB7XdCNN8F5j6zyDktJMNZZlHtSRnLz1aHKKUno3e96Mhbi5+E5rZwAvWYfoUNFN7
         B0cSlVydXbx4ZHCA7g/m9Gzr83ZUrrO/ZvrAWCvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 069/124] bpf: sock_ops sk access may stomp registers when dst_reg = src_reg
Date:   Mon, 24 Aug 2020 10:30:03 +0200
Message-Id: <20200824082412.805157874@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 84f44df664e9f0e261157e16ee1acd77cc1bb78d ]

Similar to patch ("bpf: sock_ops ctx access may stomp registers") if the
src_reg = dst_reg when reading the sk field of a sock_ops struct we
generate xlated code,

  53: (61) r9 = *(u32 *)(r9 +28)
  54: (15) if r9 == 0x0 goto pc+3
  56: (79) r9 = *(u64 *)(r9 +0)

This stomps on the r9 reg to do the sk_fullsock check and then when
reading the skops->sk field instead of the sk pointer we get the
sk_fullsock. To fix use similar pattern noted in the previous fix
and use the temp field to save/restore a register used to do
sk_fullsock check.

After the fix the generated xlated code reads,

  52: (7b) *(u64 *)(r9 +32) = r8
  53: (61) r8 = *(u32 *)(r9 +28)
  54: (15) if r9 == 0x0 goto pc+3
  55: (79) r8 = *(u64 *)(r9 +32)
  56: (79) r9 = *(u64 *)(r9 +0)
  57: (05) goto pc+1
  58: (79) r8 = *(u64 *)(r9 +32)

Here r9 register was in-use so r8 is chosen as the temporary register.
In line 52 r8 is saved in temp variable and at line 54 restored in case
fullsock != 0. Finally we handle fullsock == 0 case by restoring at
line 58.

This adds a new macro SOCK_OPS_GET_SK it is almost possible to merge
this with SOCK_OPS_GET_FIELD, but I found the extra branch logic a
bit more confusing than just adding a new macro despite a bit of
duplicating code.

Fixes: 1314ef561102e ("bpf: export bpf_sock for BPF_PROG_TYPE_SOCK_OPS prog type")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/159718349653.4728.6559437186853473612.stgit@john-Precision-5820-Tower
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 49 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index dcc06e510ec5d..9c03702600128 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8107,6 +8107,43 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		}							      \
 	} while (0)
 
+#define SOCK_OPS_GET_SK()							      \
+	do {								      \
+		int fullsock_reg = si->dst_reg, reg = BPF_REG_9, jmp = 1;     \
+		if (si->dst_reg == reg || si->src_reg == reg)		      \
+			reg--;						      \
+		if (si->dst_reg == reg || si->src_reg == reg)		      \
+			reg--;						      \
+		if (si->dst_reg == si->src_reg) {			      \
+			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg,	      \
+					  offsetof(struct bpf_sock_ops_kern,  \
+					  temp));			      \
+			fullsock_reg = reg;				      \
+			jmp += 2;					      \
+		}							      \
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
+						struct bpf_sock_ops_kern,     \
+						is_fullsock),		      \
+				      fullsock_reg, si->src_reg,	      \
+				      offsetof(struct bpf_sock_ops_kern,      \
+					       is_fullsock));		      \
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, fullsock_reg, 0, jmp);	      \
+		if (si->dst_reg == si->src_reg)				      \
+			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
+				      offsetof(struct bpf_sock_ops_kern,      \
+				      temp));				      \
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
+						struct bpf_sock_ops_kern, sk),\
+				      si->dst_reg, si->src_reg,		      \
+				      offsetof(struct bpf_sock_ops_kern, sk));\
+		if (si->dst_reg == si->src_reg)	{			      \
+			*insn++ = BPF_JMP_A(1);				      \
+			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
+				      offsetof(struct bpf_sock_ops_kern,      \
+				      temp));				      \
+		}							      \
+	} while (0)
+
 #define SOCK_OPS_GET_TCP_SOCK_FIELD(FIELD) \
 		SOCK_OPS_GET_FIELD(FIELD, FIELD, struct tcp_sock)
 
@@ -8391,17 +8428,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		SOCK_OPS_GET_TCP_SOCK_FIELD(bytes_acked);
 		break;
 	case offsetof(struct bpf_sock_ops, sk):
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
-						struct bpf_sock_ops_kern,
-						is_fullsock),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct bpf_sock_ops_kern,
-					       is_fullsock));
-		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
-						struct bpf_sock_ops_kern, sk),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct bpf_sock_ops_kern, sk));
+		SOCK_OPS_GET_SK();
 		break;
 	}
 	return insn - insn_buf;
-- 
2.25.1



