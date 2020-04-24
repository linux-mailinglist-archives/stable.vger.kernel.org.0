Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264E31B743B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgDXMZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgDXMZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:25:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A2E20700;
        Fri, 24 Apr 2020 12:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731105;
        bh=NuRlHIjlB91sUF8amoWtOUcTAyrC/yg678lKo8O7yEI=;
        h=From:To:Cc:Subject:Date:From;
        b=1Z3V5lMd9sVlkZnsFRXb69XxMbUZ/mTZA1+F/8RsAxb5UPCCYD/nwM5p8jwsKCzBP
         /KaP2FKOWtDtAbGwSZ5IujbxksLodazcNSb2M1ppM0A6IseoDzW1pt32jodEr8XhwC
         kiu1F5hKWnSXJRlDrBkE4qJI6yJmzzRqmjos+xHc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 1/8] ALSA: hda: Don't release card at firmware loading error
Date:   Fri, 24 Apr 2020 08:24:56 -0400
Message-Id: <20200424122503.11046-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 25faa4bd37c10f19e4b848b9032a17a3d44c6f09 ]

At the error path of the firmware loading error, the driver tries to
release the card object and set NULL to drvdata.  This may be referred
badly at the possible PM action, as the driver itself is still bound
and the PM callbacks read the card object.

Instead, we continue the probing as if it were no option set.  This is
often a better choice than the forced abort, too.

Fixes: 5cb543dba986 ("ALSA: hda - Deferred probing with request_firmware_nowait()")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207043
Link: https://lore.kernel.org/r/20200413082034.25166-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 3e3277100f08a..0fa0c33660087 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1839,24 +1839,15 @@ static void azx_firmware_cb(const struct firmware *fw, void *context)
 {
 	struct snd_card *card = context;
 	struct azx *chip = card->private_data;
-	struct pci_dev *pci = chip->pci;
-
-	if (!fw) {
-		dev_err(card->dev, "Cannot load firmware, aborting\n");
-		goto error;
-	}
 
-	chip->fw = fw;
+	if (fw)
+		chip->fw = fw;
+	else
+		dev_err(card->dev, "Cannot load firmware, continue without patching\n");
 	if (!chip->disabled) {
 		/* continue probing */
-		if (azx_probe_continue(chip))
-			goto error;
+		azx_probe_continue(chip);
 	}
-	return; /* OK */
-
- error:
-	snd_card_free(card);
-	pci_set_drvdata(pci, NULL);
 }
 #endif
 
-- 
2.20.1

