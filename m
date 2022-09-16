Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49885BAB38
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiIPKZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiIPKYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:24:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C062E3C164;
        Fri, 16 Sep 2022 03:14:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30EF362A44;
        Fri, 16 Sep 2022 10:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0ABC433D6;
        Fri, 16 Sep 2022 10:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323273;
        bh=BxwhUOQNa5kjI5gTqMSp0DQJWmMn1lWyYQ3JaAPDAh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Syg32tqKr9le87nHFaEILzgSZgPIOioLbsa9PQ7FVquLj1e1lHzjMDlNX86Ds482A
         gRT3nmqHSCQQzr2ecLxPLHiGgBGf/dlaAkVcEzpDKx3X7+yR0rzs2+5b/BrxeCxVWt
         sXu/S6Glb2B76SSAw6dodRUIvLbU2cPt/YZpGNaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Luke D. Jones" <luke@ljones.dev>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 32/38] platform/x86: asus-wmi: Increase FAN_CURVE_BUF_LEN to 32
Date:   Fri, 16 Sep 2022 12:09:06 +0200
Message-Id: <20220916100449.812443685@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
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

From: Luke D. Jones <luke@ljones.dev>

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



