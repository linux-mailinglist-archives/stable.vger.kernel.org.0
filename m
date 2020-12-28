Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75242E3F9A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503339AbgL1O1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503370AbgL1OZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7468122B2C;
        Mon, 28 Dec 2020 14:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165517;
        bh=80Df07jw8u0rPfckof6unHZA8g2+cWiNH7Dx5mLknAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdY8Aw0o5qW+2FS4yN3CR8KGQkW1phwOQZA1hZ/D4S4zskAsbTP7qtm9xTwv5XhMO
         PjCDxdYQO/BD1wNOSwRq2o28I3eMBX6QbID5y5GFjmpMgbgisv4zSR6WwgrLMA5GQQ
         Cg4l0bRGt2t9lPgj9mrPlgmeo0q/j7klUpJyZxWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 560/717] ASoC: cx2072x: Fix doubly definitions of Playback and Capture streams
Date:   Mon, 28 Dec 2020 13:49:18 +0100
Message-Id: <20201228125047.753708470@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0d024a8bec084205fdd9fa17479ba91f45f85db3 upstream.

The cx2072x codec driver defines multiple DAIs with the same stream
name "Playback" and "Capture".  Although the current code works more
or less as is as the secondary streams are never used, it still leads
the error message like:
 debugfs: File 'Playback' in directory 'dapm' already present!
 debugfs: File 'Capture' in directory 'dapm' already present!

Fix it by renaming the secondary streams to unique names.

Fixes: a497a4363706 ("ASoC: Add support for Conexant CX2072X CODEC")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20201208135154.9188-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cx2072x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/cx2072x.c
+++ b/sound/soc/codecs/cx2072x.c
@@ -1579,7 +1579,7 @@ static struct snd_soc_dai_driver soc_cod
 		.id	= CX2072X_DAI_DSP,
 		.probe = cx2072x_dsp_dai_probe,
 		.playback = {
-			.stream_name = "Playback",
+			.stream_name = "DSP Playback",
 			.channels_min = 2,
 			.channels_max = 2,
 			.rates = CX2072X_RATES_DSP,
@@ -1591,7 +1591,7 @@ static struct snd_soc_dai_driver soc_cod
 		.name = "cx2072x-aec",
 		.id	= 3,
 		.capture = {
-			.stream_name = "Capture",
+			.stream_name = "AEC Capture",
 			.channels_min = 2,
 			.channels_max = 2,
 			.rates = CX2072X_RATES_DSP,


