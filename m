Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41CE6AEDB1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjCGSGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbjCGSGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:06:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A3934026
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:59:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BDCC61522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5247EC433D2;
        Tue,  7 Mar 2023 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211959;
        bh=l8uX+ww20rxdEljzUC7ky+orcyiCrlVXLU7EJWfL7K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AoE+WwzMK7LyInB2z3oeqnIt+HLlHbpH7oxexJ0JZvzvDdZfpjMg5f+0mbDU8akLD
         hE9sjcGFR6vjKG+MPz6BeCBCncX9naBlUCPssyUOk2K6YWBjuNQ9/8C9NhBsQLk6gx
         ymtEQ7TjtD+ah7dgq0A6xwfKWEg05sQ6bg7J0QLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/885] cpuidle, intel_idle: Fix CPUIDLE_FLAG_IRQ_ENABLE *again*
Date:   Tue,  7 Mar 2023 17:49:25 +0100
Message-Id: <20230307170003.009357914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 6d9c7f51b1d9179bf7c3542267c656a934e8af23 ]

So objtool found this bug:

  vmlinux.o: warning: objtool: intel_idle_irq+0x10c: call to trace_hardirqs_off() leaves .noinstr.text section

As per commit 32d4fd5751ea ("cpuidle,intel_idle: Fix CPUIDLE_FLAG_IRQ_ENABLE"):

  "must not have tracing in idle functions"

Clearly people can't read and tinker along until splat dissapears.
This straight up reverts commit d295ad34f236 ("intel_idle: Fix false
positive RCU splats due to incorrect hardirqs state").

It doesn't re-introduce the problem because preceding patches fixed it
properly.

Fixes: d295ad34f236 ("intel_idle: Fix false positive RCU splats due to incorrect hardirqs state")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20230112195540.434302128@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index cfeb24d40d378..f060ac7376e69 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -168,13 +168,7 @@ static __cpuidle int intel_idle_irq(struct cpuidle_device *dev,
 
 	raw_local_irq_enable();
 	ret = __intel_idle(dev, drv, index);
-
-	/*
-	 * The lockdep hardirqs state may be changed to 'on' with timer
-	 * tick interrupt followed by __do_softirq(). Use local_irq_disable()
-	 * to keep the hardirqs state correct.
-	 */
-	local_irq_disable();
+	raw_local_irq_disable();
 
 	return ret;
 }
-- 
2.39.2



