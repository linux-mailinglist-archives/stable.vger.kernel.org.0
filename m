Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A972037449F
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbhEEQ6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236079AbhEEQ4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:56:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2208861993;
        Wed,  5 May 2021 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232750;
        bh=L40hcuFjXBEMwH8EYrimSoIFlROA8Eps/UJXGasiQKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmaQ4jsZa46MouDYprhL4oPdd31Ef9LG/brg2JIAyl0QhALMXUpJzq7ELZYM44nrj
         qKt81WfPyEH6NsSc2Zr09fGJn5ExNVZ1LykklOz9AL3pYCV9KnH7x2PFHPSKdzczs7
         mUQoEvMUELfspq8hDPlBgbZmgbn/GgJaWXgcWlpCtYsPHsi6Ik7isrHX2xUtUQBhyM
         nFp8Xx0NF7GR69HTQ+eueyeag5jz6ZAHgQF1BP5/y7MA/yl4bBkk9OZEdKv7WWttoJ
         67aackvFHU4eso0TTmSWmQwcN7wPxuW33qgkaqiuhJfkXYJ0dLUieSJt50Z08WsNvN
         4umDgROzDIQVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 10/46] ALSA: bebob: enable to deliver MIDI messages for multiple ports
Date:   Wed,  5 May 2021 12:38:20 -0400
Message-Id: <20210505163856.3463279-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ce07ea0d4e71..3935e90c8e8f 100644
--- a/sound/firewire/bebob/bebob_stream.c
+++ b/sound/firewire/bebob/bebob_stream.c
@@ -534,20 +534,22 @@ int snd_bebob_stream_init_duplex(struct snd_bebob *bebob)
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

