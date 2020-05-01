Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52FF1C1538
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgEANqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731744AbgEANo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:44:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62CBC20757;
        Fri,  1 May 2020 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340666;
        bh=M1z3zsP5aQW5/15IlODjI3cgmA2AHNWa2283H9/XnqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1N1CFu2+UecN1aCpeWjnfHq9wz9hYB8Ooaea2C19scPI+XwiLLmjkqK3GuTf/htAJ
         4IFPal+WkUaDfcb2kAUuwyedyTWte8MFhyQ5JLUh+LOmxSHsJ1pzttTK9csdooyx6w
         X24aiwxpeYHH+t18ZNhlM/uRjR8bXhgByinxShXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 074/106] ALSA: hda: Release resources at error in delayed probe
Date:   Fri,  1 May 2020 15:23:47 +0200
Message-Id: <20200501131552.865351475@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 2393e7555b531a534152ffe7bfd1862cacedaacb ]

snd-hda-intel driver handles the most of its probe task in the delayed
work (either via workqueue or via firmware loader).  When an error
happens in the later delayed probe, we can't deregister the device
itself because the probe callback already returned success and the
device was bound.  So, for now, we set hda->init_failed flag and make
the rest untouched until the device gets really unbound.
However, this leaves the device up running, keeping the resources
without any use that prevents other operations.

In this patch, we release the resources at first when a probe error
happens in the delayed probe stage, but keeps the top-level object, so
that the PM and other ops can still refer to the object itself.

Also for simplicity, snd_hda_intel object is allocated via devm, so
that we can get rid of the explicit kfree calls.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207043
Link: https://lore.kernel.org/r/20200413082034.25166-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 29 ++++++++++++++++-------------
 sound/pci/hda/hda_intel.h |  1 +
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index af21e9583c0d3..3047dc357b38b 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1203,10 +1203,8 @@ static void azx_vs_set_state(struct pci_dev *pci,
 		if (!disabled) {
 			dev_info(chip->card->dev,
 				 "Start delayed initialization\n");
-			if (azx_probe_continue(chip) < 0) {
+			if (azx_probe_continue(chip) < 0)
 				dev_err(chip->card->dev, "initialization error\n");
-				hda->init_failed = true;
-			}
 		}
 	} else {
 		dev_info(chip->card->dev, "%s via vga_switcheroo\n",
@@ -1339,12 +1337,15 @@ static int register_vga_switcheroo(struct azx *chip)
 /*
  * destructor
  */
-static int azx_free(struct azx *chip)
+static void azx_free(struct azx *chip)
 {
 	struct pci_dev *pci = chip->pci;
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 	struct hdac_bus *bus = azx_bus(chip);
 
+	if (hda->freed)
+		return;
+
 	if (azx_has_pm_runtime(chip) && chip->running)
 		pm_runtime_get_noresume(&pci->dev);
 	chip->running = 0;
@@ -1388,9 +1389,8 @@ static int azx_free(struct azx *chip)
 
 	if (chip->driver_caps & AZX_DCAPS_I915_COMPONENT)
 		snd_hdac_i915_exit(bus);
-	kfree(hda);
 
-	return 0;
+	hda->freed = 1;
 }
 
 static int azx_dev_disconnect(struct snd_device *device)
@@ -1406,7 +1406,8 @@ static int azx_dev_disconnect(struct snd_device *device)
 
 static int azx_dev_free(struct snd_device *device)
 {
-	return azx_free(device->device_data);
+	azx_free(device->device_data);
+	return 0;
 }
 
 #ifdef SUPPORT_VGA_SWITCHEROO
@@ -1773,7 +1774,7 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 	if (err < 0)
 		return err;
 
-	hda = kzalloc(sizeof(*hda), GFP_KERNEL);
+	hda = devm_kzalloc(&pci->dev, sizeof(*hda), GFP_KERNEL);
 	if (!hda) {
 		pci_disable_device(pci);
 		return -ENOMEM;
@@ -1814,7 +1815,6 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 
 	err = azx_bus_init(chip, model[dev]);
 	if (err < 0) {
-		kfree(hda);
 		pci_disable_device(pci);
 		return err;
 	}
@@ -2339,13 +2339,16 @@ static int azx_probe_continue(struct azx *chip)
 		pm_runtime_put_autosuspend(&pci->dev);
 
 out_free:
-	if (err < 0 || !hda->need_i915_power)
+	if (err < 0) {
+		azx_free(chip);
+		return err;
+	}
+
+	if (!hda->need_i915_power)
 		display_power(chip, false);
-	if (err < 0)
-		hda->init_failed = 1;
 	complete_all(&hda->probe_wait);
 	to_hda_bus(bus)->bus_probing = 0;
-	return err;
+	return 0;
 }
 
 static void azx_remove(struct pci_dev *pci)
diff --git a/sound/pci/hda/hda_intel.h b/sound/pci/hda/hda_intel.h
index 2acfff3da1a04..3fb119f090408 100644
--- a/sound/pci/hda/hda_intel.h
+++ b/sound/pci/hda/hda_intel.h
@@ -27,6 +27,7 @@ struct hda_intel {
 	unsigned int use_vga_switcheroo:1;
 	unsigned int vga_switcheroo_registered:1;
 	unsigned int init_failed:1; /* delayed init failed */
+	unsigned int freed:1; /* resources already released */
 
 	bool need_i915_power:1; /* the hda controller needs i915 power */
 };
-- 
2.20.1



