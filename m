Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1994EC267
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243966AbiC3L73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345904AbiC3LzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA2526B38E;
        Wed, 30 Mar 2022 04:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFE956137A;
        Wed, 30 Mar 2022 11:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E828C34111;
        Wed, 30 Mar 2022 11:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641137;
        bh=GsAv312AdYmmt1e+wMqZIwMIBSqRjZ1+lgs4z1QfSXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CD5WYBsydZTmg+T3SdjubYWmN1Mt9a88+QDbavVDOcWxNj/Z8v7G1P8e6fTiIJo7H
         T4/7SnxhVDfIdBFI/1sXVyefZT0QILK/rqcEz9tR2lTcgDC9YGxIOyznnacq0ClOsQ
         d+X6ermoioa1xUBSjKxJ1qE1XK1mHgbm0Kt7TYGmG4suZvzQnGIkrZONk+h2OtAuHp
         VayLb49JUijtS3BX3P8tFC8DPyGWxdQeS6U6fd6Cw0vXRGhoJukHhbVedCfU6FJlWA
         /aTJa5Da+ziPZILvVcVR6RXnPDKa5vLtqwMxlGFMB4roXIwuR8JBsNNtoL0ezvZSNW
         3LTGeyWP55XHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 32/37] media: hdpvr: initialize dev->worker at hdpvr_register_videodev
Date:   Wed, 30 Mar 2022 07:51:17 -0400
Message-Id: <20220330115122.1671763-32-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115122.1671763-1-sashal@kernel.org>
References: <20220330115122.1671763-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 07922937e9a580825f9965c46fd15e23ba5754b6 ]

hdpvr_register_videodev is responsible to initialize a worker in
hdpvr_device. However, the worker is only initialized at
hdpvr_start_streaming other than hdpvr_register_videodev.
When hdpvr_probe does not initialize its worker, the hdpvr_disconnect
will encounter one WARN in flush_work.The stack trace is as follows:

 hdpvr_disconnect+0xb8/0xf2 drivers/media/usb/hdpvr/hdpvr-core.c:425
 usb_unbind_interface+0xbf/0x3a0 drivers/usb/core/driver.c:458
 __device_release_driver drivers/base/dd.c:1206 [inline]
 device_release_driver_internal+0x22a/0x230 drivers/base/dd.c:1237
 bus_remove_device+0x108/0x160 drivers/base/bus.c:529
 device_del+0x1fe/0x510 drivers/base/core.c:3592
 usb_disable_device+0xd1/0x1d0 drivers/usb/core/message.c:1419
 usb_disconnect+0x109/0x330 drivers/usb/core/hub.c:2228

Fix this by moving the initialization of dev->worker to the starting of
hdpvr_register_videodev

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 563128d11731..60e57e0f1927 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -308,7 +308,6 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 
 	dev->status = STATUS_STREAMING;
 
-	INIT_WORK(&dev->worker, hdpvr_transmit_buffers);
 	schedule_work(&dev->worker);
 
 	v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
@@ -1165,6 +1164,9 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 	bool ac3 = dev->flags & HDPVR_FLAG_AC3_CAP;
 	int res;
 
+	// initialize dev->worker
+	INIT_WORK(&dev->worker, hdpvr_transmit_buffers);
+
 	dev->cur_std = V4L2_STD_525_60;
 	dev->width = 720;
 	dev->height = 480;
-- 
2.34.1

