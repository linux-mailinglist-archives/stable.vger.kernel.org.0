Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AF54A9623
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357510AbiBDJW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357622AbiBDJWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:22:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21248C061763;
        Fri,  4 Feb 2022 01:22:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF332B836ED;
        Fri,  4 Feb 2022 09:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6893C004E1;
        Fri,  4 Feb 2022 09:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966533;
        bh=D6CdPuM11W/cFHrtJL2IQl5AyPJZgCOpQpKSV5wrNE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJuFecwT+0Uy0RgSvE/L2V2pHG7itf6VYRjsMTOUKhvqX6fiR6egyHoBu0oP9nAwL
         vLWUoF80VB6BCz88ndoAVZkSPmVzgFVZG7OM+xVVXZmcasIe6PmUODJRht4IKlYk0L
         GVX7yK78/sBqqeFlsnl1/sQ0zunKXU7XpcVztr6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.10 05/25] Revert "drivers: bus: simple-pm-bus: Add support for probing simple bus only devices"
Date:   Fri,  4 Feb 2022 10:20:12 +0100
Message-Id: <20220204091914.467025114@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hilman <khilman@baylibre.com>

This reverts commit d5f13bbb51046537b2c2b9868177fb8fe8a6a6e9 which is
commit 98e96cf80045a383fcc47c58dd4e87b3ae587b3e upstream.

This change related to fw_devlink was backported to v5.10 but has
severaly other dependencies that were not backported.  As discussed
with the original author, the best approach for v5.10 is to revert.

Link: https://lore.kernel.org/linux-omap/7hk0efmfzo.fsf@baylibre.com
Acked-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/simple-pm-bus.c |   39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

--- a/drivers/bus/simple-pm-bus.c
+++ b/drivers/bus/simple-pm-bus.c
@@ -16,33 +16,7 @@
 
 static int simple_pm_bus_probe(struct platform_device *pdev)
 {
-	const struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
-	const struct of_device_id *match;
-
-	/*
-	 * Allow user to use driver_override to bind this driver to a
-	 * transparent bus device which has a different compatible string
-	 * that's not listed in simple_pm_bus_of_match. We don't want to do any
-	 * of the simple-pm-bus tasks for these devices, so return early.
-	 */
-	if (pdev->driver_override)
-		return 0;
-
-	match = of_match_device(dev->driver->of_match_table, dev);
-	/*
-	 * These are transparent bus devices (not simple-pm-bus matches) that
-	 * have their child nodes populated automatically.  So, don't need to
-	 * do anything more. We only match with the device if this driver is
-	 * the most specific match because we don't want to incorrectly bind to
-	 * a device that has a more specific driver.
-	 */
-	if (match && match->data) {
-		if (of_property_match_string(np, "compatible", match->compatible) == 0)
-			return 0;
-		else
-			return -ENODEV;
-	}
+	struct device_node *np = pdev->dev.of_node;
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
@@ -56,25 +30,14 @@ static int simple_pm_bus_probe(struct pl
 
 static int simple_pm_bus_remove(struct platform_device *pdev)
 {
-	const void *data = of_device_get_match_data(&pdev->dev);
-
-	if (pdev->driver_override || data)
-		return 0;
-
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
 	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
 
-#define ONLY_BUS	((void *) 1) /* Match if the device is only a bus. */
-
 static const struct of_device_id simple_pm_bus_of_match[] = {
 	{ .compatible = "simple-pm-bus", },
-	{ .compatible = "simple-bus",	.data = ONLY_BUS },
-	{ .compatible = "simple-mfd",	.data = ONLY_BUS },
-	{ .compatible = "isa",		.data = ONLY_BUS },
-	{ .compatible = "arm,amba-bus",	.data = ONLY_BUS },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, simple_pm_bus_of_match);


