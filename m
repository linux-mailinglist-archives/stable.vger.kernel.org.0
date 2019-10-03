Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48B5CA9AF
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbfJCQqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392196AbfJCQqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:46:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D164220867;
        Thu,  3 Oct 2019 16:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121173;
        bh=XhKIrUahQlqk4SXDAope8+7LBJRm3FUya3fBd/Mo1FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+s4SYSydgLl1rRj5bLQfe9Yj+NCfpaZia+z6uQl30DusLMQsI9qrnIoYOLW/E5bS
         bUBBiL0gTuOeF1n5Nvh2EpH+/fqlEGDGqd2gwefPlKM4d1EPgjuDkR/D4e8vW9pXNq
         fTnEWAruZTRi2H0h79feyS2dFj11Waho40oRIXf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 180/344] ALSA: firewire-motu: add support for MOTU 4pre
Date:   Thu,  3 Oct 2019 17:52:25 +0200
Message-Id: <20191003154557.964089743@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 6af86bdb8ad41f4cf1292d3b10857dc322758328 ]

MOTU 4pre was launched in 2012 by MOTU, Inc. This commit allows userspace
applications can transmit and receive PCM frames and MIDI messages for
this model via ALSA PCM interface and RawMidi/Sequencer interfaces.

The device supports MOTU protocol version 3. Unlike the other devices, the
device is simply designed. The size of data block is fixed to 10 quadlets
during available sampling rates (44.1 - 96.0 kHz). Each data block
includes 1 source packet header, 2 data chunks for messages, 8 data chunks
for PCM samples and 2 data chunks for padding to quadlet alignment. The
device has no MIDI, optical, BNC and AES/EBU interfaces.

Like support for the other MOTU devices, the quality of playback sound
is not enough good with periodical noise yet.

$ python2 crpp < ~/git/am-config-rom/motu/motu-4pre.img
               ROM header and bus information block
               -----------------------------------------------------------------
400  041078cc  bus_info_length 4, crc_length 16, crc 30924
404  31333934  bus_name "1394"
408  20ff7000  irmc 0, cmc 0, isc 1, bmc 0, cyc_clk_acc 255, max_rec 7 (256)
40c  0001f200  company_id 0001f2     |
410  000a41c5  device_id 00000a41c5  | EUI-64 0001f200000a41c5

               root directory
               -----------------------------------------------------------------
414  0004ef04  directory_length 4, crc 61188
418  030001f2  vendor
41c  0c0083c0  node capabilities per IEEE 1394
420  d1000002  --> unit directory at 428
424  8d000005  --> eui-64 leaf at 438

               unit directory at 428
               -----------------------------------------------------------------
428  0003ceda  directory_length 3, crc 52954
42c  120001f2  specifier id
430  13000045  version
434  17103800  model

               eui-64 leaf at 438
               -----------------------------------------------------------------
438  0002d248  leaf_length 2, crc 53832
43c  0001f200  company_id 0001f2     |
440  000a41c5  device_id 00000a41c5  | EUI-64 0001f200000a41c5

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/motu/motu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/firewire/motu/motu.c b/sound/firewire/motu/motu.c
index 03cda2166ea3d..72908b4de77c0 100644
--- a/sound/firewire/motu/motu.c
+++ b/sound/firewire/motu/motu.c
@@ -247,6 +247,17 @@ static const struct snd_motu_spec motu_audio_express = {
 	.analog_out_ports = 4,
 };
 
+static const struct snd_motu_spec motu_4pre = {
+	.name = "4pre",
+	.protocol = &snd_motu_protocol_v3,
+	.flags = SND_MOTU_SPEC_SUPPORT_CLOCK_X2 |
+		 SND_MOTU_SPEC_TX_MICINST_CHUNK |
+		 SND_MOTU_SPEC_TX_RETURN_CHUNK |
+		 SND_MOTU_SPEC_RX_SEPARETED_MAIN,
+	.analog_in_ports = 2,
+	.analog_out_ports = 2,
+};
+
 #define SND_MOTU_DEV_ENTRY(model, data)			\
 {							\
 	.match_flags	= IEEE1394_MATCH_VENDOR_ID |	\
@@ -265,6 +276,7 @@ static const struct ieee1394_device_id motu_id_table[] = {
 	SND_MOTU_DEV_ENTRY(0x000015, &motu_828mk3),	/* FireWire only. */
 	SND_MOTU_DEV_ENTRY(0x000035, &motu_828mk3),	/* Hybrid. */
 	SND_MOTU_DEV_ENTRY(0x000033, &motu_audio_express),
+	SND_MOTU_DEV_ENTRY(0x000045, &motu_4pre),
 	{ }
 };
 MODULE_DEVICE_TABLE(ieee1394, motu_id_table);
-- 
2.20.1



