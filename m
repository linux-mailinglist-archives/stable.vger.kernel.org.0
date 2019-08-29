Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67472A176E
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfH2KzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbfH2KuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2D92173E;
        Thu, 29 Aug 2019 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075815;
        bh=eYpZNX+vviP0iqdloe8IdyPbr4uR78Nhm3OiA3AA1LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSLxpaZ81qPZ8jJZhc46n46cyCzLM7fckQo8mK1EqZOXGFYzVzX4c+MBIsalbUXDi
         Mv16ntS1L31umzey/AdrgasB2gN7JxlAg26phOefruPvQuP2Q1UWgRu/a7WYiAeNLs
         PomekSYfFUcEaZdf52dslIu0aXNzhjekKUceS7Xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 04/29] ALSA: line6: Fix memory leak at line6_init_pcm() error path
Date:   Thu, 29 Aug 2019 06:49:44 -0400
Message-Id: <20190829105009.2265-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
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
index 78c2d6cab3b52..531564269444e 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -554,6 +554,15 @@ int line6_init_pcm(struct usb_line6 *line6,
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
@@ -566,15 +575,6 @@ int line6_init_pcm(struct usb_line6 *line6,
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

