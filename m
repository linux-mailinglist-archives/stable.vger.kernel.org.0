Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC46CA1A8
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbfJCP6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731088AbfJCP6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:58:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2036220700;
        Thu,  3 Oct 2019 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118283;
        bh=nw8lE8PLBPUWPA18dI7iK352YspUk1mBGfamqwxe2E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5z+EiWV5dJqdM9YFFpSQeooL19P9wpyUiqKhVvq8I5ngPCAOi3AR3aYOogzww+gP
         o/BaATRO/1w9CDH28UIuGP8edqQnQ0SjGen+wTffVsN7PZAzShpzs5Yj67ZWxsTgPS
         bHiwnnF/nC7p9UHAGQLfa++Hq+xfdgNcaLO7iLpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+2d4fc2a0c45ad8da7e99@syzkaller.appspotmail.com
Subject: [PATCH 4.4 56/99] media: radio/si470x: kill urb on error
Date:   Thu,  3 Oct 2019 17:53:19 +0200
Message-Id: <20191003154323.368128211@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 091d793f65836..c9347d5aac04f 100644
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



