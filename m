Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515655B83C0
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiINJDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiINJCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:02:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9441774BBC;
        Wed, 14 Sep 2022 02:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99CB86193B;
        Wed, 14 Sep 2022 09:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECE4C43470;
        Wed, 14 Sep 2022 09:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146115;
        bh=DJM3CoZYpCVzX8l096vek1rNTFNHFKWn2oEvcTzk1Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrAG5x0dlhqSRAxLv/3pn+b55eiDpuMkxBhHPMAp9tQddd3eL/otacXJrB3SHbnwV
         5RRGkCKIHZixkDN6XubCtPxU+FuFg4otH6U5v78PhgQAI7D83O5ceBXuY7N56VZJ5h
         1w+zCBLnrJ6cvmLU9bGO723Y8nkiLwHZHv3FxojTJ7y9tr2QnGMmK9632nndfyzl16
         U7oBiPU1+aUoXSaGvunC/SHaR486k1t0OKrzTTI6pf1AKohngMcXgTVKP3ZpBSLFue
         6bnQIopPUqWC6+JoWo13Dto9ssGCFO1FeorCn4uTPjMMe9h0dvBAbl0Eh/wy6S8vaR
         xiRqrOFyzAOQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongxiang Ke <kdx.glider@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 14/22] ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()
Date:   Wed, 14 Sep 2022 05:00:55 -0400
Message-Id: <20220914090103.470630-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
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

From: Dongxiang Ke <kdx.glider@gmail.com>

[ Upstream commit e53f47f6c1a56d2af728909f1cb894da6b43d9bf ]

There may be a bad USB audio device with a USB ID of (0x04fa, 0x4201) and
the number of it's interfaces less than 4, an out-of-bounds read bug occurs
when parsing the interface descriptor for this device.

Fix this by checking the number of interfaces.

Signed-off-by: Dongxiang Ke <kdx.glider@gmail.com>
Link: https://lore.kernel.org/r/20220906024928.10951-1-kdx.glider@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index ceb93d798182c..40ce8a1cb318a 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -1105,7 +1105,7 @@ static int __snd_usb_parse_audio_interface(struct snd_usb_audio *chip,
 	 * Dallas DS4201 workaround: It presents 5 altsettings, but the last
 	 * one misses syncpipe, and does not produce any sound.
 	 */
-	if (chip->usb_id == USB_ID(0x04fa, 0x4201))
+	if (chip->usb_id == USB_ID(0x04fa, 0x4201) && num >= 4)
 		num = 4;
 
 	for (i = 0; i < num; i++) {
-- 
2.35.1

