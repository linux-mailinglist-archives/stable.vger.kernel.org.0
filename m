Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803D13F63D4
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbhHXQ63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234631AbhHXQ5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04B26613AB;
        Tue, 24 Aug 2021 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824217;
        bh=2AgmuhxqTgjafhi/4u/qMkkV+mAxh1MeDTg/0Umv9Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loZvkWHFn0vcPPQpbat/A89uhlJMRnHVyETzZWnOf4xlRJ2Bj8A5bUYHEfuuInD2C
         SVoAXAUouOs3qUDEFqH1D2H1H/i7AWkmTS8qlel5+/CS9dtTEQZJFk+Vtf/3Pp5X0U
         sJoc9Hwee5h78XTM9vVHOzX/DVCvyMMgwsPOmEmAP7a62Fi77PibnIYMXPwxiYfML/
         AkOzB14LLeZEz4rzu4vtblAnsENjR/VsB8ZKF/fFDlZpqQHpTtFRpCO4FpKCffvJGm
         PT0CnOEm0qHSSshKehvTbHrhBHwYCWm0cdMWKoqZdvEhxgW2ZpmeRFOBR517LifszN
         HuS7uNTUpy1Ow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 050/127] bpf: Clear zext_dst of dead insns
Date:   Tue, 24 Aug 2021 12:54:50 -0400
Message-Id: <20210824165607.709387-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 45c709f8c71b525b51988e782febe84ce933e7e0 ]

"access skb fields ok" verifier test fails on s390 with the "verifier
bug. zext_dst is set, but no reg is defined" message. The first insns
of the test prog are ...

   0:	61 01 00 00 00 00 00 00 	ldxw %r0,[%r1+0]
   8:	35 00 00 01 00 00 00 00 	jge %r0,0,1
  10:	61 01 00 08 00 00 00 00 	ldxw %r0,[%r1+8]

... and the 3rd one is dead (this does not look intentional to me, but
this is a separate topic).

sanitize_dead_code() converts dead insns into "ja -1", but keeps
zext_dst. When opt_subreg_zext_lo32_rnd_hi32() tries to parse such
an insn, it sees this discrepancy and bails. This problem can be seen
only with JITs whose bpf_jit_needs_zext() returns true.

Fix by clearning dead insns' zext_dst.

The commits that contributed to this problem are:

1. 5aa5bd14c5f8 ("bpf: add initial suite for selftests"), which
   introduced the test with the dead code.
2. 5327ed3d44b7 ("bpf: verifier: mark verified-insn with
   sub-register zext flag"), which introduced the zext_dst flag.
3. 83a2881903f3 ("bpf: Account for BPF_FETCH in
   insn_has_def32()"), which introduced the sanity check.
4. 9183671af6db ("bpf: Fix leakage under speculation on
   mispredicted branches"), which bisect points to.

It's best to fix this on stable branches that contain the second one,
since that's the point where the inconsistency was introduced.

Fixes: 5327ed3d44b7 ("bpf: verifier: mark verified-insn with sub-register zext flag")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210812151811.184086-2-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index eab48745231f..0fbe7ef6b155 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11632,6 +11632,7 @@ static void sanitize_dead_code(struct bpf_verifier_env *env)
 		if (aux_data[i].seen)
 			continue;
 		memcpy(insn + i, &trap, sizeof(trap));
+		aux_data[i].zext_dst = false;
 	}
 }
 
-- 
2.30.2

