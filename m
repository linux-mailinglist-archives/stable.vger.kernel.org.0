Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098C36A3049
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBZOsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjBZOsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:48:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF2214223;
        Sun, 26 Feb 2023 06:47:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B559B80BE6;
        Sun, 26 Feb 2023 14:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A228C433EF;
        Sun, 26 Feb 2023 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422769;
        bh=hpjxSFxme2o+ctkr+hhbvGDNOGAhSVzKWb3C5apFcf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdc4wgdKLkyg2Nm1lLjPODtieTG1Dgs+0BVAY7BuQ10xMRoj6lT2VDgMDz0sNoCGr
         0yOeQLLppV8/X16MwgOcxRmBZ+q7OM6Fx+TITuDwCpFjPgo7AIX2rBq7J0Dc+mZm2o
         L9AOKRbDP61JSG0N1JEE6O4IqsHTmrI8z5aGOQgbooggbKMMbOAPAVONool7UVxL57
         y/iA9atl06RuspnvZujRex7/LCquC8HhjGuvBnZPwNoyH5wbnmiyEs0If93IFrYH/2
         tn4e+9r+OeePrTpMK69inIeqhM1SMg3RJaat4Feiens23etBEWH2mAdQlC41KWHeel
         TOO3ds627VTZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Armin Wolf <W_Armin@gmx.de>, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 35/53] platform/x86: dell-ddv: Add support for interface version 3
Date:   Sun, 26 Feb 2023 09:44:27 -0500
Message-Id: <20230226144446.824580-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 3e899fec5dfce37701d49d656954a825275bf867 ]

While trying to solve a bugreport on bugzilla, i learned that
some devices (for example the Dell XPS 17 9710) provide a more
recent DDV WMI interface (version 3).
Since the new interface version just adds an additional method,
no code changes are necessary apart from whitelisting the version.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230126194021.381092-2-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-ddv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-ddv.c b/drivers/platform/x86/dell/dell-wmi-ddv.c
index 2bb449845d143..9cb6ae42dbdc8 100644
--- a/drivers/platform/x86/dell/dell-wmi-ddv.c
+++ b/drivers/platform/x86/dell/dell-wmi-ddv.c
@@ -26,7 +26,8 @@
 
 #define DRIVER_NAME	"dell-wmi-ddv"
 
-#define DELL_DDV_SUPPORTED_INTERFACE 2
+#define DELL_DDV_SUPPORTED_VERSION_MIN	2
+#define DELL_DDV_SUPPORTED_VERSION_MAX	3
 #define DELL_DDV_GUID	"8A42EA14-4F2A-FD45-6422-0087F7A7E608"
 
 #define DELL_EPPID_LENGTH	20
@@ -49,6 +50,7 @@ enum dell_ddv_method {
 	DELL_DDV_BATTERY_RAW_ANALYTICS_START	= 0x0E,
 	DELL_DDV_BATTERY_RAW_ANALYTICS		= 0x0F,
 	DELL_DDV_BATTERY_DESIGN_VOLTAGE		= 0x10,
+	DELL_DDV_BATTERY_RAW_ANALYTICS_A_BLOCK	= 0x11, /* version 3 */
 
 	DELL_DDV_INTERFACE_VERSION		= 0x12,
 
@@ -340,7 +342,7 @@ static int dell_wmi_ddv_probe(struct wmi_device *wdev, const void *context)
 		return ret;
 
 	dev_dbg(&wdev->dev, "WMI interface version: %d\n", version);
-	if (version != DELL_DDV_SUPPORTED_INTERFACE)
+	if (version < DELL_DDV_SUPPORTED_VERSION_MIN || version > DELL_DDV_SUPPORTED_VERSION_MAX)
 		return -ENODEV;
 
 	data = devm_kzalloc(&wdev->dev, sizeof(*data), GFP_KERNEL);
-- 
2.39.0

