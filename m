Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937FE6AEE43
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbjCGSKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjCGSKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9A4974B2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10AA8B819BC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F429C433EF;
        Tue,  7 Mar 2023 18:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212306;
        bh=MWhiQgNujATw0PoR9bSWRV9Y91s/Rl7SOHJwQoD4yQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpU10SRB5FZta55gGgii2YqVCewr1fSqw99m5GHOHPVCpvt19rlAl6XeC/RH0YZn3
         Z0m1HzQwWqZuNwkOWS/3Hgj3+uKHzTLWjfdv1KpGs+W7f750hZbcdEHy2lDjV6NT2g
         xVArKTRu/fnNKNeWkmNqnISWwWkMWWDeqZQQrcjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Elliott, Robert (Servers)" <elliott@hpe.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Tejun Heo <tj@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Don <joshdon@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Elliott@vger.kernel.org
Subject: [PATCH 6.1 142/885] genirq: Fix the return type of kstat_cpu_irqs_sum()
Date:   Tue,  7 Mar 2023 17:51:16 +0100
Message-Id: <20230307170008.026734570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 47904aed898a08f028572b9b5a5cc101ddfb2d82 ]

The type of member ->irqs_sum is unsigned long, but kstat_cpu_irqs_sum()
returns int, which can result in truncation.  Therefore, change the
kstat_cpu_irqs_sum() function's return value to unsigned long to avoid
truncation.

Fixes: f2c66cd8eedd ("/proc/stat: scalability of irq num per cpu")
Reported-by: Elliott, Robert (Servers) <elliott@hpe.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Josh Don <joshdon@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kernel_stat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index ddb5a358fd829..90e2fdc17d79f 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -75,7 +75,7 @@ extern unsigned int kstat_irqs_usr(unsigned int irq);
 /*
  * Number of interrupts per cpu, since bootup
  */
-static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
+static inline unsigned long kstat_cpu_irqs_sum(unsigned int cpu)
 {
 	return kstat_cpu(cpu).irqs_sum;
 }
-- 
2.39.2



