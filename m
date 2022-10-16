Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873845FFDC9
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiJPHRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiJPHRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:17:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF397764F
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EA7C6098A
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA0BC433C1;
        Sun, 16 Oct 2022 07:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665904663;
        bh=zeIUIZXW2QGjjac0eKV9zZiB7fLF5WsvODrQQsEtgbk=;
        h=Subject:To:Cc:From:Date:From;
        b=nAsgGxDOcllmoG//5m16WYfd3cljh/jVOT8p2dRBj5V/hA7UKxeHMGs84pWik8pWR
         n3c0GyMvy/ce6VTrt0Up6abyF7BWRKH3WmPSrnqz5v/vvJElsl4GFS4waXEXCDoE2U
         wRA8EhwRmdMQXA1UcldFHiWU0Y5B/ECRbFVrX9ig=
Subject: FAILED: patch "[PATCH] mmc: sdhci-tegra: Use actual clock rate for SW tuning" failed to apply to 5.10-stable tree
To:     pshete@nvidia.com, adrian.hunter@intel.com, anrao@nvidia.com,
        treding@nvidia.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:18:22 +0200
Message-ID: <1665904702190242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

b78870e7f415 ("mmc: sdhci-tegra: Use actual clock rate for SW tuning correction")
d618978dd4d3 ("mmc: sdhci-tegra: Add runtime PM and OPP support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b78870e7f41534cc719c295d1f8809aca93aeeab Mon Sep 17 00:00:00 2001
From: Prathamesh Shete <pshete@nvidia.com>
Date: Thu, 6 Oct 2022 18:36:22 +0530
Subject: [PATCH] mmc: sdhci-tegra: Use actual clock rate for SW tuning
 correction

Ensure tegra_host member "curr_clk_rate" holds the actual clock rate
instead of requested clock rate for proper use during tuning correction
algorithm. Actual clk rate may not be the same as the requested clk
frequency depending on the parent clock source set. Tuning correction
algorithm depends on certain parameters which are sensitive to current
clk rate. If the host clk is selected instead of the actual clock rate,
tuning correction algorithm may end up applying invalid correction,
which could result in errors

Fixes: ea8fc5953e8b ("mmc: tegra: update hw tuning process")
Signed-off-by: Aniruddha TVS Rao <anrao@nvidia.com>
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221006130622.22900-4-pshete@nvidia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 2d2d8260c681..413925bce0ca 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -773,7 +773,7 @@ static void tegra_sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 		dev_err(dev, "failed to set clk rate to %luHz: %d\n",
 			host_clk, err);
 
-	tegra_host->curr_clk_rate = host_clk;
+	tegra_host->curr_clk_rate = clk_get_rate(pltfm_host->clk);
 	if (tegra_host->ddr_signaling)
 		host->max_clk = host_clk;
 	else

