Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33BB64FA4A
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiLQP2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiLQP2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:28:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D872915FF0;
        Sat, 17 Dec 2022 07:27:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70065B802C7;
        Sat, 17 Dec 2022 15:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D6DC433F0;
        Sat, 17 Dec 2022 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290866;
        bh=gXqKP8qLSfDtzf3svRbeUhGdvQn00qDVDCgVG3upEKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWTB/FbNw8gsyyce9DMKMnVpHM6C7FKo2M9wlMSYx7qwcYt9qNv4uu5SrV6VpPXlN
         SpWJP8y6eGhj9vWfVbItJmkobZhBn/w+FEKfv3EVr6wwq6SgD0KsaxReOXXNnZFxvr
         z85R43RnHITnHweZYnTeU8YFtbOQsUqLYPEORhfHhCJNJyCO6X6rX5Hsf/ibLSQiwH
         /v/S0DaCGtx5pWmHPP7oPaRkX8VhhYvwLreTBOqAWG8qHmk6SHlItW4IQYx5boBDQ6
         7Yty42WRLb36MNcbcPzWEpLiOIm1Qs+noKfmd/OlJytyDvdQTTfZFNmH3gFHHEs07V
         MKUuneAvaoxKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 09/22] ACPI: video: Change GIGABYTE GB-BXBT-2807 quirk to force_none
Date:   Sat, 17 Dec 2022 10:27:10 -0500
Message-Id: <20221217152727.98061-9-sashal@kernel.org>
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

[ Upstream commit 9f7dd272ff9338f1f43c7a837d5a7ee67811d552 ]

The GIGABYTE GB-BXBT-2807 DMI quirk was added by
commit 25417185e9b5 ("ACPI: video: Add DMI quirk for GIGABYTE
GB-BXBT-2807") which says the following in its commit message:

"The GIGABYTE GB-BXBT-2807 is a mini-PC which uses off the shelf
components, like an Intel GPU which is meant for mobile systems.
As such, it, by default, has a backlight controller exposed.

Unfortunately, the backlight controller only confuses userspace, which
sees the existence of a backlight device node and has the unrealistic
belief that there is actually a backlight there!

Add a DMI quirk to force the backlight off on this system."

So in essence this quirk was using a video_detect_force_vendor quirk
to disable backlight control. Now a days we have a specific "none"
backlight type for this. Change the quirk to video_detect_force_none
and group it together with the other force_none quirks.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index b2a616287638..375d1ef8fbea 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -197,14 +197,6 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "1015CX"),
 		},
 	},
-	{
-	 .callback = video_detect_force_vendor,
-	 /* GIGABYTE GB-BXBT-2807 */
-	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "GB-BXBT-2807"),
-		},
-	},
 	{
 	 .callback = video_detect_force_vendor,
 	 /* Samsung N150/N210/N220 */
@@ -671,6 +663,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 9020M"),
 		},
 	},
+	{
+	 .callback = video_detect_force_none,
+	 /* GIGABYTE GB-BXBT-2807 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "GB-BXBT-2807"),
+		},
+	},
 	{
 	 .callback = video_detect_force_none,
 	 /* MSI MS-7721 */
-- 
2.35.1

