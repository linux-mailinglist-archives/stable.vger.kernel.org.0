Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383B08DAAD
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfHNRTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730592AbfHNRLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:11:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E2382133F;
        Wed, 14 Aug 2019 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802684;
        bh=ZVWqXDhVYCfDqX3KEET7MUpwNtvT7KRdDULsbPhFlaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIzztwcJzVTSzBGUQe4oSLWNVb+vxgb3kDRIaUufZ4dhbFuIB/dJnWchi/PVV4PoO
         pzcloS7QF4NQ5v8KSfwt+SWxPI3NQBfftJPiWHzEb0gxut2hZQSGLCVkfyb474VrWi
         7i1iytTmf400WLY4gIonXNnwqU2WiVAmWjHtfuNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 78/91] ALSA: hiface: fix multiple memory leak bugs
Date:   Wed, 14 Aug 2019 19:01:41 +0200
Message-Id: <20190814165753.135761925@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

commit 3d92aa45fbfd7319e3a19f4ec59fd32b3862b723 upstream.

In hiface_pcm_init(), 'rt' is firstly allocated through kzalloc(). Later
on, hiface_pcm_init_urb() is invoked to initialize 'rt->out_urbs[i]'. In
hiface_pcm_init_urb(), 'rt->out_urbs[i].buffer' is allocated through
kzalloc().  However, if hiface_pcm_init_urb() fails, both 'rt' and
'rt->out_urbs[i].buffer' are not deallocated, leading to memory leak bugs.
Also, 'rt->out_urbs[i].buffer' is not deallocated if snd_pcm_new() fails.

To fix the above issues, free 'rt' and 'rt->out_urbs[i].buffer'.

Fixes: a91c3fb2f842 ("Add M2Tech hiFace USB-SPDIF driver")
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/hiface/pcm.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/sound/usb/hiface/pcm.c
+++ b/sound/usb/hiface/pcm.c
@@ -604,14 +604,13 @@ int hiface_pcm_init(struct hiface_chip *
 		ret = hiface_pcm_init_urb(&rt->out_urbs[i], chip, OUT_EP,
 				    hiface_pcm_out_urb_handler);
 		if (ret < 0)
-			return ret;
+			goto error;
 	}
 
 	ret = snd_pcm_new(chip->card, "USB-SPDIF Audio", 0, 1, 0, &pcm);
 	if (ret < 0) {
-		kfree(rt);
 		dev_err(&chip->dev->dev, "Cannot create pcm instance\n");
-		return ret;
+		goto error;
 	}
 
 	pcm->private_data = rt;
@@ -624,4 +623,10 @@ int hiface_pcm_init(struct hiface_chip *
 
 	chip->pcm = rt;
 	return 0;
+
+error:
+	for (i = 0; i < PCM_N_URBS; i++)
+		kfree(rt->out_urbs[i].buffer);
+	kfree(rt);
+	return ret;
 }


