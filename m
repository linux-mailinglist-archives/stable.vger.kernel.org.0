Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E24D532E1A
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbiEXQA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237666AbiEXQAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DA2A30B6;
        Tue, 24 May 2022 09:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A60836175C;
        Tue, 24 May 2022 16:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD9AC34113;
        Tue, 24 May 2022 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408012;
        bh=6Cm8N7iGoLf4zRP7xWJkH3JlP5PHe89qcww/m1kqHZs=;
        h=From:To:Cc:Subject:Date:From;
        b=BCx66EXnkT5X2sso95W6sgv51Ov/eCOfBHae3jYYR6V8A0s22LjcJBxKJ6EMyVFQ2
         ZReBSE6dEv4GtRA/l5RZSA96aXVSAc1iL7U1zsw4L43uGTRQJgJgp/8qQoFVIMXO4G
         aIq+qQGBDqIyQ8iQuhgynfWxilCvQwQk5TqUGunjv0bAN2mLDf1lvPQvEGo21O8d91
         8SFwKDvIUfvk+SpAlJZ2yzwDOHxdPlE9CtQtjC0Q8GDD4rcVws3Eb87Fi29mli5gbH
         nccJAoqYULPE9+XToPkSqybY1hsQwq7JSxoi76VzOFgOtGK+Ovth0nCCAeOGnZi7tN
         ow4I6BlsjTnHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Forest Crossman <cyrozap@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alexander@tsoy.me, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 01/10] ALSA: usb-audio: Don't get sample rate for MCT Trigger 5 USB-to-HDMI
Date:   Tue, 24 May 2022 11:59:58 -0400
Message-Id: <20220524160009.826957-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Forest Crossman <cyrozap@gmail.com>

[ Upstream commit d7be213849232a2accb219d537edf056d29186b4 ]

This device doesn't support reading the sample rate, so we need to apply
this quirk to avoid a 15-second delay waiting for three timeouts.

Signed-off-by: Forest Crossman <cyrozap@gmail.com>
Link: https://lore.kernel.org/r/20220504002444.114011-2-cyrozap@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index ab9f3da49941..fbbe59054c3f 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1822,6 +1822,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x06f8, 0xd002, /* Hercules DJ Console (Macintosh Edition) */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x0711, 0x5800, /* MCT Trigger 5 USB-to-HDMI */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x074d, 0x3553, /* Outlaw RR2150 (Micronas UAC3553B) */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x08bb, 0x2702, /* LineX FM Transmitter */
-- 
2.35.1

