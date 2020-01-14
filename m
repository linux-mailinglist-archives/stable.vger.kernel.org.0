Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE4213A314
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 09:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgANIkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 03:40:10 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40007 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgANIkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 03:40:10 -0500
Received: by mail-lj1-f193.google.com with SMTP id u1so13337663ljk.7;
        Tue, 14 Jan 2020 00:40:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zm6dxfwwxxsUgoQx/Ixs6f65hoaWz7f2fI6es/3Ijns=;
        b=I1uARPBp9OUDNT5/Yyt0sZC7WOngXlM96UryfU3EkWeN8o8jJBFRAWrYi36UMdfyt7
         gvEm+f9Eu3K7KDuJw7+5dmQpaA54K2oj9bg04iFcMMbDZOoQqvLmaIelS0KeGc19ZTVA
         OCJiV3wsL54ha95oB3fsc03FgcfhegKON+JfLuJa8t4kMxZ0KYNHqzyxS8IwzN/vwBCe
         c+S7DkpIkx+ziLX78jaY97LDAUsTc85fVBXVqQMWwqAYEhSl7uqH4oRWbfttaPZiJfGN
         bPMYkowbMBRAGJRNKkXZPeMDZLOZr8dMBvaIRZy1BwyLWMf/J3z1f7696ZSvD2hE3Ayi
         ch3g==
X-Gm-Message-State: APjAAAW0vFxEXSfpD/T/HiPcFcS/4uKpsVZAmoQ/TFot5r2UIu0SOze4
        zLHUZV9bddkQjdhMpOVYZ/u4LocO
X-Google-Smtp-Source: APXvYqxK2dS7w47TFeRL1ZrMAWZXamRgxsgmqFsDFdxveqSAiv1L06WR5SP8UeZYWuXxDExwsvy0yQ==
X-Received: by 2002:a2e:910b:: with SMTP id m11mr12819480ljg.213.1578991208043;
        Tue, 14 Jan 2020 00:40:08 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id b14sm6840893lff.68.2020.01.14.00.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 00:40:07 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1irHk7-0000Ia-26; Tue, 14 Jan 2020 09:40:07 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] ALSA: usb-audio: fix sync-ep altsetting sanity check
Date:   Tue, 14 Jan 2020 09:39:53 +0100
Message-Id: <20200114083953.1106-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The altsetting sanity check in set_sync_ep_implicit_fb_quirk() was
checking for there to be at least one altsetting but then went on to
access the second one, which may not exist.

This could lead to random slab data being used to initialise the sync
endpoint in snd_usb_add_endpoint().

Fixes: c75a8a7ae565 ("ALSA: snd-usb: add support for implicit feedback")
Fixes: ca10a7ebdff1 ("ALSA: usb-audio: FT C400 sync playback EP to capture EP")
Fixes: 5e35dc0338d8 ("ALSA: usb-audio: add implicit fb quirk for Behringer UFX1204")
Fixes: 17f08b0d9aaf ("ALSA: usb-audio: add implicit fb quirk for Axe-Fx II")
Fixes: 103e9625647a ("ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk")
Cc: stable <stable@vger.kernel.org>     # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 sound/usb/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index a11c8150af58..0e4eab96e23e 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -370,7 +370,7 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb_substream *subs,
 add_sync_ep_from_ifnum:
 	iface = usb_ifnum_to_if(dev, ifnum);
 
-	if (!iface || iface->num_altsetting == 0)
+	if (!iface || iface->num_altsetting < 2)
 		return -EINVAL;
 
 	alts = &iface->altsetting[1];
-- 
2.24.1

