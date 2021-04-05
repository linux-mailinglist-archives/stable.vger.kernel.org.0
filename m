Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F000F353EE0
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbhDEJIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238450AbhDEJI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF41D61398;
        Mon,  5 Apr 2021 09:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613699;
        bh=EHhROrWROsdDyDhkul3eab85ZEopNBBWliAqr7cS4UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oW7hDhH78b9Qe/UnKfRCECGontr4L9SGs0wls82m4YKZVzxSeJukMxclFinHdYeUd
         9grjaHFsW3Xr8/VsyXkLRtmUbtHx1R5lx0GQgL5WRfTCfeELNorS/AvkA4NN+8WD6C
         A2Dfb8zgZIW4WTJwlKrgrCBkyOBQhxinKaG5Su2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 059/126] ALSA: hda: Add missing sanity checks in PM prepare/complete callbacks
Date:   Mon,  5 Apr 2021 10:53:41 +0200
Message-Id: <20210405085033.006776298@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 66affb7bb0dc0905155a1b2475261aa704d1ddb5 upstream.

The recently added PM prepare and complete callbacks don't have the
sanity check whether the card instance has been properly initialized,
which may potentially lead to Oops.

This patch adds the azx_is_pm_ready() call in each place
appropriately like other PM callbacks.

Fixes: f5dac54d9d93 ("ALSA: hda: Separate runtime and system suspend")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210329113059.25035-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1023,6 +1023,9 @@ static int azx_prepare(struct device *de
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip;
 
+	if (!azx_is_pm_ready(card))
+		return 0;
+
 	chip = card->private_data;
 	chip->pm_prepared = 1;
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
@@ -1040,6 +1043,9 @@ static void azx_complete(struct device *
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip;
 
+	if (!azx_is_pm_ready(card))
+		return;
+
 	chip = card->private_data;
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 	chip->pm_prepared = 0;


