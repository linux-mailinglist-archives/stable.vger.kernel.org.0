Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47AC6A3696
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjB0CDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjB0CCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:02:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94D915886;
        Sun, 26 Feb 2023 18:02:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AEA2B80CB3;
        Mon, 27 Feb 2023 02:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DD2C4339C;
        Mon, 27 Feb 2023 02:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463338;
        bh=BE67LLaDq7x7n4LFROr+a358vdVhi1mjHIhSiKHTew8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFjqbEqzgD9xttjw7wa7xqCatulZoJRjQl8Xgc54KMv/LhpFPElQ/TprNI3UJOaFw
         kNBL9X+lQ4mL7RM2U4jDENzjq/TDLLkb6ZSiBy/1ilCuMwRHgJgBHzA5Qjc6jUx1UA
         jNoS56vOdj2FWrYFR/Zc5fNPEXlaVZk1UrjUK5RFBBjiDkwYnqy8RbS3kGXibzXL7v
         JMjZDqsmDisE7UpgPae0/iIisGDnTIRMbhUivzzJGTzqctl343zcQStwN2n8bsQe3K
         obDxoF/+f45v/XtsV4kA/HaKz0QtrIsKX01pBTVmA3+FOSv+5EWRowXLxz6l//Va/g
         3283nG47snlLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Mia Kanashi <chad@redpilled.dev>,
        Andreas Grosse <andig.mail@t-online.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 20/60] HID: uclogic: Add battery quirk
Date:   Sun, 26 Feb 2023 21:00:05 -0500
Message-Id: <20230227020045.1045105-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit f60c377f52de37f8705c5fc6d57737fdaf309ff9 ]

Some UGEE v2 tablets have a wireless version with an internal battery
and their firmware is able to report their battery level.

However, there was not found a field on their descriptor indicating
whether the tablet has battery or not, making it mandatory to classify
such devices through the UCLOGIC_BATTERY_QUIRK quirk.

Tested-by: Mia Kanashi <chad@redpilled.dev>
Tested-by: Andreas Grosse <andig.mail@t-online.de>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-params.c | 5 +++++
 drivers/hid/hid-uclogic-params.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index e052538a62fb3..23624d5b07b5a 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1222,6 +1222,11 @@ static int uclogic_params_ugee_v2_init_frame_mouse(struct uclogic_params *p)
  */
 static bool uclogic_params_ugee_v2_has_battery(struct hid_device *hdev)
 {
+	struct uclogic_drvdata *drvdata = hid_get_drvdata(hdev);
+
+	if (drvdata->quirks & UCLOGIC_BATTERY_QUIRK)
+		return true;
+
 	/* The XP-PEN Deco LW vendor, product and version are identical to the
 	 * Deco L. The only difference reported by their firmware is the product
 	 * name. Add a quirk to support battery reporting on the wireless
diff --git a/drivers/hid/hid-uclogic-params.h b/drivers/hid/hid-uclogic-params.h
index 10a05c7fd9398..b0e7f3807939b 100644
--- a/drivers/hid/hid-uclogic-params.h
+++ b/drivers/hid/hid-uclogic-params.h
@@ -20,6 +20,7 @@
 #include <linux/hid.h>
 
 #define UCLOGIC_MOUSE_FRAME_QUIRK	BIT(0)
+#define UCLOGIC_BATTERY_QUIRK		BIT(1)
 
 /* Types of pen in-range reporting */
 enum uclogic_params_pen_inrange {
-- 
2.39.0

