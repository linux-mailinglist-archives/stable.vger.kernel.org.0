Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30AC198F1F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgCaJAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730031AbgCaJAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:00:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2458020B80;
        Tue, 31 Mar 2020 09:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645245;
        bh=7GkF9U1QC4/acQ/zYteAI1o0BdFXo/0FC7l9Hnlp3EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfpIw9xG61QMdEgZsrvYII3F6prcv8YUqHXIwWhpbkaeCTxx30a+PTSSx4oy6ZB2s
         OUb1euN15aBrKhMwRRC+BfyZGVJLNSgPS5MSicyeWcAckQpwWE0yfy07kd7TX9aS40
         9ehLaYYiZGxdoWT5t1aLqmn3dBGLgYsWTvaeVj1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.6 09/23] media: usbtv: fix control-message timeouts
Date:   Tue, 31 Mar 2020 10:59:21 +0200
Message-Id: <20200331085312.064800702@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085308.098696461@linuxfoundation.org>
References: <20200331085308.098696461@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 536f561d871c5781bc33d26d415685211b94032e upstream.

The driver was issuing synchronous uninterruptible control requests
without using a timeout. This could lead to the driver hanging on
various user requests due to a malfunctioning (or malicious) device
until the device is physically disconnected.

The USB upper limit of five seconds per request should be more than
enough.

Fixes: f3d27f34fdd7 ("[media] usbtv: Add driver for Fushicai USBTV007 video frame grabber")
Fixes: c53a846c48f2 ("[media] usbtv: add video controls")
Cc: stable <stable@vger.kernel.org>     # 3.11
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Lubomir Rintel <lkundrak@v3.sk>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/usbtv/usbtv-core.c  |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -56,7 +56,7 @@ int usbtv_set_regs(struct usbtv *usbtv,
 
 		ret = usb_control_msg(usbtv->udev, pipe, USBTV_REQUEST_REG,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, index, NULL, 0, 0);
+			value, index, NULL, 0, USB_CTRL_GET_TIMEOUT);
 		if (ret < 0)
 			return ret;
 	}
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -800,7 +800,8 @@ static int usbtv_s_ctrl(struct v4l2_ctrl
 		ret = usb_control_msg(usbtv->udev,
 			usb_rcvctrlpipe(usbtv->udev, 0), USBTV_CONTROL_REG,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0, USBTV_BASE + 0x0244, (void *)data, 3, 0);
+			0, USBTV_BASE + 0x0244, (void *)data, 3,
+			USB_CTRL_GET_TIMEOUT);
 		if (ret < 0)
 			goto error;
 	}
@@ -851,7 +852,7 @@ static int usbtv_s_ctrl(struct v4l2_ctrl
 	ret = usb_control_msg(usbtv->udev, usb_sndctrlpipe(usbtv->udev, 0),
 			USBTV_CONTROL_REG,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0, index, (void *)data, size, 0);
+			0, index, (void *)data, size, USB_CTRL_SET_TIMEOUT);
 
 error:
 	if (ret < 0)


