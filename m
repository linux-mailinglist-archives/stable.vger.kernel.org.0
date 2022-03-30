Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99514EC223
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345195AbiC3L6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344358AbiC3Lw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325CD2E686;
        Wed, 30 Mar 2022 04:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 150596167D;
        Wed, 30 Mar 2022 11:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE07C36AE7;
        Wed, 30 Mar 2022 11:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640923;
        bh=e/QTXOR4IKo2wWU/0hmkkw381mCDHN8YxiKFRH0zEm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okgVZxXE9nccnCBJT40YVOpIqYwA6p2KzE6n3bk01UWM8bE4M1Lp670yG7nfgGIxf
         Imf2X9w5uL6FtlGtu2/uUi5OW4F0VFB20d/M7qzUZH8rio9TeMN0d3dEMtBg+X7sPr
         zMEg7HGAGLpLzpRT4DPgz8p8PTVS3EqN9LUEd7vqB7kCVNg9LrMAdVuPQV4XPrY99p
         zQCICkKV/a1aFJts81ALqMJ1rVunj3NKxzedYHImbmG7IpetZjv44SPOtmlTi8Q1wz
         /qhJyUsyQPfaukSqU2f8YSne1uQ2c7GAoCkRIxj1R7vFr/+aS+O7tqv5xS92sgBeba
         ACXQo5BZSxOYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 07/59] ASoC: cs42l42: Report full jack status when plug is detected
Date:   Wed, 30 Mar 2022 07:47:39 -0400
Message-Id: <20220330114831.1670235-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 8d06f797f844d04a961f201f886f7f9985edc9bf ]

When a plug event is detect report the full state of all status
bits, don't assume that there will have been a previous unplug
event to clear all the bits. Report the state of both HEADPHONE
and MICROPHONE bits according to detected type, and clear all the
button status bits. The current button status is already checked
and reported at the end of the function.

During a system suspend the jack could be unplugged and plugged,
possibly changing the jack type. On resume the interrupt status will
indicate a plug event - there will not be an unplug event to clear
the bits.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220121120412.672284-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index a63fba4e6c9c..eb170d106396 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -1630,7 +1630,11 @@ static irqreturn_t cs42l42_irq_thread(int irq, void *data)
 
 	mutex_lock(&cs42l42->jack_detect_mutex);
 
-	/* Check auto-detect status */
+	/*
+	 * Check auto-detect status. Don't assume a previous unplug event has
+	 * cleared the flags. If the jack is unplugged and plugged during
+	 * system suspend there won't have been an unplug event.
+	 */
 	if ((~masks[5]) & irq_params_table[5].mask) {
 		if (stickies[5] & CS42L42_HSDET_AUTO_DONE_MASK) {
 			cs42l42_process_hs_type_detect(cs42l42);
@@ -1638,11 +1642,15 @@ static irqreturn_t cs42l42_irq_thread(int irq, void *data)
 			case CS42L42_PLUG_CTIA:
 			case CS42L42_PLUG_OMTP:
 				snd_soc_jack_report(cs42l42->jack, SND_JACK_HEADSET,
-						    SND_JACK_HEADSET);
+						    SND_JACK_HEADSET |
+						    SND_JACK_BTN_0 | SND_JACK_BTN_1 |
+						    SND_JACK_BTN_2 | SND_JACK_BTN_3);
 				break;
 			case CS42L42_PLUG_HEADPHONE:
 				snd_soc_jack_report(cs42l42->jack, SND_JACK_HEADPHONE,
-						    SND_JACK_HEADPHONE);
+						    SND_JACK_HEADSET |
+						    SND_JACK_BTN_0 | SND_JACK_BTN_1 |
+						    SND_JACK_BTN_2 | SND_JACK_BTN_3);
 				break;
 			default:
 				break;
-- 
2.34.1

