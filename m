Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27ACBBA9A1
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbfIVTR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392190AbfIVSzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:55:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C3E521D7A;
        Sun, 22 Sep 2019 18:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178541;
        bh=pClu90STKLB18oeln6ktnsGd79j8DaMmJ6BX0IqDGQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/UJcOEXLi5WMKgHEbRQCNA+y1zoCODfVnWuTKjGYujl3Nr2SLHF5QFxPl9g6yguy
         +p/PIuX7ICbFn95mmYMy3bzSb8HK2eCdrjknq3CoIIa+zMmMUzw7oZCVTfho6M3i+i
         6O9h5vYrI6KPt2h7ZRktUQC6JeYpmrg7/wmWrPTU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+2d4fc2a0c45ad8da7e99@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 061/128] media: radio/si470x: kill urb on error
Date:   Sun, 22 Sep 2019 14:53:11 -0400
Message-Id: <20190922185418.2158-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 0d616f2a3fdbf1304db44d451d9f07008556923b ]

In the probe() function radio->int_in_urb was not killed if an
error occurred in the probe sequence. It was also missing in
the disconnect.

This caused this syzbot issue:

https://syzkaller.appspot.com/bug?extid=2d4fc2a0c45ad8da7e99

Reported-and-tested-by: syzbot+2d4fc2a0c45ad8da7e99@syzkaller.appspotmail.com

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/si470x/radio-si470x-usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 313a95f195a27..19e381dd58089 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -743,7 +743,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	/* start radio */
 	retval = si470x_start_usb(radio);
 	if (retval < 0)
-		goto err_all;
+		goto err_buf;
 
 	/* set initial frequency */
 	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
@@ -758,6 +758,8 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 
 	return 0;
 err_all:
+	usb_kill_urb(radio->int_in_urb);
+err_buf:
 	kfree(radio->buffer);
 err_ctrl:
 	v4l2_ctrl_handler_free(&radio->hdl);
@@ -831,6 +833,7 @@ static void si470x_usb_driver_disconnect(struct usb_interface *intf)
 	mutex_lock(&radio->lock);
 	v4l2_device_disconnect(&radio->v4l2_dev);
 	video_unregister_device(&radio->videodev);
+	usb_kill_urb(radio->int_in_urb);
 	usb_set_intfdata(intf, NULL);
 	mutex_unlock(&radio->lock);
 	v4l2_device_put(&radio->v4l2_dev);
-- 
2.20.1

