Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40746498F0E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357459AbiAXTuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:50:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60170 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355575AbiAXTlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:41:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F301B810BD;
        Mon, 24 Jan 2022 19:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B35C340E5;
        Mon, 24 Jan 2022 19:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053312;
        bh=UQ1kjsQKUztbG+mC2ezX3DTEhk+4oW25wpr9eV2E+4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boIcQFx4say9+X4vfIVtRa75+Ber3MzPsXkssRxcOOnL8T3qpQgk+Pu0DSxD2gYIO
         FXowpTDnDgGQCfVaZkIX0Qzav4oSQJVrpJpg8V5RUPrRe3vz++TFmz62FDIGz8/MRq
         U+Rktg0+p4zV/gfuQU3DuvoCDjxGu11EK7VTdYNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 024/563] media: s2255: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:36:29 +0100
Message-Id: <20220124184025.266304041@linuxfoundation.org>
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
@@ -1884,7 +1884,7 @@ static long s2255_vendor_req(struct s225
 				    USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				    USB_DIR_IN,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 
 		if (r >= 0)
 			memcpy(TransferBuffer, buf, TransferBufferLength);
@@ -1893,7 +1893,7 @@ static long s2255_vendor_req(struct s225
 		r = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 				    Request, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 	}
 	kfree(buf);
 	return r;


