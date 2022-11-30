Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A117563E017
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiK3Sxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiK3SxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:53:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A111CB22
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:53:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F089B81CAF
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D38C433D6;
        Wed, 30 Nov 2022 18:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834399;
        bh=VwXXeRt6xQyQwBK4ROVGyz1SFb5IlEYz5klkPODi2E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0TcPSO0IaqUA8/AlH89hSGkecMTvDOKwfVK5uHrAxG1taQ+9o7dDXWi+lecLEP0z
         ab2hCLEqz9zQCIFdQvYahPYczze4qDd/MBrP1JNpazrRDK6zQ0WTD85g1o5WgNqsEf
         ooxenOaUUFug1ZMiGtrQjERKX2tLijPkdfN4iU3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 240/289] Input: i8042 - apply probe defer to more ASUS ZenBook models
Date:   Wed, 30 Nov 2022 19:23:45 +0100
Message-Id: <20221130180549.551977903@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 26c263bf1847d4dadba016a0457c4c5f446407bf ]

There are yet a few more ASUS ZenBook models that require the deferred
probe.  At least, there are different ZenBook UX325x and UX425x
models.  Let's extend the DMI matching table entries for adapting
those missing models.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20221108142027.28480-1-tiwai@suse.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 4fbec7bbecca..5043dc7b8fb3 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -114,18 +114,18 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* ASUS ZenBook UX425UA */
+		/* ASUS ZenBook UX425UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425UA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* ASUS ZenBook UM325UA */
+		/* ASUS ZenBook UM325UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
-- 
2.35.1



