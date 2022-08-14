Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C74591F89
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 12:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiHNKXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 06:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiHNKXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 06:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0D222BF5
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 03:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26D97B80B28
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 10:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C98C433C1;
        Sun, 14 Aug 2022 10:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660472589;
        bh=/rtrjQB59As4EyBIRsxdYoYWFDaRUoUD+e4FzgmUktA=;
        h=Subject:To:Cc:From:Date:From;
        b=MVwFjqVDoOhzToR+zkUcJ6Dr0c3LApjtT0xCJ7MsBii5UJG+ikn9NFQD7xOEGfic1
         JD6JZ9/P/FqT9R+SGxSIsHs+zUJByefqBrC+MmZeYShhPB+71Zxr4R9kjsxcQ8Akaj
         SdwtN/LffM6YatsmLXwEOXh3C58xyA3N/mVl+7FE=
Subject: FAILED: patch "[PATCH] Input: i8042 - add additional TUXEDO devices to i8042 quirk" failed to apply to 5.18-stable tree
To:     wse@tuxedocomputers.com, dmitry.torokhov@gmail.com,
        hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Aug 2022 12:22:59 +0200
Message-ID: <1660472579132187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 436d219069628f0f0ed27f606224d4ee02a0ca17 Mon Sep 17 00:00:00 2001
From: Werner Sembach <wse@tuxedocomputers.com>
Date: Fri, 8 Jul 2022 13:17:38 -0700
Subject: [PATCH] Input: i8042 - add additional TUXEDO devices to i8042 quirk
 tables

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

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 50b090e77fca..5204a7dd61d4 100644
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

