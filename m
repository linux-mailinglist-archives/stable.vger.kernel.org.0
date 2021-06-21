Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B723AEECA
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhFUQcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231959AbhFUQaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:30:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF042613C0;
        Mon, 21 Jun 2021 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292695;
        bh=WlC68sZthjWflMpmWXBCqDi4iAudeXEkSFV/uSxmxLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pk22mhBWvxqFPQkjh5/e/BNCr7OqhY6it50wAu+WFuKu+xTAFmPSkOs8B/SdMyYaj
         hyEzk9z1G+7EBT36cMOmaeq+sg2DVfFxaUVGPF60yIkFpszd4j4fR8r6oW87zVgfPe
         E9WkaNTfGqx8dEcfNDKB+xrEuJGewYkFRynM9Lhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Benedict Schlueter <benedict.schlueter@rub.de>,
        Piotr Krysiuk <piotras@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/146] bpf: Inherit expanded/patched seen count from old aux data
Date:   Mon, 21 Jun 2021 18:15:26 +0200
Message-Id: <20210621154917.255349343@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d203b0fd863a2261e5d00b97f3d060c4c2a6db71 ]

Instead of relying on current env->pass_cnt, use the seen count from the
old aux data in adjust_insn_aux_data(), and expand it to the new range of
patched instructions. This change is valid given we always expand 1:n
with n>=1, so what applies to the old/original instruction needs to apply
for the replacement as well.

Not relying on env->pass_cnt is a prerequisite for a later change where we
want to avoid marking an instruction seen when verified under speculative
execution path.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index da8fc57ff5b2..71ac1da127a6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10475,6 +10475,7 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 {
 	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
 	struct bpf_insn *insn = new_prog->insnsi;
+	u32 old_seen = old_data[off].seen;
 	u32 prog_len;
 	int i;
 
@@ -10495,7 +10496,8 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
 	for (i = off; i < off + cnt - 1; i++) {
-		new_data[i].seen = env->pass_cnt;
+		/* Expand insni[off]'s seen count to the patched range. */
+		new_data[i].seen = old_seen;
 		new_data[i].zext_dst = insn_has_def32(env, insn + i);
 	}
 	env->insn_aux_data = new_data;
-- 
2.30.2



