Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B59649992A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454105AbiAXVbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451493AbiAXVXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:23:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E960C028C33;
        Mon, 24 Jan 2022 12:17:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BC156149E;
        Mon, 24 Jan 2022 20:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE800C340E5;
        Mon, 24 Jan 2022 20:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055438;
        bh=BLOgM/qEZEaWm+wF2EqNfKAit9z/KekYzEWR/+WaUNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sETNr2RmogfRo+vtk4CezCdkNjVndE4QqOlgptg6tYYkHmzSUpIZ3JHd/vmgWEXDm
         BF4YBuvu//3VPIZAT1ZnAMWQyX2GhABQzfRjvWrsmQKfsSANx1EAbWhwuFzibr8fHr
         2nvKyYvuh4UMWyebUWv9ykYa9gwwcm39FnsSPdnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/846] media: em28xx: fix memory leak in em28xx_init_dev
Date:   Mon, 24 Jan 2022 19:33:55 +0100
Message-Id: <20220124184105.040452542@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 948e22e29b42a..ebc430b05f21c 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3625,8 +3625,10 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
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
@@ -3645,7 +3647,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		dev_err(&dev->intf->dev,
 			"%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 		       __func__, retval);
-		return retval;
+		goto err_deinit_media;
 	}
 
 	/* register i2c bus 1 */
@@ -3661,9 +3663,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 				"%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 				__func__, retval);
 
-			em28xx_i2c_unregister(dev, 0);
-
-			return retval;
+			goto err_unreg_i2c;
 		}
 	}
 
@@ -3671,6 +3671,12 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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



