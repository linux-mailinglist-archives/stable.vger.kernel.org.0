Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC3608AEE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJVJQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiJVJPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:15:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C554157543;
        Sat, 22 Oct 2022 01:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 982D960AE4;
        Sat, 22 Oct 2022 08:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA6BC433C1;
        Sat, 22 Oct 2022 08:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425961;
        bh=UOnueW/PyZnrz3FegMDaggbsCd7whTzND7A2kW84/4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZGI5Wp1lSoppcYAftGjLGgF2Akp5aknZu52IfLtd2sRB89aMf5ls5DQeNROsEI7A
         cXqOyUGYx+CHJfw7iePi75E6p0t+QLZyQS6tVa0Cd4q+Jpi2sp548hetggJdrAPSyM
         OPbQKrSHW1Ny2+cVAlQsQck+b0yn5fvyPKqJoMmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johnothan King <johnothanking@protonmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Arne Wendt <arne.wendt@tuhh.de>
Subject: [PATCH 5.19 672/717] HID: nintendo: check analog user calibration for plausibility
Date:   Sat, 22 Oct 2022 09:29:11 +0200
Message-Id: <20221022072528.159495833@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johnothan King <johnothanking@protonmail.com>

[ Upstream commit 50503e360eeb968a3d00234c9cc4057d774c3e9a ]

Arne Wendt writes:
  Cheap clone controllers may (falsely) report as having a user
  calibration for the analog sticks in place, but return
  wrong/impossible values for the actual calibration data.
  In the present case at mine, the controller reports having a
  user calibration in place and successfully executes the read
  commands. The reported user calibration however is
  min = center = max = 0.

  This pull request addresses problems of this kind by checking the
  provided user calibration-data for plausibility (min < center < max)
  and falling back to the default values if implausible.

I'll note that I was experiencing a crash because of this bug when using
the GuliKit KingKong 2 controller. The crash manifests as a divide by
zero error in the kernel logs:
kernel: divide error: 0000 [#1] PREEMPT SMP NOPTI

Link: https://github.com/nicman23/dkms-hid-nintendo/pull/25
Link: https://github.com/DanielOgorchock/linux/issues/36
Co-authored-by: Arne Wendt <arne.wendt@tuhh.de>
Signed-off-by: Johnothan King <johnothanking@protonmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/gvpL2G6VwXGJPvxX5KRiu9pVjvTivgayug_jdKDY6zfuAaAqncP9BkKLosjwUXNlgVVTMfJSKfwPF1K79cKAkwGComyC21vCV3q9B3EXNkE=@protonmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 55 +++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index f33a03c96ba6..cce324887952 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -761,12 +761,31 @@ static int joycon_read_stick_calibration(struct joycon_ctlr *ctlr, u16 cal_addr,
 	cal_y->max = cal_y->center + y_max_above;
 	cal_y->min = cal_y->center - y_min_below;
 
-	return 0;
+	/* check if calibration values are plausible */
+	if (cal_x->min >= cal_x->center || cal_x->center >= cal_x->max ||
+	    cal_y->min >= cal_y->center || cal_y->center >= cal_y->max)
+		ret = -EINVAL;
+
+	return ret;
 }
 
 static const u16 DFLT_STICK_CAL_CEN = 2000;
 static const u16 DFLT_STICK_CAL_MAX = 3500;
 static const u16 DFLT_STICK_CAL_MIN = 500;
+static void joycon_use_default_calibration(struct hid_device *hdev,
+					   struct joycon_stick_cal *cal_x,
+					   struct joycon_stick_cal *cal_y,
+					   const char *stick, int ret)
+{
+	hid_warn(hdev,
+		 "Failed to read %s stick cal, using defaults; e=%d\n",
+		 stick, ret);
+
+	cal_x->center = cal_y->center = DFLT_STICK_CAL_CEN;
+	cal_x->max = cal_y->max = DFLT_STICK_CAL_MAX;
+	cal_x->min = cal_y->min = DFLT_STICK_CAL_MIN;
+}
+
 static int joycon_request_calibration(struct joycon_ctlr *ctlr)
 {
 	u16 left_stick_addr = JC_CAL_FCT_DATA_LEFT_ADDR;
@@ -794,38 +813,24 @@ static int joycon_request_calibration(struct joycon_ctlr *ctlr)
 					    &ctlr->left_stick_cal_x,
 					    &ctlr->left_stick_cal_y,
 					    true);
-	if (ret) {
-		hid_warn(ctlr->hdev,
-			 "Failed to read left stick cal, using dflts; e=%d\n",
-			 ret);
-
-		ctlr->left_stick_cal_x.center = DFLT_STICK_CAL_CEN;
-		ctlr->left_stick_cal_x.max = DFLT_STICK_CAL_MAX;
-		ctlr->left_stick_cal_x.min = DFLT_STICK_CAL_MIN;
 
-		ctlr->left_stick_cal_y.center = DFLT_STICK_CAL_CEN;
-		ctlr->left_stick_cal_y.max = DFLT_STICK_CAL_MAX;
-		ctlr->left_stick_cal_y.min = DFLT_STICK_CAL_MIN;
-	}
+	if (ret)
+		joycon_use_default_calibration(ctlr->hdev,
+					       &ctlr->left_stick_cal_x,
+					       &ctlr->left_stick_cal_y,
+					       "left", ret);
 
 	/* read the right stick calibration data */
 	ret = joycon_read_stick_calibration(ctlr, right_stick_addr,
 					    &ctlr->right_stick_cal_x,
 					    &ctlr->right_stick_cal_y,
 					    false);
-	if (ret) {
-		hid_warn(ctlr->hdev,
-			 "Failed to read right stick cal, using dflts; e=%d\n",
-			 ret);
-
-		ctlr->right_stick_cal_x.center = DFLT_STICK_CAL_CEN;
-		ctlr->right_stick_cal_x.max = DFLT_STICK_CAL_MAX;
-		ctlr->right_stick_cal_x.min = DFLT_STICK_CAL_MIN;
 
-		ctlr->right_stick_cal_y.center = DFLT_STICK_CAL_CEN;
-		ctlr->right_stick_cal_y.max = DFLT_STICK_CAL_MAX;
-		ctlr->right_stick_cal_y.min = DFLT_STICK_CAL_MIN;
-	}
+	if (ret)
+		joycon_use_default_calibration(ctlr->hdev,
+					       &ctlr->right_stick_cal_x,
+					       &ctlr->right_stick_cal_y,
+					       "right", ret);
 
 	hid_dbg(ctlr->hdev, "calibration:\n"
 			    "l_x_c=%d l_x_max=%d l_x_min=%d\n"
-- 
2.35.1



