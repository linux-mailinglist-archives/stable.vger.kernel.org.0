Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB57328F48
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbhCATs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241740AbhCATix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE0B864FFF;
        Mon,  1 Mar 2021 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618541;
        bh=VejxEiyxyML83jVdaBmLRIWKWPlBf9I+ntI8vXbTOUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBTDiHMZ+gP1ayR0TG8xLjPxB8+z7HLSlP/dhzgx+fyY+hYrr5UhxelWOsmzmDNEZ
         eHcK8StbO+ldzTTZQ1MIYzaqE341vnRNymxgNlH4Bq7itB1dIso9H5AuvH38VEffT4
         OuDT+OG2AZssg/7RU2gE7FxLKinAmfZbMFAb2YZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/663] bpf: Clear subreg_def for global function return values
Date:   Mon,  1 Mar 2021 17:06:12 +0100
Message-Id: <20210301161147.873757369@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 45159b27637b0fef6d5ddb86fc7c46b13c77960f ]

test_global_func4 fails on s390 as reported by Yauheni in [1].

The immediate problem is that the zext code includes the instruction,
whose result needs to be zero-extended, into the zero-extension
patchlet, and if this instruction happens to be a branch, then its
delta is not adjusted. As a result, the verifier rejects the program
later.

However, according to [2], as far as the verifier's algorithm is
concerned and as specified by the insn_no_def() function, branching
insns do not define anything. This includes call insns, even though
one might argue that they define %r0.

This means that the real problem is that zero extension kicks in at
all. This happens because clear_caller_saved_regs() sets BPF_REG_0's
subreg_def after global function calls. This can be fixed in many
ways; this patch mimics what helper function call handling already
does.

  [1] https://lore.kernel.org/bpf/20200903140542.156624-1-yauheni.kaliuta@redhat.com/
  [2] https://lore.kernel.org/bpf/CAADnVQ+2RPKcftZw8d+B1UwB35cpBhpF5u3OocNh90D9pETPwg@mail.gmail.com/

Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
Reported-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210212040408.90109-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c09594e70f90a..6c2e4947beaeb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4786,8 +4786,9 @@ static int check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 					subprog);
 			clear_caller_saved_regs(env, caller->regs);
 
-			/* All global functions return SCALAR_VALUE */
+			/* All global functions return a 64-bit SCALAR_VALUE */
 			mark_reg_unknown(env, caller->regs, BPF_REG_0);
+			caller->regs[BPF_REG_0].subreg_def = DEF_NOT_SUBREG;
 
 			/* continue with next insn after call */
 			return 0;
-- 
2.27.0



