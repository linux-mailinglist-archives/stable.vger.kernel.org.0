Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE75B3EB87F
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242332AbhHMPOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241951AbhHMPNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8C966112D;
        Fri, 13 Aug 2021 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867554;
        bh=r/It5R4/yhQY6rvDBmpY0DcKcwXQ2ZWlt5AclDMwB+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8Uid0oLC0ezrRrlNdzllD1geSCeTQbNFgVvjHrTFnuAkhM+xIoXXwes5ECfM3jUr
         pptTCv91BX0rgbNuIC3J+y0nfM+WhkN4uHotrnrEf7RbU/g7PnC3fxn+NyuAa5IcVk
         Uh0EM8+j/vVWw6gWVtqpEnQyZmxty24FLVt2YEeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Benedict Schlueter <benedict.schlueter@rub.de>,
        Piotr Krysiuk <piotras@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 03/11] bpf: Inherit expanded/patched seen count from old aux data
Date:   Fri, 13 Aug 2021 17:07:10 +0200
Message-Id: <20210813150520.181696817@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.072304554@linuxfoundation.org>
References: <20210813150520.072304554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit d203b0fd863a2261e5d00b97f3d060c4c2a6db71 upstream.

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
[OP: - declare old_data as bool instead of u32 (struct bpf_insn_aux_data.seen
     is bool in 5.4)
     - adjusted context for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5690,6 +5690,7 @@ static int adjust_insn_aux_data(struct b
 				u32 off, u32 cnt)
 {
 	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
+	bool old_seen = old_data[off].seen;
 	int i;
 
 	if (cnt == 1)
@@ -5701,8 +5702,10 @@ static int adjust_insn_aux_data(struct b
 	memcpy(new_data, old_data, sizeof(struct bpf_insn_aux_data) * off);
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
-	for (i = off; i < off + cnt - 1; i++)
-		new_data[i].seen = true;
+	for (i = off; i < off + cnt - 1; i++) {
+		/* Expand insni[off]'s seen count to the patched range. */
+		new_data[i].seen = old_seen;
+	}
 	env->insn_aux_data = new_data;
 	vfree(old_data);
 	return 0;


