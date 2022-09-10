Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA4D5B4967
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiIJVTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiIJVS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:18:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A480D4DF1F;
        Sat, 10 Sep 2022 14:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D7E2B80943;
        Sat, 10 Sep 2022 21:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E75C433B5;
        Sat, 10 Sep 2022 21:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844657;
        bh=g1K/tsCZeF3hfaAJ8DuIWNbrtY7uwq/dhFvhIaqT3/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLxgpPyOabUMCkTKT/iXfD+hIq8+nlXvu1t8eowwOCWUrEnRNlmcMs4wh8MaP2skh
         17GJT4wkd94m6LhjcaSWHzJTMvcAKk4sTv4zMSxQIegRfcVxND6qrgiVGFnk6v1DMU
         SSiVo6znfKm535ct4D5uw+RPnWCtwBfV5JxVfTrlx8j8D1USOU1LbNo6JQdybh+obM
         7sZJlpAJ9nxCAjv4jkvGYSUxRIZzJIYobPKCX3yTlg20HWmCmI1ADaBmHjQ+KOgSGr
         qMFH9P22xMXVSMgQHkR1VGK9ArrYyRjRZdtUBBZ6ie6AIWI6aIWlsijmotf4EN4I9m
         8nF4RpWfijkAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Luke D. Jones" <luke@ljones.dev>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 34/38] platform/x86: asus-wmi: Increase FAN_CURVE_BUF_LEN to 32
Date:   Sat, 10 Sep 2022 17:16:19 -0400
Message-Id: <20220910211623.69825-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
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

From: "Luke D. Jones" <luke@ljones.dev>

[ Upstream commit 5542dfc582f4a925f67bbfaf8f62ca83506032ae ]

Fix for TUF laptops returning with an -ENOSPC on calling
asus_wmi_evaluate_method_buf() when fetching default curves. The TUF method
requires at least 32 bytes space.

This also moves and changes the pr_debug() in fan_curve_check_present() to
pr_warn() in fan_curve_get_factory_default() so that there is at least some
indication in logs of why it fails.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20220828074638.5473-1-luke@ljones.dev
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 62ce198a34631..a0f31624aee97 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -107,7 +107,7 @@ module_param(fnlock_default, bool, 0444);
 #define WMI_EVENT_MASK			0xFFFF
 
 #define FAN_CURVE_POINTS		8
-#define FAN_CURVE_BUF_LEN		(FAN_CURVE_POINTS * 2)
+#define FAN_CURVE_BUF_LEN		32
 #define FAN_CURVE_DEV_CPU		0x00
 #define FAN_CURVE_DEV_GPU		0x01
 /* Mask to determine if setting temperature or percentage */
@@ -2208,8 +2208,10 @@ static int fan_curve_get_factory_default(struct asus_wmi *asus, u32 fan_dev)
 	curves = &asus->custom_fan_curves[fan_idx];
 	err = asus_wmi_evaluate_method_buf(asus->dsts_id, fan_dev, mode, buf,
 					   FAN_CURVE_BUF_LEN);
-	if (err)
+	if (err) {
+		pr_warn("%s (0x%08x) failed: %d\n", __func__, fan_dev, err);
 		return err;
+	}
 
 	fan_curve_copy_from_buf(curves, buf);
 	curves->device_id = fan_dev;
@@ -2227,9 +2229,6 @@ static int fan_curve_check_present(struct asus_wmi *asus, bool *available,
 
 	err = fan_curve_get_factory_default(asus, fan_dev);
 	if (err) {
-		pr_debug("fan_curve_get_factory_default(0x%08x) failed: %d\n",
-			 fan_dev, err);
-		/* Don't cause probe to fail on devices without fan-curves */
 		return 0;
 	}
 
-- 
2.35.1

