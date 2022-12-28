Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452E8657A99
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiL1PNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiL1PNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:13:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F91313E81
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:12:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29617B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F972C433EF;
        Wed, 28 Dec 2022 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240361;
        bh=qY16RBtuxcD3RstD6hVr5F6RiT/+hNpK2zQhV3Y6A1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnydmrogOT9MWU82VKOhsNDS/do511JZWxqR9xqG1+YPfe7fzAqefBLgqBoBR//ly
         CnL78Eu70KgIa/Suom7W4IM0hdzJJe4MLY/eys0F45QFfhEI8E+mPVwHnFRaCbicL+
         P+BXRejr89mHEIGZrpnmh8p6rarEo8n48Lfy5648=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ulf Hansson <ulf.hansson@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0113/1146] cpuidle: dt: Return the correct numbers of parsed idle states
Date:   Wed, 28 Dec 2022 15:27:32 +0100
Message-Id: <20221228144333.223947542@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 252f2a9686a6..448bc796b0b4 100644
--- a/drivers/cpuidle/dt_idle_states.c
+++ b/drivers/cpuidle/dt_idle_states.c
@@ -223,6 +223,6 @@ int dt_init_idle_driver(struct cpuidle_driver *drv,
 	 * also be 0 on platforms with missing DT idle states or legacy DT
 	 * configuration predating the DT idle states bindings.
 	 */
-	return i;
+	return state_idx - start_idx;
 }
 EXPORT_SYMBOL_GPL(dt_init_idle_driver);
-- 
2.35.1



