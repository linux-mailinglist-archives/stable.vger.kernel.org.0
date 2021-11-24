Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28F745BC73
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243250AbhKXMa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:30:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245559AbhKXM2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:28:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C282C6127B;
        Wed, 24 Nov 2021 12:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756228;
        bh=d9TS26GOOEKT3ntUV5tTPdcraKeZI2CzwpteWVyayus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hw/VbAr+/lL7sgf52y5Lm8oxpvwvKmF/BiQtr106lBFkO6BFURE9Ha8nR2YxYlGTi
         SOECEDjIdKfuW5x/n43CTHP6WOJST+NPMrxoyxNKT7jP7pGrz4o8Wj72ci08xE4tlQ
         XrxJte3gCzolvIcHXA4nu+fGE5jEEpzeECjOB5Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 012/251] ALSA: ua101: fix division by zero at probe
Date:   Wed, 24 Nov 2021 12:54:14 +0100
Message-Id: <20211124115710.639029914@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 55f261b73a7e1cb254577c3536cef8f415de220a upstream.

Add the missing endpoint max-packet sanity check to probe() to avoid
division by zero in alloc_stream_buffers() in case a malicious device
has broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: 63978ab3e3e9 ("sound: add Edirol UA-101 support")
Cc: stable@vger.kernel.org      # 2.6.34
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211026095401.26522-1-johan@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/misc/ua101.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -1032,7 +1032,7 @@ static int detect_usb_format(struct ua10
 		fmt_playback->bSubframeSize * ua->playback.channels;
 
 	epd = &ua->intf[INTF_CAPTURE]->altsetting[1].endpoint[0].desc;
-	if (!usb_endpoint_is_isoc_in(epd)) {
+	if (!usb_endpoint_is_isoc_in(epd) || usb_endpoint_maxp(epd) == 0) {
 		dev_err(&ua->dev->dev, "invalid capture endpoint\n");
 		return -ENXIO;
 	}
@@ -1040,7 +1040,7 @@ static int detect_usb_format(struct ua10
 	ua->capture.max_packet_bytes = usb_endpoint_maxp(epd);
 
 	epd = &ua->intf[INTF_PLAYBACK]->altsetting[1].endpoint[0].desc;
-	if (!usb_endpoint_is_isoc_out(epd)) {
+	if (!usb_endpoint_is_isoc_out(epd) || usb_endpoint_maxp(epd) == 0) {
 		dev_err(&ua->dev->dev, "invalid playback endpoint\n");
 		return -ENXIO;
 	}


