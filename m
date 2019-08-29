Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D07A1704
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfH2KvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbfH2KvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:51:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D9123403;
        Thu, 29 Aug 2019 10:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075863;
        bh=i68YAx0D+iihBuR6c+tSkqoQfrPainAO2vDNRhzakUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJfSvbMdLDxqoQaiVOlRd3BimC9Ia+C2zKQuq/GDGn/+OD9SeDyVPgc3ueXMQ95Vm
         vBEL4U5NKcYoSXpxvYHs4m2fcDpNg1I1+1etbCexamdRhNak1UQkLs/p6c+nU9Auww
         j2xjxV/Vnno97HM9hVF9aEp2hO9n4Jt1rEJkO8OQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 2/8] ALSA: line6: Fix memory leak at line6_init_pcm() error path
Date:   Thu, 29 Aug 2019 06:50:54 -0400
Message-Id: <20190829105100.2649-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105100.2649-1-sashal@kernel.org>
References: <20190829105100.2649-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1bc8d18c75fef3b478dbdfef722aae09e2a9fde7 ]

I forgot to release the allocated object at the early error path in
line6_init_pcm().  For addressing it, slightly shuffle the code so
that the PCM destructor (pcm->private_free) is assigned properly
before all error paths.

Fixes: 3450121997ce ("ALSA: line6: Fix write on zero-sized buffer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/pcm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index a9f99a6c39095..74b399372e0b4 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -552,6 +552,15 @@ int line6_init_pcm(struct usb_line6 *line6,
 	line6pcm->volume_monitor = 255;
 	line6pcm->line6 = line6;
 
+	spin_lock_init(&line6pcm->out.lock);
+	spin_lock_init(&line6pcm->in.lock);
+	line6pcm->impulse_period = LINE6_IMPULSE_DEFAULT_PERIOD;
+
+	line6->line6pcm = line6pcm;
+
+	pcm->private_data = line6pcm;
+	pcm->private_free = line6_cleanup_pcm;
+
 	line6pcm->max_packet_size_in =
 		usb_maxpacket(line6->usbdev,
 			usb_rcvisocpipe(line6->usbdev, ep_read), 0);
@@ -564,15 +573,6 @@ int line6_init_pcm(struct usb_line6 *line6,
 		return -EINVAL;
 	}
 
-	spin_lock_init(&line6pcm->out.lock);
-	spin_lock_init(&line6pcm->in.lock);
-	line6pcm->impulse_period = LINE6_IMPULSE_DEFAULT_PERIOD;
-
-	line6->line6pcm = line6pcm;
-
-	pcm->private_data = line6pcm;
-	pcm->private_free = line6_cleanup_pcm;
-
 	err = line6_create_audio_out_urbs(line6pcm);
 	if (err < 0)
 		return err;
-- 
2.20.1

