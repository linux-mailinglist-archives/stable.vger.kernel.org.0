Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABBA1FB931
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732925AbgFPQBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732715AbgFPPvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:51:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED9CE207C4;
        Tue, 16 Jun 2020 15:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322709;
        bh=QWZhGhZw6SXi3y7+QniH5c40RvMZkswOJ864wEI/Dn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaff/vqBhlU7gjmeiE7KVO+oPHJeMzt1hob3HgW3cHIMwDPqUWh2QdOKX1A67zTuy
         gSoDrXYo4nCbUqMkCrIA/lckPX5BE20yljEWcAr98IkdfyK8ziyB/1MkqP52p7vCJe
         hveoLYRIpVfTOkI9KCfdJmvtFyLyB9xM0zkRRatk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 074/161] ALSA: pcm: fix snd_pcm_link() lockdep splat
Date:   Tue, 16 Jun 2020 17:34:24 +0200
Message-Id: <20200616153109.904646314@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit e18035cf5cb3d2bf8e4f4d350a23608bd208b934 upstream.

Add and use snd_pcm_stream_lock_nested() in snd_pcm_link/unlink
implementation.  The code is fine, but generates a lockdep complaint:

============================================
WARNING: possible recursive locking detected
5.7.1mq+ #381 Tainted: G           O
--------------------------------------------
pulseaudio/4180 is trying to acquire lock:
ffff888402d6f508 (&group->lock){-...}-{2:2}, at: snd_pcm_common_ioctl+0xda8/0xee0 [snd_pcm]

but task is already holding lock:
ffff8883f7a8cf18 (&group->lock){-...}-{2:2}, at: snd_pcm_common_ioctl+0xe4e/0xee0 [snd_pcm]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&group->lock);
  lock(&group->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by pulseaudio/4180:
 #0: ffffffffa1a05190 (snd_pcm_link_rwsem){++++}-{3:3}, at: snd_pcm_common_ioctl+0xca0/0xee0 [snd_pcm]
 #1: ffff8883f7a8cf18 (&group->lock){-...}-{2:2}, at: snd_pcm_common_ioctl+0xe4e/0xee0 [snd_pcm]
[...]

Cc: stable@vger.kernel.org
Fixes: f57f3df03a8e ("ALSA: pcm: More fine-grained PCM link locking")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/37252c65941e58473b1219ca9fab03d48f47e3e3.1591610330.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Takashi Iwai <tiwai@suse.de>

---
 sound/core/pcm_native.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -138,6 +138,16 @@ void snd_pcm_stream_lock_irq(struct snd_
 }
 EXPORT_SYMBOL_GPL(snd_pcm_stream_lock_irq);
 
+static void snd_pcm_stream_lock_nested(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_group *group = &substream->self_group;
+
+	if (substream->pcm->nonatomic)
+		mutex_lock_nested(&group->mutex, SINGLE_DEPTH_NESTING);
+	else
+		spin_lock_nested(&group->lock, SINGLE_DEPTH_NESTING);
+}
+
 /**
  * snd_pcm_stream_unlock_irq - Unlock the PCM stream
  * @substream: PCM substream
@@ -2197,7 +2207,7 @@ static int snd_pcm_link(struct snd_pcm_s
 	snd_pcm_stream_unlock_irq(substream);
 
 	snd_pcm_group_lock_irq(target_group, nonatomic);
-	snd_pcm_stream_lock(substream1);
+	snd_pcm_stream_lock_nested(substream1);
 	snd_pcm_group_assign(substream1, target_group);
 	refcount_inc(&target_group->refs);
 	snd_pcm_stream_unlock(substream1);
@@ -2213,7 +2223,7 @@ static int snd_pcm_link(struct snd_pcm_s
 
 static void relink_to_local(struct snd_pcm_substream *substream)
 {
-	snd_pcm_stream_lock(substream);
+	snd_pcm_stream_lock_nested(substream);
 	snd_pcm_group_assign(substream, &substream->self_group);
 	snd_pcm_stream_unlock(substream);
 }


