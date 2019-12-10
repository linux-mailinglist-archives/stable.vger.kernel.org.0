Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128EA1196A8
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfLJVKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbfLJVKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78F1E246AD;
        Tue, 10 Dec 2019 21:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012220;
        bh=QLCQh0vfV7h/ZjC9RNBV9ppkij/a1m7fig8tN2/1+Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EB3oeAZHDppBQIVMS7t9sdZ/KMxxloRuZ6AJ5TpyRFjrIjfe9+v7F+cBNMRcREiiL
         JXd/+VnS64mDU1QhA199ALrfoDncOmSShZXomajMKSj5cVLKahfFu3R3aT2vpqIM28
         qFGlHUOrj96paTx2GRl8SrZSkjhYns2YP1qWyXKY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 170/350] ALSA: hda - Fix pending unsol events at shutdown
Date:   Tue, 10 Dec 2019 16:04:35 -0500
Message-Id: <20191210210735.9077-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ca58f55108fee41d87c9123f85ad4863e5de7f45 ]

This is an alternative fix attemp for the issue reported in the commit
caa8422d01e9 ("ALSA: hda: Flush interrupts on disabling") that was
reverted later due to regressions.  Instead of tweaking the hardware
disablement order and the enforced irq flushing, do calling
cancel_work_sync() of the unsol work early enough, and explicitly
ignore the unsol events during the shutdown by checking the
bus->shutdown flag.

Fixes: caa8422d01e9 ("ALSA: hda: Flush interrupts on disabling")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://lore.kernel.org/r/s5h1ruxt9cz.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_bind.c  | 4 ++++
 sound/pci/hda/hda_intel.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 8272b50b83493..6a85645663759 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -43,6 +43,10 @@ static void hda_codec_unsol_event(struct hdac_device *dev, unsigned int ev)
 {
 	struct hda_codec *codec = container_of(dev, struct hda_codec, core);
 
+	/* ignore unsol events during shutdown */
+	if (codec->bus->shutdown)
+		return;
+
 	if (codec->patch_ops.unsol_event)
 		codec->patch_ops.unsol_event(codec, ev);
 }
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index c52419376c748..86a416cdeb296 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1382,8 +1382,11 @@ static int azx_free(struct azx *chip)
 static int azx_dev_disconnect(struct snd_device *device)
 {
 	struct azx *chip = device->device_data;
+	struct hdac_bus *bus = azx_bus(chip);
 
 	chip->bus.shutdown = 1;
+	cancel_work_sync(&bus->unsol_work);
+
 	return 0;
 }
 
-- 
2.20.1

