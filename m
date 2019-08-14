Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D8B8D7D0
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfHNQQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:16:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34233 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbfHNQQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 12:16:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DEBD320A0D;
        Wed, 14 Aug 2019 12:16:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Aug 2019 12:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3aCEZ4
        iLpwA9J1WUyNEGdf4+zwVUmbYRlCr+amhJnCo=; b=UAAIQzdBd0r3GIBGow8Lsv
        Rft73v5+O5H0rlBzthTnT4co7Gjf6fs/FEE1qQelCad5gvxbF5qOL97xsmEj+3st
        SfcUK1JJQFVtuDq1hvpPrTWdDdrCwSxDUCl6DdnUV1YL09onc2sn1ZEGZQcXbOAv
        /RzvoQAF4AM0fPok4RrY3jnzeOgvr2/lsMyrEDzJt+xqEfI3XaTuL+Ky91fr9Zbq
        bYAwqFhZOSpYSoxy3s9o7BhmO8g3xmZ9itWyFz9ZdkFOlQbU6Kd/VJ1pQ81R8l12
        cTmx2Nd5ArXxSIsKL/H/fdWMBetz6uBgS8XLx2GKGctRVfjtDSX3q2paLDCdifRQ
        ==
X-ME-Sender: <xms:5zNUXdJw9DDZ8WVwuZ23PEIP6K27BK5UAm2UdqN9HSSaRdJVTnaMQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:5zNUXW1udA4x-vLBYpxxy6VPc2VC7Fgpt21ffJUT4P9_Ig6k_UgfpA>
    <xmx:5zNUXQKJoNVTuaHckVEHuNPllRmDTLW-M7MQb8xuJCzVwgimtp7ixw>
    <xmx:5zNUXWlDFEQsmQiQv2iDeJyn4ARa9RqBICdToiyC1Cy0bjYgNOystg>
    <xmx:5zNUXd_IrNMYcs5jM6g9mCy7jhclzqZBBrNj54AL1BvdEinozIe9hQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E55C380087;
        Wed, 14 Aug 2019 12:16:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hiface: fix multiple memory leak bugs" failed to apply to 4.4-stable tree
To:     wenwen@cs.uga.edu, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 14 Aug 2019 18:16:30 +0200
Message-ID: <1565799390152249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3d92aa45fbfd7319e3a19f4ec59fd32b3862b723 Mon Sep 17 00:00:00 2001
From: Wenwen Wang <wenwen@cs.uga.edu>
Date: Wed, 7 Aug 2019 04:08:51 -0500
Subject: [PATCH] ALSA: hiface: fix multiple memory leak bugs

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

diff --git a/sound/usb/hiface/pcm.c b/sound/usb/hiface/pcm.c
index 14fc1e1d5d13..c406497c5919 100644
--- a/sound/usb/hiface/pcm.c
+++ b/sound/usb/hiface/pcm.c
@@ -600,14 +600,13 @@ int hiface_pcm_init(struct hiface_chip *chip, u8 extra_freq)
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
@@ -620,4 +619,10 @@ int hiface_pcm_init(struct hiface_chip *chip, u8 extra_freq)
 
 	chip->pcm = rt;
 	return 0;
+
+error:
+	for (i = 0; i < PCM_N_URBS; i++)
+		kfree(rt->out_urbs[i].buffer);
+	kfree(rt);
+	return ret;
 }

