Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6E5451449
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349091AbhKOUCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344311AbhKOTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96BF56365B;
        Mon, 15 Nov 2021 18:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002533;
        bh=jHJ9EuWDwTLlOvDNLGXPSe0N4N42R8Qbm+unTi9E2p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcMXXldT0cBXSmPp3y0Tn8NxOQx9/rGm+yqkv1FLNozheXuCvbbi9+2sHnfMof9lq
         t+bIA5vddo2UQWiZxywVJw6jgB4J2lf0/DusAZkzdArUqyQdjjzyRNld0VtnKOldpa
         RsWdWe9ABZIaUZGkruFGi4E4xZxD7ASd/0zaVsZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 604/917] ALSA: hda: Use position buffer for SKL+ again
Date:   Mon, 15 Nov 2021 18:01:39 +0100
Message-Id: <20211115165449.250603455@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c4ca3871e21fa085096316f5f8d9975cf3dfde1d ]

The commit f87e7f25893d ("ALSA: hda - Improved position reporting on
SKL+") changed the PCM position report for SKL+ chips to use DPIB, but
according to Pierre, DPIB is no best choice for the accurate position
reports and it often reports too early.  The recommended method is
rather the classical position buffer.

This patch makes the PCM position reporting on SKL+ back to the
position buffer again.

Fixes: f87e7f25893d ("ALSA: hda - Improved position reporting on SKL+")
Suggested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210929072934.6809-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 95b9a615c47ca..90e9263ac0bd7 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -881,27 +881,6 @@ static int azx_get_delay_from_fifo(struct azx *chip, struct azx_dev *azx_dev,
 	return substream->runtime->delay;
 }
 
-static unsigned int azx_skl_get_dpib_pos(struct azx *chip,
-					 struct azx_dev *azx_dev)
-{
-	return _snd_hdac_chip_readl(azx_bus(chip),
-				    AZX_REG_VS_SDXDPIB_XBASE +
-				    (AZX_REG_VS_SDXDPIB_XINTERVAL *
-				     azx_dev->core.index));
-}
-
-/* get the current DMA position with correction on SKL+ chips */
-static unsigned int azx_get_pos_skl(struct azx *chip, struct azx_dev *azx_dev)
-{
-	/* DPIB register gives a more accurate position for playback */
-	if (azx_dev->core.substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		return azx_skl_get_dpib_pos(chip, azx_dev);
-
-	/* read of DPIB fetches the actual posbuf */
-	azx_skl_get_dpib_pos(chip, azx_dev);
-	return azx_get_pos_posbuf(chip, azx_dev);
-}
-
 static void __azx_shutdown_chip(struct azx *chip, bool skip_link_reset)
 {
 	azx_stop_chip(chip);
@@ -1591,7 +1570,7 @@ static void assign_position_fix(struct azx *chip, int fix)
 		[POS_FIX_POSBUF] = azx_get_pos_posbuf,
 		[POS_FIX_VIACOMBO] = azx_via_get_position,
 		[POS_FIX_COMBO] = azx_get_pos_lpib,
-		[POS_FIX_SKL] = azx_get_pos_skl,
+		[POS_FIX_SKL] = azx_get_pos_posbuf,
 		[POS_FIX_FIFO] = azx_get_pos_fifo,
 	};
 
-- 
2.33.0



