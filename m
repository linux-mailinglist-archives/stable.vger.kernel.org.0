Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5994395E5
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbhJYMTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233067AbhJYMTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF6ED60FDA;
        Mon, 25 Oct 2021 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635164239;
        bh=+dTGrFrFfzFxC5RMHG3/2ZpQrfugi52+1DYDtAvVEeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIfsKSQLQP1dZ05cQkfZHeg0nxS58Qvb+URxY1sdA8VTasXl/Kes8SE4YcpwaYlRS
         XZYoOyBJPAaRkwfrlLDBiPp6YR4j/b6KE8+9pv/zWEyjDWgaEv1wNpwjl3OToNIlNP
         TUy3xx8l2dlm7+8MvSFwY3FxxAb+tbMQS7uoUAuPWnAovk2zO9qPKBkY4GgnhDfUta
         9Wk3ZH3cKWkdl0mmujwSnxlOrgBCUlUijTVY84suinTpz1lgztRdfgR/oRKAdMb0U7
         KA9YlLxLQ1drTinqh2Hf7ZjUmjoJwf+5YtiRAD2JOnmcaHSfTN1BhzyEJ7ZJ8Bx+Wr
         OBeeREaxi8O5A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyuU-0001mW-Ty; Mon, 25 Oct 2021 14:17:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 7/8] media: s2255: fix control-message timeouts
Date:   Mon, 25 Oct 2021 14:16:40 +0200
Message-Id: <20211025121641.6759-8-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025121641.6759-1-johan@kernel.org>
References: <20211025121641.6759-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout define for the five-second
timeouts.

Fixes: 38f993ad8b1f ("V4L/DVB (8125): This driver adds support for the Sensoray 2255 devices.")
Cc: stable@vger.kernel.org      # 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/s2255/s2255drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 3b0e4ed75d99..acf18e2251a5 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1882,7 +1882,7 @@ static long s2255_vendor_req(struct s2255_dev *dev, unsigned char Request,
 				    USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				    USB_DIR_IN,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 
 		if (r >= 0)
 			memcpy(TransferBuffer, buf, TransferBufferLength);
@@ -1891,7 +1891,7 @@ static long s2255_vendor_req(struct s2255_dev *dev, unsigned char Request,
 		r = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 				    Request, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 	}
 	kfree(buf);
 	return r;
-- 
2.32.0

