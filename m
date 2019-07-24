Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167CD73A41
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390921AbfGXTsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391034AbfGXTsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:48:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB21C21873;
        Wed, 24 Jul 2019 19:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997698;
        bh=9emZkSTCwyNtMvzp8juiAJBq7YHr93QN1SGkx+lKNoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+Gz4S5zGifu4cf2r2iEw0kceeMutCMsMeoc26k16wXJzO3k+DvpHgUDjXx9rXarA
         ZRDXqyOpazn9vfrwU/Jbr/EEdZuwHZpLKmCzdV2aMDbmsPXj5OM/w6tPdoqIWSNB96
         E9yW/Y8gHEjMhFHaf9RX+7ncIr+O7TIOgbkUE1tU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 111/371] bpf: fix callees pruning callers
Date:   Wed, 24 Jul 2019 21:17:43 +0200
Message-Id: <20190724191733.191660682@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eea1c227b9e9bad295e8ef984004a9acf12bb68c ]

The commit 7640ead93924 partially resolved the issue of callees
incorrectly pruning the callers.
With introduction of bounded loops and jmps_processed heuristic
single verifier state may contain multiple branches and calls.
It's possible that new verifier state (for future pruning) will be
allocated inside callee. Then callee will exit (still within the same
verifier state). It will go back to the caller and there R6-R9 registers
will be read and will trigger mark_reg_read. But the reg->live for all frames
but the top frame is not set to LIVE_NONE. Hence mark_reg_read will fail
to propagate liveness into parent and future walking will incorrectly
conclude that the states are equivalent because LIVE_READ is not set.
In other words the rule for parent/live should be:
whenever register parentage chain is set the reg->live should be set to LIVE_NONE.
is_state_visited logic already follows this rule for spilled registers.

Fixes: 7640ead93924 ("bpf: verifier: make sure callees don't prune with caller differences")
Fixes: f4d7e40a5b71 ("bpf: introduce function calls (verification)")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4ff130ddfbf6..cbc03f051598 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6197,17 +6197,18 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	 * the state of the call instruction (with WRITTEN set), and r0 comes
 	 * from callee with its full parentage chain, anyway.
 	 */
-	for (j = 0; j <= cur->curframe; j++)
-		for (i = j < cur->curframe ? BPF_REG_6 : 0; i < BPF_REG_FP; i++)
-			cur->frame[j]->regs[i].parent = &new->frame[j]->regs[i];
 	/* clear write marks in current state: the writes we did are not writes
 	 * our child did, so they don't screen off its reads from us.
 	 * (There are no read marks in current state, because reads always mark
 	 * their parent and current state never has children yet.  Only
 	 * explored_states can get read marks.)
 	 */
-	for (i = 0; i < BPF_REG_FP; i++)
-		cur->frame[cur->curframe]->regs[i].live = REG_LIVE_NONE;
+	for (j = 0; j <= cur->curframe; j++) {
+		for (i = j < cur->curframe ? BPF_REG_6 : 0; i < BPF_REG_FP; i++)
+			cur->frame[j]->regs[i].parent = &new->frame[j]->regs[i];
+		for (i = 0; i < BPF_REG_FP; i++)
+			cur->frame[j]->regs[i].live = REG_LIVE_NONE;
+	}
 
 	/* all stack frames are accessible from callee, clear them all */
 	for (j = 0; j <= cur->curframe; j++) {
-- 
2.20.1



