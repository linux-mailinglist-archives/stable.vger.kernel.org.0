Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C52F26198D
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbgIHSUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731454AbgIHQLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F83624736;
        Tue,  8 Sep 2020 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579660;
        bh=RVr8PcWE29fyPNXwUF/aGB4qkOtdGavpST2mHQkdMws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpRLfyUdIZBK8DxjYP/miDMT0BSxN2JWgsAAZYzqFZZYrl9PXgXwMZaGt8r5XGEIA
         rXqVjynSGVR7bR6qH5+gubITv9hRnRQWJHPKfMc9VrPwx7EcutqSYaEYaJTasK4fg1
         Z50jr0zcFgqZvrS11NQYQnHS6WSzLrr3zze4V8lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 142/186] ALSA; firewire-tascam: exclude Tascam FE-8 from detection
Date:   Tue,  8 Sep 2020 17:24:44 +0200
Message-Id: <20200908152248.546056788@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 0bd8bce897b6697bbc286b8ba473aa0705fe394b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/tascam/tascam.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/sound/firewire/tascam/tascam.c
+++ b/sound/firewire/tascam/tascam.c
@@ -39,9 +39,6 @@ static const struct snd_tscm_spec model_
 		.midi_capture_ports = 2,
 		.midi_playback_ports = 4,
 	},
-	// This kernel module doesn't support FE-8 because the most of features
-	// can be implemented in userspace without any specific support of this
-	// module.
 };
 
 static int identify_model(struct snd_tscm *tscm)
@@ -211,11 +208,39 @@ static void snd_tscm_remove(struct fw_un
 }
 
 static const struct ieee1394_device_id snd_tscm_id_table[] = {
+	// Tascam, FW-1884.
+	{
+		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_SPECIFIER_ID |
+			       IEEE1394_MATCH_VERSION,
+		.vendor_id = 0x00022e,
+		.specifier_id = 0x00022e,
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
 	{
 		.match_flags = IEEE1394_MATCH_VENDOR_ID |
-			       IEEE1394_MATCH_SPECIFIER_ID,
+			       IEEE1394_MATCH_SPECIFIER_ID |
+			       IEEE1394_MATCH_VERSION,
 		.vendor_id = 0x00022e,
 		.specifier_id = 0x00022e,
+		.version = 0x800004,
 	},
 	{}
 };


