Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D04C4513ED
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348754AbhKOT7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344135AbhKOTXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E44E06362F;
        Mon, 15 Nov 2021 18:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002356;
        bh=6wnlAsLWAXDc/4xbWbXpl69JThoV4wWfKpUyNX+mhe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0sxkcRwOC6p4r5B5s+toRz0L4iyfT0hNn/mkwj3RpiWZqbImf0iShxPMpGhRYL/R
         YjePY5YWy/F0FxKgNzA8ZPJVXDTAag01sMarmFgaskrtYAo6SGjfb19rZ70HKnWyR9
         MkU/Q/tU3rZJkcXkUeP5SOtQysDBwpT+XkaGtQnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/917] bpf: Fixes possible race in update_prog_stats() for 32bit arches
Date:   Mon, 15 Nov 2021 18:00:31 +0100
Message-Id: <20211115165446.936957479@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index fe1e857324e66..d3a307a8c42b9 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -585,11 +585,13 @@ static void notrace update_prog_stats(struct bpf_prog *prog,
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



