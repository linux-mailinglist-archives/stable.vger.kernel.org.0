Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDFA8D7CF
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfHNQQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:16:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37939 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbfHNQQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 12:16:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A5E9420C69;
        Wed, 14 Aug 2019 12:16:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Aug 2019 12:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DDU6ts
        gZcOeV4wPPjv8tnRvg7nGUMxpAY5jqD/dbRGM=; b=jrNn9AEfZ47hz4YYCYeSoI
        Bq2KFh28rPiMcOMFBBvLRJM21/sMsjAFDBx0CrtZMDWwT5xfK4LZMKPmVCLlKGW5
        HGLO3kWoKhTK8iD95i4cJ8LR4czBd09B6PI2mripeRObovKNvMsRj82RdaE83XE2
        qvZg9hJQmWdnduGDlr5K8t+hmKFBKSQzYOGXw2jWLQdjdg+UJv/v2w+7kNxuJm7J
        3UH4BDt84dAUYGGvWWSADbpAh9UofU5gNdoF1ucJudgYlp05vaMjCZ/M7O6nEnWv
        M+caNjCw41kOWAq1+QVHxVsqCDBs4kAzdTdqtBkyi0iH73G5KRWZ8uHAeoX9wPTQ
        ==
X-ME-Sender: <xms:4DNUXaXTfmRysDM6aMu9NGTsOMzUAJATE4_tfQIxYntNc4ZF5bwfLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:4DNUXTcwYHVwWHoRO1ynd2bQVe4IrXMI77Kt5_rCN6mNqN-uIScLqw>
    <xmx:4DNUXeKmhpe5Yd757umc5VxMRfWiXZ41so46IOCMPthDJnfeErvZOw>
    <xmx:4DNUXQxKHNTvenUfXkVOvBJGMJpSsjLZCQadRVyd4UOXdgE1jUPRlA>
    <xmx:4DNUXZPCexbRiz9mi9-Gc0cmZ10TorWe-UwnS5uPcjB3MQWA8LXM-Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BDF57380074;
        Wed, 14 Aug 2019 12:16:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hiface: fix multiple memory leak bugs" failed to apply to 4.14-stable tree
To:     wenwen@cs.uga.edu, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 14 Aug 2019 18:16:29 +0200
Message-ID: <156579938925158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

