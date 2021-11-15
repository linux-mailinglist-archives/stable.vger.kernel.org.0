Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E12452370
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350454AbhKPB0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243431AbhKOTA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:00:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FE7C63311;
        Mon, 15 Nov 2021 18:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000067;
        bh=CACZSDmBx/9+0kTRxrLdaOAtXKdspJ30AroUXW3FMl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hY+4R3gb9IhCFLKTl+mrgRFv6TqcVByJyxPveNyrV9BMO+WmRQ2srVCctMGjJ1pF4
         i0e9XQ8GtBWuwzHfxdb/bPkYKFumgM36xa13+lHMvc9xuzg4zFFY4IilcwzkicbPqZ
         ZCRQVCIOcOIWZZsJIUqljv0kf8B+d+RxWx8WFbH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 524/849] bpf: Fixes possible race in update_prog_stats() for 32bit arches
Date:   Mon, 15 Nov 2021 18:00:07 +0100
Message-Id: <20211115165437.999055546@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d979617aa84d96acca44c2f5778892b4565e322f ]

It seems update_prog_stats() suffers from same issue fixed
in the prior patch:

As it can run while interrupts are enabled, it could
be re-entered and the u64_stats syncp could be mangled.

Fixes: fec56f5890d9 ("bpf: Introduce BPF trampoline")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211026214133.3114279-3-eric.dumazet@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 28a3630c48ee1..9587e5ebddaa3 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -579,11 +579,13 @@ static void notrace update_prog_stats(struct bpf_prog *prog,
 	     * Hence check that 'start' is valid.
 	     */
 	    start > NO_START_TIME) {
+		unsigned long flags;
+
 		stats = this_cpu_ptr(prog->stats);
-		u64_stats_update_begin(&stats->syncp);
+		flags = u64_stats_update_begin_irqsave(&stats->syncp);
 		stats->cnt++;
 		stats->nsecs += sched_clock() - start;
-		u64_stats_update_end(&stats->syncp);
+		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	}
 }
 
-- 
2.33.0



