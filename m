Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9218456FC4C
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiGKJmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiGKJls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:41:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B72545D9;
        Mon, 11 Jul 2022 02:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3387FCE1261;
        Mon, 11 Jul 2022 09:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A6AC34115;
        Mon, 11 Jul 2022 09:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531261;
        bh=lBs3T7xG3KVxzjM+1QQloaEKYvmThmvW7933opqJwKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QU51YLJm3m1bdgW91lMGvYT8CoFEtSZC3vLZJVmyT9he/km59diI2mOJnhdvLPMN
         vIuM90mY4jcVmvcgeI08HouZYF6Q/K+rXxqSf/fHKorREbijObAfr4CuUvSzcXGa+Q
         QXL1e4J1FU+Ce48IKtDBY4WuW60icNXkxNX25ODw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/230] platform/x86: wmi: introduce helper to convert driver to WMI driver
Date:   Mon, 11 Jul 2022 11:04:56 +0200
Message-Id: <20220711090605.220579381@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barnabás Pőcze <pobrn@protonmail.com>

[ Upstream commit e7b2e33449e22fdbaa0247d96f31543affe6163d ]

Introduce a helper function which wraps the appropriate
`container_of()` macro invocation to convert
a `struct device_driver` to `struct wmi_driver`.

Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Link: https://lore.kernel.org/r/20210904175450.156801-27-pobrn@protonmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 1b65bb61ce88..9aeb1a009097 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -676,6 +676,11 @@ static struct wmi_device *dev_to_wdev(struct device *dev)
 	return container_of(dev, struct wmi_device, dev);
 }
 
+static inline struct wmi_driver *drv_to_wdrv(struct device_driver *drv)
+{
+	return container_of(drv, struct wmi_driver, driver);
+}
+
 /*
  * sysfs interface
  */
@@ -794,8 +799,7 @@ static void wmi_dev_release(struct device *dev)
 
 static int wmi_dev_match(struct device *dev, struct device_driver *driver)
 {
-	struct wmi_driver *wmi_driver =
-		container_of(driver, struct wmi_driver, driver);
+	struct wmi_driver *wmi_driver = drv_to_wdrv(driver);
 	struct wmi_block *wblock = dev_to_wblock(dev);
 	const struct wmi_device_id *id = wmi_driver->id_table;
 
@@ -892,8 +896,7 @@ static long wmi_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 	/* let the driver do any filtering and do the call */
-	wdriver = container_of(wblock->dev.dev.driver,
-			       struct wmi_driver, driver);
+	wdriver = drv_to_wdrv(wblock->dev.dev.driver);
 	if (!try_module_get(wdriver->driver.owner)) {
 		ret = -EBUSY;
 		goto out_ioctl;
@@ -926,8 +929,7 @@ static const struct file_operations wmi_fops = {
 static int wmi_dev_probe(struct device *dev)
 {
 	struct wmi_block *wblock = dev_to_wblock(dev);
-	struct wmi_driver *wdriver =
-		container_of(dev->driver, struct wmi_driver, driver);
+	struct wmi_driver *wdriver = drv_to_wdrv(dev->driver);
 	int ret = 0;
 	char *buf;
 
@@ -990,8 +992,7 @@ static int wmi_dev_probe(struct device *dev)
 static void wmi_dev_remove(struct device *dev)
 {
 	struct wmi_block *wblock = dev_to_wblock(dev);
-	struct wmi_driver *wdriver =
-		container_of(dev->driver, struct wmi_driver, driver);
+	struct wmi_driver *wdriver = drv_to_wdrv(dev->driver);
 
 	if (wdriver->filter_callback) {
 		misc_deregister(&wblock->char_dev);
@@ -1296,15 +1297,12 @@ static void acpi_wmi_notify_handler(acpi_handle handle, u32 event,
 
 	/* If a driver is bound, then notify the driver. */
 	if (wblock->dev.dev.driver) {
-		struct wmi_driver *driver;
+		struct wmi_driver *driver = drv_to_wdrv(wblock->dev.dev.driver);
 		struct acpi_object_list input;
 		union acpi_object params[1];
 		struct acpi_buffer evdata = { ACPI_ALLOCATE_BUFFER, NULL };
 		acpi_status status;
 
-		driver = container_of(wblock->dev.dev.driver,
-				      struct wmi_driver, driver);
-
 		input.count = 1;
 		input.pointer = params;
 		params[0].type = ACPI_TYPE_INTEGER;
-- 
2.35.1



