Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D015243AF8C
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhJZJ5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhJZJ5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A7D60F24;
        Tue, 26 Oct 2021 09:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635242081;
        bh=nyUiNsWaXu7J7EBCjgMBONE2lBGC6AijnH3+208gHk0=;
        h=From:To:Cc:Subject:Date:From;
        b=IcCrcZA6ot/XDbhxUd+ZROF+GVbjsIi9MGCTkO6xkTLTMrWzMPIMvHk4UN7tysl63
         bxH75ZdPC3kMW433GIjN69XarQu5ic2SukukWUrfVH+r/KSgDpiKqMQL8kGzfYUGwr
         xKidZ4eZJ+7PhkdMPIdIbsYgw+C0Gy51P1VNLtMc2Um1/QshPAHvuGPW97v5vspN8B
         QA9y2RGbc+LV0xQKVzUW6EU8XkeKkJuaTyRmkYvH7Eg/izoy8RmsZ8fyI8Wkt3Iufw
         euwNO+WFOFl4jwQsrKfTg9NU3lGnkXLLxzVW827kUnKihjDoTw5gSEID1TAYHpUPhm
         0YnwekDKkhszg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfJA0-0006uh-Kv; Tue, 26 Oct 2021 11:54:24 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Clemens Ladisch <clemens@ladisch.de>
Cc:     Takashi Iwai <tiwai@suse.com>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] sound: ua101: fix division by zero at probe
Date:   Tue, 26 Oct 2021 11:54:01 +0200
Message-Id: <20211026095401.26522-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 sound/usb/misc/ua101.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index 5834d1dc317e..4f6b20ed29dd 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -1000,7 +1000,7 @@ static int detect_usb_format(struct ua101 *ua)
 		fmt_playback->bSubframeSize * ua->playback.channels;
 
 	epd = &ua->intf[INTF_CAPTURE]->altsetting[1].endpoint[0].desc;
-	if (!usb_endpoint_is_isoc_in(epd)) {
+	if (!usb_endpoint_is_isoc_in(epd) || usb_endpoint_maxp(epd) == 0) {
 		dev_err(&ua->dev->dev, "invalid capture endpoint\n");
 		return -ENXIO;
 	}
@@ -1008,7 +1008,7 @@ static int detect_usb_format(struct ua101 *ua)
 	ua->capture.max_packet_bytes = usb_endpoint_maxp(epd);
 
 	epd = &ua->intf[INTF_PLAYBACK]->altsetting[1].endpoint[0].desc;
-	if (!usb_endpoint_is_isoc_out(epd)) {
+	if (!usb_endpoint_is_isoc_out(epd) || usb_endpoint_maxp(epd) == 0) {
 		dev_err(&ua->dev->dev, "invalid playback endpoint\n");
 		return -ENXIO;
 	}
-- 
2.32.0

