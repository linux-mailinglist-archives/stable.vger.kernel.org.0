Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DA64A4EB0
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 19:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350447AbiAaSn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 13:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244230AbiAaSnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 13:43:55 -0500
X-Greylist: delayed 467 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 31 Jan 2022 10:43:55 PST
Received: from mail.hahnjo.de (backus.hahnjo.de [IPv6:2a03:4000:2a:2c1::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3625C061714;
        Mon, 31 Jan 2022 10:43:55 -0800 (PST)
Received: from Jonas-Dell.home (unknown [IPv6:2a01:cb15:40c:c100:cf0a:528a:fee7:c993])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.hahnjo.de (Postfix) with ESMTPSA id E391D5870138;
        Mon, 31 Jan 2022 19:36:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hahnjo.de; s=default;
        t=1643654164; bh=DnXhFAGWRC1c19WVXbcduyTvpHjO7t6osxp9bE7zzBM=;
        h=From:To:Cc:Subject:Date;
        b=pAchqnRzQbyD6A+ShzZNlceg6D8ZM/iB8q64fAIK31HXUD/l40ut7gDmY7lfgxAj3
         oY4fw3oJa6pz98QgdyrxvUAaB2PBjtlaAZp4iIttE3Lv4QMGUa2/0GtDV65679hVef
         iSGyoUFjlO385DSynUwrUhXJ/3ioDKPL662iH4CQSsLDgCBJ1YhY1GUOhmkzGs57M7
         GLXUGWxFu+dX9FXBFydVuygrSIXq991ZhpS2XWUjaj+zWXpCV4y+ffWF8YdLCDsPcx
         /UvLQxdLDyxnAUFJc9iV007eL++4NBBdHuBjb1k04I49XopB+f/ovXHE32cY0sMZT7
         cjUA/jMnUwYyA==
From:   Jonas Hahnfeld <hahnjo@hahnjo.de>
To:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Jonas Hahnfeld <hahnjo@hahnjo.de>,
        Jukka Heikintalo <heikintalo.jukka@gmail.com>,
        =?UTF-8?q?Pawe=C5=82=20Susicki?= <pawel.susicki@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: usb-audio: Correct quirk for VF0770
Date:   Mon, 31 Jan 2022 19:35:16 +0100
Message-Id: <20220131183516.61191-1-hahnjo@hahnjo.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 sound/usb/quirks-table.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index b1522e43173e..0ea39565e623 100644
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
-- 
2.35.1

