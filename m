Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F775A47D7
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiH2LCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiH2LBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:01:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7E73DF1D;
        Mon, 29 Aug 2022 04:01:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70484B80EF1;
        Mon, 29 Aug 2022 11:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB23BC433D6;
        Mon, 29 Aug 2022 11:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770901;
        bh=7foF926lnwBI6NihxGIkytHW0nt49QkNV+JJmQKSCuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/39oh0L5CuId8L3Z8OO81qC8NT4ZUJe3DuAZ/NiismfWpsGRI5zobOVodou4lFMc
         gMJOQucuqAm1UTq2tCk8ukCzGbgRvC+9n53Vy4PxLSA98hBLGB9l+miRIg0iNtZVBk
         Yud3E4WiPokF+ckiRVmYCc8M9j2QLNVNdvDxWDQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/136] Input: i8042 - add additional TUXEDO devices to i8042 quirk tables
Date:   Mon, 29 Aug 2022 12:58:04 +0200
Message-Id: <20220829105805.328579631@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

[ Upstream commit 436d219069628f0f0ed27f606224d4ee02a0ca17 ]

A lot of modern Clevo barebones have touchpad and/or keyboard issues after
suspend fixable with nomux + reset + noloop + nopnp. Luckily, none of them
have an external PS/2 port so this can safely be set for all of them.

I'm not entirely sure if every device listed really needs all four quirks,
but after testing and production use. No negative effects could be
observed when setting all four.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220708161005.1251929-2-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 76 ++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 8 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 184d7c30f732f..4b0201cf71f5e 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -900,14 +900,6 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
-	{
-		/* Clevo P650RS, 650RP6, Sager NP8152-S, and others */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P65xRP"),
-		},
-		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
-	},
 	{
 		/* OQO Model 01 */
 		.matches = {
@@ -1162,6 +1154,74 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65xH"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		/* Clevo P650RS, 650RP6, Sager NP8152-S, and others */
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65xRP"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65_P67H"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65_67RP"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "P65_67RS"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		/*
+		 * This is only a partial board_name and might be followed by
+		 * another letter or number. DMI_MATCH however does do partial
+		 * matching.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "P67xRP"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "PB50_70DFx,DDx"),
-- 
2.35.1



