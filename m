Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6FD38EEFA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhEXPzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235008AbhEXPy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED3066191B;
        Mon, 24 May 2021 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870812;
        bh=6uPdLOtWDwPTg23SaBpdldN7cAfKsfp4eOLSq3ZdXgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7ABEu59Ny1drFB1BltKZsJ/h63hzH7z4Gekf3bjNCOAnc4zHY6m9EuJsUfHZCWYR
         8rbuEAks77SasghZ3kiZHiVwCGgrx6M/KEdhi7nxD8OTfZ9ZCIXnTpDkooe38l3X+3
         CUlBDF4aN/G6M4oG/JtH09TQCZdR9AOtq6fGxU/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 038/104] ALSA: dice: fix stream format at middle sampling rate for Alesis iO 26
Date:   Mon, 24 May 2021 17:25:33 +0200
Message-Id: <20210524152334.094681399@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 1b6604896e78969baffc1b6cc6bc175f95929ac4 upstream.

Alesis iO 26 FireWire has two pairs of digital optical interface. It
delivers PCM frames from the interfaces by second isochronous packet
streaming. Although both of the interfaces are available at 44.1/48.0
kHz, first one of them is only available at 88.2/96.0 kHz. It reduces
the number of PCM samples to 4 in Multi Bit Linear Audio data channel
of data blocks on the second isochronous packet streaming.

This commit fixes hardcoded stream formats.

Cc: <stable@vger.kernel.org>
Fixes: 28b208f600a3 ("ALSA: dice: add parameters of stream formats for models produced by Alesis")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210513125652.110249-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/dice/dice-alesis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/dice/dice-alesis.c
+++ b/sound/firewire/dice/dice-alesis.c
@@ -16,7 +16,7 @@ alesis_io14_tx_pcm_chs[MAX_STREAMS][SND_
 static const unsigned int
 alesis_io26_tx_pcm_chs[MAX_STREAMS][SND_DICE_RATE_MODE_COUNT] = {
 	{10, 10, 4},	/* Tx0 = Analog + S/PDIF. */
-	{16, 8, 0},	/* Tx1 = ADAT1 + ADAT2. */
+	{16, 4, 0},	/* Tx1 = ADAT1 + ADAT2 (available at low rate). */
 };
 
 int snd_dice_detect_alesis_formats(struct snd_dice *dice)


