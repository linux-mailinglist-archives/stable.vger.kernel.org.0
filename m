Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204AF8D7D1
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfHNQQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:16:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54957 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbfHNQQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 12:16:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6E4C720C69;
        Wed, 14 Aug 2019 12:16:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Aug 2019 12:16:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SaaYGn
        bABltzNgtLlJHAKxqE/PAbPU4JlXkOGMpSzjs=; b=eGFduDUl2VSeZ6y5l92U2R
        pN3F97MY+aRaKACIQ5yJboYtx+uHvvsxtA5Ed5XUh1RmRaPw6TSqNRz2nKn+6uat
        Mdj+YK9WlQeYQJTmD+Bq2bT7NIRnIVeBzbnOl10nUSycgJys7h8um8RrlZy1UzvM
        o7osdIi2M9Be0FAzn3LUUEuduxgwZzmAJGxc9HUNfW3RbGqBHL2eWqqcBJh/y90w
        BtN74ZALa1gekDiv/iIr1Fd83QkSm1fXBO48h4LtPA4hp5ZiimXxSF3t0LXjw2jV
        SCCMfAXcwTu22bQh9D9Tsg2mq2Iqto7BzGdKxMsBiS/o94fcvTqC2Am5i16rqF2g
        ==
X-ME-Sender: <xms:6TNUXUcyNeUFF9BoMISAUfUCDey1BAEVW2ZNB-nPna5F-DEi36j1rQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6TNUXd5I50D3pwNJW3NE5BZDR043e8qlQwyctVeupBOSZ4TgzPPh8g>
    <xmx:6TNUXXuKR4G_T3EezXIOLu3kke1Y6MipZmS6MmgfGtb0pD0cROajDA>
    <xmx:6TNUXYr97W3xDd-FeKzbNEC_8YkOm-WfmtuEY9lT3GGZFlD4eRlJVw>
    <xmx:6TNUXZaUjUpBXKmdfJOBzpJiiyUzvYKSY_2C2_1Zp0oFlq9oxpQDKA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7F46380075;
        Wed, 14 Aug 2019 12:16:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hiface: fix multiple memory leak bugs" failed to apply to 4.9-stable tree
To:     wenwen@cs.uga.edu, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 14 Aug 2019 18:16:30 +0200
Message-ID: <15657993909215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

