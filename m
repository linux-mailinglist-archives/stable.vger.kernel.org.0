Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5445C308
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349864AbhKXNfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349897AbhKXNdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:33:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C754D61BE2;
        Wed, 24 Nov 2021 12:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758413;
        bh=FAWz6gRsZOcH9Kvrml9LPVeQqespzp4gnFKsZBwwdq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuFzmVFrY+1jT2E/yuR4BIl+HCkl8uuC7HSjUdJC47x0qluUybAJy7Z3OHGFUj/zT
         m1slz3eZ0/OxT33uj1v+a1/ZO/6k0R2kaMMjPd9KuHTk2uoHGf50Algm6CRABu1n2J
         jTk/uNwOluIn0PTB0rAtVS7qaSwKhC/6kloH7Rnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing-Ting Wu <jing-ting.wu@mediatek.com>,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/154] sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()
Date:   Wed, 24 Nov 2021 12:57:37 +0100
Message-Id: <20211124115704.296895162@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit 42dc938a590c96eeb429e1830123fef2366d9c80 ]

Nothing protects the access to the per_cpu variable sd_llc_id. When testing
the same CPU (i.e. this_cpu == that_cpu), a race condition exists with
update_top_cache_domain(). One scenario being:

              CPU1                            CPU2
  ==================================================================

  per_cpu(sd_llc_id, CPUX) => 0
                                    partition_sched_domains_locked()
      				      detach_destroy_domains()
  cpus_share_cache(CPUX, CPUX)          update_top_cache_domain(CPUX)
    per_cpu(sd_llc_id, CPUX) => 0
                                          per_cpu(sd_llc_id, CPUX) = CPUX
    per_cpu(sd_llc_id, CPUX) => CPUX
    return false

ttwu_queue_cond() wouldn't catch smp_processor_id() == cpu and the result
is a warning triggered from ttwu_queue_wakelist().

Avoid a such race in cpus_share_cache() by always returning true when
this_cpu == that_cpu.

Fixes: 518cd6234178 ("sched: Only queue remote wakeups when crossing cache boundaries")
Reported-by: Jing-Ting Wu <jing-ting.wu@mediatek.com>
Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20211104175120.857087-1-vincent.donnefort@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc8ff11e60242..e456cce772a3a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2650,6 +2650,9 @@ out:
 
 bool cpus_share_cache(int this_cpu, int that_cpu)
 {
+	if (this_cpu == that_cpu)
+		return true;
+
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
 }
 
-- 
2.33.0



