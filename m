Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AC76AE901
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCGRUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCGRTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:19:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82016911C3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:15:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8528614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FDEC433EF;
        Tue,  7 Mar 2023 17:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209310;
        bh=MWhiQgNujATw0PoR9bSWRV9Y91s/Rl7SOHJwQoD4yQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6Uv3SGgCWj7YI2BOdofiGqi8z6cFUaguy1yU0IMK4jXh3mDF3Y/oiGU4vWLWz86t
         kNWWcgklHh4tL5F3jhtzV14pdfa7X5Cm/AVF7G3RhyXnFPdN4DAtgwT0Mc9prjuppI
         2mYontGu3TJQUbtNeH4eMLdhXWceca6zl0JilOFA=
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
Subject: [PATCH 6.2 0177/1001] genirq: Fix the return type of kstat_cpu_irqs_sum()
Date:   Tue,  7 Mar 2023 17:49:09 +0100
Message-Id: <20230307170029.608922890@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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



