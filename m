Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6C21B40ED
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgDVKtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbgDVKNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:13:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 743922070B;
        Wed, 22 Apr 2020 10:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550420;
        bh=3HJTmXXcWce+2vY31PeSWp7yk0edXQda+IjiXehcJhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRxvi3SXehnSM31KB6PJIkkZ9Mt4RyfxHIqZRQYqzUTKNFBzgapB+n7LzL9kiRAEt
         sn2rfpSp1E1vp7Pi4DkJzHwJbp/g9MAUflBrb4L26+2ZWdJznNW8B0/TFssc2wontm
         N5rDfhPDPWrWtj0H9IAh0d3ScL0w8JVjXICwpoiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 10/64] ALSA: hda: Dont release card at firmware loading error
Date:   Wed, 22 Apr 2020 11:56:54 +0200
Message-Id: <20200422095014.483066597@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 25faa4bd37c10f19e4b848b9032a17a3d44c6f09 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2076,24 +2076,15 @@ static void azx_firmware_cb(const struct
 {
 	struct snd_card *card = context;
 	struct azx *chip = card->private_data;
-	struct pci_dev *pci = chip->pci;
 
-	if (!fw) {
-		dev_err(card->dev, "Cannot load firmware, aborting\n");
-		goto error;
-	}
-
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
 


