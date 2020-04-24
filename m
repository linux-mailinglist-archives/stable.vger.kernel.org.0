Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D3A1B74D7
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgDXM3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgDXMYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916AE21655;
        Fri, 24 Apr 2020 12:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731042;
        bh=5w0pPWHJ6p8y1WH5Y8SL625yyy4a7ZtFwa0wGR8BOJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deokhw3E/PZ0nAj78IyKxr59VXNaNi1p7IsUDVVEJJAX6lfZWeX9N+bwRq3ea57/Y
         M4of021eaJG5wxk2G5+50bGRfomkPkt+vkwT4Bbe+txEOYO14B6fP52DCGEvlUQPF7
         9u6xrpBOmT2KBOTXM5H+2wW2FU36YA+1wB81xkQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Roy Spliet <nouveau@spliet.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 05/18] ALSA: hda: Keep the controller initialization even if no codecs found
Date:   Fri, 24 Apr 2020 08:23:42 -0400
Message-Id: <20200424122355.10453-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122355.10453-1-sashal@kernel.org>
References: <20200424122355.10453-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9479e75fca370a5220784f7596bf598c4dad0b9b ]

Currently, when the HD-audio controller driver doesn't detect any
codecs, it tries to abort the probe.  But this abort happens at the
delayed probe, i.e. the primary probe call already returned success,
hence the driver is never unbound until user does so explicitly.
As a result, it may leave the HD-audio device in the running state
without the runtime PM.  More badly, if the device is a HD-audio bus
that is tied with a GPU, GPU cannot reach to the full power down and
consumes unnecessarily much power.

This patch changes the logic after no-codec situation; it continues
probing without the further codec initialization but keep the
controller driver running normally.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207043
Tested-by: Roy Spliet <nouveau@spliet.org>
Link: https://lore.kernel.org/r/20200413082034.25166-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 54a9b391ecce0..b993b652ead81 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2054,7 +2054,7 @@ static int azx_first_init(struct azx *chip)
 	/* codec detection */
 	if (!azx_bus(chip)->codec_mask) {
 		dev_err(card->dev, "no codecs found!\n");
-		return -ENODEV;
+		/* keep running the rest for the runtime PM */
 	}
 
 	if (azx_acquire_irq(chip, 0) < 0)
@@ -2441,9 +2441,11 @@ static int azx_probe_continue(struct azx *chip)
 #endif
 
 	/* create codec instances */
-	err = azx_probe_codecs(chip, azx_max_codecs[chip->driver_type]);
-	if (err < 0)
-		goto out_free;
+	if (bus->codec_mask) {
+		err = azx_probe_codecs(chip, azx_max_codecs[chip->driver_type]);
+		if (err < 0)
+			goto out_free;
+	}
 
 #ifdef CONFIG_SND_HDA_PATCH_LOADER
 	if (chip->fw) {
@@ -2457,7 +2459,7 @@ static int azx_probe_continue(struct azx *chip)
 #endif
 	}
 #endif
-	if ((probe_only[dev] & 1) == 0) {
+	if (bus->codec_mask && !(probe_only[dev] & 1)) {
 		err = azx_codec_configure(chip);
 		if (err < 0)
 			goto out_free;
-- 
2.20.1

