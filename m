Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CA1452501
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358066AbhKPBqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241554AbhKOSWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:22:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED2F63415;
        Mon, 15 Nov 2021 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998808;
        bh=wHJuatrHECD/rAZlHZ94hOODw5p+QMyTaOaVaNr1G7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ibdupBCGturIeE0wbgSG4gpGHjCFjRUPWrhwxkYCqmT5EKezp3RXdl1PUjGP/Bd8o
         emA9v6901knnPjNdN4eoFSDL+xtzmbnVzdyTeHQ35JID5uis2f2e1x4WWETuBJ75Q/
         ei5S7fS8F27ObTF48Tqkj803r9JhDxBL2XWnwFAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 036/849] ALSA: ua101: fix division by zero at probe
Date:   Mon, 15 Nov 2021 17:51:59 +0100
Message-Id: <20211115165421.225950620@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
@@ -1000,7 +1000,7 @@ static int detect_usb_format(struct ua10
 		fmt_playback->bSubframeSize * ua->playback.channels;
 
 	epd = &ua->intf[INTF_CAPTURE]->altsetting[1].endpoint[0].desc;
-	if (!usb_endpoint_is_isoc_in(epd)) {
+	if (!usb_endpoint_is_isoc_in(epd) || usb_endpoint_maxp(epd) == 0) {
 		dev_err(&ua->dev->dev, "invalid capture endpoint\n");
 		return -ENXIO;
 	}
@@ -1008,7 +1008,7 @@ static int detect_usb_format(struct ua10
 	ua->capture.max_packet_bytes = usb_endpoint_maxp(epd);
 
 	epd = &ua->intf[INTF_PLAYBACK]->altsetting[1].endpoint[0].desc;
-	if (!usb_endpoint_is_isoc_out(epd)) {
+	if (!usb_endpoint_is_isoc_out(epd) || usb_endpoint_maxp(epd) == 0) {
 		dev_err(&ua->dev->dev, "invalid playback endpoint\n");
 		return -ENXIO;
 	}


