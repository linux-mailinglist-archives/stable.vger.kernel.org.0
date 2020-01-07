Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A851334A2
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgAGV1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:27:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbgAGU6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4621E24679;
        Tue,  7 Jan 2020 20:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430688;
        bh=b6hHzhhH4j4yJWEfAwTZPH2tgCJ0peR/nIhwBna9zBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iH4P6A8XKKLlANHO0PxcPvMOAevNka07w/FtUq6YXLMRdy24n+vSziNAkBqyVFogD
         CNd0RQF3bJreiI+Dy9akbUt5KccOhjBzDwZPn0cCYRWWsBzXRUPM6wHn3PpU6FoY+N
         2FLHXaIp/uM5yJKNwC+oHoe4o1HeAGFI6qlxwzaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/191] ALSA: hda: Allow HDA to be runtime suspended when dGPU is not bound to a driver
Date:   Tue,  7 Jan 2020 21:52:56 +0100
Message-Id: <20200107205335.996172425@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit bacd861452d2be86a4df341b12e32db7dac8021e ]

Nvidia proprietary driver doesn't support runtime power management, so
when a user only wants to use the integrated GPU, it's a common practice
to let dGPU not to bind any driver, and let its upstream port to be
runtime suspended. At the end of runtime suspension the port uses
platform power management to disable power through _OFF method of power
resource, which is listed by _PR3.

After commit b516ea586d71 ("PCI: Enable NVIDIA HDA controllers"), when
the dGPU comes with an HDA function, the HDA won't be suspended if the
dGPU is unbound, so the power resource can't be turned off by its
upstream port driver.

Commit 37a3a98ef601 ("ALSA: hda - Enable runtime PM only for
discrete GPU") only allows HDA to be runtime suspended once GPU is
bound, to keep APU's HDA working.

However, HDA on dGPU isn't that useful if dGPU is not bound to any
driver.  So let's relax the runtime suspend requirement for dGPU's HDA
function, to disable the power source to save lots of power.

BugLink: https://bugs.launchpad.net/bugs/1840835
Fixes: b516ea586d71 ("PCI: Enable NVIDIA HDA controllers")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20191018073848.14590-2-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 86a416cdeb29..4e757aa9d322 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1280,11 +1280,17 @@ static void init_vga_switcheroo(struct azx *chip)
 {
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 	struct pci_dev *p = get_bound_vga(chip->pci);
+	struct pci_dev *parent;
 	if (p) {
 		dev_info(chip->card->dev,
 			 "Handle vga_switcheroo audio client\n");
 		hda->use_vga_switcheroo = 1;
-		chip->bus.keep_power = 1; /* cleared in either gpu_bound op or codec probe */
+
+		/* cleared in either gpu_bound op or codec probe, or when its
+		 * upstream port has _PR3 (i.e. dGPU).
+		 */
+		parent = pci_upstream_bridge(p);
+		chip->bus.keep_power = parent ? !pci_pr3_present(parent) : 1;
 		chip->driver_caps |= AZX_DCAPS_PM_RUNTIME;
 		pci_dev_put(p);
 	}
-- 
2.20.1



