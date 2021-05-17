Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF7F382ECF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbhEQOLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238071AbhEQOJe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:09:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8F4F611EE;
        Mon, 17 May 2021 14:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260407;
        bh=F+pne/Hjxiv7x9JXuhGkN38R9E5g7VxohpNgBfzPr/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkL9njieqWRSqO/8ZRdxADokpNUQfJZzW5yUrpx4vuyZKi/x+sIasWP248Ij2zgj4
         qB91CzWGb8qQ/WMrOMiSi8YN4Sqb8rdGR9i/FmD5Lrr3h61ADQK1ByaAsBexUuYwsp
         eXJPw253GB9PQtKDzqnT9CSlNSzw7BKOyb6vu0UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 032/363] ALSA: bebob: enable to deliver MIDI messages for multiple ports
Date:   Mon, 17 May 2021 15:58:18 +0200
Message-Id: <20210517140303.686018853@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit d2b6f15bc18ac8fbce25398290774c21f5b2cd44 ]

Current implementation of bebob driver doesn't correctly handle the case
that the device has multiple MIDI ports. The cause is the number of MIDI
conformant data channels is passed to AM824 data block processing layer.

This commit fixes the bug.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210321032831.340278-4-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/bebob/bebob_stream.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/firewire/bebob/bebob_stream.c b/sound/firewire/bebob/bebob_stream.c
index bbae04793c50..c18017e0a3d9 100644
--- a/sound/firewire/bebob/bebob_stream.c
+++ b/sound/firewire/bebob/bebob_stream.c
@@ -517,20 +517,22 @@ int snd_bebob_stream_init_duplex(struct snd_bebob *bebob)
 static int keep_resources(struct snd_bebob *bebob, struct amdtp_stream *stream,
 			  unsigned int rate, unsigned int index)
 {
-	struct snd_bebob_stream_formation *formation;
+	unsigned int pcm_channels;
+	unsigned int midi_ports;
 	struct cmp_connection *conn;
 	int err;
 
 	if (stream == &bebob->tx_stream) {
-		formation = bebob->tx_stream_formations + index;
+		pcm_channels = bebob->tx_stream_formations[index].pcm;
+		midi_ports = bebob->midi_input_ports;
 		conn = &bebob->out_conn;
 	} else {
-		formation = bebob->rx_stream_formations + index;
+		pcm_channels = bebob->rx_stream_formations[index].pcm;
+		midi_ports = bebob->midi_output_ports;
 		conn = &bebob->in_conn;
 	}
 
-	err = amdtp_am824_set_parameters(stream, rate, formation->pcm,
-					 formation->midi, false);
+	err = amdtp_am824_set_parameters(stream, rate, pcm_channels, midi_ports, false);
 	if (err < 0)
 		return err;
 
-- 
2.30.2



