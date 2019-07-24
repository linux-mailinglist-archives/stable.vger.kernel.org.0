Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3F673D4C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404040AbfGXTv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404037AbfGXTvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:51:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9657422ADF;
        Wed, 24 Jul 2019 19:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997915;
        bh=UIt44Sy2Z317ig9zcjRjZVvOxAI/fLmn8R0PcqkaCAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDsK4+l1vxTKSOfTk7VBSwO78J3oPjf09LjhYcI9u1U8FCCzdALa78BBBHlDeA83p
         +ZKGl+8Zv3STPjGnznvsLMJOuvKbDWS4ZcKHeJLV91frF0SzkdovpFXWZI7FAwGF4+
         S0zjtrZz7KbMMs8dkTDzyQaZhEnR6bGXi51yi2vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Rander Wang <rander.wang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 187/371] ALSA: hda: Fix a headphone detection issue when using SOF
Date:   Wed, 24 Jul 2019 21:18:59 +0200
Message-Id: <20190724191739.107624383@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index b2e9454f5816..6a190f0d2803 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -78,6 +78,8 @@ void snd_hdac_bus_init_cmd_io(struct hdac_bus *bus)
 	snd_hdac_chip_writew(bus, RINTCNT, 1);
 	/* enable rirb dma and response irq */
 	snd_hdac_chip_writeb(bus, RIRBCTL, AZX_RBCTL_DMA_EN | AZX_RBCTL_IRQ_EN);
+	/* Accept unsolicited responses */
+	snd_hdac_chip_updatel(bus, GCTL, AZX_GCTL_UNSOL, AZX_GCTL_UNSOL);
 	spin_unlock_irq(&bus->reg_lock);
 }
 EXPORT_SYMBOL_GPL(snd_hdac_bus_init_cmd_io);
@@ -414,9 +416,6 @@ int snd_hdac_bus_reset_link(struct hdac_bus *bus, bool full_reset)
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



