Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC3026669D
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgIKRaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgIKM5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:57:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0512C2220E;
        Fri, 11 Sep 2020 12:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828910;
        bh=U/mzlecwlX18nx6LnGZoHxwzL8DkmoulQ2Fg0vy3/mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4bQpGCr4j8jwSD/EGBbSI0EoPNqJToJ0jOU8wZ+g+H30ZLTkz4wJNVEDx5TzWp+Q
         tz3Kus3l7TQMOSYWufW6wuTqOuqEkAzsTO/yjdVEQrkkXmNR8wDYBY+x8iPuuvPga8
         KDUuTHGVXO5qxrpRjP0b2tQ/9GjDIl4Qe6W2Teq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 53/62] ALSA; firewire-tascam: exclude Tascam FE-8 from detection
Date:   Fri, 11 Sep 2020 14:46:36 +0200
Message-Id: <20200911122505.037116689@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

Tascam FE-8 is known to support communication by asynchronous transaction
only. The support can be implemented in userspace application and
snd-firewire-ctl-services project has the support. However, ALSA
firewire-tascam driver is bound to the model.

This commit changes device entries so that the model is excluded. In a
commit 53b3ffee7885 ("ALSA: firewire-tascam: change device probing
processing"), I addressed to the concern that version field in
configuration differs depending on installed firmware. However, as long
as I checked, the version number is fixed. It's safe to return version
number back to modalias.

Fixes: 53b3ffee7885 ("ALSA: firewire-tascam: change device probing processing")
Cc: <stable@vger.kernel.org> # 4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20200823075537.56255-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/firewire/tascam/tascam.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/sound/firewire/tascam/tascam.c b/sound/firewire/tascam/tascam.c
index ee0bc18395088..a4143f45c7f7a 100644
--- a/sound/firewire/tascam/tascam.c
+++ b/sound/firewire/tascam/tascam.c
@@ -172,11 +172,39 @@ static void snd_tscm_remove(struct fw_unit *unit)
 }
 
 static const struct ieee1394_device_id snd_tscm_id_table[] = {
+	// Tascam, FW-1884.
 	{
 		.match_flags = IEEE1394_MATCH_VENDOR_ID |
-			       IEEE1394_MATCH_SPECIFIER_ID,
+			       IEEE1394_MATCH_SPECIFIER_ID |
+			       IEEE1394_MATCH_VERSION,
 		.vendor_id = 0x00022e,
 		.specifier_id = 0x00022e,
+		.version = 0x800000,
+	},
+	// Tascam, FE-8 (.version = 0x800001)
+	// This kernel module doesn't support FE-8 because the most of features
+	// can be implemented in userspace without any specific support of this
+	// module.
+	//
+	// .version = 0x800002 is unknown.
+	//
+	// Tascam, FW-1082.
+	{
+		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_SPECIFIER_ID |
+			       IEEE1394_MATCH_VERSION,
+		.vendor_id = 0x00022e,
+		.specifier_id = 0x00022e,
+		.version = 0x800003,
+	},
+	// Tascam, FW-1804.
+	{
+		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_SPECIFIER_ID |
+			       IEEE1394_MATCH_VERSION,
+		.vendor_id = 0x00022e,
+		.specifier_id = 0x00022e,
+		.version = 0x800004,
 	},
 	/* FE-08 requires reverse-engineering because it just has faders. */
 	{}
-- 
2.25.1



