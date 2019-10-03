Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F65CA18F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbfJCP5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730858AbfJCP5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:57:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 463FF222C2;
        Thu,  3 Oct 2019 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118224;
        bh=wVfcTFXLsCfnAl3EY9Df6/EOTv2IHPa/afWP8DrLIdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wymGGOoMhoFXFV3QzwmErtUCxeqOqxwe7m7lcZuhK+UMip8ja+BgAbY/qyxE8ITk0
         hOB3vziXMNFGHYTBsnhQzfzPzwfiAjZKz2kW2ntqucakb/r5pffUhAYFc3A5f5SHoB
         OpGRwV2iGUdT96RM778ERoelI/wC69ZdM3k8WYY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 33/99] ALSA: hda: Flush interrupts on disabling
Date:   Thu,  3 Oct 2019 17:52:56 +0200
Message-Id: <20191003154310.457652454@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4727f5b80e76d..acc2c7dbfb151 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -340,6 +340,8 @@ static void azx_int_disable(struct hdac_bus *bus)
 	list_for_each_entry(azx_dev, &bus->stream_list, list)
 		snd_hdac_stream_updateb(azx_dev, SD_CTL, SD_INT_MASK, 0);
 
+	synchronize_irq(bus->irq);
+
 	/* disable SIE for all streams */
 	snd_hdac_chip_writeb(bus, INTCTL, 0);
 
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index ef8955abd9186..96ccab15da836 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1274,9 +1274,9 @@ static int azx_free(struct azx *chip)
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



