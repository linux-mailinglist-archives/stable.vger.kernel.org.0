Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFF327C839
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgI2L7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730590AbgI2Lky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55E44221E7;
        Tue, 29 Sep 2020 11:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379651;
        bh=xR3JxS7dReW87Az2A8LeOTHlQ0QfKGc3fI+787wEz9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7rEB1vyd/RoJMo+3to05PLrg/uOe1qssw1cIgxr3yAlLthSfZCmTyFpFo8UcMHwF
         JFuSbciWWxtsOmt+VrzUWiLmeRBXJ2yJOzC6WtshmwpQSLQKIH554KEsBkIX2MRCds
         IJneJTSx+08snTMbBqZkKSmsb8+b1O5I/dAWaziM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 259/388] ALSA: hda: Fix potential race in unsol event handler
Date:   Tue, 29 Sep 2020 12:59:50 +0200
Message-Id: <20200929110023.008438923@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c637fa151259c0f74665fde7cba5b7eac1417ae5 ]

The unsol event handling code has a loop retrieving the read/write
indices and the arrays without locking while the append to the array
may happen concurrently.  This may lead to some inconsistency.
Although there hasn't been any proof of this bad results, it's still
safer to protect the racy accesses.

This patch adds the spinlock protection around the unsol handling loop
for addressing it.  Here we take bus->reg_lock as the writer side
snd_hdac_bus_queue_event() is also protected by that lock.

Link: https://lore.kernel.org/r/20200516062556.30951-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/hdac_bus.c b/sound/hda/hdac_bus.c
index 8f19876244ebe..53be2cac98e7c 100644
--- a/sound/hda/hdac_bus.c
+++ b/sound/hda/hdac_bus.c
@@ -158,6 +158,7 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
 	struct hdac_driver *drv;
 	unsigned int rp, caddr, res;
 
+	spin_lock_irq(&bus->reg_lock);
 	while (bus->unsol_rp != bus->unsol_wp) {
 		rp = (bus->unsol_rp + 1) % HDA_UNSOL_QUEUE_SIZE;
 		bus->unsol_rp = rp;
@@ -169,10 +170,13 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
 		codec = bus->caddr_tbl[caddr & 0x0f];
 		if (!codec || !codec->dev.driver)
 			continue;
+		spin_unlock_irq(&bus->reg_lock);
 		drv = drv_to_hdac_driver(codec->dev.driver);
 		if (drv->unsol_event)
 			drv->unsol_event(codec, res);
+		spin_lock_irq(&bus->reg_lock);
 	}
+	spin_unlock_irq(&bus->reg_lock);
 }
 
 /**
-- 
2.25.1



