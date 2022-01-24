Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C8C498F5D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348056AbiAXTwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37030 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356421AbiAXTqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:46:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EC4DB8122A;
        Mon, 24 Jan 2022 19:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE1BC340E5;
        Mon, 24 Jan 2022 19:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053569;
        bh=CilhLBgCJlcnOoNau8LRQawIH8ihBF0Ww7tvfGee2IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXTV7CBzCoErAJqo6OG23lobKpM1MafxaWHLujdKmyx6C0iSNUu1uT1J9it30XQfy
         DfIUNQBdXi5J4DxwlcPsTNZ1d6+t6M+MQUbafsuW7PUMzgPt7/kwEB7AKdbH4Rd+lB
         QAjy/s4g7WaMLg3YNjTkccJKIUFlPvTP1kzQ/YeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/563] media: em28xx: fix memory leak in em28xx_init_dev
Date:   Mon, 24 Jan 2022 19:37:21 +0100
Message-Id: <20220124184027.022405066@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index cf45cc566cbe2..87e375562dbb2 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3575,8 +3575,10 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
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
@@ -3595,7 +3597,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		dev_err(&dev->intf->dev,
 			"%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 		       __func__, retval);
-		return retval;
+		goto err_deinit_media;
 	}
 
 	/* register i2c bus 1 */
@@ -3611,9 +3613,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 				"%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 				__func__, retval);
 
-			em28xx_i2c_unregister(dev, 0);
-
-			return retval;
+			goto err_unreg_i2c;
 		}
 	}
 
@@ -3621,6 +3621,12 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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



