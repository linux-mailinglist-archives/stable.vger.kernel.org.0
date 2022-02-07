Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F814ABDA3
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388867AbiBGLpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385484AbiBGLby (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A17DC03F93F;
        Mon,  7 Feb 2022 03:30:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABA3B60AB0;
        Mon,  7 Feb 2022 11:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ACBC004E1;
        Mon,  7 Feb 2022 11:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233430;
        bh=xjkRWAuO6sjuAxBcS+6c7kSyPv7Q3Yfk0x1pK5sdx1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlWz7zmJ7oA1Xkk9qcUJGklv6hw8BLVngWURiJmsOYG2R9k3LRsErNjJR/v6XAdrp
         R06GCmQRsdrr4y6zUxA4aLH3rT4bUgY2BgDb1yxsPAf2qKscYqLkoXhtFdk26lPhFx
         eneCnyqo+BQjiBgEHYmyAQEZZ3wJdRpClOPB3zO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jukka Heikintalo <heikintalo.jukka@gmail.com>,
        =?UTF-8?q?Pawe=C5=82=20Susicki?= <pawel.susicki@gmail.com>,
        Jonas Hahnfeld <hahnjo@hahnjo.de>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 010/126] ALSA: usb-audio: Correct quirk for VF0770
Date:   Mon,  7 Feb 2022 12:05:41 +0100
Message-Id: <20220207103804.413334168@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jonas Hahnfeld <hahnjo@hahnjo.de>

commit 4ee02e20893d2f9e951c7888f2284fa608ddaa35 upstream.

This device provides both audio and video. The original quirk added in
commit 48827e1d6af5 ("ALSA: usb-audio: Add quirk for VF0770") used
USB_DEVICE to match the vendor and product ID. Depending on module order,
if snd-usb-audio was asked first, it would match the entire device and
uvcvideo wouldn't get to see it. Change the matching to USB_AUDIO_DEVICE
to restore uvcvideo matching in all cases.

Fixes: 48827e1d6af5 ("ALSA: usb-audio: Add quirk for VF0770")
Reported-by: Jukka Heikintalo <heikintalo.jukka@gmail.com>
Tested-by: Jukka Heikintalo <heikintalo.jukka@gmail.com>
Reported-by: Paweł Susicki <pawel.susicki@gmail.com>
Tested-by: Paweł Susicki <pawel.susicki@gmail.com>
Cc: <stable@vger.kernel.org> # 5.4, 5.10, 5.14, 5.15
Signed-off-by: Jonas Hahnfeld <hahnjo@hahnjo.de>
Link: https://lore.kernel.org/r/20220131183516.61191-1-hahnjo@hahnjo.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -84,7 +84,7 @@
  * combination.
  */
 {
-	USB_DEVICE(0x041e, 0x4095),
+	USB_AUDIO_DEVICE(0x041e, 0x4095),
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
 		.ifnum = QUIRK_ANY_INTERFACE,
 		.type = QUIRK_COMPOSITE,


