Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B715C6B4723
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjCJOs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbjCJOrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:47:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29874122388
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:47:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4960B822E9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF6BC433A0;
        Fri, 10 Mar 2023 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459641;
        bh=QdSmjz7UcOLYvOWqQcvkoqyQImsnGfecnyRzdm5uz4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmYNx0JAjMpyDa1VaQQRF1Oe10LCrfIr1h+a3MxdO68HCG+uAU53JqlxpBhYgOj0u
         HXmeQesltQm3vayBgV88QDSnx4Ff9oo1oL2YytfXRZY8uGJCl5pEliERigwmjV4R9Y
         vAMg9Culogq0/GtTXAgrMXlnrp0XoO/ldFEE+Aco=
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
Subject: [PATCH 5.10 071/529] genirq: Fix the return type of kstat_cpu_irqs_sum()
Date:   Fri, 10 Mar 2023 14:33:34 +0100
Message-Id: <20230310133808.259622454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 8fff3500d50ee..1160e20995a02 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -73,7 +73,7 @@ extern unsigned int kstat_irqs_usr(unsigned int irq);
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



