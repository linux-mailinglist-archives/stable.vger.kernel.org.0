Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3708B66C66B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjAPQUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbjAPQTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:19:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B793298C2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:10:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 386FD61057
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCA0C433EF;
        Mon, 16 Jan 2023 16:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885435;
        bh=sBNTPbnWdjlWVJsr1wCRproTBLBpnm8bGudy7Lnjmbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdWcLPjcsYS55q1GwfT8JQo/PrfrRR/vezIXhyyDxkoMvwVG5PZDWyUBseccqrr16
         Vm5jkVMzg55OiZpjNIp0U9lq7vLSWx9qFIxhymmzpXdAYzJoqZ7sgfDbqKeaqfwtLk
         T+/APMHGXUFR4s/f6hZujXrxdxQbV/875dLgexDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ulf Hansson <ulf.hansson@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/658] cpuidle: dt: Return the correct numbers of parsed idle states
Date:   Mon, 16 Jan 2023 16:42:18 +0100
Message-Id: <20230116154911.931182441@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit ee3c2c8ad6ba6785f14a60e4081d7c82e88162a2 ]

While we correctly skips to initialize an idle state from a disabled idle
state node in DT, the returned value from dt_init_idle_driver() don't get
adjusted accordingly. Instead the number of found idle state nodes are
returned, while the callers are expecting the number of successfully
initialized idle states from DT.

This leads to cpuidle drivers unnecessarily continues to initialize their
idle state specific data. Moreover, in the case when all idle states have
been disabled in DT, we would end up registering a cpuidle driver, rather
than relying on the default arch specific idle call.

Fixes: 9f14da345599 ("drivers: cpuidle: implement DT based idle states infrastructure")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/dt_idle_states.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/dt_idle_states.c b/drivers/cpuidle/dt_idle_states.c
index d06d21a9525d..74702065730c 100644
--- a/drivers/cpuidle/dt_idle_states.c
+++ b/drivers/cpuidle/dt_idle_states.c
@@ -224,6 +224,6 @@ int dt_init_idle_driver(struct cpuidle_driver *drv,
 	 * also be 0 on platforms with missing DT idle states or legacy DT
 	 * configuration predating the DT idle states bindings.
 	 */
-	return i;
+	return state_idx - start_idx;
 }
 EXPORT_SYMBOL_GPL(dt_init_idle_driver);
-- 
2.35.1



