Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B59532DF8
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 17:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbiEXP7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbiEXP7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:59:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352BF9BAC7;
        Tue, 24 May 2022 08:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEF64B81785;
        Tue, 24 May 2022 15:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F988C34113;
        Tue, 24 May 2022 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653407972;
        bh=6Cm8N7iGoLf4zRP7xWJkH3JlP5PHe89qcww/m1kqHZs=;
        h=From:To:Cc:Subject:Date:From;
        b=URDTsRzelaNOFmufVi6YgY3zXPK+Cn8jiLnGR6rISyeMGcDhVrdG086GYeaGLcsSJ
         PVchyXowSh9904nsJwcuXrf2ERHNT09W/6waB3rt3M4bB3Rfq4axscsADt3qf7s/r2
         QmwYFt+WCf4yEk6v3x/L1PMmaNymCIQjg+CtLJkYMDqLZkvIBPPX7mH4LMNUF74H67
         LXAM90Kr8vI9SF5NP2sZNK73nwoYdPHT6m7oEd0iTEAmE8TlFPcSRaTEXjTfXFbpik
         qYcEKT0Y1Wo6tcqENmuhn6j0/vichiV2L+uRQd+rHSw8VeMzWVM6tJCuNNwA9DDEda
         rZJn3Fr6wf9RQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Forest Crossman <cyrozap@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alexander@tsoy.me, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 01/12] ALSA: usb-audio: Don't get sample rate for MCT Trigger 5 USB-to-HDMI
Date:   Tue, 24 May 2022 11:59:15 -0400
Message-Id: <20220524155929.826793-1-sashal@kernel.org>
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

