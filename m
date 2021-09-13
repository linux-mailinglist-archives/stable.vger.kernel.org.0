Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC968408E9D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbhIMNgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240592AbhIMNdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:33:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0016B613A1;
        Mon, 13 Sep 2021 13:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539575;
        bh=n0xECGA7Aa7dSr2TdWQ0gbsVXkxXFHey0L4XmPXWOKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAiHbgzh8s9ThaYAWK4jeohZ6NEsynt3bzDiMYJ1UjAL2K9F0I1YLAjjh7Gwh2awt
         AeKRSF6CQw4Ul8AvUUaS/QmE93avcc9Kr9nSpFvzD2z8nG9a32gKk2Ygqo66/ORzSZ
         AxLcSoHCZ/X8GIBuXBZfPs+V+vhLeAt9zjmkd3RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Fengqing <hefengqing@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/236] bpf: Fix potential memleak and UAF in the verifier.
Date:   Mon, 13 Sep 2021 15:13:03 +0200
Message-Id: <20210913131103.013186287@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Fengqing <hefengqing@huawei.com>

[ Upstream commit 75f0fc7b48ad45a2e5736bcf8de26c8872fe8695 ]

In bpf_patch_insn_data(), we first use the bpf_patch_insn_single() to
insert new instructions, then use adjust_insn_aux_data() to adjust
insn_aux_data. If the old env->prog have no enough room for new inserted
instructions, we use bpf_prog_realloc to construct new_prog and free the
old env->prog.

There have two errors here. First, if adjust_insn_aux_data() return
ENOMEM, we should free the new_prog. Second, if adjust_insn_aux_data()
return ENOMEM, bpf_patch_insn_data() will return NULL, and env->prog has
been freed in bpf_prog_realloc, but we will use it in bpf_check().

So in this patch, we make the adjust_insn_aux_data() never fails. In
bpf_patch_insn_data(), we first pre-malloc memory for the new
insn_aux_data, then call bpf_patch_insn_single() to insert new
instructions, at last call adjust_insn_aux_data() to adjust
insn_aux_data.

Fixes: 8041902dae52 ("bpf: adjust insn_aux_data when patching insns")
Signed-off-by: He Fengqing <hefengqing@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20210714101815.164322-1-hefengqing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 29d4f4e37595..78f24b19f6b1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10456,10 +10456,11 @@ static void convert_pseudo_ld_imm64(struct bpf_verifier_env *env)
  * insni[off, off + cnt).  Adjust corresponding insn_aux_data by copying
  * [0, off) and [off, end) to new locations, so the patched range stays zero
  */
-static int adjust_insn_aux_data(struct bpf_verifier_env *env,
-				struct bpf_prog *new_prog, u32 off, u32 cnt)
+static void adjust_insn_aux_data(struct bpf_verifier_env *env,
+				 struct bpf_insn_aux_data *new_data,
+				 struct bpf_prog *new_prog, u32 off, u32 cnt)
 {
-	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
+	struct bpf_insn_aux_data *old_data = env->insn_aux_data;
 	struct bpf_insn *insn = new_prog->insnsi;
 	u32 old_seen = old_data[off].seen;
 	u32 prog_len;
@@ -10472,12 +10473,9 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 	old_data[off].zext_dst = insn_has_def32(env, insn + off + cnt - 1);
 
 	if (cnt == 1)
-		return 0;
+		return;
 	prog_len = new_prog->len;
-	new_data = vzalloc(array_size(prog_len,
-				      sizeof(struct bpf_insn_aux_data)));
-	if (!new_data)
-		return -ENOMEM;
+
 	memcpy(new_data, old_data, sizeof(struct bpf_insn_aux_data) * off);
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
@@ -10488,7 +10486,6 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 	}
 	env->insn_aux_data = new_data;
 	vfree(old_data);
-	return 0;
 }
 
 static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len)
@@ -10523,6 +10520,14 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 					    const struct bpf_insn *patch, u32 len)
 {
 	struct bpf_prog *new_prog;
+	struct bpf_insn_aux_data *new_data = NULL;
+
+	if (len > 1) {
+		new_data = vzalloc(array_size(env->prog->len + len - 1,
+					      sizeof(struct bpf_insn_aux_data)));
+		if (!new_data)
+			return NULL;
+	}
 
 	new_prog = bpf_patch_insn_single(env->prog, off, patch, len);
 	if (IS_ERR(new_prog)) {
@@ -10530,10 +10535,10 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 			verbose(env,
 				"insn %d cannot be patched due to 16-bit range\n",
 				env->insn_aux_data[off].orig_idx);
+		vfree(new_data);
 		return NULL;
 	}
-	if (adjust_insn_aux_data(env, new_prog, off, len))
-		return NULL;
+	adjust_insn_aux_data(env, new_data, new_prog, off, len);
 	adjust_subprog_starts(env, off, len);
 	adjust_poke_descs(new_prog, off, len);
 	return new_prog;
-- 
2.30.2



