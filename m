Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319C4C1535
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfI2OCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730109AbfI2OCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94DF92082F;
        Sun, 29 Sep 2019 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765718;
        bh=rg1m6UnFhcxOaDXtA3qfOIvCLZHYb3NhucEHI4MbCGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWhelMvTNtgyKBXv8DxyVNJywFaZlqHZfoBM8fHPIuCUyDwgUDsT/bRWJFM2ZQyhO
         g5g9T+8QDEEsytTyLsNE93TUGrtvJvFZt/qej0J4r/muRbTCm+1tFquPL5xXPq24+w
         60uHtW1feof1GJkMe9hF7i82M5m4iDeJ4PUIpxZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 25/45] ALSA: dice: fix wrong packet parameter for Alesis iO26
Date:   Sun, 29 Sep 2019 15:55:53 +0200
Message-Id: <20190929135031.279014406@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 3a9236e97207f2469254b4098995159b80174d95 upstream.

At higher sampling rate (e.g. 192.0 kHz), Alesis iO26 transfers 4 data
channels per data block in CIP.

Both iO14 and iO26 have the same contents in their configuration ROM.
For this reason, ALSA Dice driver attempts to distinguish them according
to the value of TX0_AUDIO register at probe callback. Although the way is
valid at lower and middle sampling rate, it's lastly invalid at higher
sampling rate because because the two models returns the same value for
read transaction to the register.

In the most cases, users just plug-in the device and ALSA dice driver
detects it. In the case, the device runs at lower sampling rate and
the driver detects expectedly. For this reason, this commit leaves the
way to detect as is.

Fixes: 28b208f600a3 ("ALSA: dice: add parameters of stream formats for models produced by Alesis")
Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20190916101851.30409-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/dice/dice-alesis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/dice/dice-alesis.c
+++ b/sound/firewire/dice/dice-alesis.c
@@ -15,7 +15,7 @@ alesis_io14_tx_pcm_chs[MAX_STREAMS][SND_
 
 static const unsigned int
 alesis_io26_tx_pcm_chs[MAX_STREAMS][SND_DICE_RATE_MODE_COUNT] = {
-	{10, 10, 8},	/* Tx0 = Analog + S/PDIF. */
+	{10, 10, 4},	/* Tx0 = Analog + S/PDIF. */
 	{16, 8, 0},	/* Tx1 = ADAT1 + ADAT2. */
 };
 


