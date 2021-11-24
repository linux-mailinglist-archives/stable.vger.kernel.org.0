Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A3545BE98
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244505AbhKXMtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245626AbhKXMqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:46:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EA6E610A6;
        Wed, 24 Nov 2021 12:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756824;
        bh=P1efQ1EJYZ7M3hPLIesNMPnifDK4J0i56+3LXQgiPIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2X9RDqql6TSwuqDDBOvE6ehJDAYc0Riw9dpiPOgnZTg141MvOi3TyIqYrmP97USL
         jq195suIzjc0inmLhmTkqPxf81fpzC0CDnP04Sz6ZoY34iUoxI9Qc6FpjECEv2k19r
         JcGQhgcjTsTb0dvi44BByYr7l07iOjcTvJ/rY0TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing-Ting Wu <jing-ting.wu@mediatek.com>,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 220/251] sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()
Date:   Wed, 24 Nov 2021 12:57:42 +0100
Message-Id: <20211124115717.918812279@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 7cedada731c1b..544a1cb66d90d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1852,6 +1852,9 @@ out:
 
 bool cpus_share_cache(int this_cpu, int that_cpu)
 {
+	if (this_cpu == that_cpu)
+		return true;
+
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
 }
 #endif /* CONFIG_SMP */
-- 
2.33.0



