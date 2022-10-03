Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A8B5F295D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiJCHSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiJCHRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:17:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770C046D8E;
        Mon,  3 Oct 2022 00:14:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5BCF60F97;
        Mon,  3 Oct 2022 07:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C49C433C1;
        Mon,  3 Oct 2022 07:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781248;
        bh=vV6J72lgCKZaW1qd9qddBQY27IkQVHpqMFO4vnJKAs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZIEXvpgCPLc5LPZpg2xe7oRmr6y2vQaBn8kSggNEQmRFGUNc4GYJ03ZaoJ9Bet8h
         Ok70n9sxX6PXAVyw9VqkmklTazC0U4EXL1jLnejsEa6ob92d9UbNopMwNQGirGybzX
         EMMiocSCRkfIGXuxpwp3ntS24pDwq0QO7GZsUeM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <npitre@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Peng Fan <peng.fan@nxp.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.19 024/101] Revert "firmware: arm_scmi: Add clock management to the SCMI power domain"
Date:   Mon,  3 Oct 2022 09:10:20 +0200
Message-Id: <20221003070725.088014050@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

commit 3c6656337852e9f1a4079d172f3fddfbf00868f9 upstream.

This reverts commit a3b884cef873 ("firmware: arm_scmi: Add clock management
to the SCMI power domain").

Using the GENPD_FLAG_PM_CLK tells genpd to gate/ungate the consumer
device's clock(s) during runtime suspend/resume through the PM clock API.
More precisely, in genpd_runtime_resume() the clock(s) for the consumer
device would become ungated prior to the driver-level ->runtime_resume()
callbacks gets invoked.

This behaviour isn't a good fit for all platforms/drivers. For example, a
driver may need to make some preparations of its device in its
->runtime_resume() callback, like calling clk_set_rate() before the
clock(s) should be ungated. In these cases, it's easier to let the clock(s)
to be managed solely by the driver, rather than at the PM domain level.

For these reasons, let's drop the use GENPD_FLAG_PM_CLK for the SCMI PM
domain, as to enable it to be more easily adopted across ARM platforms.

Fixes: a3b884cef873 ("firmware: arm_scmi: Add clock management to the SCMI power domain")
Cc: Nicolas Pitre <npitre@baylibre.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20220919122033.86126-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/scmi_pm_domain.c |   26 --------------------------
 1 file changed, 26 deletions(-)

--- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
+++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
@@ -8,7 +8,6 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
-#include <linux/pm_clock.h>
 #include <linux/pm_domain.h>
 #include <linux/scmi_protocol.h>
 
@@ -53,27 +52,6 @@ static int scmi_pd_power_off(struct gene
 	return scmi_pd_power(domain, false);
 }
 
-static int scmi_pd_attach_dev(struct generic_pm_domain *pd, struct device *dev)
-{
-	int ret;
-
-	ret = pm_clk_create(dev);
-	if (ret)
-		return ret;
-
-	ret = of_pm_clk_add_clks(dev);
-	if (ret >= 0)
-		return 0;
-
-	pm_clk_destroy(dev);
-	return ret;
-}
-
-static void scmi_pd_detach_dev(struct generic_pm_domain *pd, struct device *dev)
-{
-	pm_clk_destroy(dev);
-}
-
 static int scmi_pm_domain_probe(struct scmi_device *sdev)
 {
 	int num_domains, i;
@@ -124,10 +102,6 @@ static int scmi_pm_domain_probe(struct s
 		scmi_pd->genpd.name = scmi_pd->name;
 		scmi_pd->genpd.power_off = scmi_pd_power_off;
 		scmi_pd->genpd.power_on = scmi_pd_power_on;
-		scmi_pd->genpd.attach_dev = scmi_pd_attach_dev;
-		scmi_pd->genpd.detach_dev = scmi_pd_detach_dev;
-		scmi_pd->genpd.flags = GENPD_FLAG_PM_CLK |
-				       GENPD_FLAG_ACTIVE_WAKEUP;
 
 		pm_genpd_init(&scmi_pd->genpd, NULL,
 			      state == SCMI_POWER_STATE_GENERIC_OFF);


