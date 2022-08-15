Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12EF593E81
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345619AbiHOUoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347731AbiHOUnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:43:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5B7B2879;
        Mon, 15 Aug 2022 12:07:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D37FBCE1082;
        Mon, 15 Aug 2022 19:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52D6C433C1;
        Mon, 15 Aug 2022 19:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590472;
        bh=fCYDI+F88UGUTrDjbcNz8uPK++EHHjAD50nTwpOJZGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPGVADW0QB9+owDFtgF8Kz8m3GEjF8dETJn0v5b9vIr6+EkqjjmhRmo5RxvookjtF
         BqV2d/uwPwBz+u3BIcBmkZGJso0obKDBERXfQZ86tC5Se6Za/tK+tJZp31H3pfrWQb
         EhwhpjoVH4RifZvErbsH/hCHMnGHgVDUA4dGFtd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0271/1095] hwmon: (sch56xx-common) Add DMI override table
Date:   Mon, 15 Aug 2022 19:54:30 +0200
Message-Id: <20220815180440.967279788@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit fd2d53c367ae9983c2100ac733a834e0c79d7537 ]

Some devices like the Fujitsu Celsius W380 do contain
a working sch56xx hardware monitoring device, but do
not contain the necessary DMI onboard device.

Do not check for the presence of an suitable onboard device
on these machines. The list of affected machines was created
using data collected by the Linux Hardware Project.

Tested on a Fujitsu Esprimo P720, but sadly not on a affected
machine.

Fixes: 393935baa45e (hwmon: (sch56xx-common) Add automatic module loading on supported devices)
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220604220200.2567-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sch56xx-common.c | 44 ++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/sch56xx-common.c b/drivers/hwmon/sch56xx-common.c
index 3ece53adabd6..de3a0886c2f7 100644
--- a/drivers/hwmon/sch56xx-common.c
+++ b/drivers/hwmon/sch56xx-common.c
@@ -523,6 +523,28 @@ static int __init sch56xx_device_add(int address, const char *name)
 	return PTR_ERR_OR_ZERO(sch56xx_pdev);
 }
 
+static const struct dmi_system_id sch56xx_dmi_override_table[] __initconst = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CELSIUS W380"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO P710"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO E9900"),
+		},
+	},
+	{ }
+};
+
 /* For autoloading only */
 static const struct dmi_system_id sch56xx_dmi_table[] __initconst = {
 	{
@@ -543,16 +565,18 @@ static int __init sch56xx_init(void)
 		if (!dmi_check_system(sch56xx_dmi_table))
 			return -ENODEV;
 
-		/*
-		 * Some machines like the Esprimo P720 and Esprimo C700 have
-		 * onboard devices named " Antiope"/" Theseus" instead of
-		 * "Antiope"/"Theseus", so we need to check for both.
-		 */
-		if (!dmi_find_device(DMI_DEV_TYPE_OTHER, "Antiope", NULL) &&
-		    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Antiope", NULL) &&
-		    !dmi_find_device(DMI_DEV_TYPE_OTHER, "Theseus", NULL) &&
-		    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Theseus", NULL))
-			return -ENODEV;
+		if (!dmi_check_system(sch56xx_dmi_override_table)) {
+			/*
+			 * Some machines like the Esprimo P720 and Esprimo C700 have
+			 * onboard devices named " Antiope"/" Theseus" instead of
+			 * "Antiope"/"Theseus", so we need to check for both.
+			 */
+			if (!dmi_find_device(DMI_DEV_TYPE_OTHER, "Antiope", NULL) &&
+			    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Antiope", NULL) &&
+			    !dmi_find_device(DMI_DEV_TYPE_OTHER, "Theseus", NULL) &&
+			    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Theseus", NULL))
+				return -ENODEV;
+		}
 	}
 
 	/*
-- 
2.35.1



