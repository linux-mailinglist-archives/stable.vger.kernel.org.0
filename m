Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0283C4B76
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbhGLG5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239554AbhGLG40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD64C611B0;
        Mon, 12 Jul 2021 06:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072818;
        bh=ByUDmKPkm879Guxqu+tJMet4VjQuRfdUKxJqad5il4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VitvHQ6OEoYKCNcDEBPvbV1hyMQh9PwIlkS3nM4GAoinN0bRNQYxPMd72GkcSwR94
         cQpPGHDsFjNCrZ4A0Y0ZL7gXnlpdH7qvuMua4H+wFjILtt0JPEIGhW7pTBU5iUVQUS
         skWXWWBjeNV00x9n9UlAjGdGuCItZgjG/QCObplE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 006/700] ALSA: firewire-motu: fix stream format for MOTU 8pre FireWire
Date:   Mon, 12 Jul 2021 08:01:29 +0200
Message-Id: <20210712060925.673395934@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit fc36ef80ca2c68b2c9df06178048f08280e4334f upstream.

My previous refactoring for ALSA firewire-motu driver brought regression
to handle MOTU 8pre FireWire. The packet format is not operated correctly.

Cc: <stable@vger.kernel.org>
Fixes: dfbaa4dc11eb ("ALSA: firewire-motu: add model-specific table of chunk count")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210614083133.39753-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/motu/motu-protocol-v2.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/firewire/motu/motu-protocol-v2.c
+++ b/sound/firewire/motu/motu-protocol-v2.c
@@ -353,6 +353,7 @@ const struct snd_motu_spec snd_motu_spec
 	.protocol_version = SND_MOTU_PROTOCOL_V2,
 	.flags = SND_MOTU_SPEC_RX_MIDI_2ND_Q |
 		 SND_MOTU_SPEC_TX_MIDI_2ND_Q,
-	.tx_fixed_pcm_chunks = {10, 6, 0},
-	.rx_fixed_pcm_chunks = {10, 6, 0},
+	// Two dummy chunks always in the end of data block.
+	.tx_fixed_pcm_chunks = {10, 10, 0},
+	.rx_fixed_pcm_chunks = {6, 6, 0},
 };


