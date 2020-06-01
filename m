Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3B21EAF4B
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgFATBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 15:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbgFAR4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C139207BB;
        Mon,  1 Jun 2020 17:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034164;
        bh=gTOUMFkpdm0Z/lU3SAmaaDcHe9k6MTlfvEDDxfKc/j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IKEXtuGoKxp1lprTP6CR1AFElryjx/fN3uyPoiQw8yyapRJ3PC6un5Aq9Wpa2jx4
         aPGTVyOTK35CdvYjbR4O428RqmZCAs0r776r5t0LoRKGXzufhPwmB4T5NhauMba6Xf
         pzA7sTdsBIZtsyYjqBOqjgS2a/aBJvxEGyXyM/Ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessm.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 20/48] ALSA: usb-audio: mixer: volume quirk for ESS Technology Asus USB DAC
Date:   Mon,  1 Jun 2020 19:53:30 +0200
Message-Id: <20200601173958.447364995@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessm.com>

[ Upstream commit 4020d1ccbe55bdf67b31d718d2400506eaf4b43f ]

The Asus USB DAC is a USB type-C audio dongle for connecting to
the headset and headphone. The volume minimum value -23040 which
is 0xa600 in hexadecimal with the resolution value 1 indicates
this should be endianness issue caused by the firmware bug. Add
a volume quirk to fix the volume control problem.

Also fixes this warning:
  Warning! Unlikely big volume range (=23040), cval->res is probably wrong.
  [5] FU [Headset Capture Volume] ch = 1, val = -23040/0/1
  Warning! Unlikely big volume range (=23040), cval->res is probably wrong.
  [7] FU [Headset Playback Volume] ch = 1, val = -23040/0/1

Signed-off-by: Chris Chiu <chiu@endlessm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200526062613.55401-1-chiu@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index f191f4a3cf3b..9bbe84ce7d07 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -979,6 +979,14 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 			cval->res = 384;
 		}
 		break;
+	case USB_ID(0x0495, 0x3042): /* ESS Technology Asus USB DAC */
+		if ((strstr(kctl->id.name, "Playback Volume") != NULL) ||
+			strstr(kctl->id.name, "Capture Volume") != NULL) {
+			cval->min >>= 8;
+			cval->max = 0;
+			cval->res = 1;
+		}
+		break;
 	}
 }
 
-- 
2.25.1



