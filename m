Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768BA498F53
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347155AbiAXTwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54262 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345185AbiAXT0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:26:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD54A614DC;
        Mon, 24 Jan 2022 19:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39EDC340EE;
        Mon, 24 Jan 2022 19:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052395;
        bh=bfB2/RcW2K+xexjn5NVIMB7nOFtsU1aTuXcNAlD80bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MqzU+wtmBNolgyk/XqOY5A1m9sJYf2czZjn3E+pLtUWGZ132sT5b9hC+4JLBXLx1e
         uIRE+pEheD0DhfCx2tlV0VeBM02AnKzbScyQPtqU2wwEp2XDCWaPU8yJ0uQz00ABEb
         bdD0HCH1kgy46lNgUJ9aikcZ5VloWGUTf7ZcsJFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/320] media: em28xx: fix memory leak in em28xx_init_dev
Date:   Mon, 24 Jan 2022 19:40:28 +0100
Message-Id: <20220124183955.247242999@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 22be5a10d0b24eec9e45decd15d7e6112b25f080 ]

In the em28xx_init_rev, if em28xx_audio_setup fails, this function fails
to deallocate the media_dev allocated in the em28xx_media_device_init.

Fix this by adding em28xx_unregister_media_device to free media_dev.

BTW, this patch is tested in my local syzkaller instance, and it can
prevent the memory leak from occurring again.

CC: Pavel Skripkin <paskripkin@gmail.com>
Fixes: 37ecc7b1278f ("[media] em28xx: add media controller support")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 3e96b4b711d75..bfca9d0a1fe15 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3515,8 +3515,10 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	if (dev->is_audio_only) {
 		retval = em28xx_audio_setup(dev);
-		if (retval)
-			return -ENODEV;
+		if (retval) {
+			retval = -ENODEV;
+			goto err_deinit_media;
+		}
 		em28xx_init_extension(dev);
 
 		return 0;
@@ -3535,7 +3537,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		dev_err(&dev->intf->dev,
 			"%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 		       __func__, retval);
-		return retval;
+		goto err_deinit_media;
 	}
 
 	/* register i2c bus 1 */
@@ -3551,9 +3553,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 				"%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 				__func__, retval);
 
-			em28xx_i2c_unregister(dev, 0);
-
-			return retval;
+			goto err_unreg_i2c;
 		}
 	}
 
@@ -3561,6 +3561,12 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	em28xx_card_setup(dev);
 
 	return 0;
+
+err_unreg_i2c:
+	em28xx_i2c_unregister(dev, 0);
+err_deinit_media:
+	em28xx_unregister_media_device(dev);
+	return retval;
 }
 
 static int em28xx_duplicate_dev(struct em28xx *dev)
-- 
2.34.1



