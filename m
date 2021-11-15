Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16821450B6E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbhKORYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236568AbhKORVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:21:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F46E63255;
        Mon, 15 Nov 2021 17:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996549;
        bh=Pg/AWtKOto0ZXSwji35KsQXPqY5CZMi5w4dFeL5NVD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7xpzuic94zmzFJ3fGVbdpESHzIRZbkSRuvwixK56RCCwxtGbmxJiRrXlTcOd6vAI
         7oaMJx3+HBHgLPm6fcC5ZMW0XMeC0lG1i3zBDkHpL5ksXDPS0gYzcJyFE3LJ8EhdHh
         2MkTqwMCV8cqFsQuH7e9onlAFTfaeIfzKF0CZeUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/355] selftests/bpf: Fix strobemeta selftest regression
Date:   Mon, 15 Nov 2021 18:01:45 +0100
Message-Id: <20211115165319.636707594@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 0133c20480b14820d43c37c0e9502da4bffcad3a ]

After most recent nightly Clang update strobemeta selftests started
failing with the following error (relevant portion of assembly included):

  1624: (85) call bpf_probe_read_user_str#114
  1625: (bf) r1 = r0
  1626: (18) r2 = 0xfffffffe
  1628: (5f) r1 &= r2
  1629: (55) if r1 != 0x0 goto pc+7
  1630: (07) r9 += 104
  1631: (6b) *(u16 *)(r9 +0) = r0
  1632: (67) r0 <<= 32
  1633: (77) r0 >>= 32
  1634: (79) r1 = *(u64 *)(r10 -456)
  1635: (0f) r1 += r0
  1636: (7b) *(u64 *)(r10 -456) = r1
  1637: (79) r1 = *(u64 *)(r10 -368)
  1638: (c5) if r1 s< 0x1 goto pc+778
  1639: (bf) r6 = r8
  1640: (0f) r6 += r7
  1641: (b4) w1 = 0
  1642: (6b) *(u16 *)(r6 +108) = r1
  1643: (79) r3 = *(u64 *)(r10 -352)
  1644: (79) r9 = *(u64 *)(r10 -456)
  1645: (bf) r1 = r9
  1646: (b4) w2 = 1
  1647: (85) call bpf_probe_read_user_str#114

  R1 unbounded memory access, make sure to bounds check any such access

In the above code r0 and r1 are implicitly related. Clang knows that,
but verifier isn't able to infer this relationship.

Yonghong Song narrowed down this "regression" in code generation to
a recent Clang optimization change ([0]), which for BPF target generates
code pattern that BPF verifier can't handle and loses track of register
boundaries.

This patch works around the issue by adding an BPF assembly-based helper
that helps to prove to the verifier that upper bound of the register is
a given constant by controlling the exact share of generated BPF
instruction sequence. This fixes the immediate issue for strobemeta
selftest.

  [0] https://github.com/llvm/llvm-project/commit/acabad9ff6bf13e00305d9d8621ee8eafc1f8b08

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211029182907.166910-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/strobemeta.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
index 067eb625d01c5..938765d87528a 100644
--- a/tools/testing/selftests/bpf/progs/strobemeta.h
+++ b/tools/testing/selftests/bpf/progs/strobemeta.h
@@ -10,6 +10,14 @@
 #include <linux/types.h>
 #include "bpf_helpers.h"
 
+#define bpf_clamp_umax(VAR, UMAX)					\
+	asm volatile (							\
+		"if %0 <= %[max] goto +1\n"				\
+		"%0 = %[max]\n"						\
+		: "+r"(VAR)						\
+		: [max]"i"(UMAX)					\
+	)
+
 typedef uint32_t pid_t;
 struct task_struct {};
 
@@ -404,6 +412,7 @@ static __always_inline void *read_map_var(struct strobemeta_cfg *cfg,
 
 	len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN, map.tag);
 	if (len <= STROBE_MAX_STR_LEN) {
+		bpf_clamp_umax(len, STROBE_MAX_STR_LEN);
 		descr->tag_len = len;
 		payload += len;
 	}
@@ -421,6 +430,7 @@ static __always_inline void *read_map_var(struct strobemeta_cfg *cfg,
 		len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN,
 					 map.entries[i].key);
 		if (len <= STROBE_MAX_STR_LEN) {
+			bpf_clamp_umax(len, STROBE_MAX_STR_LEN);
 			descr->key_lens[i] = len;
 			payload += len;
 		}
@@ -428,6 +438,7 @@ static __always_inline void *read_map_var(struct strobemeta_cfg *cfg,
 		len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN,
 					 map.entries[i].val);
 		if (len <= STROBE_MAX_STR_LEN) {
+			bpf_clamp_umax(len, STROBE_MAX_STR_LEN);
 			descr->val_lens[i] = len;
 			payload += len;
 		}
-- 
2.33.0



