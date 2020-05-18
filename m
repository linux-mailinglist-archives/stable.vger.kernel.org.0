Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724AB1D80AB
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgERRlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729210AbgERRlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:41:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3882D20715;
        Mon, 18 May 2020 17:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823667;
        bh=FbYVbW5S+MWJqqzX/D8J0938n0JU/xFXLAl/FccIewI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3f3KBso/yCpUWnm6JuHpu5qV0VYOsChBlxbyHJrtbyhLViiBttv+EwLE92R9yxbk
         fwL5ziF1ABvABgHcdu3QsJECMDIPTeGutngq2N/tMHXL4qw50w8B59HBDG2dgI3kd9
         zYuJ7Of/RaM0hGEdG0ThXkIuuJZdPiu+2MzvAano=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+194dffdb8b22fc5d207a@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 74/86] ALSA: rawmidi: Initialize allocated buffers
Date:   Mon, 18 May 2020 19:36:45 +0200
Message-Id: <20200518173505.468778017@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
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
@@ -136,7 +136,7 @@ static int snd_rawmidi_runtime_create(st
 		runtime->avail = 0;
 	else
 		runtime->avail = runtime->buffer_size;
-	if ((runtime->buffer = kmalloc(runtime->buffer_size, GFP_KERNEL)) == NULL) {
+	if ((runtime->buffer = kzalloc(runtime->buffer_size, GFP_KERNEL)) == NULL) {
 		kfree(runtime);
 		return -ENOMEM;
 	}
@@ -661,7 +661,7 @@ int snd_rawmidi_output_params(struct snd
 		return -EINVAL;
 	}
 	if (params->buffer_size != runtime->buffer_size) {
-		newbuf = kmalloc(params->buffer_size, GFP_KERNEL);
+		newbuf = kzalloc(params->buffer_size, GFP_KERNEL);
 		if (!newbuf)
 			return -ENOMEM;
 		spin_lock_irq(&runtime->lock);


