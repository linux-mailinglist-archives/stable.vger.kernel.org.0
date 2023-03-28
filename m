Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED6E6CC2EF
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbjC1OuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbjC1Oto (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:49:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4888E05E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B73A4CE1D3B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6E9C433D2;
        Tue, 28 Mar 2023 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014947;
        bh=fEZOnQtP0VdFol/D97Icme1BuX4OM5d6XCMc3GCW6qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guRbdizGzXjrErlF1NPzWjqpCsyExIrVCxTqQzQ+ZuCRFeYMW5TwG5g3A83wHb6Pk
         prZxQCdcfNjfjB0+EUdkVfUF02ubfm2te7fK2KFly/V2F5V//a67YWvzLP6/p9sFZC
         vkXkhOdtaCQOHUdeU9BRZo1REOuNalHBCkEmY2O4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Phinex Hung <phinex@realtek.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 111/240] hwmon: fix potential sensor registration fail if of_node is missing
Date:   Tue, 28 Mar 2023 16:41:14 +0200
Message-Id: <20230328142624.405320947@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phinex Hung <phinex@realtek.com>

[ Upstream commit 2315332efcbe7124252f080e03b57d3d2f1f4771 ]

It is not sufficient to check of_node in current device.
In some cases, this would cause the sensor registration to fail.

This patch looks for device's ancestors to find a valid of_node if any.

Fixes: d560168b5d0f ("hwmon: (core) New hwmon registration API")
Signed-off-by: Phinex Hung <phinex@realtek.com>
Link: https://lore.kernel.org/r/20230321060224.3819-1-phinex@realtek.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hwmon.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 33edb5c02f7d7..d193ed3cb35e5 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -757,6 +757,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	struct hwmon_device *hwdev;
 	const char *label;
 	struct device *hdev;
+	struct device *tdev = dev;
 	int i, err, id;
 
 	/* Complain about invalid characters in hwmon name attribute */
@@ -826,7 +827,9 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	hwdev->name = name;
 	hdev->class = &hwmon_class;
 	hdev->parent = dev;
-	hdev->of_node = dev ? dev->of_node : NULL;
+	while (tdev && !tdev->of_node)
+		tdev = tdev->parent;
+	hdev->of_node = tdev ? tdev->of_node : NULL;
 	hwdev->chip = chip;
 	dev_set_drvdata(hdev, drvdata);
 	dev_set_name(hdev, HWMON_ID_FORMAT, id);
@@ -838,7 +841,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 
 	INIT_LIST_HEAD(&hwdev->tzdata);
 
-	if (dev && dev->of_node && chip && chip->ops->read &&
+	if (hdev->of_node && chip && chip->ops->read &&
 	    chip->info[0]->type == hwmon_chip &&
 	    (chip->info[0]->config[0] & HWMON_C_REGISTER_TZ)) {
 		err = hwmon_thermal_register_sensors(hdev);
-- 
2.39.2



