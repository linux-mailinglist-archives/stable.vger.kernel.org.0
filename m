Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BDF5B8433
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiINJIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiINJHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:07:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F05578BD2;
        Wed, 14 Sep 2022 02:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A068B81711;
        Wed, 14 Sep 2022 09:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41746C433C1;
        Wed, 14 Sep 2022 09:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146228;
        bh=AtZNvHJ8JmIDopLclj3kB31eh5RYZOGuOeAsxYXWpkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLr484WW2PTYgw404oE5WMUAoY1IZmKE+WhcI+EswdOrH3XeDaXyKFN/xTFkNeo6l
         nxUsn+jnQ4eHLeJMc/7U6wDRtmmAAFjM+AJFtrFhfTebAyfJlNaHXTWgtCpNoUcZdx
         e2QKb26l6h5sj8LWwaWy4Ke00Nh7e2n+9ZqUMeNIchLa9hJCQuknJ4FeINqPt82eXp
         fRTj6UT0yfw6CZ+gwUnwX7GIb5AO+N/3mwDuHp0nu+DuZxIAe1WBqsbHiPcZFY0z3G
         3HHU4g4ZJ+kxNcBdUqQVW4ZOBT1t+YmjbGJtaEq3YI/XWrmdAV7ndSr2vPHcuPvErR
         2IW+53BnYKtJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongxiang Ke <kdx.glider@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 08/13] ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()
Date:   Wed, 14 Sep 2022 05:03:10 -0400
Message-Id: <20220914090317.471116-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090317.471116-1-sashal@kernel.org>
References: <20220914090317.471116-1-sashal@kernel.org>
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
index 2f6d39c2ba7c8..7711184a0d0bf 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -1106,7 +1106,7 @@ static int __snd_usb_parse_audio_interface(struct snd_usb_audio *chip,
 	 * Dallas DS4201 workaround: It presents 5 altsettings, but the last
 	 * one misses syncpipe, and does not produce any sound.
 	 */
-	if (chip->usb_id == USB_ID(0x04fa, 0x4201))
+	if (chip->usb_id == USB_ID(0x04fa, 0x4201) && num >= 4)
 		num = 4;
 
 	for (i = 0; i < num; i++) {
-- 
2.35.1

