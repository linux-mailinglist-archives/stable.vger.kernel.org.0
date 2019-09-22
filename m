Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A670BA6F0
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404378AbfIVSyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404294AbfIVSyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:54:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1588A2190F;
        Sun, 22 Sep 2019 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178460;
        bh=Cf4Wd4dqhlenxxCWrCyFZa1Vh2QvD9KHlalJzrSXLOw=;
        h=From:To:Cc:Subject:Date:From;
        b=sQK7sH7XmeyphkUEAmr5NUZv/iLIUt5A89+wVZmN2KR78fBDl67aVjUzXt3/PuKNU
         996OWgTSfaB8qsfT4SuFESxA3bmrzzdgjE6SzEtks/Bru6KjpS//MHiXT1rUXSolMM
         ocAV1vd2+098yKp9KkdDli50FcW22X/s2HaoGHzY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 001/128] ALSA: hda: Flush interrupts on disabling
Date:   Sun, 22 Sep 2019 14:52:11 -0400
Message-Id: <20190922185418.2158-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit caa8422d01e983782548648e125fd617cadcec3f ]

I was looking at

<4> [241.835158] general protection fault: 0000 [#1] PREEMPT SMP PTI
<4> [241.835181] CPU: 1 PID: 214 Comm: kworker/1:3 Tainted: G     U            5.2.0-CI-CI_DRM_6509+ #1
<4> [241.835199] Hardware name: Dell Inc.                 OptiPlex 745                 /0GW726, BIOS 2.3.1  05/21/2007
<4> [241.835234] Workqueue: events snd_hdac_bus_process_unsol_events [snd_hda_core]
<4> [241.835256] RIP: 0010:input_handle_event+0x16d/0x5e0
<4> [241.835270] Code: 48 8b 93 58 01 00 00 8b 52 08 89 50 04 8b 83 f8 06 00 00 48 8b 93 00 07 00 00 8d 70 01 48 8d 04 c2 83 e1 08 89 b3 f8 06 00 00 <66> 89 28 66 44 89 60 02 44 89 68 04 8b 93 f8 06 00 00 0f 84 fd fe
<4> [241.835304] RSP: 0018:ffffc9000019fda0 EFLAGS: 00010046
<4> [241.835317] RAX: 6b6b6b6ec6c6c6c3 RBX: ffff8880290fefc8 RCX: 0000000000000000
<4> [241.835332] RDX: 000000006b6b6b6b RSI: 000000006b6b6b6c RDI: 0000000000000046
<4> [241.835347] RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000000001
<4> [241.835362] R10: ffffc9000019faa0 R11: 0000000000000000 R12: 0000000000000004
<4> [241.835377] R13: 0000000000000000 R14: ffff8880290ff1d0 R15: 0000000000000293
<4> [241.835392] FS:  0000000000000000(0000) GS:ffff88803de80000(0000) knlGS:0000000000000000
<4> [241.835409] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4> [241.835422] CR2: 00007ffe9a99e9b7 CR3: 000000002f588000 CR4: 00000000000006e0
<4> [241.835436] Call Trace:
<4> [241.835449]  input_event+0x45/0x70
<4> [241.835464]  snd_jack_report+0xdc/0x100
<4> [241.835490]  snd_hda_jack_report_sync+0x83/0xc0 [snd_hda_codec]
<4> [241.835512]  snd_hdac_bus_process_unsol_events+0x5a/0x70 [snd_hda_core]
<4> [241.835530]  process_one_work+0x245/0x610

which has the hallmarks of a worker queued from interrupt after it was
supposedly cancelled (note the POISON_FREE), and I could not see where
the interrupt would be flushed on shutdown so added the likely suspects.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111174
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_controller.c | 2 ++
 sound/pci/hda/hda_intel.c   | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/hda/hdac_controller.c b/sound/hda/hdac_controller.c
index 74244d8e29090..e858b6fa0c3ad 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -443,6 +443,8 @@ static void azx_int_disable(struct hdac_bus *bus)
 	list_for_each_entry(azx_dev, &bus->stream_list, list)
 		snd_hdac_stream_updateb(azx_dev, SD_CTL, SD_INT_MASK, 0);
 
+	synchronize_irq(bus->irq);
+
 	/* disable SIE for all streams */
 	snd_hdac_chip_writeb(bus, INTCTL, 0);
 
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index c3e3d80ff7203..2b8edd343f393 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1455,9 +1455,9 @@ static int azx_free(struct azx *chip)
 	}
 
 	if (bus->chip_init) {
+		azx_stop_chip(chip);
 		azx_clear_irq_pending(chip);
 		azx_stop_all_streams(chip);
-		azx_stop_chip(chip);
 	}
 
 	if (bus->irq >= 0)
-- 
2.20.1

