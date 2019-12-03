Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF1A111C1E
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfLCWkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728406AbfLCWkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06EF62084F;
        Tue,  3 Dec 2019 22:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412831;
        bh=Xa0P0FxM0Gq/F+aLvZEhJQcfjIqGe80/BPTAXeIeAFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDUTQeKiquagZpW7u62emz0ErEVqJOvMj1i0pZGlgH+XrLpq1HsT9KJp8igZXY7yh
         D0/Rvc8hSyi1uZNbhwfE0svB4Nvq0BfQlbXtOSnGVHY5fjd9HfnMJunneZa5t6xmOe
         lFuqNwA3hKyWHRUjXRmmCxRLHSnWMfdmLldQRfV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 032/135] bpf: Allow narrow loads of bpf_sysctl fields with offset > 0
Date:   Tue,  3 Dec 2019 23:34:32 +0100
Message-Id: <20191203213012.412482742@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 7541c87c9b7a7e07c84481f37f2c19063b44469b ]

"ctx:file_pos sysctl:read read ok narrow" works on s390 by accident: it
reads the wrong byte, which happens to have the expected value of 0.
Improve the test by seeking to the 4th byte and expecting 4 instead of
0.

This makes the latent problem apparent: the test attempts to read the
first byte of bpf_sysctl.file_pos, assuming this is the least-significant
byte, which is not the case on big-endian machines: a non-zero offset is
needed.

The point of the test is to verify narrow loads, so we cannot cheat our
way out by simply using BPF_W. The existence of the test means that such
loads have to be supported, most likely because llvm can generate them.
Fix the test by adding a big-endian variant, which uses an offset to
access the least-significant byte of bpf_sysctl.file_pos.

This reveals the final problem: verifier rejects accesses to bpf_sysctl
fields with offset > 0. Such accesses are already allowed for a wide
range of structs: __sk_buff, bpf_sock_addr and sk_msg_md to name a few.
Extend this support to bpf_sysctl by using bpf_ctx_range instead of
offsetof when matching field offsets.

Fixes: 7b146cebe30c ("bpf: Sysctl hook")
Fixes: e1550bfe0de4 ("bpf: Add file_pos field to bpf_sysctl ctx")
Fixes: 9a1027e52535 ("selftests/bpf: Test file_pos field in bpf_sysctl ctx")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrey Ignatov <rdna@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20191028122902.9763-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c                       | 4 ++--
 tools/testing/selftests/bpf/test_sysctl.c | 8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 0a00eaca6fae6..9ad7cd3267f52 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1302,12 +1302,12 @@ static bool sysctl_is_valid_access(int off, int size, enum bpf_access_type type,
 		return false;
 
 	switch (off) {
-	case offsetof(struct bpf_sysctl, write):
+	case bpf_ctx_range(struct bpf_sysctl, write):
 		if (type != BPF_READ)
 			return false;
 		bpf_ctx_record_field_size(info, size_default);
 		return bpf_ctx_narrow_access_ok(off, size, size_default);
-	case offsetof(struct bpf_sysctl, file_pos):
+	case bpf_ctx_range(struct bpf_sysctl, file_pos):
 		if (type == BPF_READ) {
 			bpf_ctx_record_field_size(info, size_default);
 			return bpf_ctx_narrow_access_ok(off, size, size_default);
diff --git a/tools/testing/selftests/bpf/test_sysctl.c b/tools/testing/selftests/bpf/test_sysctl.c
index a3bebd7c68ddc..c938f1767ca72 100644
--- a/tools/testing/selftests/bpf/test_sysctl.c
+++ b/tools/testing/selftests/bpf/test_sysctl.c
@@ -158,9 +158,14 @@ static struct sysctl_test tests[] = {
 		.descr = "ctx:file_pos sysctl:read read ok narrow",
 		.insns = {
 			/* If (file_pos == X) */
+#if __BYTE_ORDER == __LITTLE_ENDIAN
 			BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_1,
 				    offsetof(struct bpf_sysctl, file_pos)),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0, 2),
+#else
+			BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_1,
+				    offsetof(struct bpf_sysctl, file_pos) + 3),
+#endif
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 4, 2),
 
 			/* return ALLOW; */
 			BPF_MOV64_IMM(BPF_REG_0, 1),
@@ -173,6 +178,7 @@ static struct sysctl_test tests[] = {
 		.attach_type = BPF_CGROUP_SYSCTL,
 		.sysctl = "kernel/ostype",
 		.open_flags = O_RDONLY,
+		.seek = 4,
 		.result = SUCCESS,
 	},
 	{
-- 
2.20.1



