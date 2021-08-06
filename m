Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C563E254D
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243940AbhHFITF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243920AbhHFISL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:18:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AB4F61207;
        Fri,  6 Aug 2021 08:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237874;
        bh=eT6BjlNhNV89V8Cy+xtEwv40UcjJm1hXKk3R0beNwwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdRJpXq2p9wMXmR376bXbt9G7XQsSyvUj3htlWf3UcwFTwl/5Lyr+A80AYGvTtb8B
         gV7VysOOe9b/r438LmWaZ2+RtreujRWcBw+pJJdoSu49mEiwCctWhvoecefyWfhn8X
         RTIqzVZbIz9oL12F1r1mNZ85klWGbMGVwuQ0zub0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Benedict Schlueter <benedict.schlueter@rub.de>,
        Piotr Krysiuk <piotras@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 18/23] bpf: Inherit expanded/patched seen count from old aux data
Date:   Fri,  6 Aug 2021 10:16:50 +0200
Message-Id: <20210806081112.763477052@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit d203b0fd863a2261e5d00b97f3d060c4c2a6db71 upstream

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
[OP: declare old_data as bool instead of u32 (struct bpf_insn_aux_data.seen
     is bool in 5.4)]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8304,6 +8304,7 @@ static int adjust_insn_aux_data(struct b
 {
 	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
 	struct bpf_insn *insn = new_prog->insnsi;
+	bool old_seen = old_data[off].seen;
 	u32 prog_len;
 	int i;
 
@@ -8324,7 +8325,8 @@ static int adjust_insn_aux_data(struct b
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
 	for (i = off; i < off + cnt - 1; i++) {
-		new_data[i].seen = true;
+		/* Expand insni[off]'s seen count to the patched range. */
+		new_data[i].seen = old_seen;
 		new_data[i].zext_dst = insn_has_def32(env, insn + i);
 	}
 	env->insn_aux_data = new_data;


