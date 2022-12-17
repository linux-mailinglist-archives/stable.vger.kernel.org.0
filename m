Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A084564FA22
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiLQP3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiLQP2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:28:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E5E1649C;
        Sat, 17 Dec 2022 07:27:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB796B803F3;
        Sat, 17 Dec 2022 15:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8866C433F2;
        Sat, 17 Dec 2022 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290867;
        bh=F0urdnkucMtpBcL6F6n89t7nSeKSfvkxHBTux19h244=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYF/lGaNcOuZXsxActe+gdsF/oXqzH4PPsn0dqZTi06QihRumjUBr4ljxrEKkZ9no
         eBP+S5LRjRuzaovyc80039yq4B4d6nBJNHib1M2gTYHxKNGzkNhsy2u602HsE7rUyj
         CPdH6nivjyKpWcoXftYDKrXoAJ2yXDws4OveAD47wmd+mLt9b3XwAvynQYiXclX3il
         7ttu8UEpT7emuWbBcvDonJPLERh0OEEOhOvxgi7Or5y0tdCqTjKtr4lxH0jDKiaOe5
         +7ZbBx+i0NFp3dFWnBpkWs7MLxHqlOJhoGOuuDyJr6KL4pnls9BUYOfxNpzndD9T+v
         0hxMvSDWm+1ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 10/22] ACPI: video: Change Sony Vaio VPCEH3U1E quirk to force_native
Date:   Sat, 17 Dec 2022 10:27:11 -0500
Message-Id: <20221217152727.98061-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152727.98061-1-sashal@kernel.org>
References: <20221217152727.98061-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 84d56f326a8ef0071df8c0c3b983b9e2c3b73006 ]

According to: https://bugzilla.kernel.org/show_bug.cgi?id=202401
the Sony Vaio VPCEH3U1E quirk was added to disable the acpi_video0
backlight interface because that was not working, so that userspace
will pick the actually working native nv_backlight interface instead.

With the new kernel behavior of hiding native interfaces unless
acpi_video_get_backlight_type() returns native, the current
video_detect_force_vendor quirk will cause the working nv_backlight
interface will be disabled too.

Change the quirk to video_detect_force_native to get the desired
result of only registering the nv_backlight interface.

After this all currently remaining force_vendor quirks in
video_detect_dmi_table[] are there to prefer a vendor interface over
a non working ACPI video interface, add a comment to document this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 375d1ef8fbea..0ab98f2e484c 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,10 @@ static int video_detect_force_none(const struct dmi_system_id *d)
 }
 
 static const struct dmi_system_id video_detect_dmi_table[] = {
+	/*
+	 * Models which should use the vendor backlight interface,
+	 * because of broken ACPI video backlight control.
+	 */
 	{
 	 /* https://bugzilla.redhat.com/show_bug.cgi?id=1128309 */
 	 .callback = video_detect_force_vendor,
@@ -224,14 +228,6 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "NC210/NC110"),
 		},
 	},
-	{
-	 .callback = video_detect_force_vendor,
-	 /* Sony VPCEH3U1E */
-	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEH3U1E"),
-		},
-	},
 	{
 	 .callback = video_detect_force_vendor,
 	 /* Xiaomi Mi Pad 2 */
@@ -601,6 +597,15 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "N250P"),
 		},
 	},
+	{
+	 /* https://bugzilla.kernel.org/show_bug.cgi?id=202401 */
+	 .callback = video_detect_force_native,
+	 /* Sony Vaio VPCEH3U1E */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEH3U1E"),
+		},
+	},
 
 	/*
 	 * These Toshibas have a broken acpi-video interface for brightness
-- 
2.35.1

