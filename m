Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A5045B990
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241860AbhKXMDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241872AbhKXMDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:03:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 331FF600EF;
        Wed, 24 Nov 2021 12:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755204;
        bh=hE/KIvjporwLZdJC7wBgnwCtWXPOABD3VpNH3yv5xTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElPP+V1nQxuh8hyy80VZtAvhlyjg8qT/WvsjJ0KDWaq1DtNL3ebBYJErIfOFKRQhU
         P1AP377KXj+04GBpGamnQyJ8wprpmm375TkX+wrq02G9Bw+SuaBQ4T2OHflW2Hux5a
         htLfLsJs8x2l4o7yNgGkqPVQYmc8ujtt1KZ+NrVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 011/162] ALSA: ua101: fix division by zero at probe
Date:   Wed, 24 Nov 2021 12:55:14 +0100
Message-Id: <20211124115658.692366462@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
 	ua->capture.max_packet_bytes = le16_to_cpu(epd->wMaxPacketSize);
 
 	epd = &ua->intf[INTF_PLAYBACK]->altsetting[1].endpoint[0].desc;
-	if (!usb_endpoint_is_isoc_out(epd)) {
+	if (!usb_endpoint_is_isoc_out(epd) || usb_endpoint_maxp(epd) == 0) {
 		dev_err(&ua->dev->dev, "invalid playback endpoint\n");
 		return -ENXIO;
 	}


