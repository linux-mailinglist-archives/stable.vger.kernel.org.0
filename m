Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A91B2666A0
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgIKRag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgIKM4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:56:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A59AD22249;
        Fri, 11 Sep 2020 12:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828903;
        bh=4UwAwY108elDYdJj/b91viIve21RQvKuhMtyBTpMSJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b33U/8oerozCOzf4BTHR+00vk0jUkIMIicfsfLo5lz9KECX9gGG7uYZiuZ1BMaEDj
         oyrckYiS8g48O4CUX1QFEYIej594V0JtWZxYAXDrnrNgdQ+hRIBz81zv7Mk+LfG+Zb
         VjDlHs/WZOPIfSlzFmGq9tTHU2647BqKNLDaBC2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 51/62] ALSA: firewire-digi00x: add support for console models of Digi00x series
Date:   Fri, 11 Sep 2020 14:46:34 +0200
Message-Id: <20200911122504.936717931@linuxfoundation.org>
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

[ Upstream commit 13e005f9f933a35b5e55c9d36f151efe2a8383ec ]

Digi00x series includes two types of unit; rack and console. As long as
reading information on config rom of Digi 002 console, 'MODEL_ID' field
has a different value from the one on Digi 002 rack.

We've already got a test report from users with Digi 003 rack. We can
assume that console type and rack type has different value in the field.

This commit adds a device entry for console type. For following commits,
this commit also adds a member to 'struct snd_digi00x' to identify console
type.

$ cd linux-firewire-utils/src
$ python2 ./crpp < /sys/bus/firewire/devices/fw1/config_rom
               ROM header and bus information block
               -----------------------------------------------------------------
400  0404f9d0  bus_info_length 4, crc_length 4, crc 63952
404  31333934  bus_name "1394"
408  60647002  irmc 0, cmc 1, isc 1, bmc 0, cyc_clk_acc 100, max_rec 7 (256)
40c  00a07e00  company_id 00a07e     |
410  00a30000  device_id 0000a30000  | EUI-64 00a07e0000a30000

               root directory
               -----------------------------------------------------------------
414  00058a39  directory_length 5, crc 35385
418  0c0043a0  node capabilities
41c  04000001  hardware version
420  0300a07e  vendor
424  81000007  --> descriptor leaf at 440
428  d1000001  --> unit directory at 42c

               unit directory at 42c
               -----------------------------------------------------------------
42c  00046674  directory_length 4, crc 26228
430  120000a3  specifier id
434  13000001  version
438  17000001  model
43c  81000007  --> descriptor leaf at 458

               descriptor leaf at 440
               -----------------------------------------------------------------
440  00055913  leaf_length 5, crc 22803
444  000050f2  descriptor_type 00, specifier_ID 50f2
448  80000000
44c  44696769
450  64657369
454  676e0000

               descriptor leaf at 458
               -----------------------------------------------------------------
458  0004a6fd  leaf_length 4, crc 42749
45c  00000000  textual descriptor
460  00000000  minimal ASCII
464  44696769  "Digi"
468  20303032  " 002"

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/digi00x/digi00x.c | 13 +++++++++++--
 sound/firewire/digi00x/digi00x.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/digi00x/digi00x.c b/sound/firewire/digi00x/digi00x.c
index 1f33b7a1fca4c..6973a7ff1c503 100644
--- a/sound/firewire/digi00x/digi00x.c
+++ b/sound/firewire/digi00x/digi00x.c
@@ -13,7 +13,8 @@ MODULE_AUTHOR("Takashi Sakamoto <o-takashi@sakamocchi.jp>");
 MODULE_LICENSE("GPL v2");
 
 #define VENDOR_DIGIDESIGN	0x00a07e
-#define MODEL_DIGI00X		0x000002
+#define MODEL_CONSOLE		0x000001
+#define MODEL_RACK		0x000002
 
 static int name_card(struct snd_dg00x *dg00x)
 {
@@ -75,6 +76,8 @@ static int snd_dg00x_probe(struct fw_unit *unit,
 	spin_lock_init(&dg00x->lock);
 	init_waitqueue_head(&dg00x->hwdep_wait);
 
+	dg00x->is_console = entry->model_id == MODEL_CONSOLE;
+
 	err = name_card(dg00x);
 	if (err < 0)
 		goto error;
@@ -138,7 +141,13 @@ static const struct ieee1394_device_id snd_dg00x_id_table[] = {
 		.match_flags = IEEE1394_MATCH_VENDOR_ID |
 			       IEEE1394_MATCH_MODEL_ID,
 		.vendor_id = VENDOR_DIGIDESIGN,
-		.model_id = MODEL_DIGI00X,
+		.model_id = MODEL_CONSOLE,
+	},
+	{
+		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_MODEL_ID,
+		.vendor_id = VENDOR_DIGIDESIGN,
+		.model_id = MODEL_RACK,
 	},
 	{}
 };
diff --git a/sound/firewire/digi00x/digi00x.h b/sound/firewire/digi00x/digi00x.h
index 907e739936777..d641a0cf077a3 100644
--- a/sound/firewire/digi00x/digi00x.h
+++ b/sound/firewire/digi00x/digi00x.h
@@ -57,6 +57,7 @@ struct snd_dg00x {
 	/* For asynchronous MIDI controls. */
 	struct snd_rawmidi_substream *in_control;
 	struct snd_fw_async_midi_port out_control;
+	bool is_console;
 };
 
 #define DG00X_ADDR_BASE		0xffffe0000000ull
-- 
2.25.1



