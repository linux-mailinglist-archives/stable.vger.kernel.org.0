Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6A856FC53
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiGKJmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbiGKJmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4E89B191;
        Mon, 11 Jul 2022 02:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6315F612F3;
        Mon, 11 Jul 2022 09:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715C4C34115;
        Mon, 11 Jul 2022 09:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531269;
        bh=DuRnfld3GVLwDCJgA7tVCkA/1g0bZZs/tHdu9/d1NME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUmfpv/SncEhxw5dItkV4PH6dj1IN3xmQVcaq3NIgpcbxzOV2ICjRH1NohCOfObMy
         0BUxH0oPPwYJtzuXlq2vbMrjXpOHEg4sa0uUlYMIAGBPSy3R6QuL1g0LYkX0P5x4i7
         U8dhmEFaNJhLzdm1lOjGXp5zT+LrMwU+4Ej9WruI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/230] platform/x86: wmi: Fix driver->notify() vs ->probe() race
Date:   Mon, 11 Jul 2022 11:04:58 +0200
Message-Id: <20220711090605.277376059@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9918878676a5f9e99b98679f04b9e6c0f5426b0a ]

The driver core sets struct device->driver before calling out
to the bus' probe() method, this leaves a window where an ACPI
notify may happen on the WMI object before the driver's
probe() method has completed running, causing e.g. the
driver's notify() callback to get called with drvdata
not yet being set leading to a NULL pointer deref.

At a check for this to the WMI core, ensuring that the notify()
callback is not called before the driver is ready.

Fixes: 1686f5444546 ("platform/x86: wmi: Incorporate acpi_install_notify_handler")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211128190031.405620-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index a00b72ace6d2..c4f917d45b51 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -53,6 +53,7 @@ struct guid_block {
 
 enum {	/* wmi_block flags */
 	WMI_READ_TAKES_NO_ARGS,
+	WMI_PROBED,
 };
 
 struct wmi_block {
@@ -980,6 +981,7 @@ static int wmi_dev_probe(struct device *dev)
 		}
 	}
 
+	set_bit(WMI_PROBED, &wblock->flags);
 	return 0;
 
 probe_misc_failure:
@@ -997,6 +999,8 @@ static void wmi_dev_remove(struct device *dev)
 	struct wmi_block *wblock = dev_to_wblock(dev);
 	struct wmi_driver *wdriver = drv_to_wdrv(dev->driver);
 
+	clear_bit(WMI_PROBED, &wblock->flags);
+
 	if (wdriver->filter_callback) {
 		misc_deregister(&wblock->char_dev);
 		kfree(wblock->char_dev.name);
@@ -1299,7 +1303,7 @@ static void acpi_wmi_notify_handler(acpi_handle handle, u32 event,
 		return;
 
 	/* If a driver is bound, then notify the driver. */
-	if (wblock->dev.dev.driver) {
+	if (test_bit(WMI_PROBED, &wblock->flags) && wblock->dev.dev.driver) {
 		struct wmi_driver *driver = drv_to_wdrv(wblock->dev.dev.driver);
 		struct acpi_object_list input;
 		union acpi_object params[1];
-- 
2.35.1



