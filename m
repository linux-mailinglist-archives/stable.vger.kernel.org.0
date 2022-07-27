Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1EA582FDF
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242286AbiG0Rak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242585AbiG0RaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:30:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38485246C;
        Wed, 27 Jul 2022 09:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A23C600BE;
        Wed, 27 Jul 2022 16:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9943BC433C1;
        Wed, 27 Jul 2022 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940466;
        bh=LDTAR5XNGEs6IbAPArum+Jk2Iiza2SC3BANq8xb76xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xOISjigE5jYPoVqbVcfrKCqkAX90p8HZbZ7BURSqVTFhkzCPSkkPIHJ2w7ff6GfZ
         42bCXcO9jeuwaJn3JlRnDOe22e7z50I8qRofunRbhEFuhJarXzu6+eVuKgW0aog1zI
         SssQrerLwXWUlms3+D0yPYHHvyRj0Dfi53/3tuso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.18 006/158] mmc: sdhci-omap: Fix a lockdep warning for PM runtime init
Date:   Wed, 27 Jul 2022 18:11:10 +0200
Message-Id: <20220727161021.703512831@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 51189eb9ddc88851edc42f539a0f9862fd0630c2 upstream.

We need runtime PM enabled early in probe before sdhci_setup_host() for
sdhci_omap_set_capabilities(). But on the first runtime resume we must
not call sdhci_runtime_resume_host() as sdhci_setup_host() has not been
called yet. Let's check for an initialized controller like we already do
for context restore to fix a lockdep warning.

Fixes: f433e8aac6b9 ("mmc: sdhci-omap: Implement PM runtime functions")
Reported-by: Yegor Yefremov <yegorslists@googlemail.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220622051215.34063-1-tony@atomide.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-omap.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1303,8 +1303,9 @@ static int sdhci_omap_probe(struct platf
 	/*
 	 * omap_device_pm_domain has callbacks to enable the main
 	 * functional clock, interface clock and also configure the
-	 * SYSCONFIG register of omap devices. The callback will be invoked
-	 * as part of pm_runtime_get_sync.
+	 * SYSCONFIG register to clear any boot loader set voltage
+	 * capabilities before calling sdhci_setup_host(). The
+	 * callback will be invoked as part of pm_runtime_get_sync.
 	 */
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, 50);
@@ -1446,7 +1447,8 @@ static int __maybe_unused sdhci_omap_run
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_omap_host *omap_host = sdhci_pltfm_priv(pltfm_host);
 
-	sdhci_runtime_suspend_host(host);
+	if (omap_host->con != -EINVAL)
+		sdhci_runtime_suspend_host(host);
 
 	sdhci_omap_context_save(omap_host);
 
@@ -1463,10 +1465,10 @@ static int __maybe_unused sdhci_omap_run
 
 	pinctrl_pm_select_default_state(dev);
 
-	if (omap_host->con != -EINVAL)
+	if (omap_host->con != -EINVAL) {
 		sdhci_omap_context_restore(omap_host);
-
-	sdhci_runtime_resume_host(host, 0);
+		sdhci_runtime_resume_host(host, 0);
+	}
 
 	return 0;
 }


