Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7C229AE41
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753095AbgJ0N63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753084AbgJ0N63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:58:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0FCA2068D;
        Tue, 27 Oct 2020 13:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807108;
        bh=Fm8SMGoT1zLCKx2eTQJU65KETB+YjyUzs+tsSf8AAIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8dcj1VLUY5TPX+Y/PXLbZNgy8Db6lYCtoG7EFAUrzz1zorcv3XWeCTgPu02xR7eE
         xP5BuucmNeSWhyQqXpNzfwrRh2OtR68Kr5JmUyTOIHI8PuL0yy62+QB7rpg2IG6jgp
         udo7Arr0LZeq9w/5Mz9+popYBO2yCpr6Nb4XDe5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 045/112] ALSA: seq: oss: Avoid mutex lock for a long-time ioctl
Date:   Tue, 27 Oct 2020 14:49:15 +0100
Message-Id: <20201027134902.692482951@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 2759caad2600d503c3b0ed800e7e03d2cd7a4c05 ]

Recently we applied a fix to cover the whole OSS sequencer ioctls with
the mutex for dealing with the possible races.  This works fine in
general, but in theory, this may lead to unexpectedly long stall if an
ioctl like SNDCTL_SEQ_SYNC is issued and an event with the far future
timestamp was queued.

For fixing such a potential stall, this patch changes the mutex lock
applied conditionally excluding such an ioctl command.  Also, change
the mutex_lock() with the interruptible version for user to allow
escaping from the big-hammer mutex.

Fixes: 80982c7e834e ("ALSA: seq: oss: Serialize ioctls")
Suggested-by: Pavel Machek <pavel@ucw.cz>
Link: https://lore.kernel.org/r/20200922083856.28572-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/oss/seq_oss.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss.c b/sound/core/seq/oss/seq_oss.c
index 8044775999eda..4d1548b951c41 100644
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -186,9 +186,12 @@ odev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (snd_BUG_ON(!dp))
 		return -ENXIO;
 
-	mutex_lock(&register_mutex);
+	if (cmd != SNDCTL_SEQ_SYNC &&
+	    mutex_lock_interruptible(&register_mutex))
+		return -ERESTARTSYS;
 	rc = snd_seq_oss_ioctl(dp, cmd, arg);
-	mutex_unlock(&register_mutex);
+	if (cmd != SNDCTL_SEQ_SYNC)
+		mutex_unlock(&register_mutex);
 	return rc;
 }
 
-- 
2.25.1



