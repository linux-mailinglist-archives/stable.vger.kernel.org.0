Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E7499216
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380995AbiAXURY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40694 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355508AbiAXUNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96AC66091B;
        Mon, 24 Jan 2022 20:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD4FC340E5;
        Mon, 24 Jan 2022 20:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055221;
        bh=21wLfuqbveCS5JVAQjiuxwd7PXQ2jDvYYmglTZT6T1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SG5OOckxHMkZFuTiruYg43jr9f+VIafaxwImUDN9yhJtEvbP350qxNO+TkNVepI3r
         FvNnqJCZPgeHOocKhoiKp9DXk4KJI4pdyuIWVY71q61xiFaJgfMgbtZo8W4jzIxM4K
         R8gzD9FTk3qHbNCqYEg5YDzEE63pswxoPhrzOB+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 047/846] media: s2255: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:32:44 +0100
Message-Id: <20220124184102.569859643@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit f71d272ad4e354097020a4e6b1dc6e4b59feb50f upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout define for the five-second
timeouts.

Fixes: 38f993ad8b1f ("V4L/DVB (8125): This driver adds support for the Sensoray 2255 devices.")
Cc: stable@vger.kernel.org      # 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/s2255/s2255drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1882,7 +1882,7 @@ static long s2255_vendor_req(struct s225
 				    USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				    USB_DIR_IN,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 
 		if (r >= 0)
 			memcpy(TransferBuffer, buf, TransferBufferLength);
@@ -1891,7 +1891,7 @@ static long s2255_vendor_req(struct s225
 		r = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 				    Request, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 	}
 	kfree(buf);
 	return r;


