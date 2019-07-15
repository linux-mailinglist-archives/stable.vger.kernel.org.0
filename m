Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDEB68DE0
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732617AbfGOOCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730235AbfGOOAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:00:05 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4296B2083D;
        Mon, 15 Jul 2019 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199204;
        bh=8/6cGbemBxBgbQEs4ZYCF9p5eQXSdOQ7wFxbD9VUR10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2hxhRBzmqiCY4FAHRHYnxhFNZHrr6nUlood5ufnGV9T5XO3axbKFWhG3q16g/opZ
         VO8kkGScJsIoJ1GFNSNBCI3+bE1lGNyKqi2h68YtuUFq4635gJP4tQ4vPd9Vs7mhSH
         8gRf+Bo1aEBxXJFYC865cmBsHpsA8s1ZL5vAXsKA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rander Wang <rander.wang@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 215/249] ALSA: hda: Fix a headphone detection issue when using SOF
Date:   Mon, 15 Jul 2019 09:46:20 -0400
Message-Id: <20190715134655.4076-215-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rander Wang <rander.wang@linux.intel.com>

[ Upstream commit 7c2b3629d09ddec810dc4c1d3a6657c32def8f71 ]

To save power, the hda hdmi driver in ASoC invokes snd_hdac_ext_bus_link_put
to disable CORB/RIRB buffers DMA if there is no user of bus and invokes
snd_hdac_ext_bus_link_get to set up CORB/RIRB buffers when it is used.
Unsolicited responses is disabled in snd_hdac_bus_stop_cmd_io called by
snd_hdac_ext_bus_link_put , but it is not enabled in snd_hdac_bus_init_cmd_io
called by snd_hdac_ext_bus_link_get. So for put-get sequence, Unsolicited
responses is disabled and headphone can't be detected by hda codecs.

Now unsolicited responses is only enabled in snd_hdac_bus_reset_link
which resets controller. The function is only called for setup of
controller. This patch enables Unsolicited responses after RIRB is
initialized in snd_hdac_bus_init_cmd_io which works together with
snd_hdac_bus_reset_link to set up controller.

Tested legacy hda driver and SOF driver on intel whiskeylake.

Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_controller.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/hda/hdac_controller.c b/sound/hda/hdac_controller.c
index b02f74528b66..812dc144fb5b 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -79,6 +79,8 @@ void snd_hdac_bus_init_cmd_io(struct hdac_bus *bus)
 	snd_hdac_chip_writew(bus, RINTCNT, 1);
 	/* enable rirb dma and response irq */
 	snd_hdac_chip_writeb(bus, RIRBCTL, AZX_RBCTL_DMA_EN | AZX_RBCTL_IRQ_EN);
+	/* Accept unsolicited responses */
+	snd_hdac_chip_updatel(bus, GCTL, AZX_GCTL_UNSOL, AZX_GCTL_UNSOL);
 	spin_unlock_irq(&bus->reg_lock);
 }
 EXPORT_SYMBOL_GPL(snd_hdac_bus_init_cmd_io);
@@ -415,9 +417,6 @@ int snd_hdac_bus_reset_link(struct hdac_bus *bus, bool full_reset)
 		return -EBUSY;
 	}
 
-	/* Accept unsolicited responses */
-	snd_hdac_chip_updatel(bus, GCTL, AZX_GCTL_UNSOL, AZX_GCTL_UNSOL);
-
 	/* detect codecs */
 	if (!bus->codec_mask) {
 		bus->codec_mask = snd_hdac_chip_readw(bus, STATESTS);
-- 
2.20.1

