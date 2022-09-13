Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3295B6FB0
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiIMOP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiIMOPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:15:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DE361734;
        Tue, 13 Sep 2022 07:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15B5F614BC;
        Tue, 13 Sep 2022 14:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C25C433D6;
        Tue, 13 Sep 2022 14:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078243;
        bh=QORNZ5e1kZu2Hon3rOnPJKvLEa4Hg1g6E++NapJ2ppg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCGl63ORguTv9gwKK0RJq1fej5PBcZwgCUPRYtvoqHSpdxzHwhrGSgW0YeNV+4fFH
         d1qgywKmA4/LvWyTgziFNe2ey2MtJAjVpKr61k7j7E6lEnaWOrxlS+8DgAsBX41cx/
         qLZpPXLv5dxq4KJBafxFP/i4Z8VzIVEPfGsD1bKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 065/192] ASoC: cs42l42: Only report button state if there was a button interrupt
Date:   Tue, 13 Sep 2022 16:02:51 +0200
Message-Id: <20220913140413.203153241@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ea75deef1a738d25502cfbb2caa564270b271525 ]

Only report a button state change if the interrupt status shows that
there was a button event.

Previously the code would always drop into the button reporting at the
end of interrupt handling if the jack was present. If neither of the
button report interrupts were pending it would report all buttons
released. This could then lead to a button being reported as released
while it is still pressed.

Fixes: c5b8ee0879bc ("ASoC: cs42l42: Report jack and button detection")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220815123138.3810249-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 4fade23887972..8cba3015398b7 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -1618,7 +1618,6 @@ static irqreturn_t cs42l42_irq_thread(int irq, void *data)
 	unsigned int current_plug_status;
 	unsigned int current_button_status;
 	unsigned int i;
-	int report = 0;
 
 	mutex_lock(&cs42l42->irq_lock);
 	if (cs42l42->suspended) {
@@ -1713,13 +1712,15 @@ static irqreturn_t cs42l42_irq_thread(int irq, void *data)
 
 			if (current_button_status & CS42L42_M_DETECT_TF_MASK) {
 				dev_dbg(cs42l42->dev, "Button released\n");
-				report = 0;
+				snd_soc_jack_report(cs42l42->jack, 0,
+						    SND_JACK_BTN_0 | SND_JACK_BTN_1 |
+						    SND_JACK_BTN_2 | SND_JACK_BTN_3);
 			} else if (current_button_status & CS42L42_M_DETECT_FT_MASK) {
-				report = cs42l42_handle_button_press(cs42l42);
-
+				snd_soc_jack_report(cs42l42->jack,
+						    cs42l42_handle_button_press(cs42l42),
+						    SND_JACK_BTN_0 | SND_JACK_BTN_1 |
+						    SND_JACK_BTN_2 | SND_JACK_BTN_3);
 			}
-			snd_soc_jack_report(cs42l42->jack, report, SND_JACK_BTN_0 | SND_JACK_BTN_1 |
-								   SND_JACK_BTN_2 | SND_JACK_BTN_3);
 		}
 	}
 
-- 
2.35.1



