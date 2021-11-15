Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3D6451163
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243693AbhKOTHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:07:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243743AbhKOTDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:03:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B21C560296;
        Mon, 15 Nov 2021 18:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000125;
        bh=ullSF88pRmHb8GKVlCS8QDZvP6HPC3eQ+jDZ6fKOWcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQFGVZuq1IzYYS3KVJAcKH8kUKMRlPSww+C0fx7YnGZ7oNXnBLNM1Sd3K+EyMAWCc
         2FLfwXyG5HMUhtBWU3Dj8P002fkrG3NkcP9hdc+tG4iLaObyNHNEynMdqChoohE/8E
         lh5stjBGizOgeg+Yh9fIEMi7uQRWJcFrzj23DX0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 547/849] bpf: Fix propagation of bounds from 64-bit min/max into 32-bit and var_off.
Date:   Mon, 15 Nov 2021 18:00:30 +0100
Message-Id: <20211115165438.764177109@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit b9979db8340154526d9ab38a1883d6f6ba9b6d47 ]

Before this fix:
166: (b5) if r2 <= 0x1 goto pc+22
from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0xffffffff))

After this fix:
166: (b5) if r2 <= 0x1 goto pc+22
from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0x1))

While processing BPF_JLE the reg_set_min_max() would set true_reg->umax_value = 1
and call __reg_combine_64_into_32(true_reg).

Without the fix it would not pass the condition:
if (__reg64_bound_u32(reg->umin_value) && __reg64_bound_u32(reg->umax_value))

since umin_value == 0 at this point.
Before commit 10bf4e83167c the umin was incorrectly ingored.
The commit 10bf4e83167c fixed the correctness issue, but pessimized
propagation of 64-bit min max into 32-bit min max and corresponding var_off.

Fixes: 10bf4e83167c ("bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211101222153.78759-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                               | 2 +-
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 592b9b68cbd93..b9fb079559a6d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1402,7 +1402,7 @@ static bool __reg64_bound_s32(s64 a)
 
 static bool __reg64_bound_u32(u64 a)
 {
-	return a > U32_MIN && a < U32_MAX;
+	return a >= U32_MIN && a <= U32_MAX;
 }
 
 static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
index 1b1c798e92489..1b138cd2b187d 100644
--- a/tools/testing/selftests/bpf/verifier/array_access.c
+++ b/tools/testing/selftests/bpf/verifier/array_access.c
@@ -186,7 +186,7 @@
 	},
 	.fixup_map_hash_48b = { 3 },
 	.errstr_unpriv = "R0 leaks addr",
-	.errstr = "R0 unbounded memory access",
+	.errstr = "invalid access to map value, value_size=48 off=44 size=8",
 	.result_unpriv = REJECT,
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
-- 
2.33.0



