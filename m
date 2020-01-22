Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC288144EA7
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgAVJa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:30:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgAVJa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:30:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 341EE24672;
        Wed, 22 Jan 2020 09:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685426;
        bh=Oogjn1641qqnsLaIbsL6+IzoJpqGsW+vBvF7sxRiUBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPk81BVSjkRyoyXsVRz8maMfckaPsA7DzfZuD7cNlFNuEQwJxMXCsAB3efUGinmuD
         Th2Cqof37kwbuwjJzg6u1smxu5f3W/94uekhNZMI14Dbz9V6AaHWsDz+fiB3ok3SZX
         Oq/0xw0UQlHIJ2k9yozi3FriaDYMcf5YrhfP/b2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 10/76] ALSA: line6: Fix memory leak at line6_init_pcm() error path
Date:   Wed, 22 Jan 2020 10:28:26 +0100
Message-Id: <20200122092752.571103099@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 1bc8d18c75fef3b478dbdfef722aae09e2a9fde7 upstream.

I forgot to release the allocated object at the early error path in
line6_init_pcm().  For addressing it, slightly shuffle the code so
that the PCM destructor (pcm->private_free) is assigned properly
before all error paths.

Fixes: 3450121997ce ("ALSA: line6: Fix write on zero-sized buffer")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/pcm.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -523,6 +523,15 @@ int line6_init_pcm(struct usb_line6 *lin
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
 	/* Read and write buffers are sized identically, so choose minimum */
 	line6pcm->max_packet_size = min(
 			usb_maxpacket(line6->usbdev,
@@ -535,15 +544,6 @@ int line6_init_pcm(struct usb_line6 *lin
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


