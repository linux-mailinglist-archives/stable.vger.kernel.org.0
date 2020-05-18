Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD951D8116
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgERRom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728904AbgERRok (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:44:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 062F72083E;
        Mon, 18 May 2020 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823880;
        bh=eDNVAQR9bAqbtW3RfWRqf3JH/mbMza7PvaMw3TiDEdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaz2aZk89cJMysBM7GavwX9QrjV/Fl/iJR/p/gSDb2KoWSuGy6q+gkNcabJr/HurG
         jFbX0KatNxi6NM43YRNPPy6robeZiKy9urR8lJU2Usq8HP8NzdWDs3piH+USR+xfdP
         dcE83o8RzE8f2tfAJpIXvLigqHIrMUCsL2EwCCKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+194dffdb8b22fc5d207a@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 74/90] ALSA: rawmidi: Initialize allocated buffers
Date:   Mon, 18 May 2020 19:36:52 +0200
Message-Id: <20200518173506.329434545@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5a7b44a8df822e0667fc76ed7130252523993bda upstream.

syzbot reported the uninitialized value exposure in certain situations
using virmidi loop.  It's likely a very small race at writing and
reading, and the influence is almost negligible.  But it's safer to
paper over this just by replacing the existing kvmalloc() with
kvzalloc().

Reported-by: syzbot+194dffdb8b22fc5d207a@syzkaller.appspotmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/rawmidi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -125,7 +125,7 @@ static int snd_rawmidi_runtime_create(st
 		runtime->avail = 0;
 	else
 		runtime->avail = runtime->buffer_size;
-	if ((runtime->buffer = kmalloc(runtime->buffer_size, GFP_KERNEL)) == NULL) {
+	if ((runtime->buffer = kzalloc(runtime->buffer_size, GFP_KERNEL)) == NULL) {
 		kfree(runtime);
 		return -ENOMEM;
 	}
@@ -650,7 +650,7 @@ int snd_rawmidi_output_params(struct snd
 		return -EINVAL;
 	}
 	if (params->buffer_size != runtime->buffer_size) {
-		newbuf = kmalloc(params->buffer_size, GFP_KERNEL);
+		newbuf = kzalloc(params->buffer_size, GFP_KERNEL);
 		if (!newbuf)
 			return -ENOMEM;
 		spin_lock_irq(&runtime->lock);


