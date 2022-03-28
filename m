Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1714E93D8
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240924AbiC1LZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240852AbiC1LWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:22:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323875715F;
        Mon, 28 Mar 2022 04:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC1E8B80ED8;
        Mon, 28 Mar 2022 11:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD15C36AE3;
        Mon, 28 Mar 2022 11:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466378;
        bh=B/ptuIBjSOUNX8jU6o6Szs1rixvugMsl9zrW73w96CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MC0iK3pZN00mEmYGWfujoR/3Fr8eZznyOLu8LVh3Ztt1xZajH8zX/MiiMaF9EbE9o
         g12TQ9DZvAXcEVUwpyWmWUS8G0FDoFXFMBOYm52rzmJze5JOnOfxaStnZrhVLPoZ5N
         HjP62mgh4VwMu32gh2zzolkDG6dzthi43hQJ8g7rcgKQ6V/ePyBLcSu7flFeAKUGAu
         AZ/AGMqRiruddIpJZWlobdGD0ceLMQFmAQgYykDS9pVr5ifgdXXVHt75zuO4Wjbm2l
         dTpSR3txUXpw528vRcdbyXk89s6BT7Bjv26bw/Fn43KcwAIw/5Mz2si2M0mgDjY9uZ
         QH1m/PSUTzsFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mario.limonciello@amd.com, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 32/43] ACPI / x86: Add skip i2c clients quirk for Nextbook Ares 8
Date:   Mon, 28 Mar 2022 07:18:16 -0400
Message-Id: <20220328111828.1554086-32-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f38312c9b569322edf4baae467568206fe46d57b ]

The Nextbook Ares 8 is a x86 ACPI tablet which ships with Android x86
as factory OS. Its DSDT contains a bunch of I2C devices which are not
actually there, causing various resource conflicts (the Android x86
kernel fork ignores I2C devices described in the DSDT).

Add a ACPI_QUIRK_SKIP_I2C_CLIENTS for the Nextbook Ares 8 to the
acpi_quirk_skip_dmi_ids table to woraround this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index ffdeed5334d6..9b991294f1e5 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -284,6 +284,15 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
+	{
+		/* Nextbook Ares 8 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M890BAP"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+	},
 	{
 		/* Whitelabel (sold as various brands) TM800A550L */
 		.matches = {
-- 
2.34.1

