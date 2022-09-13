Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51665B7227
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiIMOpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiIMOnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:43:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F118B6E2DC;
        Tue, 13 Sep 2022 07:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F501B80F01;
        Tue, 13 Sep 2022 14:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C847BC433D6;
        Tue, 13 Sep 2022 14:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078975;
        bh=PgDM3ajWpuFY3hObR9Y+9AgEDoWVeiUNMjT7ZyVTZBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn/D7ujaZ0ReXabIN/HhM/6A/wFVCWinmAPHFXoscYCX4NehwwV7Q30sUXZGTRT3K
         1G4tVXBkkHg/lqyagfCOjhzhVzH95vGmFCYcZcugpgblASg+tJJ9Jw7tiH2I1pFnlf
         aLYtIgFcIZ2KD6f4d+UGLi6XianAsQ/9wjn/2HPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongxiang Ke <kdx.glider@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 26/79] ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()
Date:   Tue, 13 Sep 2022 16:04:31 +0200
Message-Id: <20220913140351.564581137@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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

From: Dongxiang Ke <kdx.glider@gmail.com>

commit e53f47f6c1a56d2af728909f1cb894da6b43d9bf upstream.

There may be a bad USB audio device with a USB ID of (0x04fa, 0x4201) and
the number of it's interfaces less than 4, an out-of-bounds read bug occurs
when parsing the interface descriptor for this device.

Fix this by checking the number of interfaces.

Signed-off-by: Dongxiang Ke <kdx.glider@gmail.com>
Link: https://lore.kernel.org/r/20220906024928.10951-1-kdx.glider@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -1106,7 +1106,7 @@ static int __snd_usb_parse_audio_interfa
 	 * Dallas DS4201 workaround: It presents 5 altsettings, but the last
 	 * one misses syncpipe, and does not produce any sound.
 	 */
-	if (chip->usb_id == USB_ID(0x04fa, 0x4201))
+	if (chip->usb_id == USB_ID(0x04fa, 0x4201) && num >= 4)
 		num = 4;
 
 	for (i = 0; i < num; i++) {


